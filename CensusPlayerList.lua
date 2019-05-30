--[[
	CensusPlus for World of Warcraft(tm).
	
	Copyright 2005 - 2006 Cooper Sellers and WarcraftRealms.com

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
]]


------------------------------------------------------------------------------------
--
-- CensusPlus
-- A WoW UI customization by Cooper Sellers
--
--
------------------------------------------------------------------------------------
local	addon_name, addon_tableID = ...   -- Addon_name contains the Addon name which must be the same as the container folder name... addon_tableID is a common private table for all .lua files in the directory.
--print("list")
--print (addon_name)
--print (addon_tableID) 
local CPp = addon_tableID  --short cut name for private shared table.

local g_PlayerList = {}		
local g_PlayerLookupTable = {}
local CensusPlus_NumPlayerButtons = 20
local g_MaxNumListed = 1000
local CPL_profiling_timerstart = 0
local CPL_profiling_timediff = 0	
local Name_Realm = nil
local Char_List = nil
local LogonrealmName = CPp.CensusPlusLocale .. GetRealmName()
	
function CensusPlus_ShowPlayerList()
	CP_PlayerListWindow:Show();
end

function CensusPlus_PlayerListOnShow() -- referenced by CensusPlayerList.xml

--CPL_profiling_timerstart =	debugprofilestop();
	
	local realmKey = nil;
	local guildKey = nil;
	local raceKey = nil;
	local classKey = nil;
	local levelKey = nil;
	local guildRealmKey = nil;

	--
	--  Clear our character list
	--
	CensusPlus_ClearPlayerList();
	Char_List = nil;
	--
	-- Verify Logon realm
	--
		if( LogonrealmName == nil ) then
		return; 
	end


	--
	-- Get faction
	--

	local factionGroup = UnitFactionGroup("player");
	if( factionGroup == nil or factionGroup == "Neutral" ) then
		return;
	end
	
	--
	-- Has user selected a realm
	--
	if (CPp.ConnectedRealmsButton ~= 0) then
		realmKey = CPp.VRealms[CPp.ConnectedRealmsButton]
		Char_List = 2
	else
		Char_List = 1
--		print("realmKey = "..realmKey)
	end

	--
	-- Has the user made any selections?
	--
	if ((CPp.ConnectedRealmsButton ~= 0) and (CPp.GuildSelected ~= nil )) then 
		guildKey = CPp.GuildSelected
		guildRealmKey = CPp.VRealms[CPp.ConnectedRealmsButton]
		Char_List = 3		
	else
		guildKey = nil
		guildRealmKey = nil;
	end
	
	if (CPp.RaceSelected > 0) then
		local thisFactionRaces = CensusPlus_GetFactionRaces(factionGroup);
		raceKey = thisFactionRaces[CPp.RaceSelected];
	end
	
	if (CPp.ClassSelected > 0) then
		local thisFactionClasses = CensusPlus_GetFactionClasses(factionGroup);
		classKey = thisFactionClasses[CPp.ClassSelected];
	end
	
	if (CPp.LevelSelected > 0 or CPp.LevelSelected < 0) then
		levelKey = CPp.LevelSelected;
	end

--	CPL_profiling_timerstart =debugprofilestop();

	if (CPp.GuildSelected ~= nil) then
		local conmemcount = #CPp.VRealms
		for i = 1,conmemcount,1 do
			if ((CPp.VRealms[i] ~= nil) and (CPp.VRealms[i] ~= "")) then
				realmName = CPp.VRealms[i];
				CensusPlus_ForAllCharacters(realmName, factionGroup, raceKey, classKey, guildKey, levelKey, guildRealmKey, CensusPlus_AddPlayerToList);
			end
		end
		local size = #g_PlayerList
--		print ("guildkeyed playerlist size = "..size)
	else
		if (CPp.ConnectedRealmsButton ~= 0) then
			CensusPlus_ForAllCharacters( realmKey, factionGroup, raceKey, classKey, nil, levelKey,nil, CensusPlus_AddPlayerToList);
			local size = #g_PlayerList
--			print("non-guild realm selected playerlist size = "..size)
		else
			local conmemcount = #CPp.VRealms
			for i = 1,conmemcount,1 do
				if ((CPp.VRealms[i] ~= nil) and (CPp.VRealms[i] ~= "")) then
					realmName = CPp.VRealms[i];
					CensusPlus_ForAllCharacters(realmName, factionGroup, raceKey, classKey, nil, levelKey, nil, CensusPlus_AddPlayerToList);
				end
			end
			local size = #g_PlayerList
--			print ("superset size = "..size)
		end
	end	
	if( CPp.EnableProfiling ) then
		CPL_profiling_timerdiff = debugprofilestop() - CPL_profiling_timerstart
		print( "PROFILE: Time to do calcs 1 " .. CP_profiling_timerdiff / 1000000000 );
--CPL_profiling_timerstart =	debugprofilestop();
	end
		

	--
	--  Build our list
	--
	CensusPlus_UpdatePlayerListButtons();
	
	local totalCharactersText = format(CENSUSPLUS_TOTALCHAR, #g_PlayerList );
	if( #g_PlayerList == g_MaxNumListed ) then
		totalCharactersText = totalCharactersText .. " -- " .. CENSUSPLUS_MAXXED;
	end
	
	CensusPlayerListCount:SetText(totalCharactersText);

end

----------------------------------------------------------------------------------
--
-- Predicate function which can be used to compare two characters for sorting
--
---------------------------------------------------------------------------------
local function CharacterPredicate(lhs, rhs)
	--
	-- nil references are always less than
	--
	if (lhs == nil) then
		if (rhs == nil) then
			return false;
		else
			return true;
		end
	elseif (rhs == nil) then
		return false;
	end
	--
	-- Sort by name -- this sorting does occur true and false.
	--
	if (lhs.m_name < rhs.m_name) then
		return true;
	elseif (rhs.m_name < lhs.m_name) then
		return false;
	end

	--
	-- Sort by level  -- by test this next section never gets used
	--
	if (lhs.m_level < rhs.m_level) then
		return true;
	elseif (rhs.m_level < lhs.m_level) then
		return false;
	end

	--
	-- identical
	--
	return false;
end

-- local function CensusPlus_UpdatePlayerLookup( index, entry )
	--
	--  Have to update our table
	--
--	g_PlayerLookupTable[entry.m_name] = index;
-- end
		


----------------------------------------------------------------------------------
--
-- Update the Player button contents
--
---------------------------------------------------------------------------------
function CensusPlus_UpdatePlayerListButtons()
	--
	--  Sort the list
	--
	local size = #g_PlayerList
--	print("size "..size)
	local LUname = nil
	local LUrealm = nil
	if (size) then
		table.sort(g_PlayerList, CharacterPredicate);
--		print("sorted")
--		table.foreach(g_PlayerList, CensusPlus_UpdatePlayerLookup )  -- note: .foreach is deprecated in Lua 5.1 (still works for now)
		for index,entry in pairs (g_PlayerList) do
--			print(index.."   "..entry.m_name)
			LUname = g_PlayerList[entry.m_name]
			LUrealm = g_PlayerList[entry.m_realm]
--			if (LUrealm == nil) then
--				LUrealm = LogonrealmName
--			end
			if ((LUname ~= nil) and (LUrealm ~= nil)) then
				Name_Realm =LUname.."-"..LUrealm
				g_PlayerLookupTable[Name_Realm] = index;
			
			end
		end
--		print("Lookup table built")
	end
	
	--
	-- Determine where the scroll bar is
	--
	local offset = FauxScrollFrame_GetOffset( CensusPlusPlayerListScrollFrame );
--	print("offset "..offset)
	--
	-- Walk through all the rows in the frame
	--
	local i = 1;
	while( i <= CensusPlus_NumPlayerButtons ) do
		--
		-- Get the index to the ad displayed in this row
		--
		local iPlayer = i + offset;
		--
		-- Get the button on this row
		--
		local button = _G["CensusPlusPlayerButton"..i];
		--
		-- Is there a valid Player on this row?
		--
		if (iPlayer <= size) then
			local player = g_PlayerList[iPlayer];
--			print(iPlayer.." "..player.m_name)
			--
			-- Update the button text
			--
			button:Show();
			local textField = "CensusPlusPlayerButton"..i.."Name";
			if ( player.m_name == nil or player.m_name == "") then
				_G[textField]:SetText( "NONE" );
			else
				_G[textField]:SetText( player.m_name );
			end
			
			local textField = "CensusPlusPlayerButton"..i.."Level";
			if ( player.m_level == nil or player.m_level == "") then
				_G[textField]:SetText( "n/a" );
			else
				_G[textField]:SetText( player.m_level );
			end
			
			local textField = "CensusPlusPlayerButton"..i.."Class";
			if (Char_List == 1) or (Char_List == 3) then -- display characters realm and last seen
				CensusPlayerListCol3:SetText(CENSUSPLUS_REALM)
				if (( player.m_realm == nil) or (player.m_realm == "")) then
					_G[textField]:SetText( "Realm Bad!!" );
				else
					_G[textField]:SetText( player.m_realm );
				end
            else -- display Guild and GuildRealm
				CensusPlayerListCol3:SetText(GUILD)
				if ( (player.m_guild == nil) or (player.m_guild == "")) then
					_G[textField]:SetText( "Unguilded" );
				else
					_G[textField]:SetText( player.m_guild );
				end
			end
			
			local textField = "CensusPlusPlayerButton"..i.."Seen";
			if ((Char_List == 1) or (Char_List == 3)) then -- display characters realm and last seen			
				CensusPlayerListCol4:SetText(CENSUSPLUS_LASTSEEN)
				if ( (player.m_seen == nil) or (player.m_seen == "")) then
					_G[textField]:SetText( "UNKNOWN" );
				else
					_G[textField]:SetText( player.m_seen );
				end
            else -- display Guild and GuildRealm
				CensusPlayerListCol4:SetText(CENSUSPLUS_GUILDREALM)
				if (( player.m_guildRealm == nil) or (player.guildRealm == "")) then
					_G[textField]:SetText( "Realm Bad!!" );
				else
					_G[textField]:SetText( player.m_guildRealm );
				end
			end
		else
			--
			-- Hide the button
			--
			button:Hide();
		end
		--
		-- Next row
		--
		i = i + 1;
	end
	--
	-- Update the scroll bar
	--
	FauxScrollFrame_Update(CensusPlusPlayerListScrollFrame, size, CensusPlus_NumPlayerButtons, CensusPlus_GUILDBUTTONSIZEY);
end

----------------------------------------------------------------------------------
--
-- Find a characters in the g_PlayerList array by name
--
---------------------------------------------------------------------------------
function CensusPlus_PlayerButton_OnClick(self, button, down) -- referenced by CensusPlayerList.xml
	local id = self:GetID();
	local offset = FauxScrollFrame_GetOffset( CensusPlusPlayerListScrollFrame );
	local newSelection = id + offset;

	local player = g_PlayerList[newSelection];
	FriendsFrame_ShowDropdown(player.m_name, 1);
end

----------------------------------------------------------------------------------
--
-- Clear all the characters
--
---------------------------------------------------------------------------------
function CensusPlus_ClearPlayerList()
	g_PlayerList = nil;
	g_PlayerList = {};
	
	g_PlayerLookupTable = nil;
	g_PlayerLookupTable = {};
end

----------------------------------------------------------------------------------
--
-- Add a character to the list
--
---------------------------------------------------------------------------------
function CensusPlus_AddPlayerToList( name, level, guild,raceName,className,lastseen, realmName, guildRealm)
--	print("addPlayertoList")
	local size = #g_PlayerList
--	print(name.." ".. level.." ".. guild.." "..realmName.." "..guildRealm.." "..raceName.." "..className.." "..lastseen)	
	if( size >= g_MaxNumListed ) then
		return;
	end
	Name_Realm = name.."-"..realmName
	local index = g_PlayerLookupTable[Name_Realm];
	if (index == nil) then
		local size = #g_PlayerList
		index = size + 1;
		g_PlayerList[index] = { m_name = name, m_level = level, m_guild = guild, m_realm = realmName, m_guildRealm = guildRealm, m_seen = lastseen}; -- add?? m_realm = guild_realm???
		g_PlayerLookupTable[Name_Realm] = index;
	end
end

function CensusPlus_List_OnMouseDown( self, button ) -- referenced by CensusPlayerList.xml
	if ( ( ( not self.isLocked ) or ( self.isLocked == 0 ) ) and ( button == "LeftButton" ) ) then
		self:StartMoving();
		self.isMoving = true;
	end
end
