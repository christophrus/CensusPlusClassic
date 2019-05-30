--[[--------------------------------------------------------------------
	LibReamID a fork by bringoutyourdead@warcraftrealms.com from
	LibRealmInfo
	World of Warcraft library for obtaining information about realms.
	Copyright 2014 Phanx <addons@phanx.net>
	Do not distribute as a standalone addon.
	See accompanying LICENSE and README files for more details.
	https://github.com/Phanx/LibRealmInfo
	http://wow.curseforge.com/addons/librealminfo
	http://www.wowinterface.com/downloads/info22987-LibRealmInfo
----------------------------------------------------------------------]]

--[[
reason for fork
LibRealmInfo wouldn't work for me due to the following reasons:
ServerIDs from Character Transfer page didn't match actual ServerID in game and were found to be non-unique.
realmID must be unique. to create this I concatenate ServerID-RealmName

problems found with LibRealmInfo
strmatch used incorrect match phrase.. Player:  actual is Player-  but both were found not needed as we only needed %d+

The 3 functions of LibRealmInfo had issues when compared to the GitHub documentation
lib:GetRealmInfoByUnit(unit) returns via lib:GetRealmInfo(realmID)  problem is later function drops first return item from former.

Since the key for table data was based upon an unfortunately incorrect assumption the keys for all line items had to be updated.
and since the key went from numeric to text other changes had to be made in coding.

table connections was found to be redundant.. since it was found that all Connected Realms were in reality merged realms each on a unique ServerID

lib:GetRealmInfoByName(searchName, searchRegion) has not been fully modified and is not useful at this time. 
Blizzards API GetCurrentRegion() appears to be nothing more then an alias for GetCVar("portal") which only says which region client you installed.
The local replacement function fails due to non-unique key generation.
]]

local MAJOR, MINOR = "LibRealmID", 1
assert(LibStub, MAJOR.." requires LibStub")
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local standalone = (...) == MAJOR
local data, connections
local Unpack

local function debug(...)
	if standalone then
		print("|cffff7f7f["..MAJOR.."]|r", ...)
	end
end

------------------------------------------------------------------------

function lib:GetRealmInfo(realmID)
--	realmID = tonumber(realmID)
	if not realmID then return end
	if Unpack then
		Unpack()
	end

	local info = data[realmID]
	if info then
		return realmID, info.name, info.apiName, info.rules, info.locale, info.battlegroup, info.region, info.timezone, info.connected, info.latinName
	end

	debug("No info found for realm", realmID)
end

------------------------------------------------------------------------

local currentRegion
local portalToRegion = { US = "US", EU = "EU", RU = "EU", KR = "KR", CN = "CN", TW = "TW" }
local localeToRegion = { deDE = "EU", esES = "EU", esMX = "US", frFR = "EU", itIT = "EU", ruRU = "EU", koKR = "KR", enCN = "CN", zhCN = "CN", enTW = "TW", zhTW = "TW" }
-- enGB client returns enUS, ptPT client returns ptBR, no way to tell what's what
-- not actually sure if enCN and enTW return accurately

local function GetCurrentRegion()
	if not currentRegion then
		local realmID, _ = (strmatch(UnitGUID("player"), "(%d+)"))
		if not realmID then
			_, _, _, _, realmID = BNGetToonInfo(BNGetInfo() or 1)
		end
		if realmID then
			_, _, _, _, _, currentRegion = lib:GetRealmInfo(realmID)
		end
		if not currentRegion then
			local portal = GetCVar("portal")
			if portal then
				currentRegion = portalToRegion[strupper(portal)]
			else
				currentRegion = localeToRegion[GetLocale()]
			end
		end
		if not currentRegion then
			return debug("Could not determine current region.")
		end
	end
	return currentRegion
end

function lib:GetRealmInfoByName(searchName, searchRegion)
	searchName = gsub(searchName, "%s", "")
	searchRegion = searchRegion or GetCurrentRegion()
	debug("GetRealmInfoByName", searchName, searchRegion, GetCurrentRegion())

	if Unpack then
		Unpack()
	end

	for id, info in pairs(data) do
		if info.region == searchRegion and info.apiName == searchName then
			return id, info.name, info.apiName, info.rules, info.locale, info.battlegroup, info.region, info.timezone, info.connected, info.latinName
		end
	end
end

------------------------------------------------------------------------

function lib:GetRealmInfoByUnit(unit)
	local guid = unit and UnitGUID(unit)

	if guid then

		local realmID = (strmatch(guid,"%d+" ))  --
		realmID = realmID.."-"..GetRealmName()

		if realmID then
			return self:GetRealmInfo(realmID)
		end
	end
end

------------------------------------------------------------------------

function Unpack()
	debug("Unpacking data...")

	for id, info in pairs(data) do
		local name, rules, locale, battlegroup, region, timezone = strsplit(",", info)
		local name, translit = strsplit("|", name)
--		local ConnectID = tonumber(id)  -- not here
		data[id] = {
--			realmID = id,
			name = name,
			apiName = (gsub(name, "%s", "")),
			latinName = translit, -- only for ruRU language realms
			rules = rules,
			locale = locale,
			battlegroup = battlegroup,
			region = region,
			timezone = timezone, -- only for US region realms -- not really true all EU are set to CET
		}
	end
--[[  -- do tonumber of realmID and use that in walk through data.. return count of realms as Connected .. don't need connections table.
	for i = 1, #connections do
		local t = { strsplit(",", connections[i]) }
		for j = 1, #t do
			local id = tonumber(t[j])
			t[j] = id
			local info = data[id]
			if info then
				info.connected = t
			elseif standalone then
				print("|cffff7f7f["..MAJOR.."]|r No data for connected realm", id, "from", connections[i])
			end
		end
	end
--]]
	connections = nil
	Unpack = nil
	collectgarbage()

	debug("Done unpacking data.")

	--[[
	local auto = { GetAutoCompleteRealms() }
	if #auto > 1 then
		local id, _, _, _, _, _, _, _, connected = lib:GetRealmInfoByName(GetRealmName())
		if not id then
			return
		end
		if not connected then
			print("|cffffff7fLibRealmInfo:|r Missing connected realm info for", id, GetRealmName())
			return
		end
		for i = 1, #auto do
			local name = auto[i]
			auto[name] = true
			auto[i] = nil
		end
		for i = 1, #connected do
			local _, name = GetRealmInfo(connected[i])
			if auto[name] then
				auto[name] = nil
			else
				auto[name] = connected[i]
			end
		end
		if next(auto) then
			print("|cffffff7fLibRealmInfo:|r Incomplete connected realm info for", id, GetRealmName())
			for name, id in pairs(auto) do
				print(name, id == true and "MISSING" or "INCORRECT")
			end
		end
	end
	--]]
end

------------------------------------------------------------------------

data = {
--{{ NORTH AMERICA
["1136-Aegwynn"]="Aegwynn,PVP,enUS,Vengeance,US,CST",
["1426-Aerie Peak"]="Aerie Peak,PVE,enUS,Vindication,US,PST",
["1129-Agamaggan"]="Agamaggan,PVP,enUS,Shadowburn,US,CST",
["106-Aggramar"]="Aggramar,PVE,enUS,Vindication,US,CST",
["84-Akama"]="Akama,PVP,enUS,Reckoning,US,CST",
["1070-Alexstrasza"]="Alexstrasza,PVE,enUS,Rampage,US,CST",
["52-Alleria"]="Alleria,PVE,enUS,Rampage,US,CST",
["78-Altar of Storms"]="Altar of Storms,PVP,enUS,Ruin,US,EST",
["71-Alterac Mountains"]="Alterac Mountains,PVP,enUS,Ruin,US,EST",
["3722-Aman'Thul"]="Aman'Thul,PVE,enUS,Bloodlust,US,AEST",
["156-Andorhal"]="Andorhal,PVP,enUS,Shadowburn,US,EST",
["78-Anetheron"]="Anetheron,PVP,enUS,Ruin,US,EST",
["116-Antonidas"]="Antonidas,PVE,enUS,Cyclone,US,PST",
["1138-Anub'arak"]="Anub'arak,PVP,enUS,Vengeance,US,EST",
["1174-Anvilmar"]="Anvilmar,PVE,enUS,Ruin,US,PST",
["1165-Arathor"]="Arathor,PVE,enUS,Reckoning,US,PST",
["1129-Archimonde"]="Archimonde,PVP,enUS,Shadowburn,US,CST",
["3676-Area 52"]="Area 52,PVE,enUS,Vindication,US,EST",
["75-Argent Dawn"]="Argent Dawn,RP,enUS,Ruin,US,EST",
["69-Arthas"]="Arthas,PVP,enUS,Ruin,US,EST",
["99-Arygos"]="Arygos,PVE,enUS,Vindication,US,EST",
["101-Auchindoun"]="Auchindoun,PVP,enUS,Vindication,US,EST",
["77-Azgalor"]="Azgalor,PVP,enUS,Ruin,US,CST",
["121-Azjol-Nerub"]="Azjol-Nerub,PVE,enUS,Cyclone,US,MST",
["3209-Azralon"]="Azralon,PVP,ptBR,Shadowburn,US",
["77-Azshara"]="Azshara,PVP,enUS,Ruin,US,EST",
["160-Azuremyst"]="Azuremyst,PVE,enUS,Shadowburn,US,PST",
["1190-Baelgun"]="Baelgun,PVE,enUS,Shadowburn,US,PST",
["71-Balnazzar"]="Balnazzar,PVP,enUS,Ruin,US,CST",
["3723-Barthilas"]="Barthilas,PVP,enUS,Bloodlust,US,AEST",
["74-Black Dragonflight"]="Black Dragonflight,PVP,enUS,Ruin,US,EST",
["54-Blackhand"]="Blackhand,PVE,enUS,Rampage,US,CST",
["10-Blackrock"]="Blackrock,PVP,enUS,Bloodlust,US,PST",
["125-Blackwater Raiders"]="Blackwater Raiders,RP,enUS,Reckoning,US,PST",
["154-Blackwing Lair"]="Blackwing Lair,PVP,enUS,Shadowburn,US,PST",
["105-Blade's Edge"]="Blade's Edge,PVE,enUS,Vindication,US,PST",
["1147-Bladefist"]="Bladefist,PVE,enUS,Vengeance,US,PST",
["73-Bleeding Hollow"]="Bleeding Hollow,PVP,enUS,Ruin,US,EST",
["70-Blood Furnace"]="Blood Furnace,PVP,enUS,Ruin,US,CST",
["64-Bloodhoof"]="Bloodhoof,PVE,enUS,Ruin,US,EST",
["119-Bloodscalp"]="Bloodscalp,PVP,enUS,Cyclone,US,MST",
["1136-Bonechewer"]="Bonechewer,PVP,enUS,Vengeance,US,PST",
["85-Borean Tundra"]="Borean Tundra,PVE,enUS,Reckoning,US,CST",
["119-Boulderfist"]="Boulderfist,PVP,enUS,Cyclone,US,PST",
["117-Bronzebeard"]="Bronzebeard,PVE,enUS,Cyclone,US,PST",
["91-Burning Blade"]="Burning Blade,PVP,enUS,Vindication,US,EST",
["1129-Burning Legion"]="Burning Legion,PVP,enUS,Shadowburn,US,CST",
["3721-Caelestrasz"]="Caelestrasz,PVE,enUS,Bloodlust,US,AEST",
["122-Cairne"]="Cairne,PVE,enUS,Cyclone,US,CST",
["1169-Cenarion Circle"]="Cenarion Circle,RP,enUS,Cyclone,US,PST",
["1168-Cenarius"]="Cenarius,PVE,enUS,Cyclone,US,PST",
["101-Cho'gall"]="Cho'gall,PVP,enUS,Vindication,US,CST",
["1138-Chromaggus"]="Chromaggus,PVP,enUS,Vengeance,US,CST",
["157-Coilfang"]="Coilfang,PVP,enUS,Shadowburn,US,PST",
["1138-Crushridge"]="Crushridge,PVP,enUS,Vengeance,US,PST",
["1136-Daggerspine"]="Daggerspine,PVP,enUS,Vengeance,US,PST",
["3683-Dalaran"]="Dalaran,PVE,enUS,Rampage,US,EST",
["157-Dalvengyr"]="Dalvengyr,PVP,enUS,Shadowburn,US,EST",
["157-Dark Iron"]="Dark Iron,PVP,enUS,Shadowburn,US,PST",
["120-Darkspear"]="Darkspear,PVP,enUS,Cyclone,US,MST",
["87-Darrowmere"]="Darrowmere,PVE,enUS,Reckoning,US,PST",
["3726-Dath'Remar"]="Dath'Remar,PVE,enUS,Bloodlust,US,AEST",
["1173-Dawnbringer"]="Dawnbringer,PVE,enUS,Ruin,US,CST",
["155-Deathwing"]="Deathwing,PVP,enUS,Shadowburn,US,MST",
["157-Demon Soul"]="Demon Soul,PVP,enUS,Shadowburn,US,EST",
["55-Dentarg"]="Dentarg,PVE,enUS,Rampage,US,EST",
["77-Destromath"]="Destromath,PVP,enUS,Ruin,US,PST",
["154-Dethecus"]="Dethecus,PVP,enUS,Shadowburn,US,PST",
["154-Detheroc"]="Detheroc,PVP,enUS,Shadowburn,US,CST",
["1190-Doomhammer"]="Doomhammer,PVE,enUS,Shadowburn,US,MST",
["115-Draenor"]="Draenor,PVE,enUS,Cyclone,US,PST",
["114-Dragonblight"]="Dragonblight,PVE,enUS,Cyclone,US,PST",
["84-Dragonmaw"]="Dragonmaw,PVP,enUS,Reckoning,US,PST",
["127-Drak'Tharon"]="Drak'Tharon,PVP,enUS,Reckoning,US,CST",
["131-Drak'thul"]="Drak'thul,PVE,enUS,Reckoning,US,CST",
["113-Draka"]="Draka,PVE,enUS,Cyclone,US,CST",
["1425-Drakkari"]="Drakkari,PVP,esMX,Vindication,US,CST",
["3724-Dreadmaul"]="Dreadmaul,PVP,enUS,Bloodlust,US,AEST",
["1165-Drenden"]="Drenden,PVE,enUS,Reckoning,US,EST",
["119-Dunemaul"]="Dunemaul,PVP,enUS,Cyclone,US,PST",
["63-Durotan"]="Durotan,PVE,enUS,Ruin,US,EST",
["64-Duskwood"]="Duskwood,PVE,enUS,Ruin,US,EST",
["100-Earthen Ring"]="Earthen Ring,RP,enUS,Vindication,US,EST",
["115-Echo Isles"]="Echo Isles,PVE,enUS,Cyclone,US,PST",
["47-Eitrigg"]="Eitrigg,PVE,enUS,Vengeance,US,CST",
["123-Eldre'Thalas"]="Eldre'Thalas,PVE,enUS,Reckoning,US,EST",
["67-Elune"]="Elune,PVE,enUS,Ruin,US,EST",
["162-Emerald Dream"]="Emerald Dream,RPPVP,enUS,Shadowburn,US,CST",
["96-Eonar"]="Eonar,PVE,enUS,Vindication,US,EST",
["159-Eredar"]="Eredar,PVP,enUS,Shadowburn,US,EST",
["155-Executus"]="Executus,PVP,enUS,Shadowburn,US,EST",
["62-Exodar"]="Exodar,PVE,enUS,Ruin,US,EST",
["12-Farstriders"]="Farstriders,RP,enUS,Bloodlust,US,CST",
["118-Feathermoon"]="Feathermoon,RP,enUS,Reckoning,US,PST",
["114-Fenris"]="Fenris,PVE,enUS,Cyclone,US,EST",
["127-Firetree"]="Firetree,PVP,enUS,Reckoning,US,EST",
["106-Fizzcrank"]="Fizzcrank,PVE,enUS,Vindication,US,CST",
["128-Frostmane"]="Frostmane,PVP,enUS,Reckoning,US,CST",
["3725-Frostmourne"]="Frostmourne,PVP,enUS,Bloodlust,US,AEST",
["7-Frostwolf"]="Frostwolf,PVP,enUS,Bloodlust,US,PST",
["54-Galakrond"]="Galakrond,PVE,enUS,Rampage,US,PST",
["3234-Gallywix"]="Gallywix,PVE,ptBR,Ruin,US",
["1138-Garithos"]="Garithos,PVP,enUS,Vengeance,US,CST",
["51-Garona"]="Garona,PVE,enUS,Rampage,US,CST",
["3677-Garrosh"]="Garrosh,PVE,enUS,Vengeance,US,EST",
["1069-Ghostlands"]="Ghostlands,PVE,enUS,Rampage,US,CST",
["67-Gilneas"]="Gilneas,PVE,enUS,Ruin,US,EST",
["153-Gnomeregan"]="Gnomeregan,PVE,enUS,Shadowburn,US,PST",
["3207-Goldrinn"]="Goldrinn,PVE,ptBR,Rampage,US",
["159-Gorefiend"]="Gorefiend,PVP,enUS,Shadowburn,US,EST",
["71-Gorgonnash"]="Gorgonnash,PVP,enUS,Ruin,US,PST",
["158-Greymane"]="Greymane,PVE,enUS,Shadowburn,US,CST",
["68-Grizzly Hills"]="Grizzly Hills,PVE,enUS,Ruin,US,EST",
["74-Gul'dan"]="Gul'dan,PVP,enUS,Ruin,US,CST",
["3728-Gundrak"]="Gundrak,PVP,enUS,Vengeance,US,AEST",
["1136-Gurubashi"]="Gurubashi,PVP,enUS,Vengeance,US,PST",
["1136-Hakkar"]="Hakkar,PVP,enUS,Vengeance,US,CST",
["154-Haomarush"]="Haomarush,PVP,enUS,Shadowburn,US,EST",
["53-Hellscream"]="Hellscream,PVE,enUS,Rampage,US,CST",
["90-Hydraxis"]="Hydraxis,PVE,enUS,Reckoning,US,CST",
["3661-Hyjal"]="Hyjal,PVE,enUS,Vengeance,US,PST",
["104-Icecrown"]="Icecrown,PVE,enUS,Vindication,US,MST",
["57-Illidan"]="Illidan,PVP,enUS,Rampage,US,CST",
["1129-Jaedenar"]="Jaedenar,PVP,enUS,Shadowburn,US,EST",
["3728-Jubei'Thos"]="Jubei'Thos,PVP,enUS,Vengeance,US,AEST",
["1069-Kael'thas"]="Kael'thas,PVE,enUS,Rampage,US,CST",
["155-Kalecgos"]="Kalecgos,PVP,enUS,Shadowburn,US,PST",
["98-Kargath"]="Kargath,PVE,enUS,Vindication,US,EST",
["3693-Kel'Thuzad"]="Kel'Thuzad,PVP,enUS,Vindication,US,MST",
["52-Khadgar"]="Khadgar,PVE,enUS,Rampage,US,EST",
["121-Khaz Modan"]="Khaz Modan,PVE,enUS,Cyclone,US,CST",
["3726-Khaz'goroth"]="Khaz'goroth,PVE,enUS,Bloodlust,US,AEST",
["9-Kil'jaeden"]="Kil'jaeden,PVP,enUS,Bloodlust,US,PST",
["4-Kilrogg"]="Kilrogg,PVE,enUS,Bloodlust,US,PST",
["1071-Kirin Tor"]="Kirin Tor,RP,enUS,Rampage,US,CST",
["1146-Korgath"]="Korgath,PVP,enUS,Vengeance,US,CST",
["123-Korialstrasz"]="Korialstrasz,PVE,enUS,Reckoning,US,PST",
["1147-Kul Tiras"]="Kul Tiras,PVE,enUS,Vengeance,US,CST",
["101-Laughing Skull"]="Laughing Skull,PVP,enUS,Vindication,US,CST",
["154-Lethon"]="Lethon,PVP,enUS,Shadowburn,US,PST",
["3694-Lightbringer"]="Lightbringer,PVE,enUS,Cyclone,US,PST",
["91-Lightning's Blade"]="Lightning's Blade,PVP,enUS,Vindication,US,EST",
["163-Lightninghoof"]="Lightninghoof,RPPVP,enUS,Shadowburn,US,CST",
["99-Llane"]="Llane,PVE,enUS,Vindication,US,EST",
["68-Lothar"]="Lothar,PVE,enUS,Ruin,US,EST",
["1173-Madoran"]="Madoran,PVE,enUS,Ruin,US,CST",
["163-Maelstrom"]="Maelstrom,RPPVP,enUS,Shadowburn,US,CST",
["78-Magtheridon"]="Magtheridon,PVP,enUS,Ruin,US,EST",
["119-Maiev"]="Maiev,PVP,enUS,Cyclone,US,PST",
["3684-Mal'Ganis"]="Mal'Ganis,PVP,enUS,Vindication,US,CST",
["1175-Malfurion"]="Malfurion,PVE,enUS,Ruin,US,CST",
["127-Malorne"]="Malorne,PVP,enUS,Reckoning,US,CST",
["104-Malygos"]="Malygos,PVE,enUS,Vindication,US,CST",
["70-Mannoroth"]="Mannoroth,PVP,enUS,Ruin,US,EST",
["62-Medivh"]="Medivh,PVE,enUS,Ruin,US,EST",
["1151-Misha"]="Misha,PVE,enUS,Vengeance,US,PST",
["86-Mok'Nathal"]="Mok'Nathal,PVE,enUS,Reckoning,US,CST",
["3675-Moon Guard"]="Moon Guard,RP,enUS,Reckoning,US,CST",
["153-Moonrunner"]="Moonrunner,PVE,enUS,Shadowburn,US,PST",
["84-Mug'thol"]="Mug'thol,PVP,enUS,Reckoning,US,CST",
["1182-Muradin"]="Muradin,PVE,enUS,Vengeance,US,CST",
["3721-Nagrand"]="Nagrand,PVE,enUS,Bloodlust,US,AEST",
["1138-Nathrezim"]="Nathrezim,PVP,enUS,Vengeance,US,MST",
["1184-Nazgrel"]="Nazgrel,PVE,enUS,Bloodlust,US,EST",
["70-Nazjatar"]="Nazjatar,PVP,enUS,Ruin,US,PST",
["3208-Nemesis"]="Nemesis,PVP,ptBR,Rampage,US",
["128-Ner'zhul"]="Ner'zhul,PVP,enUS,Reckoning,US,PST",
["1184-Nesingwary"]="Nesingwary,PVE,enUS,Bloodlust,US,CST",
["1182-Nordrassil"]="Nordrassil,PVE,enUS,Vengeance,US,PST",
["98-Norgannon"]="Norgannon,PVE,enUS,Vindication,US,EST",
["91-Onyxia"]="Onyxia,PVP,enUS,Vindication,US,PST",
["122-Perenolde"]="Perenolde,PVE,enUS,Cyclone,US,MST",
["5-Proudmoore"]="Proudmoore,PVE,enUS,Bloodlust,US,PST",
["1185-Quel'dorei"]="Quel'Thalas,PVE,esMX,Vindication,US,CST",
["1428-Quel'Thalas"]="Quel'dorei,PVE,enUS,Bloodlust,US,CST",
["1427-Ragnaros"]="Ragnaros,PVP,esMX,Vindication,US,CST",
["1072-Ravencrest"]="Ravencrest,PVE,enUS,Rampage,US,CST",
["164-Ravenholdt"]="Ravenholdt,RPPVP,enUS,Shadowburn,US,EST",
["1151-Rexxar"]="Rexxar,PVE,enUS,Vengeance,US,CST",
["127-Rivendare"]="Rivendare,PVP,enUS,Reckoning,US,PST",
["151-Runetotem"]="Runetotem,PVE,enUS,Vengeance,US,CST",
["76-Sargeras"]="Sargeras,PVP,enUS,Shadowburn,US,CST",
["3729-Saurfang"]="Saurfang,PVE,enUS,Vengeance,US,AEST",
["118-Scarlet Crusade"]="Scarlet Crusade,RP,enUS,Reckoning,US,CST",
["156-Scilla"]="Scilla,PVP,enUS,Shadowburn,US,EST",
["1185-Sen'jin"]="Sen'jin,PVE,enUS,Bloodlust,US,CST",
["1071-Sentinels"]="Sentinels,RP,enUS,Rampage,US,PST",
["125-Shadow Council"]="Shadow Council,RP,enUS,Reckoning,US,MST",
["154-Shadowmoon"]="Shadowmoon,PVP,enUS,Shadowburn,US,EST",
["85-Shadowsong"]="Shadowsong,PVE,enUS,Reckoning,US,PST",
["117-Shandris"]="Shandris,PVE,enUS,Cyclone,US,EST",
["155-Shattered Halls"]="Shattered Halls,PVP,enUS,Shadowburn,US,PST",
["157-Shattered Hand"]="Shattered Hand,PVP,enUS,Shadowburn,US,EST",
["47-Shu'halo"]="Shu'halo,PVE,enUS,Vengeance,US,PST",
["12-Silver Hand"]="Silver Hand,RP,enUS,Bloodlust,US,PST",
["86-Silvermoon"]="Silvermoon,PVE,enUS,Reckoning,US,PST",
["1169-Sisters of Elune"]="Sisters of Elune,RP,enUS,Cyclone,US,CST",
["74-Skullcrusher"]="Skullcrusher,PVP,enUS,Ruin,US,EST",
["131-Skywall"]="Skywall,PVE,enUS,Reckoning,US,PST",
["1138-Smolderthorn"]="Smolderthorn,PVP,enUS,Vengeance,US,EST",
["159-Spinebreaker"]="Spinebreaker,PVP,enUS,Shadowburn,US,PST",
["127-Spirestone"]="Spirestone,PVP,enUS,Reckoning,US,PST",
["160-Staghelm"]="Staghelm,PVE,enUS,Shadowburn,US,CST",
["1071-Steamwheedle Cartel"]="Steamwheedle Cartel,RP,enUS,Rampage,US,EST",
["119-Stonemaul"]="Stonemaul,PVP,enUS,Cyclone,US,PST",
["60-Stormrage"]="Stormrage,PVE,enUS,Ruin,US,EST",
["58-Stormreaver"]="Stormreaver,PVP,enUS,Rampage,US,CST",
["127-Stormscale"]="Stormscale,PVP,enUS,Reckoning,US,PST",
["113-Suramar"]="Suramar,PVE,enUS,Cyclone,US,PST",
["158-Tanaris"]="Tanaris,PVE,enUS,Shadowburn,US,EST",
["90-Terenas"]="Terenas,PVE,enUS,Reckoning,US,MST",
["1070-Terokkar"]="Terokkar,PVE,enUS,Rampage,US,CST",
["3724-Thaurissan"]="Thaurissan,PVP,enUS,Bloodlust,US,AEST",
["71-The Forgotten Coast"]="The Forgotten Coast,PVP,enUS,Ruin,US,EST",
["75-The Scryers"]="The Scryers,RP,enUS,Ruin,US,PST",
["1129-The Underbog"]="The Underbog,PVP,enUS,Shadowburn,US,CST",
["163-The Venture Co"]="The Venture Co,RPPVP,enUS,Shadowburn,US,PST",
["12-Thorium Brotherhood"]="Thorium Brotherhood,RP,enUS,Bloodlust,US,CST",
["3678-Thrall"]="Thrall,PVE,enUS,Rampage,US,EST",
["105-Thunderhorn"]="Thunderhorn,PVE,enUS,Vindication,US,CST",
["77-Thunderlord"]="Thunderlord,PVP,enUS,Ruin,US,CST",
["11-Tichondrius"]="Tichondrius,PVP,enUS,Bloodlust,US,PST",
["3210-Tol Barad"]="Tol Barad,PVP,ptBR,Shadowburn,US",
["128-Tortheldrin"]="Tortheldrin,PVP,enUS,Reckoning,US,EST",
["1175-Trollbane"]="Trollbane,PVE,enUS,Ruin,US,EST",
["3685-Turalyon"]="Turalyon,PVE,enUS,Vindication,US,EST",
["164-Twisting Nether"]="Twisting Nether,RPPVP,enUS,Shadowburn,US,CST",
["1072-Uldaman"]="Uldaman,PVE,enUS,Rampage,US,EST",
["116-Uldum"]="Uldum,PVE,enUS,Cyclone,US,PST",
["1174-Undermine"]="Undermine,PVE,enUS,Ruin,US,EST",
["156-Ursin"]="Ursin,PVP,enUS,Shadowburn,US,PST",
["151-Uther"]="Uther,PVE,enUS,Vengeance,US,PST",
["7-Vashj"]="Vashj,PVP,enUS,Bloodlust,US,PST",
["1184-Vek'nilash"]="Vek'nilash,PVE,enUS,Bloodlust,US,CST",
["96-Velen"]="Velen,PVE,enUS,Vindication,US,PST",
["71-Warsong"]="Warsong,PVP,enUS,Ruin,US,EST",
["55-Whisperwind"]="Whisperwind,PVE,enUS,Rampage,US,CST",
["159-Wildhammer"]="Wildhammer,PVP,enUS,Shadowburn,US,CST",
["87-Windrunner"]="Windrunner,PVE,enUS,Reckoning,US,PST",
["4-Winterhoof"]="Winterhoof,PVE,enUS,Bloodlust,US,CST",
["1171-Wyrmrest Accord"]="Wyrmrest Accord,RP,enUS,Cyclone,US,PST",
["63-Ysera"]="Ysera,PVE,enUS,Ruin,US,EST",
["78-Ysondre"]="Ysondre,PVP,enUS,Ruin,US,EST",
["53-Zangarmarsh"]="Zangarmarsh,PVE,enUS,Rampage,US,MST",
["61-Zul'jin"]="Zul'jin,PVE,enUS,Ruin,US,EST",
["156-Zuluhed"]="Zuluhed,PVP,enUS,Shadowburn,US,EST",
--}}
--{{ EUROPE
["3679-Aegwynn"]="Aegwynn,PVP,deDE,Misery,EU,CET",
["1081-Aerie Peak"]="Aerie Peak,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1091-Agamaggan"]="Agamaggan,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1303-Aggra (Português)"]="Aggra (Português),PVP,ptPT,Misery,EU,CET",
["1325-Aggramar"]="Aggramar,PVE,enGB,Vengeance / Rache,EU,CET",
["1598-Ahn'Qiraj"]="Ahn'Qiraj,PVP,enGB,Vindication,EU,CET",
["639-Al'Akir"]="Al'Akir,PVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1607-Alexstrasza"]="Alexstrasza,PVE,deDE,Sturmangriff / Charge,EU,CET",
["1099-Alleria"]="Alleria,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1082-Alonsus"]="Alonsus,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["3680-Aman'thul"]="Aman'Thul,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["568-Ambossar"]="Ambossar,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1082-Anachronos"]="Anachronos,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1104-Anetheron"]="Anetheron,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["3686-Antonidas"]="Antonidas,PVE,deDE,Vengeance / Rache,EU,CET",
["1105-Anub'arak"]="Anub'arak,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["512-Arak-arahm"]="Arak-arahm,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1624-Arathi"]="Arathi,PVP,frFR,Sturmangriff / Charge,EU,CET",
["1587-Arathor"]="Arathor,PVE,enGB,Vindication,EU,CET",
["1302-Archimonde"]="Archimonde,PVP,frFR,Misery,EU,CET",
["1400-Area 52"]="Area 52,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["3702-Argent Dawn"]="Argent Dawn,RP,enGB,Reckoning / Abrechnung,EU,CET",
["578-Arthas"]="Arthas,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1406-Arygos"]="Arygos,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1923-Ясеневый лес"]="Ясеневый лес|Ashenvale,PVP,ruRU,Vindication,EU,CET",
["3666-Aszune"]="Aszune,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1597-Auchindoun"]="Auchindoun,PVP,enGB,Vindication,EU,CET",
["1396-Azjol-Nerub"]="Azjol-Nerub,PVE,enGB,Cruelty / Crueldad,EU,CET",
["579-Azshara"]="Azshara,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1922-Азурегос"]="Азурегос|Azuregos,PVE,ruRU,Vindication,EU,CET",
["1417-Azuremyst"]="Azuremyst,PVE,enGB,Glutsturm / Emberstorm,EU,CET",
["570-Baelgun"]="Baelgun,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1598-Balnazzar"]="Balnazzar,PVP,enGB,Vindication,EU,CET",
["3691-Blackhand"]="Blackhand,PVE,deDE,Vengeance / Rache,EU,CET",
["580-Blackmoore"]="Blackmoore,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["581-Blackrock"]="Blackrock,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1929-Черный Шрам"]="Черный Шрам|Blackscar,PVP,ruRU,Vindication,EU,CET",
["1416-Blade's Edge"]="Blade's Edge,PVE,enGB,Glutsturm / Emberstorm,EU,CET",
["3657-Bladefist"]="Bladefist,PVP,enGB,Cruelty / Crueldad,EU,CET",
["633-Bloodfeather"]="Bloodfeather,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1080-Bloodhoof"]="Bloodhoof,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1091-Bloodscalp"]="Bloodscalp,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["578-Blutkessel"]="Blutkessel,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1924-Пиратская бухта"]="Пиратская бухта|Booty Bay,PVP,ruRU,Vindication,EU,CET",
["1625-Борейская тундра"]="Борейская тундра|Borean Tundra,PVE,ruRU,Sturmangriff / Charge,EU,CET",
["1598-Boulderfist"]="Boulderfist,PVP,enGB,Vindication,EU,CET",
["1393-Bronze Dragonflight"]="Bronze Dragonflight,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1081-Bronzebeard"]="Bronzebeard,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1092-Burning Blade"]="Burning Blade,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["3713-Burning Legion"]="Burning Legion,PVP,enGB,Cruelty / Crueldad,EU,CET",
["633-Burning Steppes"]="Burning Steppes,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1381-C'Thun"]="C'Thun,PVP,esES,Cruelty / Crueldad,EU,CET",
["1307-Chamber of Aspects"]="Chamber of Aspects,PVE,enGB,Misery,EU,CET",
["510-Chants éternels"]="Chants éternels,PVE,frFR,Sturmangriff / Charge,EU,CET",
["1336-Cho’gall"]="Cho'gall,PVP,frFR,Vengeance / Rache,EU,CET",
["1598-Chromaggus"]="Chromaggus,PVP,enGB,Vindication,EU,CET",
["1384-Colinas Pardas"]="Colinas Pardas,PVE,esES,Cruelty / Crueldad,EU,CET",
["1127-Confrérie du Thorium"]="Confrérie du Thorium,RP,frFR,Embuscade / Hinterhalt,EU,CET",
["1086-Conseil des Ombres"]="Conseil des Ombres,RPPVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1091-Crushridge"]="Crushridge,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1086-Culte de la Rive noire"]="Culte de la Rive noire,RPPVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1598-Daggerspine"]="Daggerspine,PVP,enGB,Vindication,EU,CET",
["1621-Dalaran"]="Dalaran,PVE,frFR,Sturmangriff / Charge,EU,CET",
["1105-Dalvengyr"]="Dalvengyr,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1317-Darkmoon Faire"]="Darkmoon Faire,RP,enGB,Cruelty / Crueldad,EU,CET",
["3660-Darksorrow"]="Darksorrow,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1389-Darkspear"]="Darkspear,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1121-Das Konsortium"]="Das Konsortium,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1121-Das Syndikat"]="Das Syndikat,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1605-Страж Смерти"]="Страж Смерти|Deathguard,PVP,ruRU,Vindication,EU,CET",
["1924-Ткач Смерти"]="Ткач Смерти|Deathweaver,PVP,ruRU,Vindication,EU,CET",
["1596-Deathwing"]="Deathwing,PVP,enGB,Vindication,EU,CET",
["1609-Подземье"]="Подземье|Deepholm,PVP,ruRU,Sturmangriff / Charge,EU,CET",
["1096-Defias Brotherhood"]="Defias Brotherhood,RPPVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1084-Dentarg"]="Dentarg,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1121-Der Abyssische Rat"]="Der Mithrilorden,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1327-Der Mithrilorden"]="Der Rat von Dalaran,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1327-Der Rat von Dalaran"]="Der abyssische Rat,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["612-Destromath"]="Destromath,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["531-Dethecus"]="Dethecus,PVP,deDE,Embuscade / Hinterhalt,EU,CET",
["1618-Die Aldor"]="Die Aldor,RP,deDE,Sturmangriff / Charge,EU,CET",
["1121-Die Arguswacht"]="Die Arguswacht,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["516-Die Nachtwache"]="Die Nachtwache,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1118-Die Silberne Hand"]="Die Silberne Hand,RP,deDE,Glutsturm / Emberstorm,EU,CET",
["1121-Die Todeskrallen"]="Die Todeskrallen,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1118-Die ewige Wacht"]="Die ewige Wacht,RP,deDE,Glutsturm / Emberstorm,EU,CET",
["1402-Doomhammer"]="Doomhammer,PVE,enGB,Embuscade / Hinterhalt,EU,CET",
["1403-Draenor"]="Draenor,PVE,enGB,Embuscade / Hinterhalt,EU,CET",
["1588-Dragonblight"]="Dragonblight,PVE,enGB,Vindication,EU,CET",
["3656-Dragonmaw"]="Dragonmaw,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1092-Drak'thul"]="Drak'thul,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1122-Drek'Thar"]="Drek'Thar,PVE,frFR,Embuscade / Hinterhalt,EU,CET",
["1378-Dun Modr"]="Dun Modr,PVP,esES,Cruelty / Crueldad,EU,CET",
["1408-Dun Morogh"]="Dun Morogh,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1597-Dunemaul"]="Dunemaul,PVP,enGB,Vindication,EU,CET",
["535-Durotan"]="Durotan,PVE,deDE,Glutsturm / Emberstorm,EU,CET",
["1317-Earthen Ring"]="Earthen Ring,RP,enGB,Cruelty / Crueldad,EU,CET",
["1612-Echsenkessel"]="Echsenkessel,PVP,deDE,Sturmangriff / Charge,EU,CET",
["1123-Eitrigg"]="Eitrigg,PVE,frFR,Embuscade / Hinterhalt,EU,CET",
["1336-Eldre'Thalas"]="Eldre'Thalas,PVP,frFR,Vengeance / Rache,EU,CET",
["1315-Elune"]="Elune,PVE,frFR,Misery,EU,CET",
["2074-Emerald Dream"]="Emerald Dream,PVE,enGB,Embuscade / Hinterhalt,EU,CET",
["1091-Emeriss"]="Emeriss,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1416-Eonar"]="Eonar,PVE,enGB,Glutsturm / Emberstorm,EU,CET",
["3692-Eredar"]="Eredar,PVP,deDE,Vengeance / Rache,EU,CET",
["1925-Вечная Песня"]="Вечная Песня|Eversong,PVE,ruRU,Vindication,EU,CET",
["633-Executus"]="Executus,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1385-Exodar"]="Exodar,PVE,esES,Cruelty / Crueldad,EU,CET",
["1104-Festung der Stürme"]="Festung der Stürme,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1623-Дракономор"]="Дракономор|Fordragon,PVE,ruRU,Sturmangriff / Charge,EU,CET",
["516-Forscherliga"]="Forscherliga,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1300-Frostmane"]="Frostmane,PVP,enGB,Misery,EU,CET",
["1105-Frostmourne"]="Frostmourne,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["3657-Frostwhisper"]="Frostwhisper,PVP,enGB,Cruelty / Crueldad,EU,CET",
["3703-Frostwolf"]="Frostwolf,PVP,deDE,Vengeance / Rache,EU,CET",
["1614-Галакронд"]="Галакронд|Galakrond,PVE,ruRU,Sturmangriff / Charge,EU,CET",
["509-Garona"]="Garona,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1401-Garrosh"]="Garrosh,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["3660-Genjuros"]="Genjuros,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1588-Ghostlands"]="Ghostlands,PVE,enGB,Vindication,EU,CET",
["567-Gilneas"]="Gilneas,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1928-Голдринн"]="Голдринн|Goldrinn,PVE,ruRU,Vindication,EU,CET",
["1602-Гордунни"]="Гордунни|Gordunni,PVP,ruRU,Vindication,EU,CET",
["612-Gorgonnash"]="Gorgonnash,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1603-Седогрив"]="Седогрив|Greymane,PVP,ruRU,Vindication,EU,CET",
["1303-Grim Batol"]="Grim Batol,PVP,enGB,Misery,EU,CET",
["1927-Гром"]="Гром|Grom,PVP,ruRU,Vindication,EU,CET",
["1104-Gul'dan"]="Gul'dan,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1091-Hakkar"]="Hakkar,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["3656-Haomarush"]="Haomarush,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1587-Hellfire"]="Hellfire,PVE,enGB,Vindication,EU,CET",
["1325-Hellscream"]="Hellscream,PVE,enGB,Vengeance / Rache,EU,CET",
["1615-Ревущий фьорд"]="Ревущий фьорд|Howling Fjord,PVP,ruRU,Sturmangriff / Charge,EU,CET",
["1390-Hyjal"]="Hyjal,PVE,frFR,Misery,EU,CET",
["1624-Illidan"]="Illidan,PVP,frFR,Sturmangriff / Charge,EU,CET",
["1597-Jaedenar"]="Jaedenar,PVP,enGB,Vindication,EU,CET",
["512-Kael'thas"]="Kael'thas,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1596-Karazhan"]="Karazhan,PVP,enGB,Vindication,EU,CET",
["568-Kargath"]="Kargath,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1305-Kazzak"]="Kazzak,PVP,enGB,Misery,EU,CET",
["578-Kel'Thuzad"]="Kel'Thuzad,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1080-Khadgar"]="Khadgar,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["3690-Khaz Modan"]="Khaz Modan,PVE,frFR,Sturmangriff / Charge,EU,CET",
["1406-Khaz'goroth"]="Khaz'goroth,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1104-Kil'jaeden"]="Kil'jaeden,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1311-Kilrogg"]="Kilrogg,PVE,enGB,Misery,EU,CET",
["3714-Kirin Tor"]="Kirin Tor,RP,frFR,Glutsturm / Emberstorm,EU,CET",
["633-Kor'gall"]="Kor'gall,PVP,enGB,Cruelty / Crueldad,EU,CET",
["579-Krag'jin"]="Krag'jin,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1123-Krasus"]="Krasus,PVE,frFR,Embuscade / Hinterhalt,EU,CET",
["1082-Kul Tiras"]="Kul Tiras,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1121-Kult der Verdammten"]="Kult der Verdammten,RPPVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1086-La Croisade écarlate"]="La Croisade écarlate,RPPVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1598-Laughing Skull"]="Laughing Skull,PVP,enGB,Vindication,EU,CET",
["1127-Les Clairvoyants"]="Les Clairvoyants,RP,frFR,Embuscade / Hinterhalt,EU,CET",
["1127-Les Sentinelles"]="Les Sentinelles,RP,frFR,Embuscade / Hinterhalt,EU,CET",
["1603-Король-лич"]="Король-лич|Lich King,PVP,ruRU,Vindication,EU,CET",
["1388-Lightbringer"]="Lightbringer,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1596-Lightning's Blade"]="Lightning's Blade,PVP,enGB,Vindication,EU,CET",
["1106-Lordaeron"]="Lordaeron,PVE,deDE,Glutsturm / Emberstorm,EU,CET",
["1384-Los Errantes"]="Los Errantes,PVE,esES,Cruelty / Crueldad,EU,CET",
["570-Lothar"]="Lothar,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["3696-Madmortem"]="Madmortem,PVE,deDE,Vengeance / Rache,EU,CET",
["3681-Magtheridon"]="Magtheridon,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1612-Mal'Ganis"]="Mal'Ganis,PVP,deDE,Sturmangriff / Charge,EU,CET",
["1098-Malfurion"]="Malfurion,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1097-Malorne"]="Malorne,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1098-Malygos"]="Malygos,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["612-Mannoroth"]="Mannoroth,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1621-Marécage de Zangar"]="Marécage de Zangar,PVE,frFR,Sturmangriff / Charge,EU,CET",
["1388-Mazrigos"]="Mazrigos,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1331-Medivh"]="Medivh,PVE,frFR,Vengeance / Rache,EU,CET",
["1385-Minahonda"]="Minahonda,PVE,esES,Cruelty / Crueldad,EU,CET",
["1085-Moonglade"]="Moonglade,RP,enGB,Reckoning / Abrechnung,EU,CET",
["531-Mug'thol"]="Mug'thol,PVP,deDE,Embuscade / Hinterhalt,EU,CET",
["1311-Nagrand"]="Nagrand,PVE,enGB,Misery,EU,CET",
["1104-Nathrezim"]="Nathrezim,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1624-Naxxramas"]="Naxxramas,PVP,frFR,Sturmangriff / Charge,EU,CET",
["1105-Nazjatar"]="Nazjatar,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["612-Nefarian"]="Nefarian,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1316-Nemesis"]="Nemesis,PVP,itIT,Misery,EU,CET",
["3660-Neptulon"]="Neptulon,PVP,enGB,Cruelty / Crueldad,EU,CET",
["509-Ner’zhul"]="Ner'zhul,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["612-Nera'thor"]="Nera'thor,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1607-Nethersturm"]="Nethersturm,PVE,deDE,Sturmangriff / Charge,EU,CET",
["1393-Nordrassil"]="Nordrassil,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1408-Norgannon"]="Norgannon,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1401-Nozdormu"]="Nozdormu,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["531-Onyxia"]="Onyxia,PVP,deDE,Embuscade / Hinterhalt,EU,CET",
["1301-Outland"]="Outland,PVP,enGB,Misery,EU,CET",
["1407-Perenolde"]="Perenolde,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1309-Pozzo dell'Eternità"]="Pozzo dell'Eternità,PVE,itIT,Misery,EU,CET",
["3696-Proudmoore"]="Proudmoore,PVE,deDE,Vengeance / Rache,EU,CET",
["1396-Quel'Thalas"]="Quel'Thalas,PVE,enGB,Cruelty / Crueldad,EU,CET",
["3682-Ragnaros"]="Ragnaros,PVP,enGB,Sturmangriff / Charge,EU,CET",
["1104-Rajaxx"]="Rajaxx,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["512-Rashgarroth"]="Rashgarroth,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1329-Ravencrest"]="Ravencrest,PVP,enGB,Vengeance / Rache,EU,CET",
["1096-Ravenholdt"]="Ravenholdt,RPPVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1609-Разувий"]="Разувий|Razuvious,PVP,ruRU,Sturmangriff / Charge,EU,CET",
["1099-Rexxar"]="Rexxar,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1311-Runetotem"]="Runetotem,PVE,enGB,Misery,EU,CET",
["1379-Sanguino"]="Sanguino,PVP,esES,Cruelty / Crueldad,EU,CET",
["509-Sargeras"]="Sargeras,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1389-Saurfang"]="Saurfang,PVE,enGB,Cruelty / Crueldad,EU,CET",
["1096-Scarshield Legion"]="Scarshield Legion,RPPVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1400-Sen'jin"]="Sen'jin,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["3666-Shadowsong"]="Shadowsong,PVE,enGB,Reckoning / Abrechnung,EU,CET",
["1598-Shattered Halls"]="Shattered Halls,PVP,enGB,Vindication,EU,CET",
["633-Shattered Hand"]="Shattered Hand,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1401-Shattrath"]="Shattrath,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1379-Shen'dralar"]="Shen'dralar,PVP,esES,Cruelty / Crueldad,EU,CET",
["3391-Silvermoon"]="Silvermoon,PVE,enGB,Misery,EU,CET",
["1336-Sinstralis"]="Sinstralis,PVP,frFR,Vengeance / Rache,EU,CET",
["639-Skullcrusher"]="Skullcrusher,PVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1604-Свежеватель Душ"]="Свежеватель Душ|Soulflayer,PVP,ruRU,Vindication,EU,CET",
["3656-Spinebreaker"]="Spinebreaker,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1096-Sporeggar"]="Sporeggar,RPPVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1085-Steamwheedle Cartel"]="Steamwheedle Cartel,RP,enGB,Reckoning / Abrechnung,EU,CET",
["1417-Stormrage"]="Stormrage,PVE,enGB,Glutsturm / Emberstorm,EU,CET",
["3656-Stormreaver"]="Stormreaver,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["2073-Stormscale"]="Stormscale,PVP,enGB,Vengeance / Rache,EU,CET",
["1598-Sunstrider"]="Sunstrider,PVP,enGB,Vindication,EU,CET",
["1331-Suramar"]="Suramar,PVE,frFR,Vengeance / Rache,EU,CET",
["3687-Sylvanas"]="Sylvanas,PVP,enGB,Sturmangriff / Charge,EU,CET",
["1612-Taerar"]="Taerar,PVP,deDE,Sturmangriff / Charge,EU,CET",
["1598-Talnivarr"]="Talnivarr,PVP,enGB,Vindication,EU,CET",
["1084-Tarren Mill"]="Tarren Mill,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["1407-Teldrassil"]="Teldrassil,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1624-Temple noir"]="Temple noir,PVP,frFR,Sturmangriff / Charge,EU,CET",
["2074-Terenas"]="Terenas,PVE,enGB,Embuscade / Hinterhalt,EU,CET",
["1389-Terokkar"]="Terokkar,PVE,enGB,Cruelty / Crueldad,EU,CET",
["531-Terrordar"]="Terrordar,PVP,deDE,Embuscade / Hinterhalt,EU,CET",
["1596-The Maelstrom"]="The Maelstrom,PVP,enGB,Vindication,EU,CET",
["1085-The Sha'tar"]="The Sha'tar,RP,enGB,Reckoning / Abrechnung,EU,CET",
["1096-The Venture Co"]="The Venture Co,RPPVP,enGB,Glutsturm / Emberstorm,EU,CET",
["531-Theradras"]="Theradras,PVP,deDE,Embuscade / Hinterhalt,EU,CET",
["1927-Термоштепсель"]="Термоштепсель|Thermaplugg,PVP,ruRU,Vindication,EU,CET",
["604-Thrall"]="Thrall,PVE,deDE,Glutsturm / Emberstorm,EU,CET",
["512-Throk'Feroth"]="Throk'Feroth,PVP,frFR,Embuscade / Hinterhalt,EU,CET",
["1313-Thunderhorn"]="Thunderhorn,PVE,enGB,Misery,EU,CET",
["1106-Tichondrius"]="Tichondrius,PVE,deDE,Glutsturm / Emberstorm,EU,CET",
["535-Tirion"]="Tirion,PVE,deDE,Glutsturm / Emberstorm,EU,CET",
["1405-Todeswache"]="Todeswache,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1598-Trollbane"]="Trollbane,PVP,enGB,Vindication,EU,CET",
["1402-Turalyon"]="Turalyon,PVE,enGB,Embuscade / Hinterhalt,EU,CET",
["1091-Twilight's Hammer"]="Twilight's Hammer,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["3674-Twisting Nether"]="Twisting Nether,PVP,enGB,Sturmangriff / Charge,EU,CET",
["1384-Tyrande"]="Tyrande,PVE,esES,Cruelty / Crueldad,EU,CET",
["1122-Uldaman"]="Uldaman,PVE,frFR,Embuscade / Hinterhalt,EU,CET",
["567-Ulduar"]="Ulduar,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1379-Uldum"]="Uldum,PVP,esES,Cruelty / Crueldad,EU,CET",
["1400-Un'Goro"]="Un'Goro,PVE,deDE,Embuscade / Hinterhalt,EU,CET",
["1315-Varimathras"]="Varimathras,PVE,frFR,Misery,EU,CET",
["3656-Vashj"]="Vashj,PVP,enGB,Reckoning / Abrechnung,EU,CET",
["578-Vek'lor"]="Vek'lor,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["1416-Vek'nilash"]="Vek'nilash,PVE,enGB,Glutsturm / Emberstorm,EU,CET",
["510-Vol'jin"]="Vol'jin,PVE,frFR,Embuscade / Hinterhalt,EU,CET",
["1313-Wildhammer"]="Wildhammer,PVE,enGB,Misery,EU,CET",
["578-Wrathbringer"]="Wrathbringer,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
["639-Xavius"]="Xavius,PVP,enGB,Glutsturm / Emberstorm,EU,CET",
["1097-Ysera"]="Ysera,PVE,deDE,Reckoning / Abrechnung,EU,CET",
["1335-Ysondre"]="Ysondre,PVP,frFR,Vengeance / Rache,EU,CET",
["3657-Zenedar"]="Zenedar,PVP,enGB,Cruelty / Crueldad,EU,CET",
["1405-Zirkel des Cenarius"]="Zirkel des Cenarius,RP,deDE,Embuscade / Hinterhalt,EU,CET",
["1379-Zul'jin"]="Zul'jin,PVP,esES,Cruelty / Crueldad,EU,CET",
["1105-Zuluhed"]="Zuluhed,PVP,deDE,Glutsturm / Emberstorm,EU,CET",
--}}
--ALPHA, BETA, PTR
["970-Beta Leveling Realm 01"] = "Beta Leveling Realm 01,PVE,enUS,Ruin,US,EST",
["976-Beta Max Level PvP"] = "Beta Max Level PvP,PVP,enUS,Ruin,US,EST",
["970-Beta Leveling Realm 03"] = "Beta Leveling Realm 03,PVE,enUS,Ruin,US,EST",

--[[ {{ KOREA
="가로나,PVP,koKR,격노의 전장,KR",
="굴단,PVP,koKR,징벌의 전장,KR",
="노르간논,PVP,koKR,징벌의 전장,KR",
="달라란,PVP,koKR,격노의 전장,KR",
="데스윙,PVP,koKR,격노의 전장,KR",
="듀로탄,PVP,koKR,징벌의 전장,KR",
="렉사르,PVE,koKR,격노의 전장,KR",
="말퓨리온,PVP,koKR,격노의 전장,KR",
="불타는 군단,PVE,koKR,격노의 전장,KR",
="세나리우스,PVP,koKR,격노의 전장,KR",
="스톰레이지,PVE,koKR,징벌의 전장,KR",
="아즈샤라,PVP,koKR,징벌의 전장,KR",
="알렉스트라자,PVP,koKR,격노의 전장,KR",
="와일드해머,PVE,koKR,격노의 전장,KR",
="윈드러너,PVE,koKR,징벌의 전장,KR",
="줄진,PVP,koKR,징벌의 전장,KR",
="하이잘,PVP,koKR,격노의 전장,KR",
="헬스크림,PVP,koKR,격노의 전장,KR",
--}} ]]
--[[
--{{ CHINA
="万色星辰,PVE,zhCN,Battle Group 9,CN",
="世界之树,PVE,zhCN,Battle Group 9,CN",
="丹莫德,PVP,zhCN,Battle Group 13,CN",
="主宰之剑,PVP,zhCN,Battle Group 4,CN",
="亚雷戈斯,PVE,zhCN,Battle Group 16,CN",
="亡语者,PVP,zhCN,Battle Group 21,CN",
="伊兰尼库斯,PVP,zhCN,Battle Group 15,CN",
="伊利丹,PVP,zhCN,Battle Group 4,CN",
="伊森利恩,PVP,zhCN,Battle Group 10,CN",
="伊森德雷,PVP,zhCN,Battle Group 16,CN",
="伊瑟拉,PVE,zhCN,Battle Group 2,CN",
="伊莫塔尔,PVP,zhCN,Battle Group 14,CN",
="伊萨里奥斯,PVP,zhCN,Battle Group 10,CN",
="元素之力,PVP,zhCN,Battle Group 10,CN",
="克尔苏加德,PVP,zhCN,Battle Group 8,CN",
="克洛玛古斯,PVP,zhCN,Battle Group 11,CN",
="克苏恩,PVP,zhCN,Battle Group 11,CN",
="军团要塞,PVP,zhCN,Battle Group 17,CN",
="冬拥湖,PVP,zhCN,Battle Group 21,CN",
="冬泉谷,PVP,zhCN,Battle Group 16,CN",
="冰川之拳,PVP,zhCN,Battle Group 15,CN",
="冰霜之刃,PVP,zhCN,Battle Group 3,CN",
="冰风岗,PVP,zhCN,Battle Group 7,CN",
="凤凰之神,PVP,zhCN,Battle Group 17,CN",
="凯尔萨斯,PVP,zhCN,Battle Group 8,CN",
="凯恩血蹄,PVP,zhCN,Battle Group 5,CN",
="利刃之拳,PVP,zhCN,Battle Group 7,CN",
="刺骨利刃,PVP,zhCN,Battle Group 15,CN",
="加兹鲁维,PVP,zhCN,Battle Group 9,CN",
="加基森,PVP,zhCN,Battle Group 13,CN",
="加尔,PVP,zhCN,Battle Group 19,CN",
="加里索斯,PVP,zhCN,Battle Group 13,CN",
="勇士岛,PVP,zhCN,Battle Group 6,CN",
="千针石林,PVP,zhCN,Battle Group 6,CN",
="卡德加,PVP,zhCN,Battle Group 3,CN",
="卡德罗斯,PVP,zhCN,Battle Group 1,CN",
="卡扎克,PVP,zhCN,Battle Group 1,CN",
="卡拉赞,PVP,zhCN,Battle Group 11,CN",
="卡珊德拉,PVP,zhCN,Battle Group 9,CN",
="厄祖玛特,PVP,zhCN,Battle Group 16,CN",
="古加尔,PVP,zhCN,Battle Group 13,CN",
="古尔丹,PVP,zhCN,Battle Group 7,CN",
="古拉巴什,PVP,zhCN,Battle Group 12,CN",
="古达克,PVP,zhCN,Battle Group 21,CN",
="哈兰,PVP,zhCN,Battle Group 17,CN",
="哈卡,PVP,zhCN,Battle Group 12,CN",
="嚎风峡湾,PVP,zhCN,Battle Group 20,CN",
="回音山,PVE,zhCN,Battle Group 1,CN",
="国王之谷,PVP,zhCN,Battle Group 1,CN",
="图拉扬,PVE,zhCN,Battle Group 2,CN",
="圣火神殿,PVP,zhCN,Battle Group 6,CN",
="地狱之石,PVP,zhCN,Battle Group 3,CN",
="地狱咆哮,PVP,zhCN,Battle Group 3,CN",
="埃克索图斯,PVP,zhCN,Battle Group 13,CN",
="埃加洛尔,PVP,zhCN,Battle Group 3,CN",
="埃德萨拉,PVP,zhCN,Battle Group 5,CN",
="埃苏雷格,PVP,zhCN,Battle Group 3,CN",
="埃雷达尔,PVP,zhCN,Battle Group 7,CN",
="基尔加丹,PVP,zhCN,Battle Group 7,CN",
="基尔罗格,PVP,zhCN,Battle Group 1,CN",
="塔纳利斯,PVP,zhCN,Battle Group 14,CN",
="塞拉摩,PVP,zhCN,Battle Group 16,CN",
="塞拉赞恩,PVP,zhCN,Battle Group 14,CN",
="塞泰克,PVP,zhCN,Battle Group 18,CN",
="塞纳里奥,PVE,zhCN,Battle Group 4,CN",
="壁炉谷,PVP,zhCN,Battle Group 19,CN",
="夏维安,PVP,zhCN,Battle Group 4,CN",
="外域,PVP,zhCN,Battle Group 14,CN",
="大地之怒,PVP,zhCN,Battle Group 10,CN",
="大漩涡,PVP,zhCN,Battle Group 14,CN",
="天空之墙,PVP,zhCN,Battle Group 14,CN",
="太阳之井,PVP,zhCN,Battle Group 18,CN",
="夺灵者,PVP,zhCN,Battle Group 16,CN",
="奈法利安,PVP,zhCN,Battle Group 12,CN",
="奈萨里奥,PVP,zhCN,Battle Group 2,CN",
="奎尔丹纳斯,PVP,zhCN,Battle Group 20,CN",
="奎尔萨拉斯,PVP,zhCN,Battle Group 12,CN",
="奥妮克希亚,PVP,zhCN,Battle Group 14,CN",
="奥尔加隆,PVP,zhCN,Battle Group 21,CN",
="奥拉基尔,PVP,zhCN,Battle Group 3,CN",
="奥斯里安,PVP,zhCN,Battle Group 14,CN",
="奥特兰克,PVP,zhCN,Battle Group 7,CN",
="奥蕾莉亚,PVE,zhCN,Battle Group 1,CN",
="奥达曼,PVP,zhCN,Battle Group 1,CN",
="守护之剑,PVP,zhCN,Battle Group 9,CN",
="安其拉,PVP,zhCN,Battle Group 11,CN",
="安加萨,PVP,zhCN,Battle Group 21,CN",
="安多哈尔,PVP,zhCN,Battle Group 10,CN",
="安威玛尔,PVP,zhCN,Battle Group 1,CN",
="安戈洛,PVP,zhCN,Battle Group 14,CN",
="安格博达,PVP,zhCN,Battle Group 21,CN",
="安纳塞隆,PVP,zhCN,Battle Group 11,CN",
="安苏,PVP,zhCN,Battle Group 19,CN",
="密林游侠,PVP,zhCN,Battle Group 10,CN",
="寒冰皇冠,PVP,zhCN,Battle Group 7,CN",
="尘风峡谷,PVP,zhCN,Battle Group 1,CN",
="屠魔山谷,PVP,zhCN,Battle Group 4,CN",
="山丘之王,PVP,zhCN,Battle Group 2,CN",
="巨龙之吼,PVP,zhCN,Battle Group 7,CN",
="巫妖之王,PVP,zhCN,Battle Group 15,CN",
="巴尔古恩,PVP,zhCN,Battle Group 7,CN",
="巴瑟拉斯,PVP,zhCN,Battle Group 13,CN",
="巴纳扎尔,PVP,zhCN,Battle Group 11,CN",
="布兰卡德,PVP,zhCN,Battle Group 9,CN",
="布莱克摩,PVP,zhCN,Battle Group 5,CN",
="布莱恩,PVE,zhCN,Battle Group 13,CN",
="布鲁塔卢斯,PVP,zhCN,Battle Group 19,CN",
="希尔瓦娜斯,PVP,zhCN,Battle Group 8,CN",
="希雷诺斯,PVP,zhCN,Battle Group 18,CN",
="幽暗沼泽,PVP,zhCN,Battle Group 15,CN",
="库尔提拉斯,PVP,zhCN,Battle Group 12,CN",
="库德兰,PVP,zhCN,Battle Group 1,CN",
="弗塞雷迦,PVP,zhCN,Battle Group 3,CN",
="影之哀伤,PVP,zhCN,Battle Group 21,CN",
="影牙要塞,PVP,zhCN,Battle Group 8,CN",
="德拉诺,PVP,zhCN,Battle Group 11,CN",
="恐怖图腾,PVP,zhCN,Battle Group 13,CN",
="恶魔之翼,PVP,zhCN,Battle Group 9,CN",
="恶魔之魂,PVP,zhCN,Battle Group 13,CN",
="戈古纳斯,PVP,zhCN,Battle Group 3,CN",
="戈提克,PVP,zhCN,Battle Group 19,CN",
="战歌,PVP,zhCN,Battle Group 4,CN",
="扎拉赞恩,PVP,zhCN,Battle Group 16,CN",
="托塞德林,PVP,zhCN,Battle Group 14,CN",
="托尔巴拉德,PVP,zhCN,Battle Group 18,CN",
="拉文凯斯,PVP,zhCN,Battle Group 4,CN",
="拉文霍德,PVP,zhCN,Battle Group 12,CN",
="拉格纳洛斯,PVP,zhCN,Battle Group 7,CN",
="拉贾克斯,PVP,zhCN,Battle Group 12,CN",
="提尔之手,PVP,zhCN,Battle Group 10,CN",
="提瑞斯法,PVP,zhCN,Battle Group 8,CN",
="摩摩尔,PVP,zhCN,Battle Group 18,CN",
="斩魔者,PVP,zhCN,Battle Group 9,CN",
="斯坦索姆,PVP,zhCN,Battle Group 8,CN",
="无尽之海,PVP,zhCN,Battle Group 12,CN",
="无底海渊,PVP,zhCN,Battle Group 17,CN",
="日落沼泽,PVP,zhCN,Battle Group 10,CN",
="普瑞斯托,PVE,zhCN,Battle Group 2,CN",
="普罗德摩,PVP,zhCN,Battle Group 6,CN",
="暗影之月,PVP,zhCN,Battle Group 3,CN",
="暗影议会,PVP,zhCN,Battle Group 7,CN",
="暗影迷宫,PVP,zhCN,Battle Group 18,CN",
="暮色森林,PVP,zhCN,Battle Group 10,CN",
="暴风祭坛,PVP,zhCN,Battle Group 1,CN",
="月光林地,PVE,zhCN,Battle Group 4,CN",
="月神殿,PVE,zhCN,Battle Group 4,CN",
="末日祷告祭坛,PVP,zhCN,Battle Group 18,CN",
="末日行者,PVP,zhCN,Battle Group 19,CN",
="朵丹尼尔,PVP,zhCN,Battle Group 10,CN",
="杜隆坦,PVP,zhCN,Battle Group 5,CN",
="格瑞姆巴托,PVP,zhCN,Battle Group 12,CN",
="格雷迈恩,PVP,zhCN,Battle Group 13,CN",
="格鲁尔,PVP,zhCN,Battle Group 17,CN",
="桑德兰,PVP,zhCN,Battle Group 11,CN",
="梅尔加尼,PVP,zhCN,Battle Group 4,CN",
="梦境之树,PVE,zhCN,Battle Group 4,CN",
="森金,PVP,zhCN,Battle Group 12,CN",
="死亡之翼,PVP,zhCN,Battle Group 2,CN",
="死亡熔炉,PVP,zhCN,Battle Group 17,CN",
="毁灭之锤,PVP,zhCN,Battle Group 3,CN",
="水晶之刺,PVP,zhCN,Battle Group 9,CN",
="永夜港,PVE,zhCN,Battle Group 10,CN",
="永恒之井,PVP,zhCN,Battle Group 12,CN",
="沙怒,PVP,zhCN,Battle Group 20,CN",
="法拉希姆,PVP,zhCN,Battle Group 10,CN",
="泰兰德,PVE,zhCN,Battle Group 4,CN",
="泰拉尔,PVP,zhCN,Battle Group 12,CN",
="洛丹伦,PVP,zhCN,Battle Group 12,CN",
="洛肯,PVP,zhCN,Battle Group 21,CN",
="洛萨,PVP,zhCN,Battle Group 2,CN",
="海克泰尔,PVP,zhCN,Battle Group 12,CN",
="海加尔,PVP,zhCN,Battle Group 4,CN",
="海达希亚,PVE,zhCN,Battle Group 12,CN",
="浸毒之骨,PVP,zhCN,Battle Group 9,CN",
="深渊之喉,PVP,zhCN,Battle Group 17,CN",
="深渊之巢,PVP,zhCN,Battle Group 15,CN",
="激流之傲,PVP,zhCN,Battle Group 9,CN",
="激流堡,PVP,zhCN,Battle Group 7,CN",
="火喉,PVP,zhCN,Battle Group 15,CN",
="火烟之谷,PVP,zhCN,Battle Group 15,CN",
="火焰之树,PVP,zhCN,Battle Group 3,CN",
="火羽山,PVP,zhCN,Battle Group 5,CN",
="灰谷,PVP,zhCN,Battle Group 13,CN",
="烈焰峰,PVP,zhCN,Battle Group 2,CN",
="烈焰荆棘,PVP,zhCN,Battle Group 16,CN",
="熊猫酒仙,PVP,zhCN,Battle Group 6,CN",
="熔火之心,PVP,zhCN,Battle Group 11,CN",
="熵魔,PVP,zhCN,Battle Group 19,CN",
="燃烧之刃,PVP,zhCN,Battle Group 6,CN",
="燃烧军团,PVP,zhCN,Battle Group 11,CN",
="燃烧平原,PVP,zhCN,Battle Group 2,CN",
="爱斯特纳,PVP,zhCN,Battle Group 3,CN",
="狂热之刃,PVP,zhCN,Battle Group 9,CN",
="狂风峭壁,PVP,zhCN,Battle Group 5,CN",
="玛多兰,PVE,zhCN,Battle Group 2,CN",
="玛法里奥,PVP,zhCN,Battle Group 4,CN",
="玛洛加尔,PVP,zhCN,Battle Group 21,CN",
="玛瑟里顿,PVP,zhCN,Battle Group 2,CN",
="玛诺洛斯,PVP,zhCN,Battle Group 8,CN",
="玛里苟斯,PVP,zhCN,Battle Group 6,CN",
="瑞文戴尔,PVP,zhCN,Battle Group 8,CN",
="瑟莱德丝,PVP,zhCN,Battle Group 14,CN",
="瓦丝琪,PVP,zhCN,Battle Group 18,CN",
="瓦拉斯塔兹,PVP,zhCN,Battle Group 12,CN",
="瓦里玛萨斯,PVE,zhCN,Battle Group 11,CN",
="甜水绿洲,PVP,zhCN,Battle Group 6,CN",
="生态船,PVP,zhCN,Battle Group 19,CN",
="白银之手,PVE,zhCN,Battle Group 1,CN",
="白骨荒野,PVP,zhCN,Battle Group 19,CN",
="盖斯,PVP,zhCN,Battle Group 19,CN",
="石爪峰,PVP,zhCN,Battle Group 4,CN",
="石锤,PVP,zhCN,Battle Group 16,CN",
="破碎岭,PVP,zhCN,Battle Group 11,CN",
="祖尔金,PVP,zhCN,Battle Group 14,CN",
="祖阿曼,PVP,zhCN,Battle Group 18,CN",
="神圣之歌,PVE,zhCN,Battle Group 10,CN",
="穆戈尔,PVP,zhCN,Battle Group 18,CN",
="符文图腾,PVP,zhCN,Battle Group 5,CN",
="米奈希尔,PVP,zhCN,Battle Group 15,CN",
="索拉丁,PVP,zhCN,Battle Group 2,CN",
="红云台地,PVP,zhCN,Battle Group 5,CN",
="红龙军团,PVP,zhCN,Battle Group 1,CN",
="红龙女王,PVP,zhCN,Battle Group 5,CN",
="纳克萨玛斯,PVP,zhCN,Battle Group 12,CN",
="纳沙塔尔,PVP,zhCN,Battle Group 6,CN",
="织亡者,PVP,zhCN,Battle Group 21,CN",
="罗宁,PVP,zhCN,Battle Group 2,CN",
="羽月,PVE,zhCN,Battle Group 6,CN",
="翡翠梦境,PVE,zhCN,Battle Group 18,CN",
="耐奥祖,PVP,zhCN,Battle Group 8,CN",
="耐普图隆,PVP,zhCN,Battle Group 4,CN",
="耳语海岸,PVE,zhCN,Battle Group 7,CN",
="能源舰,PVP,zhCN,Battle Group 19,CN",
="自由之风,PVP,zhCN,Battle Group 6,CN",
="艾森娜,PVE,zhCN,Battle Group 3,CN",
="艾欧纳尔,PVP,zhCN,Battle Group 7,CN",
="艾维娜,PVE,zhCN,Battle Group 13,CN",
="艾苏恩,PVP,zhCN,Battle Group 1,CN",
="艾莫莉丝,PVP,zhCN,Battle Group 13,CN",
="艾萨拉,PVP,zhCN,Battle Group 3,CN",
="艾露恩,PVE,zhCN,Battle Group 17,CN",
="芬里斯,PVP,zhCN,Battle Group 10,CN",
="苏塔恩,PVP,zhCN,Battle Group 9,CN",
="范克里夫,PVP,zhCN,Battle Group 18,CN",
="范达尔鹿盔,PVP,zhCN,Battle Group 12,CN",
="荆棘谷,PVP,zhCN,Battle Group 14,CN",
="莫德雷萨,PVP,zhCN,Battle Group 21,CN",
="莱索恩,PVP,zhCN,Battle Group 12,CN",
="菲拉斯,PVP,zhCN,Battle Group 13,CN",
="菲米丝,PVP,zhCN,Battle Group 19,CN",
="萨塔里奥,PVP,zhCN,Battle Group 21,CN",
="萨尔,PVP,zhCN,Battle Group 6,CN",
="萨格拉斯,PVP,zhCN,Battle Group 2,CN",
="萨洛拉丝,PVP,zhCN,Battle Group 20,CN",
="萨菲隆,PVP,zhCN,Battle Group 12,CN",
="蓝龙军团,PVP,zhCN,Battle Group 2,CN",
="藏宝海湾,PVP,zhCN,Battle Group 1,CN",
="蜘蛛王国,PVP,zhCN,Battle Group 6,CN",
="血吼,PVP,zhCN,Battle Group 19,CN",
="血牙魔王,PVP,zhCN,Battle Group 6,CN",
="血环,PVP,zhCN,Battle Group 5,CN",
="血羽,PVP,zhCN,Battle Group 11,CN",
="血色十字军,PVP,zhCN,Battle Group 8,CN",
="血顶,PVP,zhCN,Battle Group 13,CN",
="试炼之环,PVP,zhCN,Battle Group 18,CN",
="诺兹多姆,PVE,zhCN,Battle Group 6,CN",
="诺森德,PVP,zhCN,Battle Group 14,CN",
="诺莫瑞根,PVP,zhCN,Battle Group 2,CN",
="贫瘠之地,PVE,zhCN,Battle Group 19,CN",
="踏梦者,PVP,zhCN,Battle Group 10,CN",
="轻风之语,PVE,zhCN,Battle Group 4,CN",
="达克萨隆,PVP,zhCN,Battle Group 21,CN",
="达基萨斯,PVP,zhCN,Battle Group 19,CN",
="达尔坎,PVP,zhCN,Battle Group 19,CN",
="达文格尔,PVP,zhCN,Battle Group 13,CN",
="达斯雷玛,PVP,zhCN,Battle Group 3,CN",
="达纳斯,PVP,zhCN,Battle Group 1,CN",
="达隆米尔,PVP,zhCN,Battle Group 7,CN",
="迅捷微风,PVP,zhCN,Battle Group 9,CN",
="远古海滩,PVP,zhCN,Battle Group 21,CN",
="迦拉克隆,PVE,zhCN,Battle Group 21,CN",
="迦玛兰,PVP,zhCN,Battle Group 15,CN",
="迦罗娜,PVP,zhCN,Battle Group 5,CN",
="迦顿,PVP,zhCN,Battle Group 19,CN",
="迪托马斯,PVP,zhCN,Battle Group 1,CN",
="迪瑟洛克,PVP,zhCN,Battle Group 13,CN",
="逐日者,PVE,zhCN,Battle Group 14,CN",
="通灵学院,PVP,zhCN,Battle Group 8,CN",
="遗忘海岸,PVE,zhCN,Battle Group 8,CN",
="金度,PVP,zhCN,Battle Group 15,CN",
="金色平原,rppvp,zhCN,Battle Group 10,CN",
="铜龙军团,PVP,zhCN,Battle Group 2,CN",
="银月,PVE,zhCN,Battle Group 8,CN",
="银松森林,PVE,zhCN,Battle Group 8,CN",
="闪电之刃,PVP,zhCN,Battle Group 4,CN",
="阿克蒙德,PVP,zhCN,Battle Group 3,CN",
="阿努巴拉克,PVP,zhCN,Battle Group 11,CN",
="阿卡玛,PVP,zhCN,Battle Group 13,CN",
="阿古斯,PVP,zhCN,Battle Group 17,CN",
="阿尔萨斯,PVP,zhCN,Battle Group 7,CN",
="阿扎达斯,PVP,zhCN,Battle Group 13,CN",
="阿拉希,PVP,zhCN,Battle Group 11,CN",
="阿拉索,PVP,zhCN,Battle Group 7,CN",
="阿斯塔洛,PVP,zhCN,Battle Group 19,CN",
="阿曼尼,PVP,zhCN,Battle Group 19,CN",
="阿格拉玛,PVP,zhCN,Battle Group 1,CN",
="阿比迪斯,PVP,zhCN,Battle Group 19,CN",
="阿纳克洛斯,PVP,zhCN,Battle Group 11,CN",
="阿迦玛甘,PVP,zhCN,Battle Group 3,CN",
="雏龙之翼,PVP,zhCN,Battle Group 9,CN",
="雷克萨,PVP,zhCN,Battle Group 6,CN",
="雷斧堡垒,PVP,zhCN,Battle Group 5,CN",
="雷霆之怒,PVP,zhCN,Battle Group 11,CN",
="雷霆之王,PVP,zhCN,Battle Group 2,CN",
="雷霆号角,PVP,zhCN,Battle Group 5,CN",
="霍格,PVP,zhCN,Battle Group 20,CN",
="霜之哀伤,PVE,zhCN,Battle Group 8,CN",
="霜狼,PVP,zhCN,Battle Group 8,CN",
="风暴之怒,PVP,zhCN,Battle Group 3,CN",
="风暴之眼,PVP,zhCN,Battle Group 10,CN",
="风暴之鳞,PVP,zhCN,Battle Group 14,CN",
="风暴峭壁,PVP,zhCN,Battle Group 21,CN",
="风行者,PVP,zhCN,Battle Group 3,CN",
="鬼雾峰,PVP,zhCN,Battle Group 5,CN",
="鲜血熔炉,PVP,zhCN,Battle Group 17,CN",
="鹰巢山,PVP,zhCN,Battle Group 8,CN",
="麦姆,PVP,zhCN,Battle Group 17,CN",
="麦维影歌,PVP,zhCN,Battle Group 4,CN",
="麦迪文,PVE,zhCN,Battle Group 8,CN",
="黄金之路,PVE,zhCN,Battle Group 5,CN",
="黑手军团,PVP,zhCN,Battle Group 11,CN",
="黑暗之矛,PVP,zhCN,Battle Group 5,CN",
="黑暗之门,PVP,zhCN,Battle Group 17,CN",
="黑暗虚空,PVP,zhCN,Battle Group 14,CN",
="黑暗魅影,PVP,zhCN,Battle Group 9,CN",
="黑石尖塔,PVP,zhCN,Battle Group 1,CN",
="黑翼之巢,PVP,zhCN,Battle Group 11,CN",
="黑铁,PVP,zhCN,Battle Group 13,CN",
="黑锋哨站,PVP,zhCN,Battle Group 21,CN",
="黑龙军团,PVP,zhCN,Battle Group 1,CN",
="龙骨平原,PVP,zhCN,Battle Group 11,CN",
--}}
--]]

--{{ TAIWAN
["3663-世界之樹"]="世界之樹,PVE,zhTW,嗜血,TW",
["3663-亞雷戈斯"]="亞雷戈斯,PVE,zhTW,嗜血,TW",
["977-冰霜之刺"]="冰霜之刺,PVP,zhTW,嗜血,TW",
["964-冰風崗哨"]="冰風崗哨,PVP,zhTW,嗜血,TW",
["999-地獄吼"]="地獄吼,PVP,zhTW,嗜血,TW",
["966-夜空之歌"]="夜空之歌,PVP,zhTW,嗜血,TW",
["980-天空之牆"]="天空之牆,PVE,zhTW,嗜血,TW",
["964-寒冰皇冠"]="寒冰皇冠,PVP,zhTW,嗜血,TW",
["964-尖石"]="尖石,PVP,zhTW,嗜血,TW",
["978-屠魔山谷"]="屠魔山谷,PVP,zhTW,嗜血,TW",
["966-巨龍之喉"]="巨龍之喉,PVP,zhTW,嗜血,TW",
["985-憤怒使者"]="憤怒使者,PVP,zhTW,嗜血,TW",
["978-日落沼澤"]="日落沼澤,PVP,zhTW,嗜血,TW",
["963-暗影之月"]="暗影之月,PVE,zhTW,嗜血,TW",
["985-水晶之刺"]="水晶之刺,PVP,zhTW,嗜血,TW",
["999-狂熱之刃"]="狂熱之刃,PVP,zhTW,嗜血,TW",
["963-眾星之子"]="眾星之子,PVE,zhTW,嗜血,TW",
["977-米奈希爾"]="米奈希爾,PVP,zhTW,嗜血,TW",
["980-聖光之願"]="聖光之願,PVE,zhTW,嗜血,TW",
["977-血之谷"]="血之谷,PVP,zhTW,嗜血,TW",
["963-語風"]="語風,PVE,zhTW,嗜血,TW",
["984-銀翼要塞"]="銀翼要塞,PVP,zhTW,嗜血,TW",
["999-阿薩斯"]="阿薩斯,PVP,zhTW,嗜血,TW",
["966-雷鱗"]="雷鱗,PVP,zhTW,嗜血,TW",
--}}

}

------------------------------------------------------------------------

connections = {
--{{ NORTH AMERICA
-- http://us.battle.net/wow/en/blog/11393305
"1136", -- Aegwynn, Bonechewer, Daggerspine, Gurubashi, Hakkar
"1129", -- Agamaggan, Archimonde, Jaedenar, The Underbog - Burning Legion
"106", -- Aggramar, Fizzcrank
"84", -- Akama, Dragonmaw, Mug'thol
"1070", -- Alexstrasza, Terokkar
"52", -- Alleria, Khadgar
"78", -- Altar of Storms, Anetheron, Magtheridon, Ysondre
"71", -- Alterac Mountains, Balnazzar, Gorgonnash, The Forgotten Coast, Warsong
"156", -- Andorhal, Scilla, Ursin, Zuluhed
"116", -- Antonidas, Uldum
"1138", -- Anub'arak, Chromaggus, Crushridge, Garithos, Nathrezim, Smolderthorn
"1174", -- Anvilmar, Undermine
"1165", -- Arathor, Drenden
"75", -- Argent Dawn, The Scryers
"99", -- Arygos, Llane
"101", -- Auchindoun, Cho'gall, Laughing Skull
"77", -- Azgalor, Azshara, Destromath, Thunderlord
"121", -- Azjol-Nerub, Khaz Modan
"160", -- Azuremyst, Staghelm
"1190", -- Baelgun, Doomhammer
"74", -- Black Dragonflight, Gul'dan, Skullcrusher
"54", -- Blackhand, Galakrond
"125", -- Blackwater Raiders, Shadow Council
"154", -- Blackwing Lair, Dethecus, Detheroc, Haomarush, Lethon - Shadowmoon
"1147", -- Bladefist, Kul Tiras
"105", -- Blade's Edge, Thunderhorn
"70", -- Blood Furnace, Mannoroth, Nazjatar
"64", -- Bloodhoof, Duskwood
"119", -- Bloodscalp, Boulderfist, Dunemaul, Maiev, Stonemaul
"85", -- Borean Tundra, Shadowsong
"117", -- Bronzebeard, Shandris
"91", -- Burning Blade, Lightning's Blade, Onyxia
"1430", -- Caelestrasz, Nagrand
"122", -- Cairne, Perenolde
"1169", -- Cenarion Circle, Sisters of Elune
"157", -- Coilfang, Dalvengyr, Dark Iron, Demon Soul, Shattered Hand
"87", -- Darrowmere, Windrunner
"1134", -- Dath'Remar, Khaz'goroth
"1173", -- Dawnbringer, Madoran
"155", -- Deathwing, Executus, Kalecgos, Shattered Halls
"55", -- Dentarg, Whisperwind
"115", -- Draenor, Echo Isles
"114", -- Dragonblight, Fenris
"113", -- Draka, Suramar
"127", -- Drak'Tharon, Firetree, Malorne, Rivendare, Spirestone, Stormscale
"131", -- Drak'thul, Skywall
"1433", -- Dreadmaul, Thaurissan
"63", -- Durotan, Ysera
"47", -- Eitrigg, Shu'halo
"123", -- Eldre'Thalas, Korialstrasz
"67", -- Elune, Gilneas
"96", -- Eonar, Velen
"159", -- Eredar, Gorefiend, Spinebreaker, Wildhammer
"62", -- Exodar, Medivh
"12", -- Farstriders, Silver Hand, Thorium Brotherhood
"118", -- Feathermoon, Scarlet Crusade
"128", -- Frostmane, Ner'zhul, Tortheldrin
"7", -- Frostwolf, Vashj
"1069", -- Ghostlands, Kael'thas
"153", -- Gnomeregan, Moonrunner
"158", -- Greymane, Tanaris
"68", -- Grizzly Hills, Lothar
"3697", -- Gundrak, Jubei'Thos
"53", -- Hellscream, Zangarmarsh
"90", -- Hydraxis, Terenas
"104", -- Icecrown, Malygos
"98", -- Kargath, Norgannon
"4", -- Kilrogg, Winterhoof
"1071", -- Kirin Tor, Sentinels, Steamwheedle Cartel
"163", -- Lightninghoof, Maelstrom, The Venture Co
"1175", -- Malfurion, Trollbane
"1151", -- Misha, Rexxar
"86", -- Mok'Nathal, Silvermoon
"1182", -- Muradin, Nordrassil
"1184", -- Nazgrel, Nesingwary, Vek'nilash
"1185", -- Quel'dorei, Sen'jin
"1072", -- Ravencrest, Uldaman
"164", -- Ravenholdt, Twisting Nether
"151", -- Runetotem, Uther
--}}

--{{ EUROPE
-- Current:  http://eu.battle.net/wow/en/forum/topic/8715582685
-- Upcoming: http://eu.battle.net/wow/en/forum/topic/9582578502

-- ENGLISH
"1081", -- Aerie Peak / Bronzebeard
"1091", -- Agamaggan / Bloodscalp / Crushridge / Emeriss / Hakkar / Twilight's Hammer
"1303", -- Aggra / Grim Batol
"1325", -- Aggramar / Hellscream
"1598", -- Ahn'Qiraj / Balnazzar / Boulderfist / Chromaggus / Daggerspine / Laughing Skull / Shattered Halls / Sunstrider / Talnivarr / Trollbane
"639", -- Al'Akir / Skullcrusher / Xavius
"1082", -- Alonsus / Anachronos / Kul Tiras
"1587", -- Arathor / Hellfire
"3666", -- Aszune / Shadowsong
"1597", -- Auchindoun / Dunemaul / Jaedenar
"1396", -- Azjol-Nerub / Quel'Thalas
"1417", -- Azuremyst / Stormrage
"3657", -- Bladefist / Frostwhisper / Zenedar
"1416", -- Blade's Edge / Vek'nilash-- OCT 8: add 1310 Eonar
"633", -- Bloodfeather / Burning Steppes / Executus / Kor'gall / Shattered Hand
"1080", -- Bloodhoof / Khadgar
"1393", -- Bronze Dragonflight / Nordrassil
"1092", -- Burning Blade / Drak'thul
"1317", -- Darkmoon Faire / Earthen Ring
"3660", -- Darksorrow / Genjuros / Neptulon
"1389", -- Darkspear / Saurfang / Terokkar
"1596", -- Deathwing / Karazhan / Lightning's Blade / The Maelstrom
"1096", -- Defias Brotherhood / Ravenholdt / Scarshield Legion / Sporeggar / The Venture Co
"1084", -- Dentarg / Tarren Mill
"1402", -- Doomhammer / Turalyon
"1588", -- Dragonblight / Ghostlands
"3656", -- Dragonmaw / Haomarush / Spinebreaker / Stormreaver / Vashj
"2074", -- Emerald Dream / Terenas
"1311", -- Kilrogg / Nagrand / Runetotem
"1388", -- Lightbringer / Mazrigos
"1085", -- Moonglade / The Sha'tar -- OCT 8: add 1117 Steamwheedle Cartel
"1313", -- Thunderhorn / Wildhammer

-- FRENCH
"512", -- Arak-arahm / Rashgarroth / Kael'Thas / Throk'Feroth
"1624", -- Arathi / Illidan / Naxxramas / Temple noir
"510", -- Chants éternels / Vol'jin
"1336", -- Cho'gall / Eldre'Thalas / Sinstralis
"1127", -- Confrérie du Thorium / Les Clairvoyants / Les Sentinelles
"1086", -- Conseil des Ombres / Culte de la Rive noire / La Croisade écarlate
"1621", -- Dalaran / Marécage de Zangar
"1122", -- Drek'Thar / Uldaman
"1123", -- Eitrigg / Krasus
"1315", -- Elune / Varimathras
"509", -- Garona / Ner'zhul / Sargeras
"1331", -- Medivh / Suramar

-- GERMAN
"1099", -- Alleria / Rexxar
"1607", -- Alexstrasza / Nethersturm
"568", -- Ambossar / Kargath
"1104", -- Anetheron / Festung der Stürme / Gul'dan / Kil'jaeden / Nathrezim / Rajaxx
"1105", -- Anub'arak / Dalvengyr / Frostmourne / Nazjatar / Zuluhed
"1400", -- Area 52 / Sen'jin / Un'Goro
"578", -- Arthas / Blutkessel / Kel'Thuzad / Vek'lor / Wrathbringer
"1406", -- Arygos / Khaz'goroth
"579", -- Azshara / Krag'jin
"570", -- Baelgun / Lothar
"1327", -- Der Mithrilorden / Der Rat von Dalaran
"612", -- Destromath / Gorgonnash / Mannoroth / Nefarian / Nera'thor
"531", -- Dethecus / Mug'thol / Onyxia / Terrordar / Theradras
"1121", -- Das Syndikat / Der abyssische Rat / Die Arguswacht / Die Todeskrallen / Kult der Verdammten-- OCT 8: add 1619 Das Konsortium
"1118", -- Die ewige Wacht / Die Silberne Hand
"516", -- Die Nachtwache / Forscherliga
"535", -- Durotan / Tirion
"1408", -- Dun Morogh / Norgannon
"1612", -- Echsenkessel / Mal'Ganis / Taerar
"1401", -- Garrosh / Nozdormu / Shattrath
"567", -- Gilneas / Ulduar
"1106", -- Lordaeron / Tichondrius
"3696", -- Madmortem / Proudmoore
"1098", -- Malfurion / Malygos
"1097", -- Malorne / Ysera
"1407", -- Perenolde / Teldrassil
"1405", -- Todeswache / Zirkel des Cenarius

-- SPANISH
"1384", -- Colinas Pardas / Los Errantes / Tyrande
"1385", -- Exodar / Minahonda
"1379", -- Sanguino / Shen'dralar / Uldum / Zul'jin

-- RUSSIAN
"1924", -- Booty Bay (RU) / Deathweaver (RU)
"1609", -- Deepholm (RU) / Razuvious (RU)
"1927", -- Grom (RU) / Thermaplugg (RU)
"1603", -- Lich King (RU) / Greymane (RU)

}
--_G.LRI_RealmInfo=data
--_G.LRI_ConnectedRealms=connection