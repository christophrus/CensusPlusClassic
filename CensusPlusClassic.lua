--[[ CensusPlusClassic for World of Warcraft(tm).
	
	Copyright 2005 - 2016 Cooper Sellers

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GLP.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
		
  Debugging/profiling note:  
  Global  CPp.EnableProfiling must be set to True
  the appropriate profiling point must be set in code with 
  --CP_profiling_timerstart =	debugprofilestop()
  don't use debugprofilestart() this does a reset of the timer... 
  if multiple code (addons) have profiling turned on.. then debugprofilestart() 
  will impact timing of the all the code profiles.
]]
--local regionKey = GetCVar("portal") == "public-test" and "PTR" or GetCVar("portal")
--Note: file layout structured for use with NotePad++ as editor using Lua(WoW) language definition

--[[	CensusPlus
--		A WoW UI customization by Cooper Sellers
--
--		CensusPlusClassic
--		Modified by christophrus
]]

local	addon_name, addon_tableID = ...   		-- Addon_name contains the Addon name which must be the same as the container folder name... addon_tableID is a common private table for all .lua files in the directory.

local CPp = addon_tableID  						--short cut name for private shared table.

local checksum = LibStub:GetLibrary("LibChecksum-1.0", true)

CPp.InterfaceVersion = "Captain Placeholder";   -- random value.. must not match CensusPlus_VERSION string.
local g_CensusPlusTZOffset = -999;
CPp.LocaleSet = false;  -- not used?
CPp.TZWarningSent = false;  -- not used? 

-- Constants
local CensusPlus_Version_Major = "0"; -- changing this number will force a saved data purge
local CensusPlus_Version_Minor = "5"; -- changing this number will force a saved data purge
local CensusPlus_Version_Maint = "0";
local CensusPlus_SubVersion = "";
--local CensusPlus_VERSION = "WoD"
local CensusPlus_VERSION = CensusPlus_Version_Major.."."..CensusPlus_Version_Minor .."."..CensusPlus_Version_Maint; 
local CensusPlus_VERSION_FULL = CensusPlus_VERSION --.."."..CensusPlus_SubVersion ;
local CensusPlus_PTR = GetCVar("portal") == "public-test" and "PTR";	-- enable true for PTR testing  enable false for live use
local CensusPlus_MAXBARHEIGHT = 128;			-- Length of blue bars
local CensusPlus_NUMGUILDBUTTONS = 10;			-- How many guild buttons are on the UI?


local MAX_CHARACTER_LEVEL = 60;					-- Maximum level a PC can attain  testing only comment out for live
local MIN_CHARACTER_LEVEL = 1;					-- Minimum observed level returned by /who command (undocumented and barely acknowledged.)
local MAX_WHO_RESULTS = 50;						-- Maximum number of who results the server will return
CensusPlus_GUILDBUTTONSIZEY = 16;				-- pixil height of guild name lines
local CensusPlus_UPDATEDELAY = 5;				-- Delay time between /who messages
local CensusPlus_UPDATEDELAY2 = 10				-- Delay time from who request to database updated
local CP_MAX_TIMES = 50;

--local g_ServerPrefix = "";					--  US VERSION!!
--local g_ServerPrefix = "EU-";					--  EU VERSION!!

-- debug flags for remote QA testing of version upgrades.
local CP_libwho = "libwho"
local CP_api = "api"
local CP_letterselect = 0					-- default letter selector pattern... valid options 1 and 2.. testing only
local CensusPlus_WHOPROCESSOR = CP_libwho   -- default processing of who request to full wholib  CP_api --
local CensusPLus_DEBUGWRITES = false    	-- don't add debug into to censusplus.lua output.
local CP_g_queue_count = 0 					-- process speed checking avg time to process 1 queue
local wholib





-- Global scope variables
CensusPlus_Database = {};						-- Database of all CensusPlusClassic results
--removed CensusPlus_BGInfo   = {};				--  Battleground info
CensusPlus_PerCharInfo = {};					--  Per character settings
CensusPlus_Unhandled = {};
CensusPlus_JobQueue = {};						-- The queue of pending jobs
local g_TrackUnhandled = false;
CPp.Options_Holder = {}							-- table is populated with existing option settings when Options panel is opened.. cancel resets live options to these settings.
CPp.Options_Holder["AccountWide"] = {}
CPp.Options_Holder["CCOverrides"] = {}
	
-- File scope variables
local g_addon_loaded = false
local g_player_loaded = false

local g_stealth = false;					-- Stealth mode switch
local g_Verbose = false;					-- Verbose mode switch
local g_Options_confirm_txt = true;			-- enable chatty confirm of options until user no longer desires
CPp.AutoCensus = false;						-- AutoCensus mode switch
local g_Options_Scope = "AW"				-- options are AW or CO
CPp.AutoStartTimer = 30						-- default Slider value in Options 
local g_FinishSoundNumber = 1				-- default finish sound.. 
local g_PlayFinishSound = false				-- mode switch
local g_CensusPlusInitialized = false;		-- Is CensusPlusClassic initialized?
local g_CurrentJob = {};					-- Current job being executed
CPp.IsCensusPlusInProgress = false;			-- Is a CensusPlusClassic in progress?
local g_CensusPlusPaused = false			-- Is CensusPlusClassic in progress paused?
CPp.CensusPlusManuallyPaused = false;       -- Is CensusPlusClassic in progress manually paused?
local CensusPlayerOnly = false				-- true if player requests via /census me

CensusPlus_JobQueue.g_NumNewCharacters = 0;					-- How many new characters found this CensusPlusClassic
CensusPlus_JobQueue.g_NumUpdatedCharacters = 0;				-- How many characters were updated during this CensusPlusClassic

local g_MobXPByLevel = {};						-- XP earned for killing
local g_CharacterXPByLevel = {};				-- XP required to advance through the given level
local g_TotalCharacterXPPerLevel = {};			-- Total XP required to attain the given level

CensusPlus_Guilds = {};							-- All known guild

local g_TotalCharacterXP = 0;					-- Total character XP for currently selected search
local g_Consecutive = 0;						-- Current consecutive same realm/faction run count
local g_TotalCount = 0;							-- Total number of characters which meet search criteria
local g_RaceCount = {};							-- Totals for each race given search criteria
local g_ClassCount = {};						-- Totals for each class given search criteria
local g_LevelCount = {};						-- Totals for each level given search criteria
local g_AccumulatorCount = 0;
local g_AccumulatorXPTotal = 0;
local g_AccumulateGuildTotals = true;			-- switch for guild work when scanning characters

CensusPlus_JobQueue.g_TempCount  = {};	

CPp.GuildSelected = 0;						-- Search criteria: Currently selected guild, 0 indicates none
CPp.RaceSelected = 0;						-- Search criteria: Currently selected race, 0 indicates none
CPp.ClassSelected = 0;						-- Search criteria: Currently selected class, 0 indicates none
CPp.LevelSelected = 0;
local current_realm = 0;

local g_LastOnUpdateTime = 0;					-- Last time OnUpdate was called
local g_WaitingForWhoUpdate = false;			-- Are we waiting for a who update event?

local g_factionGroup = "Neutral"						-- Faction of character running census. used to select/verify correct faction of race

local g_WhoAttempts = 0;                        -- Counter for detecting stuck who results
local g_MiniOnStart = 1;                        -- Flag to have the mini-censusP displayed on startup

local g_CompleteCensusStarted = false;          -- Flag for counter
local g_TakeHour = 0;                           -- Our timing hour
local g_ResetHour = true;                       -- Rest hour
local g_VariablesLoaded = false;                -- flag to tell us if vars are loaded
CPp.FirstLoad = false						-- Flag to handle (hide) various database rebuild messages on initial database creation 
local g_FirstRun = true;
local g_wasPurged = false
local whoquery_answered = false;
local whoquery_active = false
CPp.LastCensusRun = time() -- (CPp.AutoStartTrigger * 60)	--  timer used if auto census is turned on

local g_Pre_FriendsFrameOnHideOverride = nil;		--  override for friend's frame to stop the close window sound
local g_Pre_FriendsFrameOnShowOverride = nil;		--  override for friend's frame to stop the close window sound
local g_Pre_WhoList_UpdateOverride = nil;			--  override for friend's frame to stop the close window sound
local g_Pre_WhoHandler = nil;						--  override for submiting a who
local CP_Pre_OnEvent = nil;
local g_Pre_FriendsFrame_Update = nil;
local CP_updatingGuild  = nil;
local g_CurrentlyInBG = false;
local g_CurrentlyInBG_Msg = false;
local g_InternalSearchName = nil;
local g_InternalSearchLevel = nil;
local g_InternalSearchCount = 0;
CPp.EnableProfiling = false;
local CP_profiling_timerstart = 0
local CP_profiling_timediff = 0	
local g_CensusPlus_StartTime = 0;
local g_CensusWhoOverrideMsg = nil;
local g_WaitingForOverrideUpdate = false;
local g_ProblematicMessageShown = false;
local g_WhoLibLoaded = false;
local g_PratLoaded = false;
local g_WhoLibSubvert = nil;
local g_WhoLibSendWhoSubvert = nil;
local g_whoLibResultSubvert = nil;
local g_WhoLibChatSubvert = nil;
local g_WhoLibAskWhoSubvert = nil;

--  Battleground info
CENSUSPLUS_CURRENT_BATTLEFIELD_QUEUES = {};

local g_AccumulatedPruneData = {};

local g_RaceClassList = { };						-- Used to pick the right icon
g_RaceClassList[CENSUSPLUS_DRUID]		= 10;
g_RaceClassList[CENSUSPLUS_HUNTER]		= 11;
g_RaceClassList[CENSUSPLUS_MAGE]		= 12;
g_RaceClassList[CENSUSPLUS_PRIEST]		= 13;
g_RaceClassList[CENSUSPLUS_ROGUE]		= 14;
g_RaceClassList[CENSUSPLUS_WARLOCK]	    = 15;
g_RaceClassList[CENSUSPLUS_WARRIOR]	    = 16;
g_RaceClassList[CENSUSPLUS_SHAMAN]		= 17;
g_RaceClassList[CENSUSPLUS_PALADIN]	    = 18;

g_RaceClassList[CENSUSPLUS_DWARF]		= 20;
g_RaceClassList[CENSUSPLUS_GNOME]		= 21;
g_RaceClassList[CENSUSPLUS_HUMAN]		= 22;
g_RaceClassList[CENSUSPLUS_NIGHTELF]	= 23;
g_RaceClassList[CENSUSPLUS_ORC]		    = 24;
g_RaceClassList[CENSUSPLUS_TAUREN]		= 25;
g_RaceClassList[CENSUSPLUS_TROLL]		= 26;
g_RaceClassList[CENSUSPLUS_UNDEAD]		= 27;

CensusPlus_JobQueue.g_TimeDatabase = {};                      -- Time database
local function CensusPlus_Zero_g_TimeDatabase()
    CensusPlus_JobQueue.g_TimeDatabase = nil;
	CensusPlus_JobQueue.g_TimeDatabase = {};
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_DRUID]		= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_HUNTER]		= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_MAGE]			= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PRIEST]		= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_ROGUE]		= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARLOCK]	    = 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARRIOR]	    = 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_SHAMAN]		= 0;
	CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PALADIN]	    = 0;
end
CensusPlus_Zero_g_TimeDatabase();


--  These two DO NOT need to be localized
local CENSUSPlus_HORDE            = "Horde";
local CENSUSPlus_ALLIANCE         = "Alliance";

local g_FactionCheck = {};
g_FactionCheck[CENSUSPLUS_ORC]		= CENSUSPlus_HORDE;
g_FactionCheck[CENSUSPLUS_TAUREN]	= CENSUSPlus_HORDE;
g_FactionCheck[CENSUSPLUS_TROLL]	= CENSUSPlus_HORDE;
g_FactionCheck[CENSUSPLUS_UNDEAD]	= CENSUSPlus_HORDE;
g_FactionCheck[CENSUSPLUS_DWARF]	= CENSUSPlus_ALLIANCE;
g_FactionCheck[CENSUSPLUS_GNOME]	= CENSUSPlus_ALLIANCE;
g_FactionCheck[CENSUSPLUS_HUMAN]	= CENSUSPlus_ALLIANCE;
g_FactionCheck[CENSUSPLUS_NIGHTELF]	= CENSUSPlus_ALLIANCE;

-- Print a string to the chat frame
local function CensusPlus_Msg(msg)
	if( msg == nil ) then
		msg = " NIL ";
	end
	if(not(g_stealth) )then
		ChatFrame1:AddMessage(CENSUSPLUS_TEXT.." "..msg, 1.0, 1.0, 0.5);
	end
end

local function CensusPlus_WhoMsg(msg)
	if( msg == nil ) then
		msg = " NIL ";
	end
	ChatFrame1:AddMessage(CENSUSPLUS_TEXT.." "..WHO..": "..msg, 0.8, 0.8, 0.1);
end

local function CensusPlus_Msg2( msg )
	if( msg == nil ) then
		msg = " NIL ";
	end
	if(not(g_stealth) )then
		ChatFrame2:AddMessage(CENSUSPLUS_TEXT..": "..msg, 0.5, 1.0, 1.0);
	end
end

--- PTR debug messages
local channel = 0
local channelName = " "
local channelReady = false
local instanceID = 0
local language = nil -- nil = common for faction
local HortonBug = false
local HortonFingers = false
local HortonChannel = "Hortondebug"

local function HortonChatMsg(hotair)
	DEFAULT_CHAT_FRAME:AddMessage(hotair, 0.7, 0.5, 0.7)
end

local function HortonChannelMsg(hotair)
	SendChatMessage(hotair, "CHANNEL", language, channel)
	-- chattype = CHANNEL
	-- language = COMMON
	-- channel = channel
end

-- local says = HortonChannelMsg
local says = HortonChatMsg -- work around for incomplete work on Starter client sigh
local chat = HortonChatMsg

local function HortonChannelSetup()
	channel, channelName, instanceID = GetChannelName(HortonChannel)
	ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, channel)
	channelReady = true
	says("Horton finds his very own channel")
	says("Horton turned on the chatlog")
end

function CensusPlus_GetUniqueRealmName()
	
	local realmname = GetRealmName()
	local guid = UnitGUID("player")
    local realmid = string.match(guid, "^Player%-(%d+)")
	
	return realmid .. "_" .. realmname

end

-- Set up confirmation boxes
StaticPopupDialogs["CP_PURGE_CONFIRM"] = {
	text = CENSUSPLUS_PURGE_LOCAL_CONFIRM,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		CensusPlus_DoPurge()
	end,
	--  sound = "levelup2",
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	showAlert = 1
}

-- Set up Continue after override box  .. no longer valid
StaticPopupDialogs["CP_CONTINUE_CENSUS"] = {
	text = CENSUSPlus_OVERRIDE_COMPLET_PAUSED,
	button1 = CENSUSPlus_CONTINUE,
	OnAccept = function()
		CPp.CensusPlusManuallyPaused = false
		CensusPlusTakeButton:SetText(CENSUSPLUS_PAUSE)
	end,
	--  sound = "levelup2",
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	showAlert = 1
}


-- Insert a job at the end of the job queue
local function InsertJobIntoQueue(job) 
	--CensusPlus_DumpJob( job )
	table.insert(CensusPlus_JobQueue, job)
end

-- Initialize the tables of constants for XP calculations
local function InitConstantTables()
	-- XP earned for killing
	for i = 1, MAX_CHARACTER_LEVEL, 1 do
		g_MobXPByLevel[i] = i
	end

	-- XP required to advance through the given level
	for i = 1, MAX_CHARACTER_LEVEL, 1 do
		g_CharacterXPByLevel[i] = ((8 * i * g_MobXPByLevel[i]) / 100) * 100
	end

	-- Total XP required to attain the given level
	local totalCharacterXP = 0
	for i = 1, MAX_CHARACTER_LEVEL, 1 do
		--g_TotalCharacterXPPerLevel[i] = totalCharacterXP;
		--totalCharacterXP = totalCharacterXP + g_CharacterXPByLevel[i];
		val = (i * 5) / MAX_CHARACTER_LEVEL
		g_TotalCharacterXPPerLevel[i] = math.exp(val)
	end
end

-- Return a table of races for the input faction
function CensusPlus_GetFactionRaces(faction)
	local ret = {};
	if (faction == CENSUSPlus_HORDE) then
		ret = {CENSUSPLUS_ORC, CENSUSPLUS_TAUREN, CENSUSPLUS_TROLL, CENSUSPLUS_UNDEAD};
	elseif (faction == CENSUSPlus_ALLIANCE) then
		ret = {CENSUSPLUS_DWARF, CENSUSPLUS_GNOME, CENSUSPLUS_HUMAN, CENSUSPLUS_NIGHTELF};
	end
	return ret;
end

-- Return a table of classes for the input faction
-- the following function hasn't really been needed since Burning Crusade xPac v2.03..
-- but might (not likely) be needed in the future.
function CensusPlus_GetFactionClasses(faction)  
	-- this is last in first out list... add new classes to front of list.
	local ret = {};
	if (faction == CENSUSPlus_HORDE) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, CENSUSPLUS_SHAMAN, 
		CENSUSPLUS_MAGE, CENSUSPLUS_WARLOCK, CENSUSPLUS_DRUID};
	elseif (faction == CENSUSPlus_ALLIANCE) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_PALADIN, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, 
		CENSUSPLUS_MAGE, CENSUSPLUS_WARLOCK, CENSUSPLUS_DRUID};
	end
	return ret;
end

-- Return a table of classes for the input race
local function GetRaceClasses(race)
	local ret = {};
	if (race == CENSUSPLUS_ORC) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_SHAMAN, CENSUSPLUS_WARLOCK}
	elseif (race == CENSUSPLUS_TAUREN) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_HUNTER, CENSUSPLUS_SHAMAN, CENSUSPLUS_DRUID}
	elseif (race == CENSUSPLUS_TROLL) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, CENSUSPLUS_SHAMAN, CENSUSPLUS_MAGE}
	elseif (race == CENSUSPLUS_UNDEAD) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, CENSUSPLUS_MAGE, CENSUSPLUS_WARLOCK}
	elseif (race == CENSUSPLUS_DWARF) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_PALADIN, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST}
	elseif (race == CENSUSPLUS_GNOME) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_ROGUE, CENSUSPLUS_MAGE, CENSUSPLUS_WARLOCK}
	elseif (race == CENSUSPLUS_HUMAN) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_PALADIN, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, CENSUSPLUS_MAGE, CENSUSPLUS_WARLOCK}
	elseif (race == CENSUSPLUS_NIGHTELF) then
		ret = {CENSUSPLUS_WARRIOR, CENSUSPLUS_HUNTER, CENSUSPLUS_ROGUE, CENSUSPLUS_PRIEST, CENSUSPLUS_DRUID}
	end
	return ret
end

-- Return common letters found in zone names
-- only used for census splitting by zone.. not used
local function GetZoneLetters()
	return {"t", "d", "g", "f", "h", "b", "x", "gulch", "valley", "basin" };
end

-- Return common letters found in names, may override this for other languages
-- Worst case scenario is to do it for every letter in the alphabet
--[[
	see http://www.warcraftrealms.com/forum/viewtopic.php?t=4819&start=40
	Advantage: as seen from data sample
	removing the last 3 selectors "mkc" returned about same counts as current set.. 
	adding the "mkc" making the selector count the same increased found unique names by %0.17
	disavantage: as seen from data sample
	current selector will generates a duplicate name hit of 3.27 duplicates /unique name
	alternate selector will generate a duplicate name hit of 4.04 duplicates /unique name
	shortened alternate will generate duplicate name hit of 3.47 duplicates /unique name
]]
local function GetNameLetters()
	return { "a", "b", "c", "d", "e", "f", "g", "i", "o", "p", "r", "s", "t", "u", "y" }
end

local function GetNameLetters1()
	return {"a", "e", "r", "i", "n", "o", "l", "s", "t", "h", "d", "u", "m", "k", "c" }
end

local function GetNameLetters2()
	return {"a", "e", "r", "i", "n", "o", "l", "s", "t", "h", "d", "u"}
end

-- Called when the main window is shown
function CensusPlus_OnShow() -- referenced by CensusPlusClassic.xml
	-- Initialize if this is the first OnShow event
	if g_CensusPlusInitialized and g_VariablesLoaded then
		CensusPlus_UpdateView()
	end
end

-- Toggle hidden status
function CensusPlus_Toggle()
	if CensusPlusClassic:IsVisible() then
		CensusPlusClassic:Hide()
	else
		CensusPlusClassic:Show()
	end
end

-- Toggle options pane
-- referenced by CensusPlusClassic.xml
function CensusPlus_ToggleOptions(self)
	PlaySound(856, "Master")

	if not InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Show()
	end
	InterfaceOptionsFrame_OpenToCategory("CensusPlusClassic")
	--		CensusPlusSetCheckButtonState()
end

-- referenced by CensusPlusClassic.xml
function CensusPlus_OnLoad(self)
	-- Update the version number
	CensusPlusText:SetText(
		"CensusPlusClassic v" .. CensusPlus_VERSION .. CensusPlus_SubVersion
	)
	CensusPlusText2:SetText(CENSUSPLUS_UPLOAD)

	-- Init constant tables
	InitConstantTables()

	-- Register for events
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	-- Called once on load
	-- SLASH_CensusPlusVerbose1 = "/censusverbose";
	-- SlashCmdList["CensusPlusVerbose"] = CensusPlus_Verbose_toggle("alter");
	SLASH_CensusPlusCMD1 = "/CensusPlusClassic"
	SLASH_CensusPlusCMD2 = "/Census+"
	SLASH_CensusPlusCMD3 = "/Census"
	SlashCmdList["CensusPlusCMD"] = CensusPlus_Command

	CensusPlus_CheckForBattleground()

	--  Set up an empty frame for updates
	local updateFrame = CreateFrame("Frame")
	updateFrame:SetScript("OnUpdate", CensusPlus_OnUpdate)
end


function CP_ProcessWhoEvent(query, result, complete)
	if (CPp.IsCensusPlusInProgress ~= true) then return end

	local numWhoResults = 0
	local cpdb_complete_flag = ""
	whoquery_answered = true
	if (CensusPlus_WHOPROCESSOR == CP_libwho) then
		if complete then
			cpdb_complete_flag = "" -- :complete"
			numWhoResults = #result -- :too many"
		else
			cpdb_complete_flag = ""
			numWhoResults = MAX_WHO_RESULTS
		end
	else
		numWhoResults = C_FriendList.GetNumWhoResults()
	end

	if (g_Verbose == true) then
		CensusPlus_Msg(
			CENSUSPLUS_WHOQUERY .. " " .. query .. ", " .. CENSUSPLUS_FOUND .. " " .. numWhoResults .. cpdb_complete_flag
		)
		--CensusPlus_Msg(CENSUSPLUS_WHOQUERY.." "..query);
	end

	if (numWhoResults == 0) then
		--print("no results returned")
		local whoText = CensusPlus_CreateWhoText(g_CurrentJob)
		if whoText and whoText == query then
			g_WaitingForWhoUpdate = false
			whoquery_active = false
			whoquery_answered = false
		end
		-- remove job from the queue
		table.remove(CensusPlus_JobQueue)
		return
	end

	CensusPlus_ProcessWhoResults(result, numWhoResults)

	
	if ((CensusPlus_WHOPROCESSOR == CP_libwho) and not complete) or ((CensusPlus_WHOPROCESSOR == CP_api) and (numWhoResults > MAX_WHO_RESULTS)) then
		-- Who list is overflowed, split the query to make the return smaller
		local minLevel = g_CurrentJob.m_MinLevel
		local maxLevel = g_CurrentJob.m_MaxLevel
		local race = g_CurrentJob.m_Race
		local class = g_CurrentJob.m_Class
		local zoneLetter = g_CurrentJob.m_zoneLetter
		local letter = g_CurrentJob.m_Letter

		if (minLevel ~= maxLevel and minLevel ~= 0) then
			-- The level range is greater than a single level, so split it in half and submit the two jobs
			local pivot = floor((minLevel + maxLevel) / 2)
			local jobLower =
				CensusPlus_CreateJob(minLevel, pivot, nil, nil, nil)
			InsertJobIntoQueue(jobLower)
			local jobUpper =
				CensusPlus_CreateJob(pivot + 1, maxLevel, nil, nil, nil)
			InsertJobIntoQueue(jobUpper)
		else
			-- We cannot split the level range any more
			local factionGroup = UnitFactionGroup("player")
			local level = minLevel
			if (race == nil) then
				-- This job does not specify race, so split it that way, making jobs for each race]
				local thisFactionRaces =
					CensusPlus_GetFactionRaces(factionGroup)
				local numRaces = #thisFactionRaces
				for i = 1, numRaces, 1 do
					if (CENSUSPLUS_LIGHTFORGED ~= thisFactionRaces[i]) and (CENSUSPLUS_HIGHMOUNTAIN ~= thisFactionRaces[i]) then
						local job =
							CensusPlus_CreateJob(
								level,
								level,
								thisFactionRaces[i],
								nil,
								nil
							)
						InsertJobIntoQueue(job)
					end
				end
			else
				if (class == nil) then
					-- This job does not specify class, so split it that way, making jobs for each class
					local thisRaceClasses = GetRaceClasses(race)
					local numClasses = #thisRaceClasses
					for i = 1, numClasses, 1 do
						if CENSUSPLUS_DEMONHUNTER ~= thisRaceClasses[i] then
							local job =
								CensusPlus_CreateJob(
									level,
									level,
									race,
									thisRaceClasses[i],
									nil
								)
							InsertJobIntoQueue(job)
						end
					end
				else
					if (letter == nil) then
						-- There are too many characters with a single level, class and race
						-- The work around we are going to pursue is to check by name for a,e,i,o,r,s,t,u
						local letters = {}
						if CP_letterselect == 0 then
							letters = GetNameLetters()
						elseif CP_letterselect == 1 then
							letters = GetNameLetters1()
						elseif CP_letterselect == 2 then
							letters = GetNameLetters2()
						end

						for i = 1, #letters, 1 do
							local job =
								CensusPlus_CreateJob(
									level,
									level,
									race,
									class,
									letters[i]
								)
							InsertJobIntoQueue(job)
						end
						-- Block of code removed that isn't currently or ever used.. splitting by zone
					else
						-- There are too many characters with a single level, class, race and letter, give up
						local whoText = CensusPlus_CreateWhoText(g_CurrentJob)
						if (g_Verbose == true) then
							CensusPlus_Msg(format(CENSUSPLUS_TOOMANY, whoText))
						end
					end
				end
			end
		end
	else
	end

	local whoText = CensusPlus_CreateWhoText(g_CurrentJob)

	if whoText == query then
		g_WaitingForWhoUpdate = false
	end
end
  
-- CensusPlusClassic Friends Frame override to stop the window close sound
local function CensusPlus_FriendsFrame_OnHide()
	g_Pre_FriendsFrameOnHideOverride()
end

-- CensusPlusClassic Friends Frame override to stop the window close sound
local function CensusPlus_FriendsFrame_OnShow()
	g_Pre_FriendsFrameOnShowOverride()
end

-- CensusPlusClassic command
function CensusPlus_Command(param)
	local jcmdend = 0
	local jvalend = 0
	local jfolend = 0
	local command = nil
	local value = nil
	local nameval = nil
	local followon = nil
	local levelon = 0
	local _ = nil

	if (param ~= nil) then
		param = string.lower(param)
		_, jcmdend, command = string.find(param, "(%w+)")
		if (command == "options") then
			CensusPlus_ToggleOptions()
		elseif (command == "take") then
			CENSUSPLUS_TAKE_OnClick()
		elseif (command == "me") then
			CensusPlayerOnly = true
			CENSUSPLUS_TAKE_OnClick()
		elseif (command == "stop") then
			CENSUSPLUS_STOPCENSUS()
		elseif (command == "serverprune") then
			_, jvalend, value = string.find(param, "(%w+)", jcmdend + 1) -- alphanumeric selector used to warn of bad input
			if (value ~= nil) then
				value = tonumber(value)
				if (value ~= nil) then
					CENSUSPLUS_PRUNEData(value, 1) -- value isn't a number .. bad user input
				else
					CENSUSPLUS_PRUNEData(0, 1)
				end -- value is nil
			else
				CENSUSPLUS_PRUNEData(0, 1)
			end
		elseif (command == "verbose") then
			CensusPlus_Verbose_toggle("alter")
		elseif (command == "stealth") then
			CensusPlus_Stealth_toggle("alter")
		elseif (command == "prune") then
			_, jvalend, value = string.find(param, "(%w+)", jcmdend + 1) -- alphanumeric selector used to warn of bad input
			if (value ~= nil) then
				value = tonumber(value)
				if (value ~= nil) then
					CENSUSPLUS_PRUNEData(value, nil) -- value isn't a number .. bad user input
				else
					CENSUSPLUS_PRUNEData(30, nil)
				end -- value is nil
			else
				CENSUSPLUS_PRUNEData(30, nil)
			end
		elseif (command == "timer") then
			_, jvalend, value = string.find(param, "(%d+)", jcmdend + 1) -- decimal seletor works here, if bad input just reset timer
			if (value ~= nil) then
				value = tonumber(value)
			end
			CensusPlus_TimerSet(self, value, true)
		elseif (command == "who") then -- get 2nd term
			_, jvalend, nameval = string.find(param, "(%w+)", jcmdend + 1) --alphanumeric selector used to give warning of bad input
			if (nameval ~= nil) then -- nameval found non nil
				_, jfalend, followon = string.find(param, "(%a+)", jcmdend + 1) -- see if same match is found as alpha only
				if (nameval == followon) then -- alpha world so get 3rd term
					_, jfalend, followon =
						string.find(param, "(%w+)", jvalend + 1) --alphanumeric selector used to give warning of bad input
					if (followon == nil) then -- no 3rd term found
						CensusPlus_InternalWho(string.lower(nameval), nil) -- 3rd term found
					else
						levelon = tonumber(followon)
						CensusPlus_InternalWho(
							string.lower(nameval),
							string.lower(levelon)
						)
					end -- 2nd term is a number -- 3rd term is NOT a number
				else
					CensusPlus_Msg(CENSUSPLUS_CMDERR_WHO2NUM)
				end -- 2nd term is nil -- 2nd term is ""
			else
				CensusPlus_Msg(CENSUSPLUS_CMDERR_WHO2)
			end
		elseif (command == "wholibdebug") then
			_, jvalend, value = string.find(param, "(%w+)", jcmdend + 1) -- alphanumeric selector used to warn of bad input
			wholib = wholib or LibStub:GetLibrary("LibWho-2.0", true)
			wholib:SetWhoLibDebug(value)
		elseif (param == "debug") then
			if (HortonBug == false) then
				chat("Horton puts trunk in Rabbit hole and blows real hard")
				HortonChannelSetup()
				JoinTemporaryChannel(HortonChannel)
				LoggingChat(true)
				HortonBug = true
				says("Hello HortonChannel")
			else
				says("Horton turns off the chatlog")
				LoggingChat(false)
				HortonBug = false
			end
		else
			CensusPlus_DisplayUsage()
		end
	else
		CensusPlus_DisplayUsage()
	end
end

function CensusPlus_Verbose(self)
	--print(CensusPlus_Database["Info"]["Verbose"])
	--print(CensusPlus_PerCharInfo["Verbose"])
	if ((CensusPlus_PerCharInfo["Verbose"] == nil) and (CensusPlus_Database["Info"]["Verbose"] == true)) then
		CensusPlus_Verbose_toggle("On")
	elseif ((CensusPlus_PerCharInfo["Verbose"] == nil) and (CensusPlus_Database["Info"]["Verbose"] == false)) then
		CensusPlus_Verbose_toggle("Off")
	elseif (CensusPlus_PerCharInfo["Verbose"] == true) then
		CensusPlus_Verbose_toggle("On")
	elseif (CensusPlus_PerCharInfo["Verbose"] == false) then
		CensusPlus_Verbose_toggle("Off")
	else
	end
end

function CensusPlus_Verbose_toggle(state)
	if (state == "alter") then
		if (g_Verbose == true) then
			g_Verbose = false
			CensusPlus_Msg(CENSUSPLUS_VERBOSEOFF)
		else
			g_Verbose = true
			g_stealth = false
			CensusPlus_Msg(CENSUSPLUS_VERBOSEON)
		end
	elseif (state == "On") then
		g_Verbose = true
		g_stealth = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_VERBOSEON)
		end
	elseif (state == "Off") then
		g_Verbose = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_VERBOSEOFF)
		end
	end
end

local function CensusPlus_Stealth(self)
	--print(CensusPlus_Database["Info"]["Stealth"])
	--print(CensusPlus_PerCharInfo["Stealth"])
	if ((CensusPlus_PerCharInfo["Stealth"] == nil) and (CensusPlus_Database["Info"]["Stealth"] == true)) then
		CensusPlus_Stealth_toggle("On")
	elseif ((CensusPlus_PerCharInfo["Stealth"] == nil) and (CensusPlus_Database["Info"]["Stealth"] == false)) then
		CensusPlus_Stealth_toggle("Off")
	elseif (CensusPlus_PerCharInfo["Stealth"] == true) then
		CensusPlus_Stealth_toggle("On")
	elseif (CensusPlus_PerCharInfo["Stealth"] == false) then
		CensusPlus_Stealth_toggle("Off")
	else
	end
end

function CensusPlus_Stealth_toggle(state)
	if (state == "alter") then
		if (g_stealth == true) then
			g_stealth = false
			CensusPlus_Msg(CENSUSPLUS_STEALTHOFF)
		else
			g_Verbose = false
			CensusPlus_Msg(CENSUSPLUS_STEALTHON)
			g_stealth = true
		end
	elseif (state == "On") then
		g_Verbose = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_STEALTHON)
		end
		g_stealth = true
	elseif (state == "Off") then
		g_stealth = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_STEALTHOFF)
		end
	end
end

local function CensusPlus_CensusButtonShown(self)
	--print(CensusPlus_Database["Info"]["CensusButtonShown"])
	--print(CensusPlus_PerCharInfo["CensusButtonShown"])
	if ((CensusPlus_PerCharInfo["CensusButtonShown"] == nil) and (CensusPlus_Database["Info"]["CensusButtonShown"] == true)) then
		CensusPlus_CensusButtonShown_toggle("On")
		--_G[CensusButton:GetName().."Text"]:SetText("C+")
	elseif ((CensusPlus_PerCharInfo["CensusButtonShown"] == nil) and (CensusPlus_Database["Info"]["CensusButtonShown"] == false)) then
		CensusPlus_CensusButtonShown_toggle("Off")
	elseif (CensusPlus_PerCharInfo["CensusButtonShown"] == true) then
		--CensusButton:SetText("30")
		CensusPlus_CensusButtonShown_toggle("On")
	elseif (CensusPlus_PerCharInfo["CensusButtonShown"] == false) then
		CensusPlus_CensusButtonShown_toggle("Off")
	else
	end
end

function CensusPlus_CensusButtonShown_toggle(state)
	if (state == "alter") then
		if (g_CensusButtonShown == true) then
			g_CensusButtonShown = false
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONSHOWNOFF)
			CensusButtonFrame:Hide()
		else
			g_CensusButtonShown = true
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONSHOWNON)
			CensusButtonFrame:Show()
		end
	elseif (state == "On") then
		g_CensusButtonShown = true
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONSHOWNON)
		end
		CensusButtonFrame:Show()
	elseif (state == "Off") then
		g_CensusButtonShown = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONSHOWNOFF)
		end
		CensusButtonFrame:Hide()
	end
end

local function CensusPlus_CensusButtonAnimi(self)
	--print(CensusPlus_Database["Info"]["CensusButtonAnimi"])
	--print(CensusPlus_PerCharInfo["CensusButtonAnimi"])
	if ((CensusPlus_PerCharInfo["CensusButtonAnimi"] == nil) and (CensusPlus_Database["Info"]["CensusButtonAnimi"] == true)) then
		CensusPlus_CensusButtonAnimi_toggle("On")
		--_G[CensusButton:GetName().."Text"]:SetText("C+")
	elseif ((CensusPlus_PerCharInfo["CensusButtonAnimi"] == nil) and (CensusPlus_Database["Info"]["CensusButtonAnimi"] == false)) then
		--print("CensusButtonAnimi 2")
		CensusPlus_CensusButtonAnimi_toggle("Off")
	elseif (CensusPlus_PerCharInfo["CensusButtonAnimi"] == true) then
		--CensusButton:SetText("30")
		CensusPlus_CensusButtonAnimi_toggle("On")
	elseif (CensusPlus_PerCharInfo["CensusButtonAnimi"] == false) then
		CensusPlus_CensusButtonAnimi_toggle("Off")
	else
	end
end

function CensusPlus_CensusButtonAnimi_toggle(state)
	if (state == "alter") then
		if (g_CensusButtonAnimi == true) then
			g_CensusButtonAnimi = false
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONANIMIOFF)
			CensusButton:SetNormalFontObject(GameFontNormal)
			CensusButton:SetText("C+")
		else
			g_CensusButtonAnimi = true
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONANIMION)
		end
		--CensusButtonFrame:Show()
	elseif (state == "On") then
		g_CensusButtonAnimi = true
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONANIMION)
		end
		--CensusButtonFrame:Show()
	elseif (state == "Off") then
		g_CensusButtonAnimi = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_CENSUSBUTTONANIMIOFF)
		end
		CensusButton:SetNormalFontObject(GameFontNormal)
		CensusButton:SetText("C+")
	end
end

function CensusPlus_FinishSound(state)
	--print(CensusPlus_Database["Info"]["PlayFinishSound"])
	--print(CensusPlus_PerCharInfo["PlayFinishSound"])
	if ((CensusPlus_PerCharInfo["PlayFinishSound"] == nil) and (CensusPlus_Database["Info"]["PlayFinishSound"] == true)) then
		CensusPlus_FinishSound_toggle("On")
		--_G[CensusButton:GetName().."Text"]:SetText("C+")
	elseif ((CensusPlus_PerCharInfo["PlayFinishSound"] == nil) and (CensusPlus_Database["Info"]["PlayFinishSound"] == false)) then
		CensusPlus_FinishSound_toggle("Off")
	elseif (CensusPlus_PerCharInfo["PlayFinishSound"] == true) then
		--CensusButton:SetText("30")
		CensusPlus_FinishSound_toggle("On")
	elseif (CensusPlus_PerCharInfo["PlayFinishSound"] == false) then
		CensusPlus_FinishSound_toggle("Off")
	else
	end
end

function CensusPlus_FinishSound_toggle(state)
	if (state == "alter") then
		if (g_PlayFinishSound == true) then
			g_PlayFinishSound = false
			CensusPlus_Msg(CENSUSPLUS_PLAYFINISHSOUNDOFF)
		else
			g_PlayFinishSound = true
			CensusPlus_Msg(CENSUSPLUS_PLAYFINISHSOUNDON)
		end
	elseif (state == "On") then
		g_PlayFinishSound = true
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_PLAYFINISHSOUNDON)
		end
	elseif (state == "Off") then
		g_PlayFinishSound = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_PLAYFINISHSOUNDOFF)
		end
	end
end

-- CensusPlusClassic Auto Census set flag
local function CensusPlus_SetAutoCensus(self)
	--print(CensusPlus_Database["Info"]["AutoCensus"])
	--print(CensusPlus_PerCharInfo["AutoCensus"])
	if ((CensusPlus_PerCharInfo["AutoCensus"] == nil) and (CensusPlus_Database["Info"]["AutoCensus"] == true)) then
		CensusPlus_AutoCensus_toggle("On")
		--_G[CensusButton:GetName().."Text"]:SetText("C+")
	elseif ((CensusPlus_PerCharInfo["AutoCensus"] == nil) and (CensusPlus_Database["Info"]["AutoCensus"] == false)) then
		CensusPlus_AutoCensus_toggle("Off")
	elseif (CensusPlus_PerCharInfo["AutoCensus"] == true) then
	    --CensusButton:SetText("30")
		CensusPlus_AutoCensus_toggle("On")
	elseif (CensusPlus_PerCharInfo["AutoCensus"] == false) then
		CensusPlus_AutoCensus_toggle("Off")
	else
		print("call AutoCensus farm")
	end
end

function CensusPlus_AutoCensus_toggle(state)
	if (state == "alter") then
		if (CPp.AutoCensus == true) then
			CPp.AutoCensus = false
			CensusPlus_Msg(CENSUSPLUS_AUTOCENSUSOFF)
		else
			CPp.AutoCensus = true
			CensusPlus_Msg(CENSUSPLUS_AUTOCENSUSON)
		end
	elseif (state == "On") then
		CPp.AutoCensus = true
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_AUTOCENSUSON)
		end
	elseif (state == "Off") then
		CPp.AutoCensus = false
		if (g_Options_confirm_txt and not (CPp.FirstLoad == true)) then
			CensusPlus_Msg(CENSUSPLUS_AUTOCENSUSOFF)
		end
	end
end

-- CensusPlusClassic Display Usage
function CensusPlus_DisplayUsage()
	CensusPlusClassic:Show()
	local stealthUsage = g_stealth
	g_stealth = false
	CensusPlus_Msg(
		CENSUSPLUS_USAGE .. "\n  /CensusPlusClassic" .. CENSUSPLUS_OR .. "/Census+ " .. CENSUSPLUS_OR .. "/Census" .. CENSUSPLUS_AND .. CENSUSPLUS_HELP_0
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUS_OPTIONS_VERBOSE .. CENSUSPLUS_HELP_1
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUS_OPTIONS_STEALTH .. CENSUSPLUS_HELP_11
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUSPLUS_BUTTON_OPTIONS .. CENSUSPLUS_HELP_2
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUSPLUS_TAKE .. CENSUSPLUS_HELP_3
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUSPLUS_STOP .. CENSUSPLUS_HELP_4
	)
	CensusPlus_Msg(
		"  /CensusPlusClassic " .. CENSUSPLUS_PRUNE .. CENSUSPLUS_HELP_5
	)
	CensusPlus_Msg("  /CensusPlusClassic serverprune" .. CENSUSPLUS_HELP_6)
	CensusPlus_Msg("  /CensusPlusClassic who name" .. CENSUSPLUS_HELP_7)
	CensusPlus_Msg("  /CensusPlusClassic who unguilded 70" .. CENSUSPLUS_HELP_8)
	CensusPlus_Msg("  /CensusPlusClassic timer X " .. CENSUSPLUS_HELP_9)
	CensusPlus_Msg("  /CensusPlusClassic me" .. CENSUSPLUS_HELP_10)
	g_stealth = stealthUsage
end

-- CensusPlus_InternalWho - will go through our local database and see if we have
-- any info on this person
function CensusPlus_InternalWho(search, level)
	g_InternalSearchName = search
	g_InternalSearchLevel = level
	g_InternalSearchCount = 0
	local realmName = CensusPlus_GetUniqueRealmName()

	CensusPlus_ForAllCharacters(
		realmName,
		UnitFactionGroup("player"),
		nil,
		nil,
		nil,
		nil,
		CensusPlus_InternalWhoResult
	)

	CensusPlus_WhoMsg(
		CENSUSPLUS_FOUND_CAP .. g_InternalSearchCount .. CENSUSPLUS_PLAYERS
	)
end

function CensusPlus_InternalWhoResult(name, level, guild, race, class, lastSeen)
	lowerName = string.lower(name)
	level = string.lower(level)
	lowerGuild = string.lower(CensusPlus_SafeCheck(guild))
	if (g_InternalSearchName == "unguilded") then
		if (guild == "") then
			local doit = 1
			if (g_InternalSearchLevel ~= nil) then
				if (g_InternalSearchLevel ~= level) then
					doit = 0
				end
			end
			if (doit == 1) then
				local out =
					name .. " : " .. LEVEL .. " " .. level .. " " .. race .. " " .. " " .. class
				out = out .. CENSUSPLUS_LASTSEEN_COLON .. lastSeen
				CensusPlus_WhoMsg(out)
				g_InternalSearchCount = g_InternalSearchCount + 1
			end
		end
		-- found someone!
	elseif (string.find(lowerName, g_InternalSearchName) or string.find(
		lowerGuild,
		g_InternalSearchName
	)) then
		local out =
			name .. " : " .. LEVEL .. " " .. level .. " " .. race .. " " .. " " .. class
		if (guild ~= "") then
			out = out .. " <" .. guild .. ">"
		end
		out = out .. CENSUSPLUS_LASTSEEN_COLON .. lastSeen
		CensusPlus_WhoMsg(out)
		g_InternalSearchCount = g_InternalSearchCount + 1
	end
end


-- Minimize the window
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnClickMinimize(self)  
    if( CensusPlusClassic:IsVisible() ) then
	    --MiniCensusPlus:Show();
        CensusPlusClassic:Hide();
    end
end

-- Minimize the window
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnClickMaximize(self)
	if MiniCensusPlus:IsVisible() then
		MiniCensusPlus:Hide()
		CensusPlusClassic:Show()
	end
end

-- Take or pause a census depending on current status
-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_TAKE_OnClick(self)
	if CPp.IsCensusPlusInProgress then
		--CensusPlus_Msg(CENSUSPLUS_ISINPROGRESS);
		CensusPlus_TogglePause()
	else
		CensusPlus_StartCensus()
	end
end

-- Display a tooltip for the take button
-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_TAKE_OnEnter(self, motion)
	if (motion == true) then
		if CPp.IsCensusPlusInProgress then
			if CPp.CensusPlusManuallyPaused then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(CENSUSPLUS_UNPAUSECENSUS, 1.0, 1.0, 1.0)
				GameTooltip:Show()
			else
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(CENSUSPLUS_PAUSECENSUS, 1.0, 1.0, 1.0)
				GameTooltip:Show()
			end
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(CENSUSPLUS_TAKECENSUS, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	-- frame created underneath cursor.. not cursor movement to frame
	else
	end
end

-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_STOP_OnEnter(self, motion)
	if (motion == true) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(CENSUSPLUS_STOPCENSUS_TOOLTIP, 1.0, 1.0, 1.0)
		GameTooltip:Show()
	-- frame created underneath cursor.. not cursor movement to frame
	else
	end
end


function CensusPlus_TimerSet(self, minutes, ovrride)
	if minutes == nil then
		minutes = 30
	end
	if ovrride then
		CensusPlus_PerCharInfo["AutoCensusTimer"] = minutes * 60
		--print("CCO Timer = "..minutes)
		--print("AW timer = "..minutes)
	else
		CensusPlus_Database["Info"]["AutoCensusTimer"] = minutes * 60
	end
	--CensusPlus_Msg( CENSUS_OPTIONS_AUTOCENSUS.." "..CENSUSPLUS_AUTOCENSUS_DELAYTIME .." ".. minutes);
end

local function CensusPlus_BackgroundAlpha(self,steps)
	CensusPlus_Database["Info"]["CPWindow_Transparency"] = steps
end
	
-- Pause the current census
function CensusPlus_TogglePause()
	if (CPp.IsCensusPlusInProgress == true) then
		if (CPp.CensusPlusManuallyPaused == true) then
			CensusPlusTakeButton:SetText(CENSUSPLUS_PAUSE)
			CPp.CensusPlusManuallyPaused = false
		else
			CensusPlusTakeButton:SetText(CENSUSPLUS_UNPAUSE)
			if (g_Verbose == true) then
				CensusPlus_Msg(CENSUSPLUS_PAUSECENSUS)
			end

			CPp.CensusPlusManuallyPaused = true
			CensusPlayerOnly = false
		end
	end
end

-- Purge the database for this realm and faction
-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_PURGE_OnClick()
	StaticPopup_Show ("CP_PURGE_CONFIRM");
end

-- CensusPlus_DoPurge
function CensusPlus_DoPurge()
	if (CensusPlus_Database["Servers"] ~= nil) then
		CensusPlus_Database["Servers"] = nil
	end
	CensusPlus_Database["Servers"] = {}
	CensusPlus_UpdateView()
	--CensusPlus_Msg(CENSUSPLUS_PURGEMSG);

	if (CensusPlus_Database["Guilds"] ~= nil) then
		CensusPlus_Database["Guilds"] = nil
	end
	CensusPlus_Database["Guilds"] = {}

	if (CensusPlus_Database["TimesPlus"] ~= nil) then
		CensusPlus_Database["TimesPlus"] = nil
	end
	CensusPlus_Database["TimesPlus"] = {}

	if (CensusPlus_Profile ~= nil) then
		CensusPlus_Profile = nil
	end
	CensusPlus_Profile = {}

	if not (CPp.FirstLoad == true) then
		CensusPlus_Msg(CENSUSPLUS_PURGEDALL)
	end
end

-- Take a CensusPlusClassic
function CensusPlus_StartCensus()
	CensusPlusTakeButton:SetText(CENSUSPLUS_PAUSE)

	--[[ work in progress - continue census run from last state on DC or valid Character stop restart.
         Determine if pre-existing jobqueue exists from running job that was DCed or paused and logged out.
         if exists that determine delay since last queue completion.. 
         if more then x time then dump queues and restart as new start else set below states to active run status and process existing queues.
     --]]

	-- used to trigger queue processing when OnUpdate
	g_FirstRun = true
	local g_factionGroup = UnitFactionGroup("player")
	local realm = ""
	local lastjobtimediff = 1
	local realmName = CensusPlus_GetUniqueRealmName()
	--print( "Prep for start");
	if (CensusPlus_JobQueue.CensusPlus_last_time and CensusPlus_JobQueue.CensusPlus_last_time > 1) then
		lastjobtimediff = time() - CensusPlus_JobQueue.CensusPlus_last_time
		--print( "got time");
		--print( lastjobtimediff);
	else
		CensusPlus_JobQueue.CensusPlus_last_time = 1000
		lastjobtimediff = time() - CensusPlus_JobQueue.CensusPlus_last_time
	end
	if not CensusPlus_JobQueue.CensusPlus_LoginRealm then
		CensusPlus_JobQueue.CensusPlus_LoginRealm = " "
		--print( "typed Realm");
	end
	if not CensusPlus_JobQueue.CensusPlus_LoginFaction then
		CensusPlus_JobQueue.CensusPlus_LoginFaction = " "
	end
	--print(lastjobtimediff);
	if (lastjobtimediff <= 300 and CensusPlus_JobQueue.CensusPlus_LoginFaction and CensusPlus_JobQueue.CensusPlus_LoginRealm and (CensusPlus_JobQueue.CensusPlus_LoginFaction == g_factionGroup) and (CensusPlus_JobQueue.CensusPlus_LoginRealm == realmName)) then
		--print ("continue last Census");
		local queue_entry_count = #CensusPlus_JobQueue
		--print (queue_entry_count);
		g_FirstRun = False
		--print ("Start new Census");
	else
		CensusPlus_JobQueue = {}
		CensusPlus_JobQueue.g_NumNewCharacters = 0
		CensusPlus_JobQueue.g_NumUpdatedCharacters = 0
		CensusPlus_Zero_g_TimeDatabase()
		CensusPlus_JobQueue.g_TempCount = nil
		CensusPlus_JobQueue.g_TempCount = {}
	end

	CensusPlus_UpdateView()
	if (g_factionGroup == nil or g_factionGroup == CENSUSPlus_NEUTRAL) then
		CensusPlus_Msg(CENSUSPLUS_NOTINFACTION)
		CPp.LastCensusRun = time()
	--return;
	elseif CPp.IsCensusPlusInProgress then
		--if( CPp.CensusPlusManuallyPaused == true ) then
		--  CPp.CensusPlusManuallyPaused = false;
		--  CensusPlusPauseButton:SetText( CENSUSPLUS_PAUSE );
		--else
		-- D.o not initiate a new CensusPlusClassic whi.le one is in progress
		CensusPlus_Msg(
			"Census in progress but this message should not have shown"
		)
		  --return
		--end
	elseif g_CurrentlyInBG then
		CPp.LastCensusRun = time() - 600
		if not g_CurrentlyInBG_Msg then
			CensusPlus_Msg(CENSUSPLUS_ISINBG)
			g_CurrentlyInBG_Msg = true
		end
	else
		--
		--  Set a timer
		--
		g_CensusPlus_StartTime = time()
		--
		-- Initialize the job queue and counters
		--
		CensusPlus_Msg(CENSUSPLUS_TAKINGONLINE)

		local realmName = CensusPlus_GetUniqueRealmName()
		CensusPlus_JobQueue.CensusPlus_LoginRealm = realmName
		CensusPlus_JobQueue.CensusPlus_LoginFaction = g_factionGroup
		if (HortonBug == true) then
			says("after check local realm = " .. realmName)
		end

		if CensusPlayerOnly then
			if (UnitLevel("player") >= MIN_CHARACTER_LEVEL) then
				local meplayer = GetUnitName("player")
				local job =
					CensusPlus_CreateJob(
						MIN_CHARACTER_LEVEL,
						MAX_CHARACTER_LEVEL,
						nil,
						nil,
						meplayer
					)
				InsertJobIntoQueue(job)
				CPp.IsCensusPlusInProgress = true
				g_WaitingForWhoUpdate = false
				CPp.CensusPlusManuallyPaused = false

				local hour, minute = GetGameTime()
				g_TakeHour = hour
				g_ResetHour = true

				wholib = wholib or LibStub:GetLibrary("LibWho-2.0", true)
			-- queue who for player into job que
			elseif (UnitLevel("player") < MIN_CHARACTER_LEVEL) then
				CensusPlus_Msg("Player is below level 20")
				CensusPlayerOnly = false
			elseif CPp.IsCensusPlusInProgress then
				CensusPlus_Msg(CENSUSPLUS_ISINPROGRESS)
				CensusPlayerOnly = false
			end
		else
			if (CensusPlus_Database["Info"]["CensusButtonAnimi"] == true) then
				CensusButton:SetNormalFontObject(GameFontNormalSmall)
				CensusButton:SetText(MAX_CHARACTER_LEVEL)
			end

			if g_FirstRun then
				CensusPlus_Load_JobQueue()
			end

			CPp.IsCensusPlusInProgress = true
			g_WaitingForWhoUpdate = false
			CPp.CensusPlusManuallyPaused = false

			local hour, minute = GetGameTime()
			g_TakeHour = hour
			g_ResetHour = true

			wholib = wholib or LibStub:GetLibrary("LibWho-2.0", true)
			if wholib then
				CensusPlus_Msg(CENSUSPLUS_USING_WHOLIB)
				CensusPlus_UPDATEDELAY = 60
			end
		end
	end
end


-- First we load the stack with our jobs... First in last out
function CensusPlus_Load_JobQueue()
	-- first load queue with jobs in increment of 10 from 1-10 thru max_character_level-19 - max_character_level-10
	for counter = MIN_CHARACTER_LEVEL / 10, floor(
		MAX_CHARACTER_LEVEL / 10
	) - 1, 1 do
		local job =
			CensusPlus_CreateJob(counter * 10, counter * 10 + 9, nil, nil, nil)
		InsertJobIntoQueue(job)
	end
	-- next to last job to load is Max_character_level-9 thrun Max_character_level-1  if Max_character_level modulo 10 = 0
	local job =
		CensusPlus_CreateJob(
			MAX_CHARACTER_LEVEL - 9,
			MAX_CHARACTER_LEVEL - 1,
			nil,
			nil,
			nil
		)
	InsertJobIntoQueue(job)

	-- last job to load in last in first out queus is MAX_CHARACTER_LEVEL to MAX_CHARACTER_LEVEL
	-- this is one job that will almost always en.d up having to be broken up and reloaded (depending on realm population)
	local job =
		CensusPlus_CreateJob(
			MAX_CHARACTER_LEVEL,
			MAX_CHARACTER_LEVEL,
			nil,
			nil,
			nil
		)
	InsertJobIntoQueue(job)

	--for counter = 60, MAX_CHARACTER_LEVEL, 1  do
	--  local job = CensusPlus_CreateJob( counter, counter, nil, nil, nil );
	--  InsertJobIntoQueue(job);
	--end

	--	Test inserts
	--local job = CensusPlus_CreateJob( 11, 12, "Troll", nil, nil );
	--InsertJobIntoQueue(job);
end

-- Stop a CensusPlusClassic
-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_STOPCENSUS()
	if CPp.IsCensusPlusInProgress then
		CensusPlusTakeButton:SetText(CENSUSPLUS_TAKE)
		CPp.CensusPlusManuallyPaused = false
		whoquery_answered = false
		whoquery_active = false

		CensusPlusScanProgress:SetText(CENSUSPLUS_SCAN_PROGRESS_0)

		CensusPlus_DisplayResults()
		CensusPlus_JobQueue = {}

		--  Clean up the times
		CENSUSPLUS_PRUNETimes()
	else
		CensusPlus_Msg(CENSUSPLUS_NOCENSUS)
	end
	
	-- Add revert CensusButton back to defauit
	CensusButton:SetNormalFontObject(GameFontNormal)
	CensusButton:SetText("C+")
end

-- Display Census results
function CensusPlus_DisplayResults()
	--
	-- We are all done, report our results
	--
	CPp.IsCensusPlusInProgress = false
	CensusPlusScanProgress:SetText(CENSUSPLUS_SCAN_PROGRESS_0)
	g_Consecutive = g_Consecutive + 1
	CensusPlusConsecutive:SetText(format(CENSUSPLUS_CONSECUTIVE, g_Consecutive))

	--
	--  Finish our timer
	--
	local total_time = time() - g_CensusPlus_StartTime
	local realmslisttext = ""
	if not g_stealth then
		--print( CensusPlus_JobQueue.g_NumNewCharacters);
		--print( CensusPlus_JobQueue.g_NumUpdatedCharacters);
		CensusPlus_Msg(
			format(
				CENSUSPLUS_FINISHED,
				CensusPlus_JobQueue.g_NumNewCharacters,
				CensusPlus_JobQueue.g_NumUpdatedCharacters,
				SecondsToTime(total_time)
			)
		)
		--print( CP_g_queue_count);
		if (CP_g_queue_count > 0) then
			local avg_Time_per_que = total_time / CP_g_queue_count
			--print( avg_Time_per_que);
		end
		
		realmslisttext = string.sub(realmslisttext, 3)
		ChatFrame1:AddMessage(realmslisttext, 1.0, 0.3, 0.1)
		ChatFrame1:AddMessage(CENSUSPLUS_UPLOAD, 0.1, 1.0, 1.0)
	end
	CensusPlus_UpdateView()
	CPp.LastCensusRun = time()
	CensusPlus_JobQueue.g_NumNewCharacters = 0
	CensusPlus_JobQueue.g_NumUpdatedCharacters = 0
	CensusPlusTakeButton:SetText(CENSUSPLUS_TAKE)
end

-- Create a who command text for the input job
function CensusPlus_CreateWhoText(job)
	local whoText = ""
	local race = job.m_Race
	local locale = GetLocale()
	if (race ~= nil) then
		if (locale == "ruRU") then
			whoText = whoText .. race
		else
			whoText = whoText .. ' r-"' .. race .. '"'
		end
	end

	local class = job.m_Class
	if (class ~= nil) then
		if (locale == "ruRU") then
			whoText = whoText .. class
		else
			whoText = whoText .. ' c-"' .. class .. '"'
		end
	end

	local letter = job.m_Letter
	if (letter ~= nil) then
		if (locale == "ruRU") then
			whoText = whoText .. letter
		else
			whoText = whoText .. " n-" .. letter
		end
	end

	local minLevel = tostring(job.m_MinLevel)
	if (minLevel == nil) then
		minLevel = 1
	end
	local maxLevel = job.m_MaxLevel
	if (maxLevel == nil) then
		maxLevel = MAX_CHARACTER_LEVEL
	end
	whoText = whoText .. " " .. minLevel .. "-" .. maxLevel

	local zoneLetter = job.m_zoneLetter
	if (zoneLetter ~= nil) then
		if (locale == "ruRU") then
			whoText = whoText .. zoneLetter
		else
			whoText = whoText .. " z-" .. zoneLetter
		end
	end

	return whoText
end

-- Create a job
function CensusPlus_CreateJob(minLevel, maxLevel, race, class, letter)
	local job = {}
	job.m_MinLevel = minLevel
	job.m_MaxLevel = maxLevel
	job.m_Race = race
	job.m_Class = class
	job.m_Letter = letter

	CensusPlus_DumpJob(job)

	return job
end

-- Debug function do dump a job
function CensusPlus_DumpJob(job)
	local whoText = ""
	local race = job.m_Race
	if (race ~= nil) then
		whoText = whoText .. " R: " .. race
	end

	local class = job.m_Class
	if (class ~= nil) then
		whoText = whoText .. " C: " .. class
	end

	local letter = job.m_Letter
	if (letter ~= nil) then
		whoText = whoText .. " N: " .. letter
	end

	local minLevel = job.m_MinLevel
	if (minLevel ~= nil) then
		whoText = whoText .. " min: " .. minLevel
	end

	local maxLevel = job.m_MaxLevel
	if (maxLevel ~= nil) then
		whoText = whoText .. " max: " .. maxLevel
	end

	local zoneLetter = job.m_zoneLetter
	if (zoneLetter ~= nil) then
		whoText = whoText .. " Z: " .. zoneLetter
	end

	---CensusPlus_Msg( "JOB DUMP: " .. whoText );
end

-- Called on events
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnEvent(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if (arg1 == nil) then
		arg1 = "nil"
	end
	if (arg2 == nil) then
		arg2 = "nil"
	end
	if (arg3 == nil) then
		arg3 = "nil"
	end
	if (arg4 == nil) then
		arg4 = "nil"
	end

	-- If we have not been initialized,  nothing
	if (g_CensusPlusInitialized == false) then
		if ((event == "ADDON_LOADED") and (arg1 == "CensusPlusClassic")) then
			self:UnregisterEvent("ADDON_LOADED") -- need this or we get hit on all preceeding addon loaded.. including the LOD's
			--  Initialize our variables
			g_addon_loaded = true
			--print("Addon Loaded")
			return
		end
		if (event == "PLAYER_ENTERING_WORLD") then
			g_player_loaded = true
			--print("Player in world")
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if g_addon_loaded and g_player_loaded then
				CensusPlus_InitializeVariables()
			end
		end
	end

	-- WHO_LIST_UPDATE
	if (event == "TRAINER_SHOW" or event == "MERCHANT_SHOW" or event == "TRADE_SHOW" or event == "GUILD_REGISTRAR_SHOW" or event == "AUCTION_HOUSE_SHOW" or event == "BANKFRAME_OPENED" or event == "QUEST_DETAIL") then
		print(" Event triggered = " .. event)
		if CPp.IsCensusPlusInProgress then
			g_CensusPlusPaused = true
		end
	elseif (event == "TRAINER_CLOSED" or event == "MERCHANT_CLOSED" or event == "TRADE_CLOSED" or event == "GUILD_REGISTRAR_CLOSED" or event == "AUCTION_HOUSE_CLOSED" or event == "BANKFRAME_CLOSED" or event == "QUEST_FINISHED") then
		print(" Event triggered = " .. event)
		if CPp.IsCensusPlusInProgress then
			g_CensusPlusPaused = false
		end
		
	--[[
	-- Guild roster info not ready for release
	elseif (event == "GUILD_ROSTER_UPDATE") th.en
	
		--  Process Guild info
		--CensusPlus_Msg( " UPDATE GUILD " );
		if(not CP_updatingGuild ) th.en
			CP_updatingGuild  = 1;
			CensusPlus_ProcessGuildResults();
			CP_updatingGuild  = nil;
		end
	
	elseif (( event == "ADDON_LOADED") and (arg1 == "CensusPlusClassic")) then
		self:UnregisterEvent("ADDON_LOADED")   -- need this or we get hit on all preceeding addon loaded.. including the LOD's
		
		--  Initialize our variables
		CensusPlus_InitializeVariables()
	--]]

	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		--  We need to check to see if we entered a battleground
		CensusPlus_CheckForBattleground()
	elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
		CensusPlus_UpdateBattleGroundInfo()
	end
end

-- ProcessTarget --  called when UNIT_FOCUS event is fired
function CensusPlus_ProcessTarget(unit)
	if (not UnitIsPlayer(unit) or UnitIsUnit(unit, "player")) then
		return -- bail out on non-player unit or unit focus on self
	end

	local sightingData = {}
	sightingData = CensusPlus_CollectSightingData(unit)

	if (sightingData == nil or sightingData.faction == nil or sightingData.faction == CENSUSPlus_NEUTRAL) then
		-- worthless Neutral
		return
	end

	if (sightingData.level < 1) then
		--	Run away, Run Away.. Uncountable DEATH
		return
	end

	if (sightingData ~= nil and (sightingData.faction == CENSUSPlus_ALLIANCE or sightingData.faction == CENSUSPlus_HORDE)) then
		if (sightingData.guild == nil) then
			sightingData.guild = ""
			-- RGK testing [GUILD]
			sightingData.guildRankName = ""
			sightingData.guildRankIndex = ""
			--RGK endblock
		else
			sightingData.guild =
				PTR_Color_ProblemRealmGuilds_check(sightingData.guild)
		end
		--
		-- Get the portion of the database for this server
		--
		realmName = CensusPlus_GetUniqueRealmName()	
		
		local realmDatabase = CensusPlus_Database["Servers"][realmName]
		if (realmDatabase == nil) then
			CensusPlus_Database["Servers"][realmName] = {}
			realmDatabase = CensusPlus_Database["Servers"][realmName]
		end

		-- Get the portion of the database for this faction
		local factionDatabase = realmDatabase[sightingData.faction]
		if (factionDatabase == nil) then
			realmDatabase[sightingData.faction] = {}
			factionDatabase = realmDatabase[sightingData.faction]
		end

		-- Get racial database
		local raceDatabase = factionDatabase[sightingData.race]
		if (raceDatabase == nil) then
			factionDatabase[sightingData.race] = {}
			raceDatabase = factionDatabase[sightingData.race]
		end

		-- Get class database
		local classDatabase = raceDatabase[sightingData.class]
		if (classDatabase == nil) then
			raceDatabase[sightingData.class] = {}
			classDatabase = raceDatabase[sightingData.class]
		end

		sightingData.name = PTR_Color_ProblemNames_check(sightingData.name)

		--
		local entry = classDatabase[sightingData.name]
		if (entry == nil) then
			classDatabase[sightingData.name] = {}
			entry = classDatabase[sightingData.name]
		end

		sightingData.lastSeen = CensusPlus_DetermineServerDate() .. ""

		--
		-- Update the information
		--
		entry[1] = sightingData.level
		entry[2] = sightingData.guild
		entry[3] = sightingData.lastSeen
		entry[4] =
			checksum:generate(
				realmName .. sightingData.faction .. sightingData.race .. sightingData.class .. sightingData.name .. sightingData.level .. sightingData.guild .. sightingData.lastSeen .. sightingData.sex
			)
		entry[5] = sightingData.sex
	end
end


-- Gather targeting data
function CensusPlus_CollectSightingData(unit)
	if (UnitIsPlayer(unit) and UnitName(unit) ~= "Unknown") then
		-- create the return structure as non-nil fields
		local ret = {}
		local _ = nil
		ret.name = ""
		ret.realm = ""
		ret.relationship = ""
		ret.race = ""
		ret.level = 0
		ret.sex = 1
		ret.class = ""
		ret.guild = ""
		ret.guildrealm = ""
		ret.faction = ""

		-- now populate the return structure
		ret.name, ret.realm = UnitName(unit) -- returns realm also Y +?
		ret.relationship = UnitRealmRelationship(unit) -- compares against self returns LE_REALM_RELATION_VIRTUAL|LE_REALM_RELATION_COALESCED|LE_REALM_RELATION_SAME
		if ((ret.realm == nil) or ret.relationship == 1) then
			ret.realm = CensusPlus_GetUniqueRealmName()
		end
		ret.level = UnitLevel(unit) -- a number  YNum
		ret.sex = UnitSex(unit) -- a number 2=male 3=female  YNum
		ret.race, _ = UnitRace(unit) -- localized , non Y + Y non is english race treated as one word.. i.e. Blood Elf  Bloodelf
		ret.class, _ = UnitClass(unit) -- localized ,non (warning if npc the npc name is returned!) y + y  Monk  MONK
		ret.guild, ret.guildRankName, ret.guildRankIndex = GetGuildInfo(unit) -- ? + ? +Ynum=0?
		--[Note] getGuildinfo call does return all of the above.. or if not valid nil or zero for the index
		if (ret.guild == nil) then
			ret.guild = ""
			ret.guildrealm = ""
		end
		if (ret.guildrealm == nil) then
			if (ret.guild == "") then
				ret.guildrealm = ""
			else
				ret.guildrealm = CensusPlus_GetUniqueRealmName()
			end
		end
		ret.faction, _ = UnitFactionGroup(unit)
		return ret
	else
		return nil
	end
end

-- Initialize our primary save variables --  called when CensusPlusClassic ADDON_LOADED event is fired
function CensusPlus_InitializeVariables()
	if (CensusPlus_Database["Servers"] == nil) then
		CensusPlus_Database["Servers"] = {}
	end

	if (CensusPlus_Database["Times"] ~= nil) then
		CensusPlus_Database["Times"] = nil
	end

	if (CensusPlus_Database["TimesPlus"] == nil) then
		CensusPlus_Database["TimesPlus"] = {}
	end

	--  Make sure info is last so it will be first in the output so we can grab the version number
	if (CensusPlus_Database["Info"] == nil) then
		CensusPlus_Database["Info"] = {}
	end
	if (CensusPlus_PerCharInfo["Version"] == nil) then
		CensusPlus_PerCharInfo["Version"] = {}
	end

	-- V 6.0.1 to 6.1.0 database purge
	if (CensusPlus_Database["Info"]["Version"] ~= nil) then
		g_InterfaceVersion = CensusPlus_Database["Info"]["Version"]
		-- keep left V.v to compare with V.v in code
		local _, cpsubset = string.find(g_InterfaceVersion, "%.")
		local _, cpsubset2 = string.find(g_InterfaceVersion, "%.", cpsubset + 1)
		g_InterfaceVersion = string.sub(g_InterfaceVersion, 1, cpsubset2 - 1)
		--		print("found interface version "..g_InterfaceVersion)
		local _, cpsubset = string.find(CensusPlus_VERSION, "%.")
		local _, cpsubset2 = string.find(CensusPlus_VERSION, "%.", cpsubset + 1)
		local CensusPlus_Version_subset =
			string.sub(CensusPlus_VERSION, 1, cpsubset2 - 1)
		--		print("coded interface version "..CensusPlus_Version_subset)
		if (g_InterfaceVersion ~= CensusPlus_Version_subset) then
			CensusPlus_Database["Info"] = {}
			CensusPlus_PerCharInfo = nil
			CensusPlus_PerCharInfo = {}
			CensusPlus_PerCharInfo["Version"] = CensusPlus_VERSION
			CensusPlus_DoPurge()
			g_wasPurged = true
			CensusPlus_Msg(CENSUSPLUS_OBSOLETEDATAFORMATTEXT)
		end
	end
	CPp.FirstLoad = true

	CensusPlus_Database["Info"]["Version"] = CensusPlus_VERSION
	
	local g_templang = GetLocale()
	if (CensusPlus_Database["Info"]["ClientLocale"] ~= g_templang) then
		-- Client language has been changed must purge
		CensusPlus_DoPurge()
		g_wasPurged = true
		CensusPlus_Msg(CENSUSPLUS_LANGUAGECHANGED)
	end
	CensusPlus_Database["Info"]["ClientLocale"] = GetLocale()
	CensusPlusLocaleName:SetText( format(CENSUSPLUS_LOCALE, CensusPlus_Database["Info"]["ClientLocale"]) )
	
	CensusPlus_Database["Info"]["LoginServer"] = GetCVar("portal")
	CensusPlus_Database["Info"]["LogVer"] = CensusPlus_VERSION_FULL
	
	local wowVersion, wowBuild = GetBuildInfo()
	wowVersion = format("%s (%s)", wowVersion, wowBuild)
	
	CensusPlus_Database["Info"]["wowVersion"] = wowVersion
	CensusPlus_Database["Info"]['versionChecksum'] = checksum:generate(CensusPlus_VERSION_FULL..wowVersion)

	if (CensusPlus_Database["Info"]["AutoCensus"] == nil) then
		CensusPlus_Database["Info"]["AutoCensus"] = true
	end
	if (CensusPlus_Database["Info"]["Verbose"] == nil) then
		CensusPlus_Database["Info"]["Verbose"] = false
	end
	if (CensusPlus_Database["Info"]["Stealth"] == nil) then
		CensusPlus_Database["Info"]["Stealth"] = false
	end
	if (CensusPlus_Database["Info"]["PlayFinishSound"] == nil) then
		CensusPlus_Database["Info"]["PlayFinishSound"] = false
	end
	if (CensusPlus_Database["Info"]["SoundFile"] == nil) then
		CensusPlus_Database["Info"]["SoundFile"] = g_FinishSoundNumber
	end

	if (CensusPlus_Database["Info"]["AutoCensusTimer"] == nil) then
		CensusPlus_Database["Info"]["AutoCensusTimer"] = 1800
	end
	
	if (CensusPlus_JobQueue["CensusPlus_last_time"] == nil) then
		CensusPlus_JobQueue["CensusPlus_last_time"] = time() - (CPp.AutoStartTimer *60)
	end
	
	if (CensusPlus_JobQueue["CensusPlus_LoginRealm_last"] == nil) then
		CensusPlus_JobQueue["CensusPlus_LoginRealm_last"] = ""
	end
	
	if (CensusPlus_JobQueue["CensusPlus_LoginFaction_last"] == nil) then
		CensusPlus_JobQueue["CensusPlus_LoginFaction_last"] = ""
	end

	if (CensusPlus_Database["Info"]["CPWindow_Transparency"] == nil) then
		CensusPlus_Database["Info"]["CPWindow_Transparency"] = 0.5
	end

	if (CensusPlus_Database["Info"]["CensusButtonShown"] == nil) then
		CensusPlus_Database["Info"]["CensusButtonShown"] = true
	end

	if (CensusPlus_Database["Info"]["CensusButtonShown"] == true) then
		CensusButtonFrame:Show()
	else
		CensusButtonFrame:Hide()
	end

	if (CensusPlus_Database["Info"]["CensusButtonAnimi"] == nil) then
		CensusPlus_Database["Info"]["CensusButtonAnimi"] = true
	end

	if (CensusPlus_Database["Info"]["UseLogBars"] == nil) then
		CensusPlus_Database["Info"]["UseLogBars"] = true
	end

	--CensusPlusSetCheckButtonState()
	CensusPlus_Msg(" v" .. CensusPlus_VERSION .. CENSUSPLUS_MSG1)

	g_VariablesLoaded = true

	--CensusPlus_CheckTZ();
	InitConstantTables()

	g_CensusPlusInitialized = true

	--  If we are in a guild, attempt to gather the guild roster data
	--	if (IsInGuild()) then
	--		GuildRoster();
	--	end

	--  Prune times if we have too many
	CENSUSPLUS_PRUNETimes()

	--
	CensusPlus_Unhandled = nil
	CensusPlus_Unhandled = {}

	CensusPlusBlizzardOptions()
	CensusPlusSetCheckButtonState()
	CPp.FirstLoad = false -- main table initialized and options initialized
	
end


function CensusPlus_AutoStart()
	
	local currentRealm = CensusPlus_GetUniqueRealmName()
	local currentFaction = UnitFactionGroup("player")
	local lastRealm = CensusPlus_JobQueue["CensusPlus_LoginRealm_last"]
	local lastFaction = CensusPlus_JobQueue["CensusPlus_LoginFaction_last"]
	local lastRun = CensusPlus_JobQueue["CensusPlus_last_time"]
	
	if (g_wasPurged or currentRealm ~= lastRealm or currentFaction ~= lastFaction or (lastRun < time() - (CPp.AutoStartTimer * 60))) then
		CENSUSPLUS_TAKE_OnClick()
	end

end

  
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnUpdate()
	if g_FirstRun then
		CensusButton:SetText("C+")
		if (g_VariablesLoaded and not CPp.IsCensusPlusInProgress and CPp.AutoCensus == true) then
			CensusPlus_AutoStart()
		end
	elseif (g_VariablesLoaded and not CPp.IsCensusPlusInProgress and CPp.AutoCensus == true and (CPp.LastCensusRun < time() - (CPp.AutoStartTimer * 60))) then
		CENSUSPLUS_TAKE_OnClick()
	end
	if (CPp.IsCensusPlusInProgress and not g_CensusPlusPaused and not CPp.CensusPlusManuallyPaused) then
	
		--  update our progress
		local numJobs = #CensusPlus_JobQueue
		if (numJobs > 0) then
			CensusPlusScanProgress:SetText(
				format(
					CENSUSPLUS_SCAN_PROGRESS,
					numJobs,
					CensusPlus_CreateWhoText(CensusPlus_JobQueue[numJobs])
				)
			)
		end

		if (not whoquery_active or g_FirstRun) then
			--ok to request next query
			whoquery_answered = false

			-- Determine if there is any more work to 
			if (numJobs > 0) then
				-- Send the job and remove it later after it is processed in CP_ProcessWhoEvent (Lib-Who callback)
				local job = CensusPlus_JobQueue[numJobs]
				local whoText = CensusPlus_CreateWhoText(job)
				g_FirstRun = false
				
				--  Zap our current job
				g_CurrentJob = nil

				g_CurrentJob = job
				g_WaitingForWhoUpdate = true

				CensusPlus_SendWho(whoText)
				g_WhoAttempts = 0
				g_LastOnUpdateTime = GetTime()
				CensusPlus_JobQueue.CensusPlus_last_time = time()
			else
				-- We are all done, hide the friends frame and report our results
				if CensusPlus_PerCharInfo["PlayFinishSound"] then
					if (CensusPlus_PerCharInfo["SoundFile"] == nil) then
						g_FinishSoundNumber = 1
					else
						g_FinishSoundNumber =
							CensusPlus_PerCharInfo["SoundFile"]
					end
					local CPSoundFile =
						"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete" .. g_FinishSoundNumber .. ".ogg"
					local willplay = PlaySoundFile(CPSoundFile, "Master")
					if not willplay then
						local CPSoundFile =
							"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete" .. g_FinishSoundNumber .. ".mp3"
						PlaySoundFile(CPSoundFile, "Master")
					end
				elseif ((CensusPlus_PerCharInfo["PlayFinishSound"] == nil) and CensusPlus_Database["Info"]["PlayFinishSound"]) then
					if (CensusPlus_Database["Info"]["SoundFile"] == nil) then
						g_FinishSoundNumber = 1
					else
						g_FinishSoundNumber =
							CensusPlus_Database["Info"]["SoundFile"]
					end
					local CPSoundFile =
						"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete" .. g_FinishSoundNumber .. ".ogg"
					local willplay = PlaySoundFile(CPSoundFile, "Master")
					if not willplay then
						local CPSoundFile =
							"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete" .. g_FinishSoundNumber .. ".mp3"
						PlaySoundFile(CPSoundFile, "Master")
					end
				end
				if not CensusPlayerOnly then
					CensusPlus_DoTimeCounts()
				end
				CensusPlayerOnly = false
				CensusPlus_JobQueue.CensusPlus_LoginRealm_last = CensusPlus_JobQueue.CensusPlus_LoginRealm
				CensusPlus_JobQueue.CensusPlus_LoginFaction_last = CensusPlus_JobQueue.CensusPlus_LoginFaction
				CensusPlus_JobQueue.CensusPlus_LoginRealm = ""
				CensusPlus_JobQueue.CensusPlus_LoginFaction = ""
				CensusPlus_JobQueue.g_TempCount = {}
				CensusPlus_DisplayResults()
				
				-- Add CensusButton reset
				CensusButton:SetText("C+")
			end
		elseif whoquery_answered then
			local now = GetTime()
			local delta = now - g_LastOnUpdateTime
			if (delta > CensusPlus_UPDATEDELAY2) then
				g_LastOnUpdateTime = now
				print(CENSUSPLUS_TOOSLOW) -- >10 seconds to finish query!
			end
		else
			local now = GetTime()
			local delta2 = now - g_LastOnUpdateTime
			if (delta2 > CensusPlus_UPDATEDELAY) then
				g_LastOnUpdateTime = now
				--
				-- Resend /who command
				--
				g_WhoAttempts = g_WhoAttempts + 1
				local whoText = CensusPlus_CreateWhoText(g_CurrentJob)
				if (CensusPlus_PerCharInfo["Verbose"] == true) then
					CensusPlus_Msg(CENSUSPLUS_WAITING) -- this hasn't shown up in testing yet.
				end
				if (g_WhoAttempts < 2) then
					CensusPlus_SendWho(whoText)
				else
					g_WaitingForWhoUpdate = false
				end
			end
			--return -- server hasn't returned query.. so wait for next frame update
		end
	end
end


-- Take final tally
function CensusPlus_DoTimeCounts()
	-- first zero counts in g_TimeDatabase each realm/faction
	--CensusPlus_JobQueue.g_NumUpdatedCharacters = 0;
	--CensusPlus_JobQueue.g_NumNewCharacters = 0;
	local factionGroup = UnitFactionGroup("player")

	local realmName = CensusPlus_GetUniqueRealmName()
	

	CensusPlus_Zero_g_TimeDatabase()
	local thisFactionClasss = CensusPlus_GetFactionClasses(factionGroup)
	local numClasses = #thisFactionClasss
	for i = 1, numClasses, 1 do
		local charClass = thisFactionClasss[i]
		local classCount = 0

		for realmKey, factionData in
			pairs(CensusPlus_JobQueue.g_TempCount) -- realmname, factionname
		do
			for factionKey, classData in pairs(factionData) do
				if (factionKey == factionGroup) then
					for classKey, NameData in pairs(classData) do
						if (charClass == classKey) then
							for nameKey, charData in
								pairs(NameData)
							do
								--												if (HortonBug == true) then
								--													s.ays("TempCount level 3");
								--												end

								local gotcha = charData[1]
								if (gotcha == charClass) then
									classCount = classCount + 1
								end
							end
						end
					end
				end
			end
		end

		if (CENSUSPlusFemale[charClass] ~= nil) then
			charClass = CENSUSPlusFemale[class]
		end
		CensusPlus_JobQueue.g_TimeDatabase[charClass] =
			CensusPlus_JobQueue.g_TimeDatabase[charClass] + classCount
		CensusPlus_JobQueue.g_NumUpdatedCharacters =
			CensusPlus_JobQueue.g_NumUpdatedCharacters + classCount
	end
	if (CensusPlus_Database["TimesPlus"][realmName] == nil) then
		CensusPlus_Database["TimesPlus"][realmName] = {}
	end
	if (CensusPlus_Database["TimesPlus"][realmName][factionGroup] == nil) then
		CensusPlus_Database["TimesPlus"][realmName][factionGroup] = {}
	end

	if CensusPLus_DEBUGWRITES then
		CensusPlus_Database["TimesPlus"][realmName][factionGroup] =
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_DRUID] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_HUNTER] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_MAGE] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PRIEST] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_ROGUE] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARLOCK] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARRIOR] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_SHAMAN] .. "&" .. CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PALADIN] .. "&" .. CensusPlus_WHOPROCESSOR .. ":" .. CensusPlus_JobQueue.g_NumNewCharacters .. "," .. CensusPlus_JobQueue.g_NumUpdatedCharacters .. "," .. total_time
	else
		local TimeDataTime = date("!%Y-%m-%d&%H:%M:%S", GetServerTime())

		CensusPlus_Database["TimesPlus"][realmName][factionGroup][TimeDataTime] =
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_DRUID] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_HUNTER] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_MAGE] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PRIEST] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_ROGUE] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARLOCK] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_WARRIOR] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_SHAMAN] .. "&" ..
			CensusPlus_JobQueue.g_TimeDatabase[CENSUSPLUS_PALADIN]

		CensusPlus_Database["TimesPlus"][realmName][factionGroup][TimeDataTime] =
			CensusPlus_Database["TimesPlus"][realmName][factionGroup][TimeDataTime] .. ":" ..
			checksum:generate(
				CensusPlus_Database["TimesPlus"][realmName][factionGroup][TimeDataTime] ..
				realmName ..
				factionGroup ..
				TimeDataTime
			)
	end
	CensusPlus_Zero_g_TimeDatabase() --b temp data no longer needed
end

-- Add the contents of the guild results to the database
local function CensusPlus_ProcessGuildResults()
	if not g_VariablesLoaded then return end

	--  Grab temp var
	local showOfflineTemp = GetGuildRosterShowOffline()
	SetGuildRosterShowOffline(true)

	-- Walk through the guild info
	local numGuildMembers, numOnline = GetNumGuildMembers()
	if (numOnline < 2) then
		return -- only guild member online is player who is counted elsewhere
	end
	--	CensusPlus_Msg("Processing "..numOnline.." online of "..numGuildMembers.." total guild members.");

	local realmName = CensusPlus_GetUniqueRealmName()
	CensusPlus_Database["Guilds"] = nil
	if (CensusPlus_Database["Guilds"] == nil) then
		CensusPlus_Database["Guilds"] = {}
	end

	if (CensusPlus_Database["Guilds"][realmName] == nil) then
		CensusPlus_Database["Guilds"][realmName] = {}
	end

	local guildRealmDatabase = CensusPlus_Database["Guilds"][realmName]
	if (guildRealmDatabase == nil) then
		CensusPlus_Database["Guilds"][realmName] = {}
		guildRealmDatabase = CensusPlus_Database["Guilds"][realmName]
	end

	local factionGroup = UnitFactionGroup("player")
	if (factionGroup == nil) then
		CensusPlus_Database["Guilds"] = nil
		SetGuildRosterShowOffline(showOfflineTemp)
		return
	end

	local factionDatabase = guildRealmDatabase[factionGroup]
	if (factionDatabase == nil) then
		guildRealmDatabase[factionGroup] = {}
		factionDatabase = guildRealmDatabase[factionGroup]
	end

	CensusPlus_Database["Guilds"][realmName][factionGroup] = nil
	CensusPlus_Database["Guilds"][realmName][factionGroup] = {}

	factionDatabase = CensusPlus_Database["Guilds"][realmName][factionGroup]

	local Ginfo = GetGuildInfo("player")
	if (Ginfo == nil) then
		CensusPlus_Database["Guilds"] = nil
		SetGuildRosterShowOffline(showOfflineTemp)
		return
	end
	local guildDatabase = factionDatabase[Ginfo]
	if (guildDatabase == nil) then
		factionDatabase[Ginfo] = {}
		guildDatabase = factionDatabase[Ginfo]
	end

	local info = guildDatabase["GuildInfo"]
	if (info == nil) then
		guildDatabase["GuildInfo"] = {}
		info = guildDatabase["GuildInfo"]
	end

	info["Update"] = date("%m-%d-%Y", time()) .. ""
	info["ShowOnline"] = 1 --  Variable comes from FriendsFrame
	guildDatabase["Members"] = nil
	guildDatabase["Members"] = {}

	local members = guildDatabase["Members"]

	for index = 1, numGuildMembers, 1 do
		local name,
			rank,
			rankIndex,
			level,
			class,
			zone,
			note,
			officernote,
			online,
			status
		= GetGuildRosterInfo(index)

		if (members[name] == nil) then
			members[name] = {}
		end

		--CensusPlus_Msg( "Name =>" .. name );
		--CensusPlus_Msg( "rank =>" .. rank );
		--CensusPlus_Msg( "rankIndex =>" .. rankIndex );
		--CensusPlus_Msg( "level =>" .. level );
		--CensusPlus_Msg( "class =>" .. class );
		members[name]["Rank"] = rank
		members[name]["RankIndex"] = rankIndex
		members[name]["Level"] = level
		members[name]["Class"] = class
		--members[name]["Zone"]= zone;
		--members[name]["Note"]= CensusPlus_SafeSet( note );
		--members[name]["OfficerNote"]= CensusPlus_SafeSet( officernote );
		--members[name]["Online"]= online;
		--members[name]["Status"]= CensusPlus_SafeSet( status );
	end

	SetGuildRosterShowOffline(showOfflineTemp)
end

function CensusPlus_SafeCheck(param)
	if (param == nil) then
		return "nil"
	else
		return param
	end
end

-- Add the contents of the who results to the database
function CensusPlus_ProcessWhoResults(result, numWhoResults)
	--  If we are in a BG th.en stop a census
	if (g_CurrentlyInBG and CPp.IsCensusPlusInProgress) then
		CPp.LastCensusRun = time() - 600
		CensusPlus_Msg(CENSUSPLUS_ISINBG)
		CENSUSPLUS_STOPCENSUS()
	end

	--[[
		Old process, assume single realm.. process realm,faction,level,race,class,
		new process no assumption. process realm, then faction, level, race,class
		need to build dotimes for each realm found in Virtual realm set.
	   
		name comes in as name-realm
		split to name, realm
		process

	--]]
	--5.4
	if (CensusPlus_WHOPROCESSOR == CP_libwho) then
		local numWhoResults = numWhoResults
	else
		local numWhoResults = C_FriendList.GetNumWhoResults()
	end

	if (g_Verbose == true) then
		CensusPlus_Msg(format(CENSUSPLUS_PROCESSING, numWhoResults))
	end

	local name = ""
	--5.4
	local realm = ""
	--
	local guild = ""
	--5.4
	local guildRealm = ""
	--
	local level = ""
	local race = ""
	local class = ""
	local zone = ""
	local sex = ""
	--	local relate = ""
	for i = 1, numWhoResults, 1 do
		local tmpNmst = nil
		local tmpNmend = nil
		local tmpGldst = nil
		local tmpGldend = nil
		local relationship = nil
		if (CensusPlus_WHOPROCESSOR == CP_libwho) then
			name = result[i].Name
			realm = CensusPlus_GetUniqueRealmName()
			guild = result[i].Guild
			
			if (HortonBug == true) then
				says(
					"Who returned " .. result[i].Name .. "  Guild = " .. result[i].Guild
				)
			end
			if ((guild ~= nil) and (guild ~= "")) then
				local guildName = "" -- defined if valid guild returned from who call otherwise nil.. am I sure about this?
				
				guildRealm = CensusPlus_GetUniqueRealmName()
				
				if (HortonBug == true) then
					says("guild realm =  " .. guildRealm)
				end
			else
				guild = ""
				guildRealm = ""
			end

			level = result[i].Level
			race = result[i].Race
			if (CENSUSPlusFemale[race] ~= nil) then
				race = CENSUSPlusFemale[race]
			end
			class = result[i].Class
			if (CENSUSPlusFemale[class] ~= nil) then
				class = CENSUSPlusFemale[class]
			end
			zone = result[i].Zone
			sex = result[i].Sex
			-- debug testing
			--says("parsed name = " .. name);
			--says("parsed realm = " .. realm); -- this shouldn't happen except where Blizzard doesn't encode relationships
		else
			local p = C_FriendList.GetWhoInfo(i)
			name = p.fullName
			guild = p.fullGuildName
			level = p.level
			race = p.raceStr
			class = p.classStr
			zone = p.area
			sex = p.gender
			if (CENSUSPlusFemale[race] ~= nil) then
				race = CENSUSPlusFemale[race]
			end
			if (CENSUSPlusFemale[class] ~= nil) then
				class = CENSUSPlusFemale[class]
			end
			if (HortonBug == true) then
				says("who API returned " .. name)
			end
			local orig_name = name
			local orig_guild = guild
			tmpNmst, tmpNmend = string.find(name, "-")
			if tmpNmst then
				realm = string.sub(name, tmpNmst + 1)
				name = string.sub(name, 1, tmpNmst - 1)
			else
				realm = CensusPlus_GetUniqueRealmName()
			end

			if ((guild ~= nil) and (guild ~= "")) then
				local guildName = ""
				guildName, _, _ = GetGuildInfo(orig_name)
				if (guildName == nil) then
					tmpGldst, tmpGldend = string.find(orig_guild, "-")
					if tmpGldst then
						guildRealm = string.sub(orig_guild, tmpGldst + 1)
						guild = string.sub(orig_guild, 1, tmpGldst - 1)
					else
						guildRealm = CensusPlus_GetUniqueRealmName()
					end
				else
					if (guildRealm == nil) then
						guildRealm = CensusPlus_GetUniqueRealmName()
					end
				end
			else
				guild = ""
				guildRealm = ""
			end
		end

		--[[ 
				PTR testing modifications
				Blizzard has odd naming allowances in PTR realms
				name (US) or name (EU)  ditto for guild names

		--]]
		
		realm = PTR_Color_ProblemRealmGuilds_check(realm)
		name = PTR_Color_ProblemNames_check(name)
		if ((guild ~= nil) and (guild ~= "")) then
			guild = PTR_Color_ProblemRealmGuilds_check(guild)
		end
		if ((guildRealm ~= nil) and (guildRealm ~= "")) then
			guildRealm = PTR_Color_ProblemRealmGuilds_check(guildRealm)
		end	

		local realmName = CensusPlus_GetUniqueRealmName()
		
		-- coalesced realms should not show up here via /who queries.
		local realmDatabase = CensusPlus_Database["Servers"][realmName]
		if (realmDatabase == nil) then
			CensusPlus_Database["Servers"][realmName] = {}
			realmDatabase = CensusPlus_Database["Servers"][realmName]
		end

		-- Get the portion of the database for this faction
		local factionGroup = UnitFactionGroup("player")
		if (factionGroup == nil or factionGroup == "Neutral") then return end

		local factionDatabase = realmDatabase[factionGroup]
		if (factionDatabase == nil) then
			realmDatabase[factionGroup] = {}
			factionDatabase = realmDatabase[factionGroup]
		end

		-- Get racial database
		local raceDatabase = factionDatabase[race]
		if (raceDatabase == nil) then
			factionDatabase[race] = {}
			raceDatabase = factionDatabase[race]
		end

		-- Get class database
		local classDatabase = raceDatabase[class]
		if (classDatabase == nil) then
			raceDatabase[class] = {}
			classDatabase = raceDatabase[class]
		end

		-- Get this player's entry
		local entry = classDatabase[name]
		if (entry == nil) then
			classDatabase[name] = {}
			entry = classDatabase[name]
			CensusPlus_JobQueue.g_NumNewCharacters =
				CensusPlus_JobQueue.g_NumNewCharacters + 1
		end

		lastSeen = CensusPlus_DetermineServerDate() .. ""

		-- Update the information
		entry[1] = level
		entry[2] = guild
		--local hour, minute = GetGameTime();
		entry[3] = lastSeen
		entry[4] =
			checksum:generate(
				realmName .. factionGroup .. race .. class .. name .. level .. guild .. lastSeen .. sex
			)
		entry[5] = sex

		-- 5.3 g_TempCount[name] = class;
		-- 5.4 g_TempCount[realm][name] = class;
		local gct_realm = CensusPlus_JobQueue.g_TempCount[realmName]
		if (gct_realm == nil) then
			CensusPlus_JobQueue.g_TempCount[realmName] = {}
			gct_realm = CensusPlus_JobQueue.g_TempCount[realmName]
		end

		local gct_faction = gct_realm[factionGroup]
		if (gct_faction == nil) then
			gct_realm[factionGroup] = {}
			gct_faction = gct_realm[factionGroup]
		end

		local gct_class = gct_faction[class]
		if (gct_class == nil) then
			gct_faction[class] = {}
			gct_class = gct_faction[class]
		end

		local gct_name = gct_class[name]
		if (gct_name == nil) then
			gct_class[name] = {}
			gct_name = gct_class[name]
		end
		gct_name[1] = class
	end

	-- remove the job
	table.remove(CensusPlus_JobQueue)
	whoquery_active = false
	--CensusPlus_UpdateView();
end

-- Process a single entry
-- not currently used since we don't want to activity record foreign realm characters that we spot id.
local function WR_ProcessSingleEntry(name, level, race, class, guild, zone)
	CensusPlus_Msg2(BLIZZARD_STORE_PROCESSING .. name)

	if (CENSUSPlusFemale[race] ~= nil) then
		race = CENSUSPlusFemale[race]
	end

	if (CENSUSPlusFemale[class] ~= nil) then
		class = CENSUSPlusFemale[class]
	end

	-- Get the portion of the database for this server
	local realmName = CensusPlus_GetUniqueRealmName()
	local realmDatabase = CensusPlus_Database["Servers"][realmName]
	if (realmDatabase == nil) then
		CensusPlus_Database["Servers"][realmName] = {}
		realmDatabase = CensusPlus_Database["Servers"][realmName]
	end

	-- Get the portion of the database for this faction
	local factionGroup = UnitFactionGroup("player")
	if (factionGroup == nil) then return end

	local factionDatabase = realmDatabase[factionGroup]
	if (factionDatabase == nil) then
		realmDatabase[factionGroup] = {}
		factionDatabase = realmDatabase[factionGroup]
	end

	--  Remove the trailing ] that I can't remove through patterns
	--	local oldname = name;
	--	name = string.sub( oldname, 1, string.len(oldname) - 3 );

	level = tonumber(level)

	--  Test the name for possible color coding
	--  for example |cffff0000Rollie|r
	local karma_check = string.find(name, "|cff")
	if (karma_check ~= nil) then
		name = string.sub(name, 11, -3)
	end

	local pattern = "[0-9\| :]"
	if (string.find(name, pattern) ~= nil) then
		if not g_ProblematicMessageShown then
			CensusPlus_Msg(
				CENSUSPLUS_PROBLEMNAME .. name .. CENSUSPLUS_PROBLEMNAME_ACTION
			)
		end
		return
	end

	--  Do a race check just to be sure this is working
	if (g_FactionCheck[race] == nil) then
		CensusPlus_Msg(
			CENSUSPLUS_UNKNOWNRACE .. race .. CENSUSPLUS_UNKNOWNRACE_ACTION
		)
		return
	end

	-- Get racial database
	local raceDatabase = factionDatabase[race]
	if (raceDatabase == nil) then
		factionDatabase[race] = {}
		raceDatabase = factionDatabase[race]
	end

	-- Get class database
	local classDatabase = raceDatabase[class]
	if (classDatabase == nil) then
		raceDatabase[class] = {}
		classDatabase = raceDatabase[class]
	end

	-- Get this player's entry
	local entry = classDatabase[name]
	if (entry == nil) then
		classDatabase[name] = {}
		entry = classDatabase[name]
		CensusPlus_JobQueue.g_NumNewCharacters =
			CensusPlus_JobQueue.g_NumNewCharacters + 1
	end

	-- Update the information
	entry[1] = level
	entry[2] = guild
	--		local hour, minute = GetGameTime();
	entry[3] = CensusPlus_DetermineServerDate() .. ""

	g_TempCount[name] = class

	--CensusPlus_Msg2( "Processed 	" .. name );
end

-- Find a guild in the CensusPlus_Guilds array by name
local function FindGuildByName(name)
	local i
	local size = #CensusPlus_Guilds
	for i = 1, size, 1 do
		local entry = CensusPlus_Guilds[i]
		--5.4 to be done
		-- if name and realm == name and realm   to differentiate same name guild of different realms
		if (entry.m_Name == name) then
			return i
		end
	end
	return nil
end

-- Add up the total character XP and count
local function TotalsAccumulator(name, level, guild, raceName, className, lastseen, realmName, guildRealm)
	--  Add character to our player list
	--print(name.." ".. level.." "..className.." "..raceName.." "..realmName.." "..guild.." "..guildRealm.." "..lastseen)
	if g_AccumulateGuildTotals then
		CensusPlus_AddPlayerToList(
			name,
			level,
			guild,
			raceName,
			className,
			lastseen,
			realmName,
			guildRealm
		)
	end

	if g_TotalCharacterXPPerLevel[level] then
		InitConstantTables()
	end

	local totalCharacterXP = g_TotalCharacterXPPerLevel[level]
	if (totalCharacterXP == nil) then
		totalCharacterXP = 0
	end
	if (g_TotalCharacterXP == nil) then
		g_TotalCharacterXP = 0
	end
	g_TotalCharacterXP = g_TotalCharacterXP + totalCharacterXP
	g_TotalCount = g_TotalCount + 1
	--	print("g_TCount = "..g_TotalCount.." "..guild)
	if (g_AccumulateGuildTotals and (guild ~= nil)) then
		local index = FindGuildByName(guild)
		if (index == nil) then
			local size = #CensusPlus_Guilds
			index = size + 1
			CensusPlus_Guilds[index] = {
				m_Name = guild,
				m_TotalCharacterXP = 0,
				m_Count = 0,
				m_GuildRealm = guildRealm,
				m_GNfull = guild
			}
		end
		local entry = CensusPlus_Guilds[index]
		entry.m_TotalCharacterXP = entry.m_TotalCharacterXP + totalCharacterXP
		entry.m_Count = entry.m_Count + 1
	end
end

-- Predicate function which can be used to compare two guilds for sorting
local function GuildPredicate(lhs, rhs)

	-- nil references are always less than
	if (lhs == nil) then
		if (rhs == nil) then
			return false
		else
			return true
		end
	elseif (rhs == nil) then
		return false
	end
	
	-- unguilded always first
	if (lhs.m_Name == "") then
		return true
	end
	
	if (rhs.m_Name == "") then
		return false
	end

	-- Sort by total XP first
	if (rhs.m_TotalCharacterXP < lhs.m_TotalCharacterXP) then
		return true
	elseif (lhs.m_TotalCharacterXP < rhs.m_TotalCharacterXP) then
		return false
	end

	-- Sort by name
	if (lhs.m_Name < rhs.m_Name) then
		return true
	elseif (rhs.m_Name < lhs.m_Name) then
		return false
	end

	-- identical
	return false
end

-- Another accumulator for adding up XP and counts
local function CensusPlus_Accumulator(name, level, guild)
	if (g_TotalCharacterXPPerLevel[level] == nil) then
		InitConstantTables()
	end
	local totalCharacterXP = g_TotalCharacterXPPerLevel[level]
	if (totalCharacterXP == nil or g_TotalCharacterXPPerLevel[level] == nil) then return end
	g_AccumulatorXPTotal = g_AccumulatorXPTotal + totalCharacterXP
	g_AccumulatorCount = g_AccumulatorCount + 1
end

-- Reset the above accumulator
local function CensusPlus_ResetAccumulator()
	g_AccumulatorCount = 0
	g_AccumulatorXPTotal = 0
end

-- Search the character database using the search criteria and update display
function CensusPlus_UpdateView()

	--  No need to do anything if the window is not open
	if not CensusPlusClassic:IsVisible() then return end

	-- Get realm and faction
	local realmName = CensusPlus_GetUniqueRealmName()

	CensusPlusTopGuildsTitle:SetText(CENSUSPLUS_TOPGUILD)
	g_AccumulateGuildTotals = true

	if (realmName == nil) then return end

	if (CensusPlus_PTR ~= false) then
		realmName = PTR_Color_ProblemRealmGuilds_check(realmName)
	end -- not PTR must be live

	CensusPlusRealmName:SetText(format(CENSUSPLUS_REALMNAME, string.match(realmName, "_(.*)")))

	local factionGroup, factionGName = UnitFactionGroup("player")
	if (factionGroup == nil or factionGroup == "Neutral") then
		return -- rework this area?.. if neutral display warn message elif display faction  ..or not needed handled in xml
	end

	CensusPlusFactionName:SetText(format(CENSUSPLUS_FACTION, factionGName))

	if not g_VariablesLoaded then
		return -- if variables aren't loaded show partial window data and escape
	end
	
	local guildKey = nil
	local raceKey = nil
	local classKey = nil
	local levelKey = nil
	g_TotalCharacterXP = 0
	g_TotalCount = 0



	-- Has the user selected a guild?
	if (CPp.GuildSelected > 0) then
		guildKey = CensusPlus_Guilds[CPp.GuildSelected].m_Name;
	end

	-- Has the user added any search criteria?
	if (CPp.RaceSelected > 0) then
		local thisFactionRaces = CensusPlus_GetFactionRaces(factionGroup)
		raceKey = thisFactionRaces[CPp.RaceSelected]
	end
	if (CPp.ClassSelected > 0) then
		local thisFactionClasses = CensusPlus_GetFactionClasses(factionGroup)
		classKey = thisFactionClasses[CPp.ClassSelected]
	end
	if (CPp.LevelSelected > 0 or CPp.LevelSelected < 0) then
		levelKey = CPp.LevelSelected
	end

	-- Has the user added any search criteria?
	if ((guildKey ~= nil) or (raceKey ~= nil) or (classKey ~= nil) or (levelKey ~= nil)) then
		-- Get totals for this criteria
		g_AccumulateGuildTotals = false;
		CensusPlus_ForAllCharacters(realmName, factionGroup, raceKey, classKey, guildKey, levelKey, TotalsAccumulator);
		
		if( CensusPlus_EnableProfiling ) then
			CensusPlus_Msg( "PROFILE: Time to do calcs 1 " .. debugprofilestop() / 1000000000 );
			debugprofilestart();
		end
		
	else
		-- Get the overall totals and find guild information
		CensusPlus_Guilds = {};
		g_AccumulateGuildTotals = true;
		CensusPlus_ForAllCharacters(realmName, factionGroup, nil, nil, nil, nil, TotalsAccumulator);
		
		if( CensusPlus_EnableProfiling ) then
			CensusPlus_Msg( "PROFILE: Time to do calcs 1 " .. debugprofilestop() / 1000000000 );
			debugprofilestart();
		end
		
		local size = table.getn(CensusPlus_Guilds);
		if (size) then
			table.sort(CensusPlus_Guilds, GuildPredicate);
		end
		
		if( CensusPlus_EnableProfiling ) then
			CensusPlus_Msg( "PROFILE: Time to sort guilds " .. debugprofilestop() / 1000000000 );
			debugprofilestart();
		end			
	end
	
	local levelSearch = nil;
	if (levelKey ~= nil) then
		levelSearch = "  ("..CENSUSPLUS_LEVEL..": ";
		local level = levelKey;
		if (levelKey < 0) then
			levelSearch = levelSearch.."!";
			level = 0 - levelKey;
		end
		levelSearch = levelSearch..level..")";
	end

	local totalCharactersText = nil;
	if (levelSearch ~= nil) then
		totalCharactersText = format(CENSUSPLUS_TOTALCHAR, g_TotalCount) .. levelSearch
	else
		totalCharactersText = format(CENSUSPLUS_TOTALCHAR, g_TotalCount)
	end
	CensusPlusTotalCharacters:SetText(totalCharactersText);
	--CensusPlusTotalCharacterXP:SetText(format(CENSUSPlus_TOTALCHARXP, g_TotalCharacterXP));
	CensusPlus_UpdateGuildButtons();
	
	if( CensusPlus_EnableProfiling ) then
		CensusPlus_Msg( "PROFILE: Update Guilds " .. debugprofilestop() / 1000000000 );
		debugprofilestart();
	end

	-- Accumulate totals for each race
	local maxCount = 0;
	local thisFactionRaces = CensusPlus_GetFactionRaces(factionGroup);
	local numRaces = table.getn(thisFactionRaces);
	for i = 1, numRaces, 1 do
		local race = thisFactionRaces[i];
		CensusPlus_ResetAccumulator();
		if ((raceKey == nil) or (raceKey == race)) then
			CensusPlus_ForAllCharacters(realmName, factionGroup, race, classKey, guildKey, levelKey, CensusPlus_Accumulator);
		end
		if (g_AccumulatorCount > maxCount) then
			maxCount = g_AccumulatorCount;
		end
		g_RaceCount[i] = g_AccumulatorCount;
	end

	-- Update race bars
	for i = 1, numRaces, 1 do
		local race = thisFactionRaces[i];
		local buttonName = "CensusPlusRaceBar"..i;
		local button = _G[buttonName];
		local thisCount = g_RaceCount[i];
		if ((thisCount ~= nil) and (thisCount > 0) and (maxCount > 0)) then
			local height = floor((thisCount / maxCount) * CensusPlus_MAXBARHEIGHT);
			if (height < 1 or height == nil ) then height = 1; end
			button:SetHeight(height);
			button:Show();
		else
			button:Hide();
		end
		local normalTextureName= "Interface\\AddOns\\CensusPlusClassic\\skins\\CensusPlus_" .. g_RaceClassList[race]
		local legendName = "CensusPlusRaceLegend"..i;
		local legend = _G[legendName]
		legend:SetNormalTexture(normalTextureName);
		if (CPp.RaceSelectedd == i) then
			legend:LockHighlight();
		else
			legend:UnlockHighlight();
		end
	end

	if( CensusPlus_EnableProfiling ) then
		CensusPlus_Msg( "PROFILE: Update Races " .. debugprofilestop() / 1000000000 );
		debugprofilestart();
	end

	-- Accumulate totals for each class
	local maxCount = 0;
	local thisFactionClasss = CensusPlus_GetFactionClasses(factionGroup);
	local numClasses = table.getn(thisFactionClasss);
	for i = 1, numClasses, 1 do
		local class = thisFactionClasss[i];
		CensusPlus_ResetAccumulator();
		if ((classKey == nil) or (classKey == class)) then
			CensusPlus_ForAllCharacters(realmName, factionGroup, raceKey, class, guildKey, levelKey, CensusPlus_Accumulator);
		end
		if (g_AccumulatorCount > maxCount) then
			maxCount = g_AccumulatorCount;
		end
		g_ClassCount[i] = g_AccumulatorCount;
	end

	-- Update class bars
	for i = 1, numClasses, 1 do
		local class = thisFactionClasss[i];

		local buttonName = "CensusPlusClassBar"..i;
		local button = _G[buttonName]
		local thisCount = g_ClassCount[i];
		if ((thisCount ~= nil) and (thisCount > 0) and (maxCount > 0)) then
			local height = floor((thisCount / maxCount) * CensusPlus_MAXBARHEIGHT);
			if (height < 1 or height == nil ) then height = 1; end
			button:SetHeight(height);
			button:Show();
		else
			button:Hide();
		end

		local normalTextureName="Interface\\AddOns\\CensusPlusClassic\\skins\\CensusPlus_" .. g_RaceClassList[class]
		local legendName = "CensusPlusClassLegend"..i;
		local legend = _G[legendName]
		legend:SetNormalTexture(normalTextureName);
		if (g_ClassSelected == i) then
			legend:LockHighlight();
		else
			legend:UnlockHighlight();
		end
	end

	if( CensusPlus_EnableProfiling ) then
		CensusPlus_Msg( "PROFILE: Update Classes " .. debugprofilestop() / 1000000000 );
		debugprofilestart();
	end

	-- Accumulate totals for each level
	local maxCount = 0;
	for i = 1, MAX_CHARACTER_LEVEL, 1 do
	    if ((levelKey == nil) or (levelKey == i) or (levelKey < 0 and levelKey + i ~= 0)) then
			CensusPlus_ResetAccumulator();
			CensusPlus_ForAllCharacters(realmName, factionGroup, raceKey, classKey, guildKey, i, CensusPlus_Accumulator);
			if (g_AccumulatorCount > maxCount) then
				maxCount = g_AccumulatorCount;
			end
			g_LevelCount[i] = g_AccumulatorCount;
		else
			g_LevelCount[i] = 0;
		end
	end

	-- Update level bars
	for i = 1, MAX_CHARACTER_LEVEL, 1 do
		local buttonName = "CensusPlusLevelBar"..i;
		local buttonEmptyName = "CensusPlusLevelBarEmpty"..i;
		local button = getglobal(buttonName);
		local emptyButton = getglobal(buttonEmptyName);
		local thisCount = g_LevelCount[i];
		if ((thisCount ~= nil) and (thisCount > 0) and (maxCount > 0)) then
			local height = floor((thisCount / maxCount) * CensusPlus_MAXBARHEIGHT);
			if (height < 1 or height == nil ) then height = 1; end
			button:SetHeight(height);
			button:Show();
			if (emptyButton ~= nil) then
				emptyButton:Hide();
			end
		else
			button:Hide();
			if (emptyButton ~= nil) then
				emptyButton:SetHeight(CensusPlus_MAXBARHEIGHT);
				emptyButton:Show();
			end
		end
	end
	
	if( CensusPlus_EnableProfiling ) then
		CensusPlus_Msg( "PROFILE: Update Levels " .. debugprofilestop() / 1000000000 );
		debugprofilestart();	
	end
	
	if( CP_PlayerListWindow:IsVisible() ) then
		CensusPlus_PlayerListOnShow();
	end
	

	debugprofilestop();
end

-- Walk the character database and call the callback function for every entry that matches the search criteria
function CensusPlus_ForAllCharacters(realmKey, factionKey, raceKey, classKey, guildKey, levelKey, callback)
	for realmName, realmDatabase in pairs(CensusPlus_Database["Servers"]) do
		if ((realmKey == nil) or (realmKey == realmName)) then
			for factionName, factionDatabase in pairs(realmDatabase) do
				if ((factionKey == nil) or (factionKey == factionName)) then
					for raceName, raceDatabase in pairs(factionDatabase) do
						if ((raceKey == nil) or (raceKey == raceName)) then
							for className, classDatabase in pairs(raceDatabase) do
								if ((classKey == nil) or (classKey == className)) then
									for characterName, character in pairs(classDatabase) do
									local characterGuild = character[2];
										if ((guildKey == nil) or (guildKey == characterGuild)) then
											local characterLevel = character[1];
											if( characterLevel == nil ) then
												characterLevel = 0;
											end
											if ((levelKey == nil) or (levelKey == characterLevel) or (levelKey < 0 and levelKey + characterLevel ~= 0)) then
												callback(characterName, characterLevel, characterGuild, raceName, className, character[4] );
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Race legend clicked
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnClickRace(self )
	--  default click is "LeftButton" and up .. no RegisterForClicks used
	local id = self:GetID()
	if (id == CPp.RaceSelected) then
		CPp.RaceSelected = 0
	else
		CPp.RaceSelected = id
	end
	CensusPlus_UpdateView()
end

-- Class legend clicked
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnClickClass(self)
	--  default click is "LeftButton" and up .. no RegisterForClicks used
	local id = self:GetID()
	if (id == CPp.ClassSelected) then
		CPp.ClassSelected = 0
	else
		CPp.ClassSelected = id
	end
	CensusPlus_UpdateView()
end

-- Level bar loaded
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnLoadLevel(self)
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

-- Level bar clicked
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnClickLevel(self, CP_button)
	-- both right and left buttons up registered.
	local id = self:GetID()
	if (((CP_button == "LeftButton") and (id == CPp.LevelSelected)) or ((CP_button == "RightButton") and (id + CPp.LevelSelected == 0))) then
		CPp.LevelSelected = 0
	elseif (CP_button == "RightButton") then
		CPp.LevelSelected = 0 - id
	else
		CPp.LevelSelected = id
	end
	CensusPlus_UpdateView()
end

-- Race tooltip
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnEnterRace(self, motion)
	if motion then
		local factionGroup = UnitFactionGroup("player")
		local thisFactionRaces = CensusPlus_GetFactionRaces(factionGroup)
		local id = self:GetID()
		local raceName = thisFactionRaces[id]
		local count = g_RaceCount[id]
		if (count ~= nil) and (g_TotalCount > 0) then
			local percent = floor((count / g_TotalCount) * 100)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(
				raceName .. "\n" .. count .. "\n" .. percent .. "%",
				1.0,
				1.0,
				1.0
			)
			GameTooltip:Show()
			-- this should never happen
			--GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			--GameTooltip:SetText(raceName.."\n 0", 1.0, 1.0, 1.0);
			--GameTooltip:Show();
		else
		end
	end -- event triggered by frame creation.. not moues movement.. so ignore
end

-- Class tooltip
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnEnterClass(self, motion)
	if motion then
		local factionGroup = UnitFactionGroup("player")
		local thisFactionClasses = CensusPlus_GetFactionClasses(factionGroup)
		local id = self:GetID()
		local className = thisFactionClasses[id]
		local count = g_ClassCount[id]
		if (count ~= nil) and (g_TotalCount > 0) then
			local percent = floor((count / g_TotalCount) * 100)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(
				className .. "\n" .. count .. "\n" .. percent .. "%",
				1.0,
				1.0,
				1.0
			)
			GameTooltip:Show()
			-- this should never happen
			--GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			--GameTooltip:SetText(className.."\n 0", 1.0, 1.0, 1.0);
			--GameTooltip:Show();
		else
		end
	end -- entered via frame creation.. not mouse motion .. ignore
end

-- Level tooltip
-- referenced by CensusPlusClassic.xml
function CensusPlus_OnEnterLevel(self, motion )
	if motion then
		local id = self:GetID()
		local count = g_LevelCount[id]
		if (count ~= nil) and (g_TotalCount > 0) then
			local percent = floor((count / g_TotalCount) * 100)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(
				LEVEL .. " " .. id .. "\n" .. count .. "\n" .. percent .. "%",
				1.0,
				1.0,
				1.0
			)
			GameTooltip:Show()
			-- this should never happen
			--GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			--GameTooltip:SetText("Level "..id.."\n 0", 1.0, 1.0, 1.0);
			--GameTooltip:Show();
		else
		end
	end -- entered via frame creation .. not mouse movement.. ignore
end

-- Clicked a guild button
-- referenced by CensusPlusClassic.xml
function CensusPlus_GuildButton_OnClick(self )
	local id = self:GetID();
	local offset = FauxScrollFrame_GetOffset(CensusPlusGuildScrollFrame);
	local newSelection = id + offset;
	if (CPp.GuildSelected ~= newSelection) then
		CPp.GuildSelected = newSelection;
	else
		CPp.GuildSelected = 0;
	end
	CensusPlus_UpdateView();
end

-- Update the guild button contents
function CensusPlus_UpdateGuildButtons()
	-- Determine where the scroll bar is
	local offset = FauxScrollFrame_GetOffset(CensusPlusGuildScrollFrame)
	-- Walk through all the rows in the frame
	local size = #CensusPlus_Guilds
	--	print("num guild buttons = "..size)
	local i = 1
	while (i <= CensusPlus_NUMGUILDBUTTONS) do
		-- Get the index to the ad displayed in this row
		local iGuild = i + offset
		-- Get the button on this row
		local button = _G["CensusPlusGuildButton" .. i]
		-- Is there a valid guild on this row?
		if (iGuild <= size) then
			local guild = CensusPlus_Guilds[iGuild]
			-- Update the button text
			button:Show()
			local textField = "CensusPlusGuildButton" .. i .. "Text"
			if (guild.m_Name == "") then
				_G[textField]:SetText(CENSUSPLUS_UNGUILDED)
			else
				_G[textField]:SetText(guild.m_GNfull)
			end
			-- If this is the guild, highlight it
			if (CPp.GuildSelected == iGuild) then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end
		-- Hide the button
		else
			button:Hide()
		end
		--
		-- Next row
		--
		i = i + 1
	end
	
	-- Update the scroll bar
	FauxScrollFrame_Update(
		CensusPlusGuildScrollFrame,
		size,
		CensusPlus_NUMGUILDBUTTONS,
		CensusPlus_GUILDBUTTONSIZEY
	)
end

-- Walk the character database prune all characters entries that are older than X days
-- referenced by CensusPlusClassic.xml
function CENSUSPLUS_PRUNEData(nDays, sServer)

	local pruneTime = 24 * 60 * 60 * nDays

	for realmName, realmDatabase in pairs(CensusPlus_Database["Servers"]) do
		for factionName, factionDatabase in pairs(realmDatabase) do
			if ((factionKey == nil) or (factionKey == factionName)) then
				for raceName, raceDatabase in pairs(factionDatabase) do
					if ((raceKey == nil) or (raceKey == raceName)) then
						for className, classDatabase in
							pairs(raceDatabase)
						do
							if ((classKey == nil) or (classKey == className)) then
								for characterName, character in
									pairs(classDatabase)
								do
									if (characterName ~= nil) then
										--[[
											if( sServer == 1 ) then
												if( realmName ~= thisRealmName ) then
													CensusPlus_AccumulatePruneData( realmName, factionName, raceName, className, characterName );
												end
											else
												if( realmName == thisRealmName ) then
										--]]
										local lastSeen = character[4] --  2005-05-02
										local tYear, tMonth, tDay
										tYear = string.sub(lastSeen, 1, 4)
										tMonth = string.sub(lastSeen, 6, 7)
										tDay = string.sub(lastSeen, 9)

										local lastSeenTime = time({
											year = tYear,
											month = tMonth,
											day = tDay,
											hour = 0
										})

										if (time() - lastSeenTime > pruneTime) then
											CensusPlus_AccumulatePruneData(
												realmName,
												factionName,
												raceName,
												className,
												characterName
											)
										end
										--end
										--end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	CENSUSPLUS_PRUNETimes()
	CensusPlus_UpdateView()
	CENSUSPLUS_PRUNETheData()
	CENSUSPLUS_PRUNEDeadBranches()
end

-- Prune the accumulation
function CensusPlus_AccumulatePruneData(realm, faction, race, class, name)
	local pruneData = {}
	pruneData.realm = realm
	pruneData.faction = faction
	pruneData.race = race
	pruneData.class = class
	pruneData.name = name
	--print("Prune "..realm.." "..faction.." "..race.." "..class.." "..name)
	table.insert(g_AccumulatedPruneData, pruneData)
end

-- Prune the accumulation
function CENSUSPLUS_PRUNETheData()
	local num = #g_AccumulatedPruneData
	CensusPlus_Msg(format(CENSUSPLUS_PRUNEINFO, num))
	while (num > 0) do
		-- Remove the top job from the queue and send it
		local pruneData = g_AccumulatedPruneData[num]

		CensusPlus_Database["Servers"][pruneData.realm][pruneData.faction][pruneData.race][pruneData.class][pruneData.name]
		= {}
		CensusPlus_Database["Servers"][pruneData.realm][pruneData.faction][pruneData.race][pruneData.class][pruneData.name]
		= nil

		table.remove(g_AccumulatedPruneData)
		num = #g_AccumulatedPruneData
	end
end

-- Prune time entries
function CENSUSPLUS_PRUNETimes()
	local pruneDays = 60 * 60 * 24 * 21 --  num seconds
	local accumTimesData = {}
	local PruneCount = 0

	for realmName, realmDatabase in pairs(CensusPlus_Database["TimesPlus"]) do
		if (realmName ~= nil) then
			for factionName, factionDatabase in pairs(realmDatabase) do
				if (factionName ~= nil) then
					for moment, count in pairs(factionDatabase) do
						--  Moment is in format of YYYY-MM-DD&HH:MM
						local test = string.sub(moment, 1, 2)
						local tYear, tMonth, tDay
						tYear = string.sub(moment, 1, 4)
						tMonth = string.sub(moment, 6, 7)
						tDay = string.sub(moment, 9, 10)
						local momentTime = time({
							year = tYear,
							month = tMonth,
							day = tDay,
							hour = 0
						})

						if (time() - momentTime > pruneDays) then
							--  cull entry
							local pruneData = {}
							pruneData.realm = realmName
							pruneData.faction = factionName
							pruneData.entry = moment
							table.insert(accumTimesData, pruneData)
						end
					end
				end
			end
		end
	end

	local num = #accumTimesData
	while (num > 0) do
		local pruneData = accumTimesData[num]

		CensusPlus_Database["TimesPlus"][pruneData.realm][pruneData.faction][pruneData.entry]
		= {}
		CensusPlus_Database["TimesPlus"][pruneData.realm][pruneData.faction][pruneData.entry]
		= nil
		table.remove(accumTimesData)
		num = #accumTimesData
	end

	for realmName, realmDatabase in pairs(CensusPlus_Database["TimesPlus"]) do
		if (realmName ~= nil) then
			for factionName, factionDatabase in pairs(realmDatabase) do
				if (factionName ~= nil) then
					PruneCount = 0
					for _ in pairs(factionDatabase) do
						PruneCount = PruneCount + 1
					end
					if (PruneCount == 0) then
						realmDatabase[factionName] = {}
						realmDatabase[factionName] = nil
					end
				end
			end
			PruneCount = 0
			for _ in pairs(realmDatabase) do
				PruneCount = PruneCount + 1
			end
			if (PruneCount == 0) then
				CensusPlus_Database["TimesPlus"][realmName] = {}
				CensusPlus_Database["TimesPlus"][realmName] = nil
			end
		end
	end
end

function CENSUSPLUS_PRUNEDeadBranches()
	local PruneCount = 0

	for realmName, realmDatabase in pairs(CensusPlus_Database["Servers"]) do
		if (realmName ~= nil) then
			for factionName, factionDatabase in pairs(realmDatabase) do
				if (factionName ~= nil) then
					for raceName, raceDatabase in pairs(factionDatabase) do
						if (raceName ~= nil) then
							for className, classDatabase in
								pairs(raceDatabase)
							do
								if (className ~= nil) then
									PruneCount = 0
									for _ in pairs(classDatabase) do
										PruneCount = PruneCount + 1
										if (PruneCount > 0) then
											break
										end
									end
									if (PruneCount == 0) then
										raceDatabase[className] = {}
										raceDatabase[className] = nil
									end
								end
							end
							PruneCount = 0
							for _ in pairs(raceDatabase) do
								PruneCount = PruneCount + 1
								if (PruneCount > 0) then
									break
								end
							end
							if (PruneCount == 0) then
								factionDatabase[raceName] = {}
								factionDatabase[raceName] = nil
							end
						end
					end
					PruneCount = 0
					for _ in pairs(factionDatabase) do
						PruneCount = PruneCount + 1
						if (PruneCount > 0) then
							break
						end
					end
					if (PruneCount == 0) then
						realmDatabase[factionName] = {}
						realmDatabase[factionName] = nil
					end
				end
			end
			PruneCount = 0
			for _ in pairs(realmDatabase) do
				PruneCount = PruneCount + 1
				if (PruneCount > 0) then
					break
				end
			end
			if (PruneCount == 0) then
				CensusPlus_Database["Servers"][realmName] = {}
				CensusPlus_Database["Servers"][realmName] = nil
			end
		end
	end
end

function CensusPlus_CheckForBattleground()
	--CensusPlus_Msg( "Checking for BG" );
	g_CurrentlyInBG_Msg = false

	local battlefieldTime = GetBattlefieldInstanceRunTime()
	if (battlefieldTime > 0) then
		--  We are in a battleground so cancel the current take
		g_CurrentlyInBG = true -- if player in battlefield
	else
		if (GetBattlefieldStatInfo(1) ~= nil) then
			g_CurrentlyInBG = true
		else
			g_CurrentlyInBG = false
		end
	end
end

-- CensusPlus_DetermineServerDate
function CensusPlus_DetermineServerDate()
	return date("!%Y-%m-%d", GetServerTime())
end

-- Check time zone
function CensusPlus_CheckTZ()
	local UTCTimeHour = date("!%H", time())
	local LocTimeHour = date("%H", time())
	local hour, minute = GetGameTime()
	local locDiff = LocTimeHour - UTCTimeHour
	local servDiff = hour - UTCTimeHour
	g_CensusPlusTZOffset = servDiff
end

function CensusPlus_SendWho(msg)
	if (g_Verbose == true) then
		CensusPlus_Msg(format(CENSUSPLUS_SENDING, msg))
	end

	-- Add CensusButton show top of whoquery
	if g_CensusButtonAnimi then
		local _, _, topwho = string.find(msg, "(%d+)")
		topwho = string.sub(msg, string.find(msg, "-", -4) + 1)
		topwhoval = tonumber(topwho)
		if (topwhoval > 99) then
			--topwho = topwho - 100
			CensusButton:SetNormalFontObject(GameFontNormalSmall)
			topwho = "|cffff5e16" .. topwho .. "|r"
		else
			CensusButton:SetNormalFontObject(GameFontNormal)
		end
		CensusButton:SetText(topwho)
	end

	if wholib then
		wholib:Who(msg, {
			queue = wholib.WHOLIB_QUEUE_QUIET,
			flags = 0,
			callback = CP_ProcessWhoEvent
		})
		--wholib:AskWho({query = msg, queue = wholib.WHOLIB_QUEUE_QUIET, callback = CP_ProcessWhoEvent })
	else
		SendWho(msg)
	end
	whoquery_active = true
	CP_g_queue_count = CP_g_queue_count + 1
end

function PTR_Color_ProblemNames_check(name)
	--[[
			PTR testing modifications
			Blizzard has odd naming allowances in PTR realms
			name (US) or name (EU)  ditto for guild names
	--]]

	if (CensusPlus_PTR ~= false) then
		local cp_ptr_name_check, _, _ = string.find(name, "  %(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 3,
					cp_ptr_name_check + 4
				)
		end
		local cp_ptr_name_check, _, _ = string.find(name, " %(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 2,
					cp_ptr_name_check + 3
				)
		end
		local cp_ptr_name_check, _, _ = string.find(name, "%(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 1,
					cp_ptr_name_check + 2
				)
		end
	end

	--  Test the name for possible color coding
	--  for example |cffff0000Rollie|r
	local karma_check = string.find(name, "|cff")
	if (karma_check ~= nil) then
		name = string.sub(name, 11, -3)
	end
	
	--  Further check for problematic chars
	local pattern = "[%d| ]"
	if (string.find(name, pattern) ~= nil) then
		if not g_ProblematicMessageShown then
			CensusPlus_Msg(
				CENSUSPLUS_PROBLEMNAME .. name .. CENSUSPLUS_PROBLEMNAME_ACTION
			)
			g_ProblematicMessageShown = true
		end
		name = ""
	end
	return name
end

function PTR_Color_ProblemRealmGuilds_check(name)
	--[[ 
			PTR testing modifications
			Blizzard has odd naming allowances in PTR realms
			name (US) or name (EU)  ditto for guild names
´	--]]

	if (CensusPlus_PTR ~= false) then
		local cp_ptr_name_check, _, _ = string.find(name, "  %(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 3,
					cp_ptr_name_check + 4
				)
			if (HortonBug == true) then
				says("1 " .. name)
			end
		end
		local cp_ptr_name_check, _, _ = string.find(name, " %(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 2,
					cp_ptr_name_check + 3
				)
			if (HortonBug == true) then
				says("2 " .. name)
			end
		end
		local cp_ptr_name_check, _, _ = string.find(name, "%(")
		if (cp_ptr_name_check ~= nil) then
			name =
				string.sub(name, 1, cp_ptr_name_check - 1) .. string.sub(
					name,
					cp_ptr_name_check + 1,
					cp_ptr_name_check + 2
				)
			if (HortonBug == true) then
				says("3 " .. name)
			end
		end
	end
	return name
end


-- this function not correctly setup.. in fact the mini window isn't setup {acutally i5 is but hidden and off screen}
function CensusPlus_Mini_OnMouseDown(
self,
	mCP_button -- referenced by CensusPlusClassic.xml
)
	if ((not self.isLocked or (self.isLocked == 0)) and (mCP_button == "LeftButton")) then
		self:StartMoving()
		self.isMoving = true
	end
end

-- referenced by CensusPlusClassic.xml
function CensusPlus_Census_OnMouseDown(self, CP_button)
	if (not self.isLocked or (self.isLocked == 0)) then
		self:StartMoving()
		self.isMoving = true
	end
end

function CensusPlusBlizzardOptions()
	-- Create main frame for information text
	CensusPlusOptions = CreateFrame("FRAME", "CensusPlusOptions")
	CensusPlusOptions.name = GetAddOnMetadata("CensusPlusClassic", "Title")
	CensusPlusOptions.default = function(self)
		CensusPlus_ResetConfig()
	end
	CensusPlusOptions.refresh = function(self)
		CensusPlusSetCheckButtonState()
	end
	CensusPlusOptions.cancel = function(self)
		CensusPlusRestoreSettings()
	end
	CensusPlusOptions.okay = function(self)
		CensusPlusCloseOptions()
	end
	InterfaceOptions_AddCategory(CensusPlusOptions)

	-- Create Title frame
	CensusPlusOptionsHeader = CensusPlusOptions:CreateFontString(nil, "ARTWORK")
	CensusPlusOptionsHeader:SetFontObject(GameFontNormalLarge)
	CensusPlusOptionsHeader:SetJustifyH("LEFT")
	CensusPlusOptionsHeader:SetJustifyV("TOP")
	CensusPlusOptionsHeader:ClearAllPoints()
	CensusPlusOptionsHeader:SetPoint("TOPLEFT", 16, -16)
	CensusPlusOptionsHeader:SetText(
		"CensusClassic v" .. CensusPlus_VERSION_FULL
	)

	-- Create Top Text frame (section 1 header)
	CensusPlusOptionsWL = CensusPlusOptions:CreateFontString(nil, "ARTWORK")
	CensusPlusOptionsWL:SetFontObject(GameFontWhite)
	CensusPlusOptionsWL:SetJustifyH("LEFT")
	CensusPlusOptionsWL:SetJustifyV("TOP")
	CensusPlusOptionsWL:ClearAllPoints()
	CensusPlusOptionsWL:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsHeader,
		"BOTTOMLEFT",
		14,
		-6
	)
	CensusPlusOptionsWL:SetText(
		CENSUSPLUS_ACCOUNT_WIDE .. " " .. CENSUSPLUS_BUTTON_OPTIONS
	)

	-- Create Top Text frame (section 1 header)
	CensusPlusOptionsWR = CensusPlusOptions:CreateFontString(nil, "ARTWORK")
	CensusPlusOptionsWR:SetFontObject(GameFontWhite)
	CensusPlusOptionsWR:SetJustifyH("LEFT")
	CensusPlusOptionsWR:SetJustifyV("TOP")
	CensusPlusOptionsWR:ClearAllPoints()
	CensusPlusOptionsWR:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsWL,
		"TOPRIGHT",
		100,
		0
	)
	CensusPlusOptionsWR:SetText(CENSUSPLUS_CCO_OPTIONOVERRIDES)

	--Create Frame CheckButton (Verbose)
	CensusPlusCheckButton1 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton1",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton1:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsWL,
		"BOTTOMLEFT",
		2,
		-10
	)
	CensusPlusCheckButton1:SetScript("OnClick", function(self)
		local g_AW_Verbose = CensusPlusCheckButton1:GetChecked()
		--print("CB1 = ".. g_AW_Verbose)
		if g_AW_Verbose then
			CensusPlus_Database["Info"]["Verbose"] = true
			CensusPlus_Database["Info"]["Stealth"] = false
			CensusPlusCheckButton2:SetChecked(false)
			CensusPlus_Stealth(self)
		else
			CensusPlus_Database["Info"]["Verbose"] = false
		end
		CensusPlus_Verbose(self)
	end)
	CensusPlusCheckButton1Text:SetText(CENSUS_OPTIONS_VERBOSE)
	CensusPlusCheckButton1.tooltipText = CENSUS_OPTIONS_VERBOSE_TOOLTIP

	--Create Frame tri-selector button (CO - Verbose - enable)
	CensusPlusOptionsRadioButton_C1a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C1a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C1a:SetHeight(20)
	CensusPlusOptionsRadioButton_C1a:SetWidth(20)
	CensusPlusOptionsRadioButton_C1a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C1a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C1a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton1,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C1a:SetChecked(false)
	CensusPlusOptionsRadioButton_C1a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C1a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C1a:SetScript("OnClick", function(self)
		local g_CO_Verbose = CensusPlusOptionsRadioButton_C1a:GetChecked()
		if g_CO_Verbose then
			CensusPlusOptionsRadioButton_C1b:SetChecked(false)
			CensusPlusOptionsRadioButton_C1c:SetChecked(false)
			CensusPlus_PerCharInfo["Verbose"] = true
			CensusPlus_PerCharInfo["Stealth"] = false
			CensusPlusOptionsRadioButton_C2a:SetChecked(false)
			CensusPlusOptionsRadioButton_C2b:SetChecked(true)
			CensusPlusOptionsRadioButton_C2c:SetChecked(false)
			CensusPlus_Stealth(self)
		elseif not CensusPlusOptionsRadioButton_C1b:GetChecked() then
			CensusPlusOptionsRadioButton_C1c:SetChecked(true)
			CensusPlus_PerCharInfo["Verbose"] = nil
		end
		CensusPlus_Verbose(self)
	end)
	CensusPlusOptionsRadioButton_C1a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - Verbose - disable)
	CensusPlusOptionsRadioButton_C1b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C1b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C1b:SetHeight(20)
	CensusPlusOptionsRadioButton_C1b:SetWidth(20)
	CensusPlusOptionsRadioButton_C1b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C1b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C1b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C1a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C1b:SetChecked(false)
	CensusPlusOptionsRadioButton_C1b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C1b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C1b:SetScript("OnClick", function(self)
		local g_CO_Verbose = CensusPlusOptionsRadioButton_C1b:GetChecked()
		if g_CO_Verbose then
			CensusPlusOptionsRadioButton_C1a:SetChecked(false)
			CensusPlusOptionsRadioButton_C1c:SetChecked(false)
			CensusPlus_PerCharInfo["Verbose"] = false --if (not(CensusPlusOptionsRadioButton_C1a:GetChecked()))then
		else
			CensusPlusOptionsRadioButton_C1c:SetChecked(true)
			CensusPlus_PerCharInfo["Verbose"] = nil
			if CensusPlusOptionsRadioButton_C2a:GetChecked() then
				CensusPlusOptionsRadioButton_C2a:SetChecked(false)
				CensusPlusOptionsRadioButton_C2c:SetChecked(true)
				CensusPlus_PerCharInfo["Stealth"] = nil
				CensusPlus_Stealth(self)
			end
		end
		CensusPlus_Verbose(self)
	end)
	CensusPlusOptionsRadioButton_C1b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - Verbose - remove)
	CensusPlusOptionsRadioButton_C1c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C1c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C1c:SetHeight(20)
	CensusPlusOptionsRadioButton_C1c:SetWidth(20)
	CensusPlusOptionsRadioButton_C1c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C1c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C1c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C1b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C1c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C1c:GetName() .. "Text"]:SetText(
		CENSUS_OPTIONS_VERBOSE .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C1c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C1c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C1c:SetScript("OnClick", function(self)
		local g_CO_Verbose = CensusPlusOptionsRadioButton_C1c:GetChecked()
		if g_CO_Verbose then
			CensusPlusOptionsRadioButton_C1a:SetChecked(false)
			CensusPlusOptionsRadioButton_C1b:SetChecked(false)
			CensusPlus_PerCharInfo["Verbose"] = nil
			if (CensusPlusCheckButton1:GetChecked() and CensusPlusOptionsRadioButton_C2a:GetChecked()) then
				CensusPlusOptionsRadioButton_C2a:SetChecked(false)
				CensusPlusOptionsRadioButton_C2c:SetChecked(true)
				CensusPlus_PerCharInfo["Stealth"] = false
				CensusPlus_Stealth(self)
			end
		elseif not (CensusPlusOptionsRadioButton_C1a:GetChecked() or CensusPlusOptionsRadioButton_C1b:GetChecked()) then
			CensusPlusOptionsRadioButton_C1c:SetChecked(true)
			CensusPlus_PerCharInfo["Verbose"] = nil
		end
		CensusPlus_Verbose(self)
	end)
	CensusPlusOptionsRadioButton_C1c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	--Create Frame enable Stealth Mode
	CensusPlusCheckButton2 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton2",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton2:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton1,
		"BOTTOMLEFT",
		0,
		-4
	)
	CensusPlusCheckButton2:SetScript("OnClick", function(self)
		local g_AW_Stealth = CensusPlusCheckButton2:GetChecked()
		if g_AW_Stealth then
			CensusPlus_Database["Info"]["Stealth"] = true
			CensusPlus_Database["Info"]["Verbose"] = false
			CensusPlusCheckButton1:SetChecked(false)
			CensusPlus_Verbose(self)
		else
			CensusPlus_Database["Info"]["Stealth"] = false
		end
		CensusPlus_Stealth(self)
	end)
	CensusPlusCheckButton2Text:SetText(CENSUS_OPTIONS_STEALTH)
	CensusPlusCheckButton2.tooltipText = CENSUS_OPTIONS_STEALTH_TOOLTIP

	--Create Frame tri-selector button (CO - Stealth - enable)
	CensusPlusOptionsRadioButton_C2a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C2a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C2a:SetHeight(20)
	CensusPlusOptionsRadioButton_C2a:SetWidth(20)
	CensusPlusOptionsRadioButton_C2a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C2a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C2a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton2,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C2a:SetChecked(false)
	CensusPlusOptionsRadioButton_C2a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C2a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C2a:SetScript("OnClick", function(self)
		local g_CO_Stealth = CensusPlusOptionsRadioButton_C2a:GetChecked()
		if g_CO_Stealth then
			CensusPlusOptionsRadioButton_C2b:SetChecked(false)
			CensusPlusOptionsRadioButton_C2c:SetChecked(false)
			CensusPlus_PerCharInfo["Stealth"] = true
			CensusPlus_PerCharInfo["Verbose"] = false
			CensusPlusOptionsRadioButton_C1a:SetChecked(false)
			CensusPlusOptionsRadioButton_C1b:SetChecked(true)
			CensusPlusOptionsRadioButton_C1c:SetChecked(false)
			CensusPlus_Verbose(self)
		elseif not CensusPlusOptionsRadioButton_C2b:GetChecked() then
			CensusPlusOptionsRadioButton_C2c:SetChecked(true)
			CensusPlus_PerCharInfo["Stealth"] = nil
		end
		CensusPlus_Stealth(self)
	end)
	CensusPlusOptionsRadioButton_C2a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - Stealth - disable)
	CensusPlusOptionsRadioButton_C2b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C2b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C2b:SetHeight(20)
	CensusPlusOptionsRadioButton_C2b:SetWidth(20)
	CensusPlusOptionsRadioButton_C2b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C2b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C2b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C2a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C2b:SetChecked(false)
	CensusPlusOptionsRadioButton_C2b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C2b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C2b:SetScript("OnClick", function(self)
		local g_CO_Stealth = CensusPlusOptionsRadioButton_C2b:GetChecked()
		if g_CO_Stealth then
			CensusPlusOptionsRadioButton_C2a:SetChecked(false)
			CensusPlusOptionsRadioButton_C2c:SetChecked(false)
			CensusPlus_PerCharInfo["Stealth"] = false --if(not(CensusPlusOptionsRadioButton_C2a:GetChecked()) )then
		else
			CensusPlusOptionsRadioButton_C2c:SetChecked(true)
			CensusPlus_PerCharInfo["Stealth"] = nil
			if CensusPlusOptionsRadioButton_C1a:GetChecked() then
				CensusPlusOptionsRadioButton_C1a:SetChecked(false)
				CensusPlusOptionsRadioButton_C1c:SetChecked(true)
				CensusPlus_PerCharInfo["Verbose"] = nil
				CensusPlus_Verbose(self)
			end
		end
		CensusPlus_Stealth(self)
	end)
	CensusPlusOptionsRadioButton_C2b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - Stealth - remove)
	CensusPlusOptionsRadioButton_C2c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C2c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C2c:SetHeight(20)
	CensusPlusOptionsRadioButton_C2c:SetWidth(20)
	CensusPlusOptionsRadioButton_C2c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C2c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C2c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C2b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C2c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C2c:GetName() .. "Text"]:SetText(
		CENSUS_OPTIONS_STEALTH .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C2c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C2c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C2c:SetScript("OnClick", function(self)
		local g_CO_Stealth = CensusPlusOptionsRadioButton_C2c:GetChecked()
		if g_CO_Stealth then
			CensusPlusOptionsRadioButton_C2b:SetChecked(false)
			CensusPlusOptionsRadioButton_C2a:SetChecked(false)
			CensusPlus_PerCharInfo["Stealth"] = nil
			if (CensusPlusCheckButton2:GetChecked() and CensusPlusOptionsRadioButton_C1a:GetChecked()) then
				CensusPlusOptionsRadioButton_C1a:SetChecked(false)
				CensusPlusOptionsRadioButton_C1c:SetChecked(true)
				CensusPlus_PerCharInfo["Verbose"] = nil
				CensusPlus_Verbose(self)
			end
			--CensusPlusOptionsRadioButton_C2c:SetChecked(true)
		elseif not (CensusPlusOptionsRadioButton_C2a:GetChecked() or CensusPlusOptionsRadioButton_C2b:GetChecked()) then
			CensusPlus_PerCharInfo["Stealth"] = nil
		end
		CensusPlus_Stealth(self)
	end)
	CensusPlusOptionsRadioButton_C2c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	--Create Frame enable Census Button
	CensusPlusCheckButton3 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton3",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton3:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton2,
		"BOTTOMLEFT",
		2,
		-4
	)
	
	--CensusPlusOptionsWMZ
	CensusPlusCheckButton3:SetScript("OnClick", function(self)
		local g_AW_CensusButtonShown = CensusPlusCheckButton3:GetChecked()
		if g_AW_CensusButtonShown then
			CensusPlus_Database["Info"]["CensusButtonShown"] = true
		else
			CensusPlus_Database["Info"]["CensusButtonShown"] = false
			CensusPlus_Database["Info"]["CensusButtonAnimi"] = false
			CensusPlusCheckButton4:SetChecked(false)
			CensusPlus_CensusButtonAnimi(self)
		end
		CensusPlus_CensusButtonShown(self)
	end)
	CensusPlusCheckButton3Text:SetText(CENSUS_OPTIONS_BUTSHOW)
	CensusPlusCheckButton3.tooltipText = CENSUS_OPTIONS_BUTSHOW

	-- Create Frame tri-selector button (CO - CensusPlusClassic Button - enable)
	CensusPlusOptionsRadioButton_C3a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C3a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C3a:SetHeight(20)
	CensusPlusOptionsRadioButton_C3a:SetWidth(20)
	CensusPlusOptionsRadioButton_C3a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C3a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C3a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton3,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C3a:SetChecked(false)
	CensusPlusOptionsRadioButton_C3a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C3a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C3a:SetScript("OnClick", function(self)
		local g_CO_CensusButtonShown =
			CensusPlusOptionsRadioButton_C3a:GetChecked()
		if g_CO_CensusButtonShown then
			CensusPlusOptionsRadioButton_C3b:SetChecked(false)
			CensusPlusOptionsRadioButton_C3c:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonShown"] = true -- if (not(CensusPlusOptionsRadioButton_C3b:GetChecked()) )then
		else
			CensusPlusOptionsRadioButton_C3c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonShown"] = nil
			if CensusPlusOptionsRadioButton_C4a:GetChecked() then
				CensusPlusOptionsRadioButton_C4a:SetChecked(false)
				CensusPlusOptionsRadioButton_C4c:SetChecked(true)
				CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
				CensusPlus_CensusButtonAnimi(self)
			end
		end
		CensusPlus_CensusButtonShown(self)
	end)
	CensusPlusOptionsRadioButton_C3a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - CensusPlusClassic Button - disable)
	CensusPlusOptionsRadioButton_C3b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C3b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C3b:SetHeight(20)
	CensusPlusOptionsRadioButton_C3b:SetWidth(20)
	CensusPlusOptionsRadioButton_C3b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C3b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C3b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C3a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C3b:SetChecked(false)
	CensusPlusOptionsRadioButton_C3b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C3b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C3b:SetScript("OnClick", function(self)
		local g_CO_CensusButtonShown =
			CensusPlusOptionsRadioButton_C3b:GetChecked()
		if g_CO_CensusButtonShown then
			CensusPlusOptionsRadioButton_C3a:SetChecked(false)
			CensusPlusOptionsRadioButton_C3c:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonShown"] = false
			if (CensusPlusCheckButton4:GetChecked() or CensusPlusOptionsRadioButton_C4a:GetChecked()) then
				CensusPlusOptionsRadioButton_C4a:SetChecked(false)
				CensusPlusOptionsRadioButton_C4b:SetChecked(true)
				CensusPlusOptionsRadioButton_C4c:SetChecked(false)
				CensusPlus_PerCharInfo["CensusButtonAnimi"] = false
				CensusPlus_CensusButtonAnimi(self)
			end --if (not(CensusPlusOptionsRadioButton_C3a:GetChecked()) )then
		else
			CensusPlusOptionsRadioButton_C3c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonShown"] = nil
		end
		CensusPlus_CensusButtonShown(self)
	end)
	CensusPlusOptionsRadioButton_C3b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - CensusPlusClassic Button - remove)
	CensusPlusOptionsRadioButton_C3c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C3c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C3c:SetHeight(20)
	CensusPlusOptionsRadioButton_C3c:SetWidth(20)
	CensusPlusOptionsRadioButton_C3c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C3c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C3c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C3b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C3c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C3c:GetName() .. "Text"]:SetText(
		CENSUS_OPTIONS_BUTSHOW .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C3c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C3c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C3c:SetScript("OnClick", function(self)
		local g_CO_CensusButtonShown =
			CensusPlusOptionsRadioButton_C3c:GetChecked()
		if g_CO_CensusButtonShown then
			CensusPlusOptionsRadioButton_C3b:SetChecked(false)
			CensusPlusOptionsRadioButton_C3a:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonShown"] = nil
		elseif not (CensusPlusOptionsRadioButton_C3a:GetChecked() or CensusPlusOptionsRadioButton_C3b:GetChecked()) then
			CensusPlusOptionsRadioButton_C3c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonShown"] = nil
		end
		CensusPlus_CensusButtonShown(self)
	end)
	CensusPlusOptionsRadioButton_C3c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	--Create Frame CensusButton Animation
	CensusPlusCheckButton4 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton4",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton4:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton3,
		"BOTTOMLEFT",
		0,
		-4
	)
	CensusPlusCheckButton4:SetScript("OnClick", function(self)
		local g_AWCensusButtonAnimi = CensusPlusCheckButton4:GetChecked()
		if g_AWCensusButtonAnimi then
			CensusPlus_Database["Info"]["CensusButtonAnimi"] = true
			CensusPlus_Database["Info"]["CensusButtonShown"] = true
			CensusPlusCheckButton3:SetChecked(true)
			CensusPlus_CensusButtonShown(self)
		else
			CensusPlus_Database["Info"]["CensusButtonAnimi"] = false
		end
		CensusPlus_CensusButtonAnimi(self)
	end)
	CensusPlusCheckButton4Text:SetText(CENSUSPLUS_CENSUSBUTTONANIMITEXT)
	CensusPlusCheckButton4.tooltipText =
		ENABLE .. " " .. CENSUSPLUS_CENSUSBUTTONANIMITEXT

	--Create Frame tri-selector button (CO - Census button animation - enable)
	CensusPlusOptionsRadioButton_C4a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C4a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C4a:SetHeight(20)
	CensusPlusOptionsRadioButton_C4a:SetWidth(20)
	CensusPlusOptionsRadioButton_C4a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C4a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C4a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton4,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C4a:SetChecked(false)
	CensusPlusOptionsRadioButton_C4a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C4a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C4a:SetScript("OnClick", function(self)
		local g_CO_CPBAnimi = CensusPlusOptionsRadioButton_C4a:GetChecked()
		if g_CO_CPBAnimi then
			CensusPlusOptionsRadioButton_C4b:SetChecked(false)
			CensusPlusOptionsRadioButton_C4c:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = true
			CensusPlusOptionsRadioButton_C3a:SetChecked(true)
			CensusPlusOptionsRadioButton_C3b:SetChecked(false)
			CensusPlusOptionsRadioButton_C3c:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonShown"] = true
			CensusPlus_CensusButtonShown(self)
		elseif not CensusPlusOptionsRadioButton_C4a:GetChecked() then
			CensusPlusOptionsRadioButton_C4c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
		end
		CensusPlus_CensusButtonAnimi(self)
	end)
	CensusPlusOptionsRadioButton_C4a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - Census button animation - disable)
	CensusPlusOptionsRadioButton_C4b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C4b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C4b:SetHeight(20)
	CensusPlusOptionsRadioButton_C4b:SetWidth(20)
	CensusPlusOptionsRadioButton_C4b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C4b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C4b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C4a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C4b:SetChecked(false)
	CensusPlusOptionsRadioButton_C4b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C4b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C4b:SetScript("OnClick", function(self)
		local g_CO_CPBAnimi = CensusPlusOptionsRadioButton_C4b:GetChecked()
		if g_CO_CPBAnimi then
			CensusPlusOptionsRadioButton_C4a:SetChecked(false)
			CensusPlusOptionsRadioButton_C4c:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = false --if (not(CensusPlusOptionsRadioButton_C4a:GetChecked()))then
		else
			CensusPlusOptionsRadioButton_C4c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
		end
		CensusPlus_CensusButtonAnimi(self)
	end)
	CensusPlusOptionsRadioButton_C4b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - Census button animation - remove)
	CensusPlusOptionsRadioButton_C4c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C4c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C4c:SetHeight(20)
	CensusPlusOptionsRadioButton_C4c:SetWidth(20)
	CensusPlusOptionsRadioButton_C4c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C4c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C4c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C4b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C4c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C4c:GetName() .. "Text"]:SetText(
		CENSUSPLUS_CENSUSBUTTONANIMITEXT .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C4c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C4c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C4c:SetScript("OnClick", function(self)
		local g_CO_CPBAnimi = CensusPlusOptionsRadioButton_C4c:GetChecked()
		if g_CO_CPBAnimi then
			CensusPlusOptionsRadioButton_C4b:SetChecked(false)
			CensusPlusOptionsRadioButton_C4a:SetChecked(false)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
		elseif not (CensusPlusOptionsRadioButton_C4a:GetChecked() or CensusPlusOptionsRadioButton_C4b:GetChecked()) then
			CensusPlusOptionsRadioButton_C4c:SetChecked(true)
			CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
		end
		CensusPlus_CensusButtonAnimi(self)
	end)
	CensusPlusOptionsRadioButton_C4c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	-- Create Frame AutoCensus enable
	CensusPlusCheckButton5 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton5",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton5:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton4,
		"BOTTOMLEFT",
		0,
		-4
	)
	CensusPlusCheckButton5:SetScript("OnClick", function(self)
		local g_AW_AutoCensus = CensusPlusCheckButton5:GetChecked()
		if g_AW_AutoCensus then
			CensusPlus_Database["Info"]["AutoCensus"] = true
		else
			CensusPlus_Database["Info"]["AutoCensus"] = false
			CensusPlus_Database["Info"]["AutoCensusTimer"] = 1800
			if not CensusPlusOptionsRadioButton_C5a:GetChecked() then
				CensusPlusSlider1:SetValue(15)
			end
		end
		CensusPlus_SetAutoCensus(self)
	end)
	CensusPlusCheckButton5Text:SetText(CENSUS_OPTIONS_AUTOCENSUS)
	CensusPlusCheckButton5.tooltipText = CENSUSPLUS_AUTOCENSUSTEXT

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_AUTOCENSUS - enable)
	CensusPlusOptionsRadioButton_C5a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C5a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C5a:SetHeight(20)
	CensusPlusOptionsRadioButton_C5a:SetWidth(20)
	CensusPlusOptionsRadioButton_C5a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C5a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C5a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton5,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C5a:SetChecked(false)
	CensusPlusOptionsRadioButton_C5a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C5a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C5a:SetScript("OnClick", function(self)
		local g_CO_CPAuto = CensusPlusOptionsRadioButton_C5a:GetChecked()
		if g_CO_CPAuto then
			CensusPlusOptionsRadioButton_C5b:SetChecked(false)
			CensusPlusOptionsRadioButton_C5c:SetChecked(false)
			CensusPlus_PerCharInfo["AutoCensus"] = true
			CensusPlus_PerCharInfo["AutoCensusTimer"] = 1800
			CensusPlusSlider1:SetValue(30)
			-- enable new override.. reset timer to 30 and disabled
			--print(CPp.AutoStartTimer) -- revert to AW settings
		elseif not CensusPlusOptionsRadioButton_C5b:GetChecked() then
			CensusPlusOptionsRadioButton_C5c:SetChecked(true)
			CensusPlus_PerCharInfo["AutoCensus"] = nil
			CensusPlus_PerCharInfo["AutoCensusTimer"] = 1800
			CensusPlusSlider1:SetValue(30)
			if CensusPlusCheckButton5:GetChecked() then
				CensusPlusSlider1:SetValue(CensusPlus_Database["Info"]["AutoCensusTimer"] / 60)
			else
			end
		end
		CensusPlus_SetAutoCensus(self)
	end)
	CensusPlusOptionsRadioButton_C5a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_AUTOCENSUS - disable)
	CensusPlusOptionsRadioButton_C5b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C5b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C5b:SetHeight(20)
	CensusPlusOptionsRadioButton_C5b:SetWidth(20)
	CensusPlusOptionsRadioButton_C5b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C5b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C5b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C5a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C5b:SetChecked(false)
	CensusPlusOptionsRadioButton_C5b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C5b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C5b:SetScript("OnClick", function(self)
		local g_CO_CPAuto = CensusPlusOptionsRadioButton_C5b:GetChecked()
		if g_CO_CPAuto then
			CensusPlusOptionsRadioButton_C5a:SetChecked(false)
			CensusPlusOptionsRadioButton_C5c:SetChecked(false)
			CensusPlus_PerCharInfo["AutoCensus"] = false
			-- enable new override.. reset timer to 30 and disabled
			CensusPlus_PerCharInfo["AutoCensusTimer"] = 1800
			CensusPlusSlider1:SetValue(30)
			CPp.AutoStartText =
				CPp.AutoStartTimer .. " " .. CENSUS_OPTIONS_AUTOSTART .. " " .. ADDON_DISABLED
		elseif not CensusPlusOptionsRadioButton_C5a:GetChecked() then
			CensusPlusOptionsRadioButton_C5c:SetChecked(true)
			CensusPlus_PerCharInfo["AutoCensus"] = nil
			if CensusPlusCheckButton5:GetChecked() then
				CensusPlusSlider1:SetValue(CensusPlus_Database["Info"]["AutoCensusTimer"] / 60)
			end
		end
		CensusPlus_SetAutoCensus(self)
	end)
	CensusPlusOptionsRadioButton_C5b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_AUTOCENSUS - remove)
	CensusPlusOptionsRadioButton_C5c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C5c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C5c:SetHeight(20)
	CensusPlusOptionsRadioButton_C5c:SetWidth(20)
	CensusPlusOptionsRadioButton_C5c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C5c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C5c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C5b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C5c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C5c:GetName() .. "Text"]:SetText(
		CENSUS_OPTIONS_AUTOCENSUS .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C5c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C5c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C5c:SetScript("OnClick", function(self)
		local g_CO_CPAuto = CensusPlusOptionsRadioButton_C5c:GetChecked()
		if g_CO_CPAuto then
			CensusPlusOptionsRadioButton_C5b:SetChecked(false)
			CensusPlusOptionsRadioButton_C5a:SetChecked(false)
			CensusPlus_PerCharInfo["AutoCensus"] = nil
			-- enable new override.. reset timer to 30 and disabled
			CensusPlus_PerCharInfo["AutoCensusTimer"] = 1800
			if CensusPlusCheckButton5:GetChecked() then
				CensusPlusSlider1:SetValue(CensusPlus_Database["Info"]["AutoCensusTimer"] / 60)
			else
				CensusPlusSlider1:SetValue(30)
			end
			CensusPlus_SetAutoCensus(self)
		end
	end)
	CensusPlusOptionsRadioButton_C5c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	--Create Frame Timer Slider
	CensusPlusSlider1 =
		CreateFrame(
			"Slider",
			"CensusPlusSlider1",
			CensusPlusOptions,
			"OptionsSliderTemplate"
		)
	CensusPlusSlider1:SetWidth(100)
	CensusPlusSlider1:SetHeight(20)
	CensusPlusSlider1:SetOrientation("HORIZONTAL")
	CensusPlusSlider1:SetMinMaxValues(5, 30)
	CensusPlusSlider1:SetObeyStepOnDrag(true)
	CensusPlusSlider1:SetValueStep(1)
	CensusPlusSlider1:SetValue(15)
	CensusPlusSlider1:SetThumbTexture(
		"Interface\\Buttons\\UI-SliderBar-Button-Horizontal"
	)
	CensusPlusSlider1:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton5,
		"BOTTOMLEFT",
		68,
		-8
	)
	CensusPlusSlider1:SetScript("OnValueChanged", function(self, value)
		CPp.AutoStartTimer = CensusPlusSlider1:GetValue()
	end)
	CensusPlusSlider1:SetScript("OnMouseUp", function(self, value)
		local value = CensusPlusSlider1:GetValue()
		local ovrride = false
		if CensusPlusOptionsRadioButton_C5a:GetChecked() then
			ovrride = true
		else
			ovrride = false
		end
		CensusPlus_TimerSet(self, value, ovrride)
	end)
	CensusPlusSlider1.tooltipText = CENSUS_OPTIONS_TIMER_TOOLTIP --Creates a tooltip on mouseover.
	_G[CensusPlusSlider1:GetName() .. "Low"]:SetText("5") --Sets the left-side slider text (default is "Low").
	_G[CensusPlusSlider1:GetName() .. "High"]:SetText("30") --Sets the right-side slider text (default is "High").
	_G[CensusPlusSlider1:GetName() .. "Text"]:SetText(
		CENSUSPLUS_AUTOCENSUS_DELAYTIME
	) --Sets the "title" text (top-centre of slider).
	CensusPlusSlider1:Enable()

	--Create Frame Enable FinishSound
	CensusPlusCheckButton6 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton6",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton6:SetPoint(
		"TOPLEFT",
		CensusPlusSlider1,
		"BOTTOMLEFT",
		-68,
		-12
	)
	CensusPlusCheckButton6:SetScript("OnClick", function(self)
		local g_AW_FinishSound = CensusPlusCheckButton6:GetChecked()
		if g_AW_FinishSound then
			CensusPlus_Database["Info"]["PlayFinishSound"] = true
		else
			CensusPlus_Database["Info"]["PlayFinishSound"] = false
		end
		CensusPlus_FinishSound(self)
	end)
	CensusPlusCheckButton6Text:SetText(CENSUS_OPTIONS_SOUND_ON_COMPLETE)
	CensusPlusCheckButton6.tooltipText = CENSUS_OPTIONS_SOUND_TOOLTIP

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_FinishSound- enable)
	CensusPlusOptionsRadioButton_C6a =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C6a",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C6a:SetHeight(20)
	CensusPlusOptionsRadioButton_C6a:SetWidth(20)
	CensusPlusOptionsRadioButton_C6a:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C6a:ClearAllPoints()
	CensusPlusOptionsRadioButton_C6a:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton6,
		"TOPRIGHT",
		210,
		0
	)
	CensusPlusOptionsRadioButton_C6a:SetChecked(false)
	CensusPlusOptionsRadioButton_C6a:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C6a:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C6a:SetScript("OnClick", function(self)
		local g_CO_CPSound = CensusPlusOptionsRadioButton_C6a:GetChecked()
		if g_CO_CPSound then
			CensusPlusOptionsRadioButton_C6b:SetChecked(false)
			CensusPlusOptionsRadioButton_C6c:SetChecked(false)
			CensusPlus_PerCharInfo["PlayFinishSound"] = true
		elseif not CensusPlusOptionsRadioButton_C6b:GetChecked() then
			CensusPlusOptionsRadioButton_C6c:SetChecked(true)
			CensusPlus_PerCharInfo["PlayFinishSound"] = nil
		end
		CensusPlus_FinishSound(self)
	end)
	CensusPlusOptionsRadioButton_C6a.tooltipText = ENABLE

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_FinishSound - disable)
	CensusPlusOptionsRadioButton_C6b =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C6b",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C6b:SetHeight(20)
	CensusPlusOptionsRadioButton_C6b:SetWidth(20)
	CensusPlusOptionsRadioButton_C6b:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C6b:ClearAllPoints()
	CensusPlusOptionsRadioButton_C6b:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C6a,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C6b:SetChecked(false)
	CensusPlusOptionsRadioButton_C6b:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C6b:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C6b:SetScript("OnClick", function(self)
		local g_CO_CPSound = CensusPlusOptionsRadioButton_C6b:GetChecked()
		if g_CO_CPSound then
			CensusPlusOptionsRadioButton_C6a:SetChecked(false)
			CensusPlusOptionsRadioButton_C6c:SetChecked(false)
			CensusPlus_PerCharInfo["PlayFinishSound"] = false
		elseif not CensusPlusOptionsRadioButton_C6a:GetChecked() then
			CensusPlusOptionsRadioButton_C6c:SetChecked(true)
			CensusPlus_PerCharInfo["PlayFinishSound"] = nil
		end
		CensusPlus_FinishSound(self)
	end)
	CensusPlusOptionsRadioButton_C6b.tooltipText = DISABLE

	--Create Frame tri-selector button (CO - CENSUS_OPTIONS_FinishSound- remove)
	CensusPlusOptionsRadioButton_C6c =
		CreateFrame(
			"CheckButton",
			"CensusPlusOptionsRadioButton_C6c",
			CensusPlusOptions,
			"UIRadioButtonTemplate"
		)
	CensusPlusOptionsRadioButton_C6c:SetHeight(20)
	CensusPlusOptionsRadioButton_C6c:SetWidth(20)
	CensusPlusOptionsRadioButton_C6c:SetHitRectInsets(0, -5, 0, 0)
	CensusPlusOptionsRadioButton_C6c:ClearAllPoints()
	CensusPlusOptionsRadioButton_C6c:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsRadioButton_C6b,
		"TOPRIGHT",
		20,
		0
	)
	CensusPlusOptionsRadioButton_C6c:SetChecked(true)
	_G[CensusPlusOptionsRadioButton_C6c:GetName() .. "Text"]:SetText(
		CENSUS_OPTIONS_SOUND_ON_COMPLETE .. " " .. CENSUSPLUS_OPTIONS_OVERRIDE
	)
	CensusPlusOptionsRadioButton_C6c:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, self.tooltipOwnerPoint or "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
		end
		if self.tooltipRequirement then
			GameTooltip:AddLine(self.tooltipRequirement, 1.0, 1.0, 1.0, 1.0)
			GameTooltip:Show()
		end
	end)
	CensusPlusOptionsRadioButton_C6c:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	CensusPlusOptionsRadioButton_C6c:SetScript("OnClick", function(self)
		local g_CO_CPSound = CensusPlusOptionsRadioButton_C6c:GetChecked()
		if g_CO_CPSound then
			CensusPlusOptionsRadioButton_C6b:SetChecked(false)
			CensusPlusOptionsRadioButton_C6a:SetChecked(false)
			CensusPlus_PerCharInfo["PlayFinishSound"] = nil
		elseif not (CensusPlusOptionsRadioButton_C6a:GetChecked() or CensusPlusOptionsRadioButton_C6b:GetChecked()) then
			CensusPlusOptionsRadioButton_C6c:SetChecked(true)
			CensusPlus_PerCharInfo["PlayFinishSound"] = nil
		end
		CensusPlus_FinishSound(self)
	end)
	CensusPlusOptionsRadioButton_C6c.tooltipText =
		CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE

	--Create Frame SoundFilesHeader
	CensusPlusOptionsSoundFilesHeader =
		CensusPlusOptions:CreateFontString(nil, "ARTWORK")
	CensusPlusOptionsSoundFilesHeader:SetFontObject(GameFontWhite)
	CensusPlusOptionsSoundFilesHeader:SetJustifyH("LEFT")
	CensusPlusOptionsSoundFilesHeader:SetJustifyV("TOP")
	CensusPlusOptionsSoundFilesHeader:ClearAllPoints()
	CensusPlusOptionsSoundFilesHeader:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton6,
		"BOTTOMLEFT",
		120,
		-4
	)
	CensusPlusOptionsSoundFilesHeader:SetText(CENSUS_OPTIONS_SOUNDFILETEXT)

	--Create Frame SoundFile select1
	CensusPlusSoundFile1Button =
		CreateFrame(
			"Button",
			"CensusPlusSoundFile1Button",
			CensusPlusOptions,
			"UIPanelButtonTemplate"
		)
	CensusPlusSoundFile1Button:SetWidth(25)
	CensusPlusSoundFile1Button:SetHeight(25)
	CensusPlusSoundFile1Button:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsSoundFilesHeader,
		0,
		-15
	)
	CensusPlusSoundFile1Button:Enable()
	CensusPlusSoundFile1Button:SetText("1")
	CensusPlusSoundFile1Button:SetScript("OnClick", function(self)
		local willplay =
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete1.ogg",
				"Master"
			)
		if not willplay then
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete1.mp3",
				"Master"
			)
		end
		g_FinishSoundNumber = 1
		if CensusPlusOptionsRadioButton_C6a:GetChecked() then
			CensusPlus_PerCharInfo["SoundFile"] = g_FinishSoundNumber
		elseif CensusPlus_Database["Info"]["PlayFinishSound"] then
			CensusPlus_Database["Info"]["SoundFile"] = g_FinishSoundNumber
		end
	end)
	--CensusPlusSoundFile1Button:SetScript("OnMouseUp", function(self)
	--	PlaySoundFile("Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete1.ogg")
	--end)
	CensusPlusSoundFile1Button.tooltipText =
		CENSUS_OPTIONS_SOUNDFILEDEFAULT .. "1"

	--Create Frame SoundFile select2
	CensusPlusSoundFile2Button =
		CreateFrame(
			"Button",
			"CensusPlusSoundFile2Button",
			CensusPlusOptions,
			"UIPanelButtonTemplate"
		)
	CensusPlusSoundFile2Button:SetWidth(25)
	CensusPlusSoundFile2Button:SetHeight(25)
	CensusPlusSoundFile2Button:SetPoint(
		"TOPLEFT",
		CensusPlusSoundFile1Button,
		80,
		0
	)
	CensusPlusSoundFile2Button:Enable()
	CensusPlusSoundFile2Button:SetText("2")
	CensusPlusSoundFile2Button:SetScript("OnClick", function(self)
		local willplay =
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete2.ogg",
				"Master"
			)
		if not willplay then
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete2.mp3",
				"Master"
			)
		end
		g_FinishSoundNumber = 2
		if CensusPlusOptionsRadioButton_C6a:GetChecked() then
			CensusPlus_PerCharInfo["SoundFile"] = g_FinishSoundNumber
		elseif CensusPlus_Database["Info"]["PlayFinishSound"] then
			CensusPlus_Database["Info"]["SoundFile"] = g_FinishSoundNumber
		end
	end)
	--CensusPlusSoundFile2Button:SetScript("OnMouseUp", function(self)
	--	PlaySoundFile("Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete2.ogg")
	--end)
	CensusPlusSoundFile2Button.tooltipText =
		CENSUS_OPTIONS_SOUNDFILEDEFAULT .. "2"

	--Create Frame SoundFile select3
	CensusPlusSoundFile3Button =
		CreateFrame(
			"Button",
			"CensusPlusSoundFile2Button",
			CensusPlusOptions,
			"UIPanelButtonTemplate"
		)
	CensusPlusSoundFile3Button:SetWidth(25)
	CensusPlusSoundFile3Button:SetHeight(25)
	CensusPlusSoundFile3Button:SetPoint(
		"TOPLEFT",
		CensusPlusSoundFile2Button,
		80,
		0
	)
	CensusPlusSoundFile3Button:Enable()
	CensusPlusSoundFile3Button:SetText("3")
	CensusPlusSoundFile3Button:SetScript("OnClick", function(self)
		local willplay =
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete3.ogg",
				"Master"
			)
		if not willplay then
			PlaySoundFile(
				"Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete3.mp3",
				"Master"
			)
		end
		g_FinishSoundNumber = 3
		if CensusPlusOptionsRadioButton_C6a:GetChecked() then
			CensusPlus_PerCharInfo["SoundFile"] = g_FinishSoundNumber
		elseif CensusPlus_Database["Info"]["PlayFinishSound"] then
			CensusPlus_Database["Info"]["SoundFile"] = g_FinishSoundNumber
		end
	end)
	--CensusPlusSoundFile3Button:SetScript("OnMouseUp", function(self)
	--	PlaySoundFile("Interface\\AddOns\\CensusPlusClassic\\sounds\\CensusComplete3.ogg")
	--end)
	CensusPlusSoundFile3Button.tooltipText =
		CENSUS_OPTIONS_SOUNDFILEDEFAULT .. "3"

	--Create another frame..
	CensusPlusOptionsWMZ = CensusPlusOptions:CreateFontString(nil, "ARTWORK")
	CensusPlusOptionsWMZ:SetFontObject(GameFontWhite)
	CensusPlusOptionsWMZ:SetJustifyH("LEFT")
	CensusPlusOptionsWMZ:SetJustifyV("TOP")
	CensusPlusOptionsWMZ:ClearAllPoints()
	CensusPlusOptionsWMZ:SetPoint(
		"TOPLEFT",
		CensusPlusSoundFile1Button,
		"BOTTOMLEFT",
		-120,
		-4
	)
	CensusPlusOptionsWMZ:SetText(CENSUSPLUS_ACCOUNT_WIDE_ONLY_OPTIONS)

	--Create Frame Logarithmic  bars
	CensusPlusCheckButton7 =
		CreateFrame(
			"CheckButton",
			"CensusPlusCheckButton7",
			CensusPlusOptions,
			"OptionsCheckButtonTemplate"
		)
	CensusPlusCheckButton7:SetPoint(
		"TOPLEFT",
		CensusPlusOptionsWMZ,
		"BOTTOMLEFT",
		0,
		-6
	)
	CensusPlusCheckButton7:SetChecked(true)
	CensusPlusCheckButton7:SetScript("OnClick", function(self)
		local g_AW_LogBars = CensusPlusCheckButton7:GetChecked()
		if g_AW_LogBars then
			CensusPlus_Database["Info"]["UseLogBars"] = true
		else
			CensusPlus_Database["Info"]["UseLogBars"] = false
		end
		--CensusPlus_FinishSound(self)
	end)
	CensusPlusCheckButton7Text:SetText(CENSUS_OPTIONS_LOG_BARS) --
	CensusPlusCheckButton7.tooltipText = CENSUS_OPTIONS_LOG_BARSTEXT

	--Create CensusPlusClassic.Background:alpha Slider
	local g_CPWin_background_alpha = 0.5
	CensusPlusSlider2 =
		CreateFrame(
			"Slider",
			"CensusPlusSlider2",
			CensusPlusOptions,
			"OptionsSliderTemplate"
		)
	CensusPlusSlider2:SetWidth(100)
	CensusPlusSlider2:SetHeight(20)
	CensusPlusSlider2:SetOrientation("HORIZONTAL")
	CensusPlusSlider2:SetMinMaxValues(0.1, 1.0)
	CensusPlusSlider2:SetObeyStepOnDrag(true)
	CensusPlusSlider2:SetValueStep(0.1)
	CensusPlusSlider2:SetValue(0.5)
	CensusPlusSlider2:SetThumbTexture(
		"Interface\\Buttons\\UI-SliderBar-Button-Horizontal"
	)
	CensusPlusSlider2:SetPoint(
		"TOPLEFT",
		CensusPlusCheckButton7,
		"BOTTOMLEFT",
		48,
		-15
	)
	CensusPlusSlider2:SetScript("OnValueChanged", function(self, value)
		g_CPWin_background_alpha = CensusPlusSlider2:GetValue()
	end)
	CensusPlusSlider2:SetScript("OnMouseUp", function(self, value)
		CensusPlus_BackgroundAlpha(self, g_CPWin_background_alpha)
		CensusPlusBackground:SetAlpha(g_CPWin_background_alpha)
		CensusPlayerListBackground:SetAlpha(g_CPWin_background_alpha)
	end)
	CensusPlusSlider2.tooltipText =
		CENSUS_OPTIONS_BACKGROUND_TRANSPARENCY_TOOLTIP --Creates a tooltip on mouseover.
	_G[CensusPlusSlider2:GetName() .. "Low"]:SetText("0.1") --Sets the left-side slider text (default is "Low").
	_G[CensusPlusSlider2:GetName() .. "High"]:SetText("1.0") --Sets the right-side slider text (default is "High").
	_G[CensusPlusSlider2:GetName() .. "Text"]:SetText(CENSUSPLUS_TRANSPARENCY) --Sets the "title" text (top-centre of slider).
	CensusPlusSlider2:Enable()

end

function CensusPlus_ResetConfig() -- reset to defaults
	CensusPlus_Database["Info"]["AutoCensus"] = true
	CensusPlus_PerCharInfo["AutoCensus"] = nil
	CensusPlus_Database["Info"]["Verbose"] = false
	CensusPlus_PerCharInfo["Verbose"] = nil
	CensusPlus_Database["Info"]["Stealth"] = false
	CensusPlus_PerCharInfo["Stealth"] = nil
	CensusPlus_Database["Info"]["PlayFinishSound"] = false
	CensusPlus_PerCharInfo["PlayFinishSound"] = nil
	CensusPlus_Database["Info"]["SoundFile"] = 1
	CensusPlus_PerCharInfo["SoundFile"] = 1
	CensusPlus_Database["Info"]["AutoCensusTimer"] = 1800
	CensusPlus_PerCharInfo["AutoCensusTimer"] = 1800
	CensusPlus_Database["Info"]["CensusButtonShown"] = true
	CensusPlus_PerCharInfo["CensusButtonShown"] = nil
	CensusPlus_Database["Info"]["CensusButtonAnimi"] = true
	CensusPlus_PerCharInfo["CensusButtonAnimi"] = nil
	CensusPlus_Database["Info"]["CPWindow_Transparency"] = 0.5
	CensusPlus_Database["Info"]["UseLogBars"] = true
	print("ResetConfig")
	CensusPlusSetCheckButtonState()
end

function CensusPlusSetCheckButtonState() -- set option check buttons and radio button states to match existing saved variables both AW and CCO - populate backup options tables
	CensusPlusCheckButton1:SetChecked(CensusPlus_Database["Info"]["Verbose"])
	CPp.Options_Holder["AccountWide"]["Verbose"] =
		CensusPlus_Database["Info"]["Verbose"]
	CPp.Options_Holder["CCOverrides"]["Verbose"] =
		CensusPlus_PerCharInfo["Verbose"]
	if (CensusPlus_PerCharInfo["Verbose"] == nil) then
		CensusPlusOptionsRadioButton_C1a:SetChecked(false)
		CensusPlusOptionsRadioButton_C1b:SetChecked(false)
		CensusPlusOptionsRadioButton_C1c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["Verbose"] == true) then
		CensusPlusOptionsRadioButton_C1a:SetChecked(true)
		CensusPlusOptionsRadioButton_C1b:SetChecked(false)
		CensusPlusOptionsRadioButton_C1c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C1a:SetChecked(false)
		CensusPlusOptionsRadioButton_C1b:SetChecked(true)
		CensusPlusOptionsRadioButton_C1c:SetChecked(false)
	end
	CensusPlus_Verbose(self)

	CensusPlusCheckButton2:SetChecked(CensusPlus_Database["Info"]["Stealth"])
	CPp.Options_Holder["AccountWide"]["Stealth"] =
		CensusPlus_Database["Info"]["Stealth"]
	CPp.Options_Holder["CCOverrides"]["Stealth"] =
		CensusPlus_PerCharInfo["Stealth"]
	if (CensusPlus_PerCharInfo["Stealth"] == nil) then
		CensusPlusOptionsRadioButton_C2a:SetChecked(false)
		CensusPlusOptionsRadioButton_C2b:SetChecked(false)
		CensusPlusOptionsRadioButton_C2c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["Stealth"] == true) then
		CensusPlusOptionsRadioButton_C2a:SetChecked(true)
		CensusPlusOptionsRadioButton_C2b:SetChecked(false)
		CensusPlusOptionsRadioButton_C2c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C2a:SetChecked(false)
		CensusPlusOptionsRadioButton_C2b:SetChecked(true)
		CensusPlusOptionsRadioButton_C2c:SetChecked(false)
	end
	CensusPlus_Stealth(self)

	CensusPlusCheckButton3:SetChecked(
		CensusPlus_Database["Info"]["CensusButtonShown"]
	)
	CPp.Options_Holder["AccountWide"]["CensusButtonShown"] =
		CensusPlus_Database["Info"]["CensusButtonShown"]
	CPp.Options_Holder["CCOverrides"]["CensusButtonShown"] =
		CensusPlus_PerCharInfo["CensusButtonShown"]
	if (CensusPlus_PerCharInfo["CensusButtonShown"] == nil) then
		CensusPlusOptionsRadioButton_C3a:SetChecked(false)
		CensusPlusOptionsRadioButton_C3b:SetChecked(false)
		CensusPlusOptionsRadioButton_C3c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["CensusButtonShown"] == true) then
		CensusPlusOptionsRadioButton_C3a:SetChecked(true)
		CensusPlusOptionsRadioButton_C3b:SetChecked(false)
		CensusPlusOptionsRadioButton_C3c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C3a:SetChecked(false)
		CensusPlusOptionsRadioButton_C3b:SetChecked(true)
		CensusPlusOptionsRadioButton_C3c:SetChecked(false)
	end
	CensusPlus_CensusButtonShown(self)

	CensusPlusCheckButton4:SetChecked(
		CensusPlus_Database["Info"]["CensusButtonAnimi"]
	)
	CPp.Options_Holder["AccountWide"]["CensusButtonAnimi"] =
		CensusPlus_Database["Info"]["CensusButtonAnimi"]
	CPp.Options_Holder["CCOverrides"]["CensusButtonAnimi"] =
		CensusPlus_PerCharInfo["CensusButtonAnimi"]
	if (CensusPlus_PerCharInfo["CensusButtonAnimi"] == nil) then
		CensusPlusOptionsRadioButton_C4a:SetChecked(false)
		CensusPlusOptionsRadioButton_C4b:SetChecked(false)
		CensusPlusOptionsRadioButton_C4c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["CensusButtonAnimi"] == true) then
		CensusPlusOptionsRadioButton_C4a:SetChecked(true)
		CensusPlusOptionsRadioButton_C4b:SetChecked(false)
		CensusPlusOptionsRadioButton_C4c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C4a:SetChecked(false)
		CensusPlusOptionsRadioButton_C4b:SetChecked(true)
		CensusPlusOptionsRadioButton_C4c:SetChecked(false)
	end
	CensusPlus_CensusButtonAnimi(self)

	CensusPlusCheckButton5:SetChecked(CensusPlus_Database["Info"]["AutoCensus"])
	CPp.Options_Holder["AccountWide"]["AutoCensus"] =
		CensusPlus_Database["Info"]["AutoCensus"]
	CPp.Options_Holder["CCOverrides"]["AutoCensus"] =
		CensusPlus_PerCharInfo["AutoCensus"]
	if (CensusPlus_PerCharInfo["AutoCensus"] == nil) then
		CensusPlusOptionsRadioButton_C5a:SetChecked(false)
		CensusPlusOptionsRadioButton_C5b:SetChecked(false)
		CensusPlusOptionsRadioButton_C5c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["AutoCensus"] == true) then
		CensusPlusOptionsRadioButton_C5a:SetChecked(true)
		CensusPlusOptionsRadioButton_C5b:SetChecked(false)
		CensusPlusOptionsRadioButton_C5c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C5a:SetChecked(false)
		CensusPlusOptionsRadioButton_C5b:SetChecked(true)
		CensusPlusOptionsRadioButton_C5c:SetChecked(false)
	end
	CensusPlus_SetAutoCensus(self)

	if (CensusPlus_PerCharInfo["AutoCensus"] == true) then
		CensusPlusSlider1:SetValue(
			CensusPlus_PerCharInfo["AutoCensusTimer"] / 60
		)
		CPp.Options_Holder["CCOverrides"]["AutoCensusTimer"] =
			CensusPlus_PerCharInfo["AutoCensusTimer"]
		CPp.AutoStartTimer = CensusPlus_PerCharInfo["AutoCensusTimer"] / 60
	end
	if ((CensusPlus_PerCharInfo["AutoCensus"] == nil) and (CensusPlus_Database["Info"]["AutoCensus"] == true)) then
		CensusPlusSlider1:SetValue(
			CensusPlus_Database["Info"]["AutoCensusTimer"] / 60
		)
		CPp.Options_Holder["AccountWide"]["AutoCensusTimer"] =
			CensusPlus_Database["Info"]["AutoCensusTimer"]
		CPp.AutoStartTimer = CensusPlus_Database["Info"]["AutoCensusTimer"] / 60
	end
	if ((CensusPlus_Database["Info"]["AutoCensus"] == false) and not (CensusPlus_PerCharInfo["AutoCensus"] == true)) then
		CensusPlusSlider1:SetValue(30)
	end

	CensusPlusSlider2:SetValue(
		CensusPlus_Database["Info"]["CPWindow_Transparency"]
	)
	CPp.Options_Holder["AccountWide"]["CPWindow_Transparency"] =
		CensusPlus_Database["Info"]["CPWindow_Transparency"]
	CensusPlusBackground:SetAlpha(
		CensusPlus_Database["Info"]["CPWindow_Transparency"]
	)
	CensusPlayerListBackground:SetAlpha(
		CensusPlus_Database["Info"]["CPWindow_Transparency"]
	)

	CensusPlusCheckButton6:SetChecked(
		CensusPlus_Database["Info"]["PlayFinishSound"]
	)
	CPp.Options_Holder["AccountWide"]["PlayFinishSound"] =
		CensusPlus_Database["Info"]["PlayFinishSound"]
	CPp.Options_Holder["CCOverrides"]["PlayFinishSound"] =
		CensusPlus_PerCharInfo["PlayFinishSound"]
	if (CensusPlus_PerCharInfo["PlayFinishSound"] == nil) then
		CensusPlusOptionsRadioButton_C6a:SetChecked(false)
		CensusPlusOptionsRadioButton_C6b:SetChecked(false)
		CensusPlusOptionsRadioButton_C6c:SetChecked(true)
	elseif (CensusPlus_PerCharInfo["PlayFinishSound"] == true) then
		CensusPlusOptionsRadioButton_C6a:SetChecked(true)
		CensusPlusOptionsRadioButton_C6b:SetChecked(false)
		CensusPlusOptionsRadioButton_C6c:SetChecked(false)
	else
		CensusPlusOptionsRadioButton_C6a:SetChecked(false)
		CensusPlusOptionsRadioButton_C6b:SetChecked(true)
		CensusPlusOptionsRadioButton_C6c:SetChecked(false)
	end

	CPp.Options_Holder["AccountWide"]["SoundFile"] =
		CensusPlus_Database["Info"]["SoundFile"]
	CPp.Options_Holder["CCOverrides"]["SoundFile"] =
		CensusPlus_PerCharInfo["SoundFile"]

	CPp.Options_Holder["AccountWide"]["UseLogBars"] =
		CensusPlus_Database["Info"]["UseLogBars"]
	CensusPlusCheckButton7:SetChecked(CensusPlus_Database["Info"]["UseLogBars"])
	g_AW_LogBars = CensusPlus_Database["Info"]["UseLogBars"]
	
	--	CensusPlusCheckButton8:SetChecked(CensusPlus2["WMZ party4"])
	--	CensusPlusCheckButton9:SetChecked(CensusPlus2["show decimals"])
end

function CensusPlusRestoreSettings() -- reset any changes to saved settings back to previous saved in backups
	-- account wide and CCO overrides
	CensusPlus_Database["Info"]["Verbose"] =
		CPp.Options_Holder["AccountWide"]["Verbose"]
	CensusPlus_PerCharInfo["Verbose"] =
		CPp.Options_Holder["CCOverrides"]["Verbose"]
	CensusPlus_Database["Info"]["Stealth"] =
		CPp.Options_Holder["AccountWide"]["Stealth"]
	CensusPlus_PerCharInfo["Stealth"] =
		CPp.Options_Holder["CCOverrides"]["Stealth"]
	CensusPlus_Database["Info"]["CensusButtonShown"] =
		CPp.Options_Holder["AccountWide"]["CensusButtonShown"]
	CensusPlus_PerCharInfo["CensusButtonShown"] =
		CPp.Options_Holder["CCOverrides"]["CensusButtonShown"]
	CensusPlus_Database["Info"]["CensusButtonAnimi"] =
		CPp.Options_Holder["AccountWide"]["CensusButtonAnimi"]
	CensusPlus_PerCharInfo["CensusButtonAnimi"] =
		CPp.Options_Holder["CCOverrides"]["CensusButtonAnimi"]
	CensusPlus_Database["Info"]["AutoCensus"] =
		CPp.Options_Holder["AccountWide"]["AutoCensus"]
	CensusPlus_PerCharInfo["AutoCensus"] =
		CPp.Options_Holder["CCOverrides"]["AutoCensus"]
	CensusPlus_Database["Info"]["AutoCensusTimer"] =
		CPp.Options_Holder["AccountWide"]["AutoCensusTimer"]
	CensusPlus_PerCharInfo["AutoCensusTimer"] =
		CPp.Options_Holder["CCOverrides"]["AutoCensusTimer"]
	CensusPlus_Database["Info"]["PlayFinishSound"] =
		CPp.Options_Holder["AccountWide"]["PlayFinishSound"]
	CensusPlus_PerCharInfo["PlayFinishSound"] =
		CPp.Options_Holder["CCOverrides"]["PlayFinishSound"]
	CensusPlus_Database["Info"]["SoundFile"] =
		CPp.Options_Holder["AccountWide"]["SoundFile"]
	CensusPlus_PerCharInfo["SoundFile"] =
		CPp.Options_Holder["CCOverrides"]["SoundFile"]
	-- account wide only
	CensusPlus_Database["Info"]["CPWindow_Transparency"] =
		CPp.Options_Holder["AccountWide"]["CPWindow_Transparency"]
	CensusPlus_Database["Info"]["UseLogBars"] =
		CPp.Options_Holder["AccountWide"]["UseLogBars"]
	CensusPlusCloseOptions()
end

function CensusPlusCloseOptions() -- reset Interface Options frame to Blizzard default CONTROLS_LABEL =='Game.Controls'
	InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL)
end