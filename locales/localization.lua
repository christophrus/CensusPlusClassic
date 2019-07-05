--[[
	CensusPlusClassic for World of Warcraft(tm).
	
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
]]

CENSUS_OPTIONS_SOUNDFILEDEFAULT = "CensusPlusClassic\\Sounds\\CensusComplete" -- "Select default SoundFile number "; - DO NOT LOCALIZE
CENSUSPlusFemale = { };

-- Translations start below

CENSUSPLUS_DRUID = "Druid";
CENSUSPLUS_HUNTER = "Hunter";
CENSUSPLUS_MAGE = "Mage";
CENSUSPLUS_PRIEST = "Priest";
CENSUSPLUS_ROGUE = "Rogue";
CENSUSPLUS_WARLOCK = "Warlock";
CENSUSPLUS_WARRIOR = "Warrior";
CENSUSPLUS_SHAMAN = "Shaman";
CENSUSPLUS_PALADIN = "Paladin";

CENSUSPLUS_DWARF = "Dwarf";
CENSUSPLUS_GNOME = "Gnome";
CENSUSPLUS_HUMAN = "Human";
CENSUSPLUS_NIGHTELF = "Night Elf";

CENSUSPLUS_ORC = "Orc";
CENSUSPLUS_TAUREN = "Tauren";
CENSUSPLUS_TROLL = "Troll";
CENSUSPLUS_UNDEAD = "Undead";

-- Blizzard provided translations THESE MUST BE AFTER THE ENGLISH DEFINITIONS
--.. right or wrong it must match what Blizzard provides
 
 
-- deDE
if ( GetLocale() == "deDE" ) then
	CENSUSPLUS_DRUID = "Druide";
	CENSUSPlusFemale["Druidin"] = "Druide";
	CENSUSPLUS_HUNTER = "Jäger";
	CENSUSPlusFemale["Jägerin"] = "Jäger";
	CENSUSPLUS_MAGE = "Magier";
	CENSUSPlusFemale["Magierin"] = "Magier";
	CENSUSPLUS_PRIEST = "Priester";
	CENSUSPlusFemale["Priesterin"] = "Priester";
	CENSUSPLUS_ROGUE = "Schurke";
	CENSUSPlusFemale["Schurkin"] = "Schurke";
	CENSUSPLUS_WARLOCK = "Hexenmeister";
	CENSUSPlusFemale["Hexenmeisterin"] = "Hexenmeister";
	CENSUSPLUS_WARRIOR = "Krieger";
	CENSUSPlusFemale["Kriegerin"] = "Krieger";
	CENSUSPLUS_SHAMAN = "Schamane";
	CENSUSPlusFemale["Schamanin"] = "Schamane";
	CENSUSPLUS_PALADIN = "Paladin";

	CENSUSPLUS_DWARF = "Zwerg";
  CENSUSPlusFemale["Zwergin"] = "Zwerg";
	CENSUSPLUS_GNOME = "Gnom";
	CENSUSPLUS_HUMAN = "Mensch";
	CENSUSPLUS_NIGHTELF = "Nachtelf";
  CENSUSPlusFemale["Nachtelfe"] = "Nachtelf";

	CENSUSPLUS_ORC = "Orc";
	CENSUSPLUS_TAUREN = "Tauren";
	CENSUSPLUS_TROLL = "Troll";
	CENSUSPLUS_UNDEAD = "Untoter";
  CENSUSPlusFemale["Untote"] = "Untoter";
end

-- esES + esMX
if ( GetLocale() == "esES" or GetLocale() == "esMX" ) then
	CENSUSPLUS_DRUID = "Druida";
	CENSUSPLUS_HUNTER = "Cazador";
	CENSUSPlusFemale["Cazadora"] = "Cazador";
	CENSUSPLUS_MAGE = "Mago";
	CENSUSPlusFemale["Maga"] = "Mago";
	CENSUSPLUS_PRIEST = "Sacerdote";
	CENSUSPlusFemale["Sacerdotisa"] = "Sacerdote";
	CENSUSPLUS_ROGUE = "Pícaro";
	CENSUSPlusFemale["Pícara"] = "Pícaro";
	CENSUSPLUS_WARLOCK = "Brujo";
	CENSUSPlusFemale["Bruja"] = "Brujo";
	CENSUSPLUS_WARRIOR = "Guerrero";
	CENSUSPlusFemale["Guerrera"] = "Guerrero";
	CENSUSPLUS_SHAMAN = "Chamán";
	CENSUSPLUS_PALADIN = "Paladín";

	CENSUSPLUS_DWARF = "Enano";
	CENSUSPlusFemale["Enana"] = "Enano";
	CENSUSPLUS_GNOME = "Gnomo";
	CENSUSPlusFemale["Gnoma"] = "Gnomo";
	CENSUSPLUS_HUMAN = "Humano";
	CENSUSPlusFemale["Humana"] = "Humano";
	CENSUSPLUS_NIGHTELF = "Elfo de la noche";
	CENSUSPlusFemale["Elfa de la noche"] = "Elfo de la noche";

	CENSUSPLUS_ORC = "Orco";
	CENSUSPLUS_TAUREN = "Tauren";
	CENSUSPLUS_TROLL = "Trol";
	CENSUSPLUS_UNDEAD = "No-muerto";
	CENSUSPlusFemale["No-muerta"] = "No-muerto";
end

-- frFR
if ( GetLocale() == "frFR" ) then
	CENSUSPLUS_DRUID = "Druide";
  CENSUSPlusFemale["Druidesse"] = "Druide";
	CENSUSPLUS_HUNTER = "Chasseur";
  CENSUSPlusFemale["Chasseresse"] = "Chasseur";
	CENSUSPLUS_MAGE = "Mage";
	CENSUSPLUS_PRIEST = "Prêtre";
  CENSUSPlusFemale["Prêtresse"] = "Prêtre";
	CENSUSPLUS_ROGUE = "Voleur";
  CENSUSPlusFemale["Voleuse"] = "Voleur";
	CENSUSPLUS_WARLOCK = "Démoniste";
	CENSUSPLUS_WARRIOR = "Guerrier";
  CENSUSPlusFemale["Guerrière"] = "Guerrier";
	CENSUSPLUS_SHAMAN = "Chaman";
  CENSUSPlusFemale["Chamane"] = "Chaman";
	CENSUSPLUS_PALADIN = "Paladin";

	CENSUSPLUS_DWARF = "Nain";
  CENSUSPlusFemale["Naine"] = "Nain";
	CENSUSPLUS_GNOME = "Gnome";
	CENSUSPLUS_HUMAN = "Humain";
  CENSUSPlusFemale["Humaine"] = "Humain";
	CENSUSPLUS_NIGHTELF = "Elfe de la nuit";

	CENSUSPLUS_ORC = "Orc";
  CENSUSPlusFemale["Orque"] = "Orc";
	CENSUSPLUS_TAUREN = "Tauren";
  CENSUSPlusFemale["Taurène"] = "Tauren";
	CENSUSPLUS_TROLL = "Troll";
  CENSUSPlusFemale["Trollesse"] = "Troll";
	CENSUSPLUS_UNDEAD = "Mort-vivant";
  CENSUSPlusFemale["Morte-vivante"] = "Mort-vivant";
end

-- itIT
if ( GetLocale() == "itIT" ) then
	CENSUSPLUS_DRUID = "Druido";
	CENSUSPlusFemale["Druida"] = "Druido";
	CENSUSPLUS_HUNTER = "Cacciatore";
	CENSUSPlusFemale["Cacciatrice"] = "Cacciatore";
	CENSUSPLUS_MAGE = "Mago";
	CENSUSPlusFemale["Maga"] = "Mago";
	CENSUSPLUS_PRIEST = "Sacerdote";
	CENSUSPlusFemale["Sacerdotessa"] = "Sacerdote";
	CENSUSPLUS_ROGUE = "Ladro";
	CENSUSPlusFemale["Ladra"] = "Ladro";
	CENSUSPLUS_WARLOCK = "Stregone";
	CENSUSPlusFemale["Strega"] = "Stregone";
	CENSUSPLUS_WARRIOR = "Guerriero";
	CENSUSPlusFemale["Guerriera"] = "Guerriero";
	CENSUSPLUS_SHAMAN = "Sciamano";
	CENSUSPlusFemale["Sciamana"] = "Sciamano";
	CENSUSPLUS_PALADIN = "Paladino";
	CENSUSPlusFemale["Paladina"] = "Paladino";

	CENSUSPLUS_DWARF = "Nano";
	CENSUSPlusFemale["Nana"] = "Nano";
	CENSUSPLUS_GNOME = "Gnomo";
	CENSUSPlusFemale["Gnoma"] = "Gnomo";
	CENSUSPLUS_HUMAN = "Umano";
	CENSUSPlusFemale["Umana"] = "Umano";
	CENSUSPLUS_NIGHTELF = "Elfo della Notte";
	CENSUSPlusFemale["Elfa della Notte"] = "Elfo della Notte";

	CENSUSPLUS_ORC = "Orco";
	CENSUSPlusFemale["Orchessa"] = "Orco";
	CENSUSPLUS_TAUREN = "Tauren";
	CENSUSPLUS_TROLL = "Troll";
	CENSUSPLUS_UNDEAD = "Non Morto";
	CENSUSPlusFemale["Non Morta"] = "Non Morto";
end

-- koKR
if ( GetLocale() == "koKR" ) then
	CENSUSPLUS_DRUID = "드루이드";
	CENSUSPLUS_HUNTER = "사냥꾼";
	CENSUSPLUS_MAGE = "마법사";
	CENSUSPLUS_PRIEST = "사제";
	CENSUSPLUS_ROGUE = "도적";
	CENSUSPLUS_WARLOCK = "흑마법사";
	CENSUSPLUS_WARRIOR = "전사";
	CENSUSPLUS_SHAMAN = "주술사";
	CENSUSPLUS_PALADIN = "성기사";

	CENSUSPLUS_DWARF = "드워프";
	CENSUSPLUS_GNOME = "노움";
	CENSUSPLUS_HUMAN = "인간";
	CENSUSPLUS_NIGHTELF = "나이트 엘프";

	CENSUSPLUS_ORC = "오크";
	CENSUSPLUS_TAUREN = "타우렌";
	CENSUSPLUS_TROLL = "트롤";
	CENSUSPLUS_UNDEAD = "언데드";
end

-- ptBR
if ( GetLocale() == "ptBR" ) then
	CENSUSPLUS_DRUID = "Druida";
	CENSUSPlusFemale["Druidesa"] = "Druida"
	CENSUSPLUS_HUNTER  = "Caçador";
	CENSUSPlusFemale["Caçadora"]  = "Caçador";
	CENSUSPLUS_MAGE = "Mago";
	CENSUSPlusFemale["Maga"] = "Mago"
	CENSUSPLUS_PRIEST = "Sacerdote";
	CENSUSPlusFemale["Sacerdotisa"] = "Sacerdote"
	CENSUSPLUS_ROGUE = "Ladino";
	CENSUSPlusFemale["Ladina"] = "Ladino"
	CENSUSPLUS_WARLOCK = "Bruxo";
	CENSUSPlusFemale["Bruxa"] = "Bruxo"
	CENSUSPLUS_WARRIOR = "Guerreiro";
	CENSUSPlusFemale["Guerreira"] = "Guerreiro";
	CENSUSPLUS_SHAMAN = "Xamã";
	CENSUSPLUS_PALADIN = "Paladino";
	CENSUSPlusFemale["Paladina"] = "Paladino"


	CENSUSPLUS_DWARF = "Anão";
	CENSUSPlusFemale["Anã"] = "Anão";
	CENSUSPLUS_GNOME = "Gnomo";
	CENSUSPlusFemale["Gnomida"] = "Gnomo";
	CENSUSPLUS_HUMAN = "Humano";
	CENSUSPlusFemale["Humana"] = "Humano";
	CENSUSPLUS_NIGHTELF = "Elfo Noturno";
	CENSUSPlusFemale["Elfa Noturna"] = "Elfo Noturno";

	CENSUSPLUS_ORC = "Orc";
	CENSUSPlusFemale["Orquisa"] = "Orc";
	CENSUSPLUS_TROLL = "Troll";
	CENSUSPlusFemale["Trolesa"] = "Troll";
	CENSUSPLUS_TAUREN = "Tauren";
	CENSUSPlusFemale["Taurena"] = "Tauren";
	CENSUSPLUS_UNDEAD = "Morto-vivo";
	CENSUSPlusFemale["Morta-viva"] = "Morto-vivo";
end

-- ruRU
if ( GetLocale() == "ruRU" ) then
	CENSUSPLUS_DRUID = "Друид";
	CENSUSPLUS_HUNTER = "Охотник";
	CENSUSPlusFemale["Охотница"] = "Охотник";
	CENSUSPLUS_MAGE = "Маг";
	CENSUSPLUS_PRIEST = "Жрец";
	CENSUSPlusFemale["Жрица"] = "Жрец";
	CENSUSPLUS_ROGUE = "Разбойник";
	CENSUSPlusFemale["Разбойница"] = "Разбойник";
	CENSUSPLUS_WARLOCK = "Чернокнижник";
	CENSUSPlusFemale["Чернокнижница"] = "Чернокнижник";
	CENSUSPLUS_WARRIOR = "Воин";
	CENSUSPLUS_SHAMAN = "Шаман";
	CENSUSPlusFemale["Шаманка"] = "Шаман";
	CENSUSPLUS_PALADIN = "Паладин";

	CENSUSPLUS_DWARF = "Дворф";
	CENSUSPlusFemale["Дворфийка"] = "Дворф";
	CENSUSPLUS_GNOME = "Гном";
	CENSUSPlusFemale["Гномка"] = "Гном";
	CENSUSPLUS_HUMAN = "Человек";
	CENSUSPLUS_NIGHTELF = "Ночной эльф";
	CENSUSPlusFemale["Ночная эльфийка"] = "Ночной эльф";

	CENSUSPLUS_ORC = "Орк";
	CENSUSPlusFemale["Орчиха"] = "Орк";
	CENSUSPLUS_TAUREN = "Таурен";
	CENSUSPlusFemale["Тауренка"] = "Таурен";
	CENSUSPLUS_TROLL = "Тролль";
	CENSUSPLUS_UNDEAD = "Нежить";
end

-- zhCN
if ( GetLocale() == "zhCN" ) then
	CENSUSPLUS_DRUID = "德鲁伊";
	CENSUSPLUS_HUNTER = "猎人";
	CENSUSPLUS_MAGE = "法师";
	CENSUSPLUS_PRIEST = "牧师";
	CENSUSPLUS_ROGUE = "潜行者";
	CENSUSPLUS_WARLOCK = "术士";
	CENSUSPLUS_WARRIOR = "战士";
	CENSUSPLUS_SHAMAN = "萨满祭司";
	CENSUSPLUS_PALADIN = "圣骑士";

	CENSUSPLUS_DWARF = "矮人";
	CENSUSPLUS_GNOME = "侏儒";
	CENSUSPLUS_HUMAN = "人类";
	CENSUSPLUS_NIGHTELF = "暗夜精灵";

	CENSUSPLUS_ORC = "兽人";
	CENSUSPLUS_TAUREN = "牛头人";
	CENSUSPLUS_TROLL = "巨魔";
	CENSUSPLUS_UNDEAD = "亡灵";
end

-- zhTW
if ( GetLocale() == "zhTW" ) then
	CENSUSPLUS_DRUID = "德魯伊";
	CENSUSPLUS_HUNTER = "獵人";
	CENSUSPLUS_MAGE = "法師";
	CENSUSPLUS_PRIEST = "牧師";
	CENSUSPLUS_ROGUE = "盜賊";
	CENSUSPLUS_WARLOCK = "術士";
	CENSUSPLUS_WARRIOR = "戰士";
	CENSUSPLUS_SHAMAN = "薩滿";
	CENSUSPLUS_PALADIN = "聖騎士";

	CENSUSPLUS_DWARF = "矮人";
	CENSUSPLUS_GNOME = "地精";
	CENSUSPLUS_HUMAN = "人類";
	CENSUSPLUS_NIGHTELF = "夜精靈";

	CENSUSPLUS_ORC = "獸人";
	CENSUSPLUS_TAUREN = "牛頭人";
	CENSUSPLUS_TROLL = "食人妖";
	CENSUSPLUS_UNDEAD = "不死族";
end

CENSUSPLUS_ACCOUNT_WIDE = "Account wide"
CENSUSPLUS_ACCOUNT_WIDE_ONLY_OPTIONS = "Account Wide Only options"
CENSUSPLUS_AND = " and ";
CENSUSPLUS_AUTOCENSUSOFF = "AutoCensus Mode : OFF";
CENSUSPLUS_AUTOCENSUSON = "AutoCensus Mode : ON";
CENSUSPLUS_AUTOCENSUSTEXT = "Start Census after initial delay"
CENSUSPLUS_AUTOCENSUS_DELAYTIME = "Delay in minutes";
CENSUSPLUS_AUTOCLOSEWHO = "Automatically Close Who";
CENSUSPLUS_AUTOSTARTTEXT = "Auto Start on login when timer less then "
CENSUSPLUS_BADLOCAL_1 = "You appear to have a US Census version, yet your localization is set to French or German or Italian.";
CENSUSPLUS_BADLOCAL_2 = "Please do not upload data to WarcraftRealms until this has been resolved.";
CENSUSPLUS_BADLOCAL_3 = "If this is incorrect, please let Bringoutyourdead know at WoWClassicPopulation.com about your situation so he can make corrections.";
CENSUSPLUS_BUTTON_CHARACTERS = "Show Chars";
CENSUSPLUS_BUTTON_OPTIONS = "Options";
CENSUSPLUS_CCO_OPTIONOVERRIDES = "Option overrides for this character only"
CENSUSPLUS_CENSUSBUTTONANIMIOFF = "CensusButton Animation : OFF";
CENSUSPLUS_CENSUSBUTTONANIMION = "CensusButton Animation : ON";
CENSUSPLUS_CENSUSBUTTONANIMITEXT = "Census button animation"
CENSUSPLUS_CENSUSBUTTONSHOWNOFF = "CensusButton Mode : OFF";
CENSUSPLUS_CENSUSBUTTONSHOWNON = "CensusButton Mode : ON";
CENSUSPLUS_CHARACTERS = "Characters";
CENSUSPLUS_CLASS = "Classes";
CENSUSPLUS_CMDERR_WHO2 = "Who commands should be:  who name level  _ no name found, level is optional";
CENSUSPLUS_CMDERR_WHO2NUM = "Who commands can be: who name  _ no numbers in name";
CENSUSPLUS_CONSECUTIVE = "Consecutive Census: %d";
CENSUSPLUS_CONSECUTIVE_0 = "Consecutive Census: 0";
CENSUSPLUS_FACTION = "Faction: %s";
CENSUSPLUS_FACTIONUNKNOWN = "Faction: Unknown";
CENSUSPLUS_FINISHED = "Finished Taking data. Found %s new characters and saw %s. Took %s.";
CENSUSPLUS_FOUND = "found"
CENSUSPLUS_FOUND_CAP = "Found ";
CENSUSPLUS_GETGUILD = "Click Realm for Guild data";
CENSUSPLUS_HELP_0 = " following command as shown below";
CENSUSPLUS_HELP_1 = " _ Toggle verbose mode off/on";
CENSUSPLUS_HELP_10 = " _ Does Census update of player only.. this is done automatically when /CensusPlusClassic take finishes.";
CENSUSPLUS_HELP_11 = " _ Toggles stealth mode off/on - disables Verbose and all CensusPlusClassic chat messages.";
CENSUSPLUS_HELP_2 = " _ Brings up the Option window";
CENSUSPLUS_HELP_3 = " _ Start a Census snapshot";
CENSUSPLUS_HELP_4 = " _ Stop a Census snapshot";
CENSUSPLUS_HELP_5 = " X  _ Prune the database by removing characters not seen in X days - default X = 30";
CENSUSPLUS_HELP_6 = " X _ Prune the database by removing all characters not seen in X days from servers other than the one you are currently on. - default X = 0";
CENSUSPLUS_HELP_7 = " _  Will display info that matches names.";
CENSUSPLUS_HELP_8 = " _  Will list unguilded characters of that level.";
CENSUSPLUS_HELP_9 = " _  Will set the autocensus timer (to X minutes).";
CENSUSPLUS_ISINBG = "You are currently in a Battleground so a Census cannot be taken";
CENSUSPLUS_ISINPROGRESS = "A CensusPlusClassic is in progress, try again later";
CENSUSPLUS_LANGUAGECHANGED = "Client Language changed, Database purged.";
CENSUSPLUS_LASTSEEN = "Last Seen";
CENSUSPLUS_LASTSEEN_COLON = " Last Seen: ";
CENSUSPLUS_LEVEL = "Levels";
CENSUSPLUS_LOCALE = "Locale : %s";
CENSUSPLUS_LOCALEUNKNOWN = "Locale : Unknown";
CENSUSPLUS_MAXXED = "MAXXED!";
CENSUSPLUS_MSG1 = " Loaded - type /censusplus or /CensusPlusClassic  or /census for valid commands";
CENSUSPLUS_NOCENSUS = "A Census is not currently in progress";
CENSUSPLUS_NOTINFACTION = "Neutral faction - census not allowed"; 
CENSUSPLUS_NOW = " now ";
CENSUSPLUS_OBSOLETEDATAFORMATTEXT = "Old Database format found, Database purged."
CENSUSPLUS_OPTIONS_HEADER = "CensusPlusClassic Options";
CENSUSPLUS_OPTIONS_OVERRIDE = "Override"
CENSUSPLUS_OR = " or ";
CENSUSPLUS_PAUSE = "Pause";
CENSUSPLUS_PAUSECENSUS = "Pause the current census";
CENSUSPLUS_PLAYERS = " players.";
CENSUSPLUS_PLAYFINISHSOUNDNUM = "FinishSound number "
CENSUSPLUS_PLAYFINISHSOUNDOFF = "PlayFinishSound Mode : OFF";
CENSUSPLUS_PLAYFINISHSOUNDON = "PlayFinishSound Mode : ON";
CENSUSPLUS_PROBLEMNAME = "This name is problematic => ";
CENSUSPLUS_PROBLEMNAME_ACTION = ", name skipped.  This message will only be shown once.";
CENSUSPLUS_PROCESSING = "Processing %s characters.";
CENSUSPLUS_PRUNE = "Prune";
CENSUSPLUS_PRUNECENSUS = "Prune the database by removing characters not seen in 30 days.";
CENSUSPLUS_PRUNEINFO = "Pruned %d characters.";
CENSUSPLUS_PURGE = "Purge";
CENSUSPLUS_PURGEDALL = "All Census Data Purged";
CENSUSPLUS_PURGEDATABASE = "Purge the database of all data";
CENSUSPLUS_PURGEMSG = "Purged character database.";
CENSUSPLUS_PURGE_LOCAL_CONFIRM = "Are you sure you wish to PURGE your local database?";
CENSUSPLUS_RACE = "Races";
CENSUSPLUS_REALM = "Realm";
CENSUSPLUS_REALMNAME = "Realm: %s";
CENSUSPLUS_REALMUNKNOWN = "Realm: Unknown";
CENSUSPLUS_SCAN_PROGRESS = "Scan Progress: %d queries in the queue - %s";
CENSUSPLUS_SCAN_PROGRESS_0 = "No Scan In Progress";
CENSUSPLUS_SENDING = "Sending /who %s";
CENSUSPLUS_STEALTHOFF = "Stealth Mode : OFF";
CENSUSPLUS_STEALTHON = "Stealth Mode : ON";
CENSUSPLUS_STOP = "Stop";
CENSUSPLUS_STOPCENSUS_TOOLTIP = "Stop the currently active CensusPlusClassic";
CENSUSPLUS_TAKE = "Take";
CENSUSPLUS_TAKECENSUS = "\nTake a census of players \ncurrently online on this server \nand in this faction";
CENSUSPLUS_TAKINGONLINE = "Taking census of characters online...";
CENSUSPLUS_TEXT = "CensusPlusClassic";
CENSUSPLUS_TOOMANY = "WARNING: Too many characters matching: %s";
CENSUSPLUS_TOOSLOW = "Update too slow! Computer overloaded?Connection problems?";
CENSUSPLUS_TOPGUILD = "Top Guilds By XP";
CENSUSPLUS_TOTALCHAR = "Total Characters: %d";
CENSUSPLUS_TOTALCHAR_0 = "Total Characters: 0";
CENSUSPLUS_TRANSPARENCY = "Census window transparency"
CENSUSPLUS_UNGUILDED = "(Unguilded)";
CENSUSPLUS_UNKNOWNRACE = "Found an unknown race ( ";
CENSUSPLUS_UNKNOWNRACE_ACTION = " ), please tell christophrus at WoWClassicPopulation.com";
CENSUSPLUS_UNPAUSE = "Resume";
CENSUSPLUS_UNPAUSECENSUS = "Resume the current census";
CENSUSPLUS_UPLOAD = "Be sure to upload your CensusPlusClassic data to WoWClassicPopulation.com!";
CENSUSPLUS_USAGE = "Usage:";
CENSUSPLUS_USING_WHOLIB = "Using WhoLib";
CENSUSPLUS_US_LOCALE = "Select if you play on US Servers";
CENSUSPLUS_VERBOSEOFF = "Verbose Mode : OFF";
CENSUSPLUS_VERBOSEON = "Verbose Mode : ON";
CENSUSPLUS_VERBOSE_TOOLTIP = "Deselect to stop the spam!";
CENSUSPLUS_WAITING = "Waiting to send who request...";
CENSUSPLUS_WAS = " was ";
CENSUSPLUS_WHOQUERY = "Who query:"
CENSUSPLUS_WRONGLOCAL_PURGE = "Locale differs from previous setting, purging database.";
CENSUS_BUTTON_TOOLTIP = "Open CensusPlusClassic";
CENSUS_OPTIONS_AUTOCENSUS = "Auto-Census";
CENSUS_OPTIONS_AUTOSTART = "Auto-Start";
CENSUS_OPTIONS_BACKGROUND_TRANSPARENCY_TOOLTIP = "Background transparency - ten steps"
CENSUS_OPTIONS_BUTSHOW = "Show Census Button";
CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE = "Remove Override"
CENSUS_OPTIONS_LOG_BARS = "Logarithmic Level Bars";
CENSUS_OPTIONS_LOG_BARSTEXT = "Enables Logarithmic scaling on display bars"
CENSUS_OPTIONS_SOUNDFILE = "Select User provided SoundFile number ";
CENSUS_OPTIONS_SOUNDFILETEXT = "Select desired .mp3 or .OGG sound file"
CENSUS_OPTIONS_SOUND_ON_COMPLETE = "Play Sound When Done";
CENSUS_OPTIONS_SOUND_TOOLTIP = "Enable Sound then select Sound File";
CENSUS_OPTIONS_STEALTH = "Stealth"
CENSUS_OPTIONS_STEALTH_TOOLTIP = "Stealth mode - no chat messages, disables Verbose"
CENSUS_OPTIONS_TIMER_TOOLTIP = "Sets delay in minutes from the last Census ending."
CENSUS_OPTIONS_VERBOSE = "Verbose";
CENSUS_OPTIONS_VERBOSE_TOOLTIP = "Enables verbose text in chat window, disables Stealth mode"