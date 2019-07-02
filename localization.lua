--[[
	CensusPlusClassic for World of Warcraft(tm).
	
	Copyright 2005 - 2016 Cooper Sellers and WarcraftRealms.com

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
--print("English localization loading")
CENSUS_OPTIONS_SOUNDFILEDEFAULT = "CensusPlusClassic\\Sounds\\CensusComplete" -- "Select default SoundFile number "; - DO NOT LOCALIZE
CENSUSPlusFemale = { };

	-- Translations start below

CENSUSPLUS_TEXT     			 = "CensusPlusClassic";

CENSUSPLUS_MSG1             = " Loaded - type /censusplus or /CensusPlusClassic  or /census for valid commands";
CENSUSPLUS_UPLOAD           = "Be sure to upload your CensusPlusClassic data to WoWClassicPopulation.com!";
CENSUSPLUS_PAUSE            = "Pause";
CENSUSPLUS_UNPAUSE          = "Resume";
CENSUSPLUS_STOP             = "Stop";

CENSUSPLUS_PRUNE			= "Prune";
CENSUSPLUS_PRUNECENSUS		= "Prune the database by removing characters not seen in 30 days.";
CENSUSPLUS_PRUNEINFO		= "Pruned %d characters.";
CENSUSPLUS_PURGEDATABASE    = "Purge the database of all data";
CENSUSPLUS_PURGE            = "Purge";
CENSUSPLUS_PURGEMSG         = "Purged character database.";
CENSUSPLUS_PURGE_LOCAL_CONFIRM = "Are you sure you wish to PURGE your local database?";

CENSUSPLUS_TAKECENSUS       = "Take a census of players \ncurrently online on this server \nand in this faction";
CENSUSPLUS_PAUSECENSUS      = "Pause the current census";
CENSUSPLUS_UNPAUSECENSUS    = "Resume the current census";
CENSUSPLUS_STOPCENSUS_TOOLTIP       = "Stop the currently active CensusPlusClassic";
CENSUSPLUS_ISINPROGRESS     = "A CensusPlusClassic is in progress, try again later";
CENSUSPLUS_TAKINGONLINE     = "Taking census of characters online...";
CENSUSPLUS_NOCENSUS         = "A Census is not currently in progress";
CENSUSPLUS_NOTINFACTION     = "Neutral faction - census not allowed"; 
CENSUSPLUS_FINISHED         = "Finished Taking data. Found %s new characters and saw %s. Took %s.";
CENSUSPLUS_TOOMANY          = "WARNING: Too many characters matching: %s";
CENSUSPLUS_WAITING          = "Waiting to send who request...";
CENSUSPLUS_SENDING          = "Sending /who %s";
CENSUSPLUS_WHOQUERY			= "Who query:"
CENSUSPLUS_FOUND					= "found"

CENSUSPLUS_PROCESSING       = "Processing %s characters.";
CENSUSPLUS_REALM			= "Realm";
CENSUSPLUS_REALMNAME        = "Realm: ";
CENSUSPLUS_CONNECTED		= "Connected:";
CENSUSPLUS_CONNECTED2		= "Additional Connected:";
CENSUSPLUS_CONSECUTIVE		= "Consecutive Census: %d";
CENSUSPLUS_CONSECUTIVE_0	= "Consecutive Census: 0";
CENSUSPLUS_REALMUNKNOWN     = "Realm: Unknown";
CENSUSPLUS_FACTION          = "Faction: %s";
CENSUSPLUS_FACTIONUNKNOWN   = "Faction: Unknown"; -- replace this text with notinfaction above?
CENSUSPLUS_LOCALE           = "Locale : %s";
CENSUSPLUS_LOCALEUNKNOWN    = "Locale : Unknown";
CENSUSPLUS_TOTALCHAR        = "Total Characters: %d";
CENSUSPLUS_TOTALCHAR_0      = "Total Characters: 0";
CENSUSPLUS_TOTALCHARXP      = ""; -- XP Factor: %d
CENSUSPLUS_TOTALCHARXP_0    = ""; -- XP Factor: %d
CENSUSPLUS_SCAN_PROGRESS    = "Scan Progress: %d queries in the queue - %s";
CENSUSPLUS_SCAN_PROGRESS_0  = "No Scan In Progress";
CENSUSPLUS_AUTOCLOSEWHO     = "Automatically Close Who";
CENSUSPLUS_UNGUILDED        = "(Unguilded)";
CENSUSPLUS_TAKE             = "Take";
CENSUSPLUS_GETGUILD			= "Click Realm for Guild data";
CENSUSPLUS_TOPGUILD         = "Top Guilds By XP";
CENSUSPLUS_RACE             = "Races";
CENSUSPLUS_CLASS            = "Classes";
CENSUSPLUS_LEVEL            = "Levels";
CENSUSPLUS_MAXXED			= "MAXXED!";
CENSUSPLUS_GUILDREALM		= "Guild's Realm";
CENSUSPLUS_LASTSEEN			= "Last Seen";

CENSUSPLUS_DRUID            = "Druid";
CENSUSPLUS_HUNTER           = "Hunter";
CENSUSPLUS_MAGE             = "Mage";
CENSUSPLUS_PRIEST           = "Priest";
CENSUSPLUS_ROGUE            = "Rogue";
CENSUSPLUS_WARLOCK          = "Warlock";
CENSUSPLUS_WARRIOR          = "Warrior";
CENSUSPLUS_SHAMAN           = "Shaman";
CENSUSPLUS_PALADIN          = "Paladin";
CENSUSPLUS_DEATHKNIGHT		= "Death Knight";
CENSUSPLUS_MONK             = "Monk";
CENSUSPLUS_DEMONHUNTER 		= "Demon Hunter";

CENSUSPLUS_DWARF            = "Dwarf";
CENSUSPLUS_GNOME            = "Gnome";
CENSUSPLUS_HUMAN            = "Human";
CENSUSPLUS_NIGHTELF         = "Night Elf";
CENSUSPLUS_DRAENEI          = "Draenei";
CENSUSPLUS_WORGEN			= "Worgen";
CENSUSPLUS_APANDAREN        = "Pandaren";
CENSUSPLUS_LIGHTFORGED		= "Lightforged Draenei";
CENSUSPLUS_VOIDELF			= "Void Elf";
CENSUSPLUS_DARKIRON			= "Dark Iron Dwarf";

CENSUSPLUS_ORC              = "Orc";
CENSUSPLUS_TAUREN           = "Tauren";
CENSUSPLUS_TROLL            = "Troll";
CENSUSPLUS_UNDEAD           = "Undead";
CENSUSPLUS_BLOODELF         = "Blood Elf";
CENSUSPLUS_GOBLIN			= "Goblin";
CENSUSPLUS_HPANDAREN        = "Pandaren";
CENSUSPLUS_HIGHMOUNTAIN		= "Highmountain Tauren";
CENSUSPLUS_NIGHTBORNE		= "Nightborne";
CENSUSPLUS_ZANDALARI		= "Zandalari Troll";

-- Blizzard provided translations THESE MUST BE AFTER THE ENGLISH DEFINITIONS
--.. right or wrong it must match what Blizzard provides
--frFR
if ( GetLocale() == "frFR" ) then
--    CENSUSPLUS_DRUID            = "Druide";
    CENSUSPlusFemale["Druidesse"] = "Druide"; 
--    CENSUSPLUS_HUNTER           = "Chasseur";
    CENSUSPlusFemale["Chasseresse"] = "Chasseur"; 
--    CENSUSPLUS_MAGE             = "Mage";
--    CENSUSPLUS_PRIEST           = "Prêtre";
    CENSUSPlusFemale["Prêtresse"] = "Prêtre"; 
--    CENSUSPLUS_ROGUE            = "Voleur";
    CENSUSPlusFemale["Voleuse"] = "Voleur"; 
--    CENSUSPLUS_WARLOCK          = "Démoniste";
--    CENSUSPLUS_WARRIOR          = "Guerrier";
    CENSUSPlusFemale["Guerrière"] = "Guerrier"; 
--    CENSUSPLUS_SHAMAN           = "Chaman";
    CENSUSPlusFemale["Chamane"] = "Chaman"; 
--    CENSUSPLUS_PALADIN          = "Paladin";
	CENSUSPLUS_DEATHKNIGHT		= "Chevalier de la mort";	
--  CENSUSPLUS_MONK             = "Moine";
     CENSUSPlusFemale["Moniale"] = "Moine"; 
--	CENSUSPLUS_DEMONHUNTER		= "Chasseur de démons"; 
    CENSUSPlusFemale["Chasseuse de démons"] = "Chasseur de démons"; 

 --   CENSUSPLUS_DWARF            = "Nain";
    CENSUSPlusFemale["Naine"]   = "Nain";
--    CENSUSPLUS_GNOME            = "Gnome";
 --   CENSUSPLUS_HUMAN            = "Humain";
    CENSUSPlusFemale["Humaine"]   = "Humain";
--    CENSUSPLUS_NIGHTELF         = "Elfe de la nuit";
-- 	  CENSUSPLUS_DRAENEI          = "Draeneï";
--		CENSUSPLUS_WORGEN			= "Worgen";
--		CENSUSPLUS_APANDAREN        = "Pandaren";
    CENSUSPlusFemale["Pandarène"] = "Pandaren"; 
--		CENSUSPLUS_LIGHTFORGED = "Draeneï sancteforge"

--   CENSUSPLUS_ORC              = "Orc";
    CENSUSPlusFemale["Orque"]   = "Orc";
--    CENSUSPLUS_TAUREN           = "Tauren";
    CENSUSPlusFemale["Taurène"] = "Tauren";
 --   CENSUSPLUS_TROLL            = "Troll";
    CENSUSPlusFemale["Trollesse"] = "Troll";
 --   CENSUSPLUS_UNDEAD           = "Mort-vivant";
    CENSUSPlusFemale["Morte-vivante"] = "Mort-vivant";
--	  CENSUSPLUS_BLOODELF         = "Elfe de sang";
--    CENSUSPLUS_GOBLIN           = "Gobelin";
    CENSUSPlusFemale["Gobeline"] = "Gobelin"; 
--		CENSUSPLUS_HPANDAREN        = "Pandaren";  
    CENSUSPlusFemale["Pandarène"] = "Pandaren"; 
--	CENSUSPLUS_HIGHMOUNTAIN = "Tauren de Haut-Roc"
    CENSUSPlusFemale["Taurène de Haut-Roc"] = "Tauren de Haut-Roc"; 
--		CENSUSPLUS_NIGHTBORNE = "Sacrenuit";
--		CENSUSPLUS_VOIDELF = "Elfe du Vide";
end
--
--deDE
--
if ( GetLocale() == "deDE" ) then
--	CENSUSPLUS_DRUID            = "Druide";
	CENSUSPlusFemale["Druidin"] = "Druide";
--	CENSUSPLUS_HUNTER           = "Jäger";
	CENSUSPlusFemale["Jägerin"] = "Jäger";
--	CENSUSPLUS_MAGE             = "Magier";
	CENSUSPlusFemale["Magierin"] = "Magier";
--	CENSUSPLUS_PRIEST           = "Priester";
	CENSUSPlusFemale["Priesterin"] = "Priester";
--	CENSUSPLUS_ROGUE            = "Schurke";
	CENSUSPlusFemale["Schurkin"] = "Schurke";
--	CENSUSPLUS_WARLOCK          = "Hexenmeister";
	CENSUSPlusFemale["Hexenmeisterin"] = "Hexenmeister";
--	CENSUSPLUS_WARRIOR          = "Krieger";
	CENSUSPlusFemale["Kriegerin"] = "Krieger";
--	CENSUSPLUS_SHAMAN           = "Schamane";
	CENSUSPlusFemale["Schamanin"] = "Schamane";
--	CENSUSPLUS_PALADIN          = "Paladin"; 
	CENSUSPLUS_DEATHKNIGHT		= "Todesritter";
--  CENSUSPLUS_MONK             = "Mönch";
--	CENSUSPLUS_DEMONHUNTER		= "Dämonenjäger"; 
    CENSUSPlusFemale["Dämonenjägerin"] = "Dämonenjäger"; 

--	CENSUSPLUS_DWARF            = "Zwerg"; 
    CENSUSPlusFemale["Zwergin"]  = "Zwerg"; 	
--	CENSUSPLUS_GNOME            = "Gnom"; 
--	CENSUSPLUS_HUMAN            = "Mensch"; 
--	CENSUSPLUS_NIGHTELF         = "Nachtelf"; 
    CENSUSPlusFemale["Nachtelfe"]  = "Nachtelf"; 	
--	CENSUSPLUS_DRAENEI          = "Draenei";
--  CENSUSPLUS_APANDAREN        = "Pandaren";
-- CENSUSPLUS_NIGHTBORNE = "Nachtgeborener"
    CENSUSPlusFemale["Nachtgeborene"]  = "Nachtgeborener"; 	

-- CENSUSPLUS_LIGHTFORGED = "Lichtgeschmiedeter Draenei"
    CENSUSPlusFemale["Lichtgeschmiedete Draenei"]  = "Lichtgeschmiedeter Draenei"; 	
-- CENSUSPLUS_VOIDELF = "Leerenelf"
    CENSUSPlusFemale["Leerenelfe"]  = "Leerenelf"; 	

--	CENSUSPLUS_ORC              = "Orc"; 
--	CENSUSPLUS_TAUREN           = "Tauren"; 
--	CENSUSPLUS_TROLL            = "Troll"; 
--	CENSUSPLUS_UNDEAD           = "Untoter";   
    CENSUSPlusFemale["Untote"]  = "Untoter"; 	
--	CENSUSPLUS_BLOODELF         = "Blutelf";
    CENSUSPlusFemale["Blutelfe"]  = "Blutelf";
--  CENSUSPLUS_GOBLIN			= "Goblin";
-- CENSUSPLUS_HPANDAREN        = "Pandaren"; 	
--CENSUSPLUS_HIGHMOUNTAIN = "Hochbergtauren"

end
--
--ptBR
--
if ( GetLocale() == "ptBR" ) then
--CENSUSPLUS_DRUID = "Druida";
CENSUSPlusFemale["Druidesa"] = "Druida"
--CENSUSPLUS_HUNTER = "Caçador";
CENSUSPlusFemale["Caçadora"] = "Caçador";
--CENSUSPLUS_MAGE = "Mago";
CENSUSPlusFemale["Maga"] = "Mago"
--CENSUSPLUS_PRIEST = "Sacerdote";
CENSUSPlusFemale["Sacerdotisa"] = "Sacerdote"
--CENSUSPLUS_ROGUE = "Ladino";
CENSUSPlusFemale["Ladina"] = "Ladino"
--CENSUSPLUS_WARLOCK = "Bruxo";
CENSUSPlusFemale["Bruxa"] = "Bruxo"
--CENSUSPLUS_WARRIOR = "Guerreiro";
CENSUSPlusFemale["Guerreira"] = "Guerreiro";
--CENSUSPLUS_SHAMAN = "Xamã";
--CENSUSPLUS_PALADIN = "Paladino";
CENSUSPlusFemale["Paladina"] = "Paladino"
--CENSUSPLUS_DEATHKNIGHT = "Cavaleiro da Morte";
CENSUSPlusFemale["Cavaleira da Morte"] = "Cavaleiro da Morte"
--CENSUSPLUS_MONK   = "Monge";
CENSUSPlusFemale["Monja"] = "Monge"; 
--	CENSUSPLUS_DEMONHUNTER		= "Caçador de Demônios"; 
CENSUSPlusFemale["Caçadora de Demônios"] = "Caçador de Demônios"; 


--CENSUSPLUS_DWARF = "Anão";
CENSUSPlusFemale["Anã"] = "Anão";
--CENSUSPLUS_GNOME = "Gnomo";
CENSUSPlusFemale["Gnomida"] = "Gnomo";
--CENSUSPLUS_HUMAN = "Humano";
CENSUSPlusFemale["Humana"] = "Humano";
--CENSUSPLUS_NIGHTELF = "Elfo Noturno";
CENSUSPlusFemale["Elfa Noturna"] = "Elfo Noturno";
-- CENSUSPLUS_DRAENEI = "Draenei";
CENSUSPlusFemale["Draenaia"] = "Draenei";
--CENSUSPLUS_WORGEN			= "Worgen/Worgenin";
CENSUSPlusFemale["Worgenin"] = "Worgen"
-- CENSUSPLUS_APANDAREN        = "Pandaren";  
CENSUSPlusFemale["Pandarena"] = "Pandaren"; 
--CENSUSPLUS_LIGHTFORGED = "Draenei Forjado a Luz"
CENSUSPlusFemale["Draenaia Forjada a Luz"] = "Draenei Forjado a Luz"; 
--CENSUSPLUS_VOIDELF = "Elfo Caótico"
CENSUSPlusFemale["Elfa Caótica"] = "Elfo Caótico"; 

-- CENSUSPLUS_ORC = "Orc";
CENSUSPlusFemale["Orquisa"] = "Orc";
-- CENSUSPLUS_TROLL = "Troll";
CENSUSPlusFemale["Trolesa"] = "Troll";
-- CENSUSPLUS_TAUREN = "Tauren";
CENSUSPlusFemale["Taurena"] = "Tauren";
--CENSUSPLUS_UNDEAD = "Morto-vivo";
CENSUSPlusFemale["Morta-viva"] = "Morto-vivo";
--CENSUSPLUS_BLOODELF = "Elfo sangrento";
CENSUSPlusFemale["Elfa Sangrenta"] = "Elfo sangrento";
-- CENSUSPLUS_GOBLIN   = "Goblin";
CENSUSPlusFemale["Goblina"] = "Goblin"; 
-- CENSUSPLUS_HPANDAREN        = "Pandaren";  
CENSUSPlusFemale["Pandarena"] = "Pandaren"; 
-- CENSUSPLUS_NIGHTBORNE = "Filho da Noite"
CENSUSPlusFemale["Filha da Noite"] = "Filho da Noite"; 
-- CENSUSPLUS_HIGHMOUNTAIN = "Tauren Altamontês"
CENSUSPlusFemale["Taurena Altamontesa"] = "Tauren Altamontês"; 

end	
	
--
--itIT
--
if ( GetLocale() == "itIT" ) then
CENSUSPLUS_DRUID            = "Druido";
CENSUSPlusFemale["Druida"] = "Druido";
CENSUSPLUS_HUNTER           = "Cacciatore";
CENSUSPlusFemale["Cacciatrice"] = "Cacciatore";
CENSUSPLUS_MAGE             = "Mago";
CENSUSPlusFemale["Maga"] = "Mago";
CENSUSPLUS_PRIEST           = "Sacerdote";
CENSUSPlusFemale["Sacerdotessa"] = "Sacerdote";
CENSUSPLUS_ROGUE            = "Ladro";
CENSUSPlusFemale["Ladra"] = "Ladro";
CENSUSPLUS_WARLOCK          = "Stregone";
CENSUSPlusFemale["Strega"] = "Stregone";
CENSUSPLUS_WARRIOR          = "Guerriero";
CENSUSPlusFemale["Guerriera"] = "Guerriero";
CENSUSPLUS_SHAMAN           = "Sciamano";
CENSUSPlusFemale["Sciamana"] = "Sciamano";
CENSUSPLUS_PALADIN          = "Paladino";
CENSUSPlusFemale["Paladina"] = "Paladino";
CENSUSPLUS_DEATHKNIGHT		= "Cavaliere della Morte";
CENSUSPLUS_MONK             = "Monaco";
CENSUSPlusFemale["Monaca"] = "Monaco";
CENSUSPLUS_DEMONHUNTER		= "Cacciatore di Demoni"; 
CENSUSPlusFemale["Cacciatrice di Demoni"] = "Cacciatore di Demoni"; 

CENSUSPLUS_DWARF            = "Nano";
CENSUSPlusFemale["Nana"] = "Nano";
CENSUSPLUS_GNOME            = "Gnomo";
CENSUSPlusFemale["Gnoma"] = "Gnomo";
CENSUSPLUS_HUMAN            = "Umano";
CENSUSPlusFemale["Umana"] = "Umano";
CENSUSPLUS_NIGHTELF         = "Elfo della Notte";
CENSUSPlusFemale["Elfa della Notte"] = "Elfo della Notte";
CENSUSPLUS_WORGEN			= "Worgen";
CENSUSPLUS_APANDAREN        = "Pandaren";
CENSUSPLUS_LIGHTFORGED		= "Draenei Forgialuce";
CENSUSPLUS_VOIDELF			= "Elfo del Vuoto";
CENSUSPlusFemale["Elfa del Vuoto"] = "Elfo del Vuoto";
CENSUSPLUS_DARKIRON			= "Dark Iron Dwarf";

CENSUSPLUS_ORC              = "Orco";
CENSUSPlusFemale["Orchessa"] = "Orco";
CENSUSPLUS_TAUREN           = "Tauren";
CENSUSPLUS_TROLL            = "Troll";
CENSUSPLUS_UNDEAD           = "Non Morto";
CENSUSPlusFemale["Non Morta"] = "Non Morto";
CENSUSPLUS_DRAENEI          = "Draenei";
CENSUSPLUS_BLOODELF         = "Elfo del Sangue";
CENSUSPlusFemale["Elfa del Sangue"] = "Elfo del Sangue";
CENSUSPLUS_GOBLIN			= "Goblin";
CENSUSPLUS_HPANDAREN        = "Pandaren";
CENSUSPLUS_HIGHMOUNTAIN		= "Tauren di Alto Monte";
CENSUSPLUS_NIGHTBORNE		= "Nobile Oscuro";
CENSUSPlusFemale["Nobile Oscura"] = "Nobile Oscuro";
CENSUSPLUS_ZANDALARI		= "Zandalari Troll";

end
--
--esES
--
if ( GetLocale() == "esES" or GetLocale() == "esMX" ) then
  CENSUSPLUS_DRUID            = "Druida";
   CENSUSPLUS_HUNTER           = "Cazador";
   CENSUSPlusFemale["Cazadora"] = "Cazador"; 
   CENSUSPLUS_MAGE             = "Mago"; 
   CENSUSPlusFemale["Maga"] = "Mago"; 
   CENSUSPLUS_PRIEST           = "Sacerdote"; 
   CENSUSPlusFemale["Sacerdotisa"] = "Sacerdote"; 
   CENSUSPLUS_ROGUE            = "Pícaro"; 
   CENSUSPlusFemale["Pícara"] = "Pícaro"; 
   CENSUSPLUS_WARLOCK          = "Brujo"; 
   CENSUSPlusFemale["Bruja"] = "Brujo"; 
   CENSUSPLUS_WARRIOR          = "Guerrero"; 
   CENSUSPlusFemale["Guerrera"] = "Guerrero"; 
   CENSUSPLUS_SHAMAN           = "Chamán";
   CENSUSPLUS_PALADIN          = "Paladín";
	 CENSUSPLUS_DEATHKNIGHT		= "Caballero de la Muerte";
		CENSUSPLUS_MONK             = "Monje";
CENSUSPLUS_DEMONHUNTER		= "Cazador de demonios"; 
CENSUSPlusFemale["Cazadora de demonios"] = "Cazador de demonios"; 

   CENSUSPLUS_DWARF            = "Enano"; 
   CENSUSPlusFemale["Enana"] = "Enano"; 
   CENSUSPLUS_GNOME            = "Gnomo"; 
   CENSUSPlusFemale["Gnoma"] = "Gnomo"; 
   CENSUSPLUS_HUMAN            = "Humano"; 
   CENSUSPlusFemale["Humana"] = "Humano"; 
   CENSUSPLUS_NIGHTELF         = "Elfo de la noche"; 
   CENSUSPlusFemale["Elfa de la noche"] = "Elfo de la noche"; 
--   CENSUSPLUS_DRAENEI          = "Draenei";
   CENSUSPLUS_WORGEN              = "Huargen";
--   CENSUSPLUS_APANDAREN        = "Pandaren";
CENSUSPLUS_LIGHTFORGED		= "Draenei forjado por la Luz";
   CENSUSPlusFemale["Draenei forjada por la Luz"] = "Draenei forjado por la Luz"; 
CENSUSPLUS_VOIDELF			= "Elfo del Vacío";
   CENSUSPlusFemale["Elfa del Vacío"] = "Elfo del Vacío"; 
CENSUSPLUS_DARKIRON			= "Dark Iron Dwarf";

   CENSUSPLUS_ORC              = "Orco";
--   CENSUSPLUS_TAUREN           = "Tauren"; 
   CENSUSPLUS_TROLL            = "Trol";
   CENSUSPLUS_UNDEAD           = "No-muerto"; 
   CENSUSPlusFemale["No-muerta"] = "No-muerto"; 
   CENSUSPLUS_BLOODELF         = "Elfo de sangre";
   CENSUSPlusFemale["Elfa de sangre"] = "Elfo de sangre"; 
--   CENSUSPLUS_GOBLIN              = "Goblin";
--   CENSUSPLUS_HPANDAREN        = "Pandaren";
CENSUSPLUS_HIGHMOUNTAIN		= "Tauren Monte Alto";
CENSUSPLUS_NIGHTBORNE		= "Nocheterna";
CENSUSPLUS_ZANDALARI		= "Zandalari Troll";

end


CENSUSPLUS_US_LOCALE		= "Select if you play on US Servers";
CENSUSPLUS_EU_LOCALE		= "Select if you play on EURO Servers";
CENSUSPLUS_LOCALE_SELECT	= "Select if you play on US or EURO servers";
CENSUSPLUS_OPTIONS_OVERRIDE	= "Override"
CENSUSPLUS_BUTTON_OPTIONS	= "Options";
CENSUSPLUS_OPTIONS_HEADER	= "CensusPlusClassic Options";
CENSUSPLUS_ACCOUNT_WIDE		= "Account wide"
CENSUSPLUS_ACCOUNT_WIDE_ONLY_OPTIONS		= "Account Wide Only options"
CENSUSPLUS_CCO_OPTIONOVERRIDES = "Option overrides for this character only"
CENSUSPLUS_ISINBG			= "You are currently in a Battleground so a Census cannot be taken";
CENSUS_OPTIONS_BUTSHOW      = "Show Census Button";
CENSUS_OPTIONS_AUTOCENSUS   = "Auto-Census";
CENSUS_OPTIONS_AUTOSTART    = "Auto-Start";
CENSUS_OPTIONS_VERBOSE      = "Verbose";
CENSUS_OPTIONS_VERBOSE_TOOLTIP	= "Enables verbose text in chat window, disables Stealth mode"
CENSUS_OPTIONS_STEALTH = "Stealth"
CENSUS_OPTIONS_STEALTH_TOOLTIP	= "Stealth mode - no chat messages, disables Verbose"
CENSUS_OPTIONS_SOUND_ON_COMPLETE = "Play Sound When Done";
CENSUS_OPTIONS_SOUND_TOOLTIP = "Enable Sound then select Sound File";
CENSUS_OPTIONS_SOUNDFILE = "Select User provided SoundFile number ";
CENSUS_OPTIONS_SOUNDFILETEXT = "Select desired .mp3 or .OGG sound file"
CENSUS_OPTIONS_TIMER_TOOLTIP = "Sets delay in minutes from the last Census ending."
CENSUS_OPTIONS_LOG_BARS		= "Logarithmic Level Bars";
CENSUS_OPTIONS_LOG_BARSTEXT		= "Enables Logarithmic scaling on display bars"
CENSUS_OPTIONS_BACKGROUND_TRANSPARENCY_TOOLTIP = "Background transparency - ten steps"
CENSUSPLUS_VERBOSE_TOOLTIP  = "Deselect to stop the spam!";
CENSUSPlus_AUTOCENSUS_TOOLTIP = "Enable CensusPlusClassic to run automatically while playing";
CENSUSPLUS_OPTIONS_CHATTYCONFIRM = "Chatty Option confirmation - check to enable"
CENSUSPLUS_OPTIONS_CHATTY_TOOLTIP = "Enable chat to show current options settings - displays on interface options window opening and many CensusPlusClassic option changes"

CENSUSPLUS_BUTTON_CHARACTERS = "Show Chars";
CENSUSPLUS_CHARACTERS		= "Characters";

CENSUS_BUTTON_TOOLTIP		= "Open CensusPlusClassic";
-- >6.1.2
-- CensusPlus_
CENSUSPLUS_PROBLEMNAME  = "This name is problematic => ";
CENSUSPLUS_PROBLEMNAME_ACTION	= ", name skipped.  This message will only be shown once.";
CENSUSPLUS_BADLOCAL_1	= "You appear to have a US Census version, yet your localization is set to French or German or Italian.";
CENSUSPLUS_BADLOCAL_2	= "Please do not upload data to WarcraftRealms until this has been resolved.";
CENSUSPLUS_BADLOCAL_3	= "If this is incorrect, please let Bringoutyourdead know at WoWClassicPopulation.com about your situation so he can make corrections.";
CENSUSPLUS_WRONGLOCAL_PURGE	= "Locale differs from previous setting, purging database.";
CENSUSPLUS_WAS	= " was ";
CENSUSPLUS_NOW	= " now ";
CENSUSPLUS_USING_WHOLIB	= "Using WhoLib";
CENSUSPLUS_LASTSEEN_COLON	= " Last Seen: ";
CENSUSPLUS_FOUND_CAP	= "Found ";
CENSUSPLUS_PLAYERS	= " players.";
CENSUSPLUS_AND	= " and ";
CENSUSPLUS_OR	= " or ";
CENSUSPLUS_USAGE	= "Usage:";
CENSUSPLUS_STEALTHON	= "Stealth Mode : ON";
CENSUSPLUS_STEALTHOFF	= "Stealth Mode : OFF";
CENSUSPLUS_VERBOSEON	= "Verbose Mode : ON";
CENSUSPLUS_VERBOSEOFF	= "Verbose Mode : OFF";
CENSUSPLUS_CENSUSBUTTONSHOWNON = "CensusButton Mode : ON";
CENSUSPLUS_CENSUSBUTTONSHOWNOFF = "CensusButton Mode : OFF";
CENSUSPLUS_CENSUSBUTTONANIMION = "CensusButton Animation : ON";
CENSUSPLUS_CENSUSBUTTONANIMIOFF = "CensusButton Animation : OFF";
CENSUSPLUS_CENSUSBUTTONANIMITEXT = "Census button animation"
CENSUSPLUS_AUTOCENSUSON		= "AutoCensus Mode : ON";
CENSUSPLUS_AUTOCENSUSOFF	= "AutoCensus Mode : OFF";
CENSUSPLUS_AUTOCENSUSTEXT	= "Start Census after initial delay"
CENSUSPLUS_AUTOCENSUS_DELAYTIME		= "Delay in minutes";
CENSUSPLUS_AUTOSTARTTEXT	= "Auto Start on login when timer less then "
CENSUSPLUS_PLAYFINISHSOUNDON	= "PlayFinishSound Mode : ON";
CENSUSPLUS_PLAYFINISHSOUNDOFF	= "PlayFinishSound Mode : OFF";
CENSUSPLUS_PLAYFINISHSOUNDNUM	= "FinishSound number "
CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE	= "Remove Override"
CENSUSPLUS_UNKNOWNRACE	= "Found an unknown race ( ";
CENSUSPLUS_UNKNOWNRACE_ACTION	= " ), please tell Bringoutyourdead at WarcraftRealms.com";
CENSUSPLUS_TOOSLOW	= "Update too slow! Computer overloaded?Connection problems?";
CENSUSPLUS_LANGUAGECHANGED	= "Client Language changed, Database purged.";
CENSUSPLUS_CONNECTEDREALMSFOUND	= "CensusPlusClassic found the following Connected Realms";
CENSUSPLUS_OBSOLETEDATAFORMATTEXT	= "Old Database format found, Database purged."
CENSUSPLUS_TRANSPARENCY = "Census window transparency"
CENSUSPLUS_PURGEDALL	= "All Census Data Purged";
CENSUSPLUS_HELP_0	= " following command as shown below";
CENSUSPLUS_HELP_1	= " _ Toggle verbose mode off/on";
CENSUSPLUS_HELP_2	= " _ Brings up the Option window";
CENSUSPLUS_HELP_3	= " _ Start a Census snapshot";
CENSUSPLUS_HELP_4	= " _ Stop a Census snapshot";
CENSUSPLUS_HELP_5	= " X  _ Prune the database by removing characters not seen in X days - default X = 30";
CENSUSPLUS_HELP_6	= " X _ Prune the database by removing all characters not seen in X days from servers other than the one you are currently on. - default X = 0";
CENSUSPLUS_HELP_7	= " _  Will display info that matches names.";
CENSUSPLUS_HELP_8	= " _  Will list unguilded characters of that level.";
CENSUSPLUS_HELP_9	= " _  Will set the autocensus timer (to X minutes).";
CENSUSPLUS_HELP_10	= " _ Does Census update of player only.. this is done automatically when /CensusPlusClassic take finishes.";
CENSUSPLUS_HELP_11	= " _ Toggles stealth mode off/on - disables Verbose and all CensusPlusClassic chat messages.";
CENSUSPLUS_CMDERR_WHO2NUM	= "Who commands can be: who name  _ no numbers in name";
CENSUSPLUS_CMDERR_WHO2	= "Who commands should be:  who name level  _ no name found, level is optional";
-- CensusPlus_
--playerlist.lua

--[[ obsolete

i.f ( GetLocale() == "frFR" ) th.en
	

if ( GetLocale() == "esES" ) then
	--  Thanks to NeKRoMaNT  EU-Zul'jin   < contacto@nekromant.com> for the Spanish Translation

	CENSUSPLUS_TEXT      = "CensusPlusClassic";

	CENSUSPLUS_MSG1             = " operativo - Escribe /censusplus o /CensusPlusClassic para abrir la ventana principal";
	CENSUSPLUS_UPLOAD           = "¡Asegúrate de enviar tus datos a WoWClassicPopulation.com!";
	CENSUSPLUS_PAUSE            = "Pausa";
	CENSUSPLUS_UNPAUSE          = "Continuar";
	CENSUSPLUS_STOP             = "Detener";

	CENSUSPLUS_PRUNE            = "Resetear";
	CENSUSPLUS_PRUNECENSUS      = "Optimiza la base de datos borrando personajes sin censar en los últimos 30 días";
--CENSUSPLUS_PRUNEINFO		= "Pruned %d characters.";
	CENSUSPLUS_PURGEDATABASE    = "Purgar la base de datos.";
	CENSUSPLUS_PURGE            = "Purgar";
	CENSUSPLUS_PURGEMSG         = "Base de datos de personajes purgada.";
--CENSUSPLUS_PURGE_LOCAL_CONFIRM = "Are you sure you wish to PURGE your local database?";

	CENSUSPLUS_TAKECENSUS       = "Realizar un censo de jugadores \nconectados en este servidor \ny en esta facción";
	CENSUSPLUS_PAUSECENSUS      = "Pausar el censo actual";
	CENSUSPLUS_UNPAUSECENSUS    = "Continuar el censo actual";
	CENSUSPLUS_STOPCENSUS       = "Detener el censo actual";
	CENSUSPLUS_ISINPROGRESS     = "Censo en progreso, vuelve a intentarlo mas tarde";
	CENSUSPLUS_TAKINGONLINE     = "Realizando censo de personajes conectados...";
	CENSUSPLUS_NOCENSUS         = "No hay ningún censo activo";
CENSUSPLUS_NOTINFACTION     = "Facción neutral - no permitió censo"; 
	CENSUSPLUS_FINISHED         = "Se ha terminado de recoger datos. Encontrados %s nuevos personajes y %s actualizados. Duración %s.";
	CENSUSPLUS_TOOMANY          = "AVISO: Demasiadas coincidencias: %s";
	CENSUSPLUS_WAITING          = "Esperando a enviar petición /quien...";
	CENSUSPLUS_SENDING          = "Enviando /quien %s";
CENSUSPLUS_WHOQUERY			= "Who query:"
CensusPlus_FOUND					= "found"

	CENSUSPLUS_PROCESSING       = "Procesando %s personajes.";

	CENSUSPLUS_REALMNAME        = "Servidor: ";
	CENSUSPLUS_REALMUNKNOWN     = "ServidorReino: Desconocido";
	CENSUSPLUS_CONNECTED		= "Conectados: ";
	CENSUSPLUS_FACTION          = "Facción: %s";
	CENSUSPLUS_FACTIONUNKNOWN   = "Facción: Desconocida";
	CENSUSPLUS_LOCALE           = "Región : %s";
	CENSUSPLUS_LOCALEUNKNOWN    = "Región : Desconocida";
	CENSUSPLUS_TOTALCHAR        = "Personajes Totales: %d";
	CENSUSPLUS_TOTALCHAR_0      = "Personajes Totales: 0";
--CENSUSPLUS_TOTALCHARXP      = "XP Factor: %d";
--CENSUSPLUS_TOTALCHARXP_0    = "XP Factor: 0";
	CENSUSPLUS_AUTOCLOSEWHO     = "Cerrar Quien Automático";
	CENSUSPLUS_UNGUILDED        = "(Sin Hermandad)";
	CENSUSPLUS_TAKE             = "Comenzar";
	CENSUSPLUS_TOPGUILD         = "Clanes por Experiencia";
	CENSUSPLUS_RACE             = "Razas";
	CENSUSPLUS_CLASS            = "Clases";
	CENSUSPLUS_LEVEL            = "Niveles";
	
   CENSUSPLUS_DRUID            = "Druida";
   CENSUSPLUS_HUNTER           = "Cazador";
   CENSUSPlusFemale["Cazadora"] = "Cazador"; 
   CENSUSPLUS_MAGE             = "Mago"; 
   CENSUSPlusFemale["Maga"] = "Mago"; 
   CENSUSPLUS_PRIEST           = "Sacerdote"; 
   CENSUSPlusFemale["Sacerdotisa"] = "Sacerdote"; 
   CENSUSPLUS_ROGUE            = "Pícaro"; 
   CENSUSPlusFemale["Pícara"] = "Pícaro"; 
   CENSUSPLUS_WARLOCK          = "Brujo"; 
   CENSUSPlusFemale["Bruja"] = "Brujo"; 
   CENSUSPLUS_WARRIOR          = "Guerrero"; 
   CENSUSPlusFemale["Guerrera"] = "Guerrero"; 
   CENSUSPLUS_SHAMAN           = "Chamán";
   CENSUSPLUS_PALADIN          = "Paladín";
	 CENSUSPLUS_DEATHKNIGHT		= "Caballero de la Muerte";
		CENSUSPLUS_MONK             = "Monje";

   CENSUSPLUS_DWARF            = "Enano"; 
   CENSUSPlusFemale["Enana"] = "Enano"; 
   CENSUSPLUS_GNOME            = "Gnomo"; 
   CENSUSPlusFemale["Gnoma"] = "Gnomo"; 
   CENSUSPLUS_HUMAN            = "Humano"; 
   CENSUSPlusFemale["Humana"] = "Humano"; 
   CENSUSPLUS_NIGHTELF         = "Elfo de la noche"; 
   CENSUSPlusFemale["Elfa de la noche"] = "Elfo de la noche"; 
--   CENSUSPLUS_DRAENEI          = "Draenei";
   CENSUSPLUS_WORGEN              = "Huargen";
--   CENSUSPLUS_APANDAREN        = "Pandaren";

   CENSUSPLUS_ORC              = "Orco";
--   CENSUSPLUS_TAUREN           = "Tauren"; 
   CENSUSPLUS_TROLL            = "Trol";
   CENSUSPLUS_UNDEAD           = "No-muerto"; 
   CENSUSPlusFemale["No-muerta"] = "No-muerto"; 
   CENSUSPLUS_BLOODELF         = "Elfo de sangre";
   CENSUSPlusFemale["Elfa de sangre"] = "Elfo de sangre"; 
--   CENSUSPLUS_GOBLIN              = "Goblin";
--   CENSUSPLUS_HPANDAREN        = "Pandaren";

	
	CENSUSPLUS_BUTTON_OPTIONS   = "Opciones";
	CENSUSPLUS_OPTIONS_HEADER   = "Opciones CensusPlusClassic";
--CENSUSPLUS_ISINBG			= "You are currently in a Battleground so a Census cannot be taken";
	CENSUS_OPTIONS_BUTSHOW      = "Mostrar botón";
--CENSUS_OPTIONS_AUTOCENSUS   = "Auto-Census";
--CENSUS_OPTIONS_AUTOSTART    = "Auto-Start";
--CENSUS_OPTIONS_VERBOSE      = "Verbose";
--CENSUS_OPTIONS_SOUND_ON_COMPLETE = "Play Sound When Done";
--CENSUS_OPTIONS_LOG_BARS		= "Logarithmic Level Bars";

--CENSUSPLUS_VERBOSE_TOOLTIP  = "Deselect to stop the spam!";
--CENSUSPlus_AUTOCENSUS_TOOLTIP = "Enable CensusPlusClassic to run automatically while playing";

	CENSUSPLUS_BUTTON_CHARACTERS = "Mostrar personajes";
	CENSUSPLUS_CHARACTERS      = "Personajes";

	CENSUS_BUTTON_TOOLTIP      = "Abrir CensusPlusClassic";



end
--]]
	
	--[[ older translations.. now using curseforge translation support
els.eif ( GetLocale() == "ptBR" ) th.en
-- Thanks to Riggz US-Tol Barad <contato> for the Portuguese Translation

CENSUSPLUS_DRUID = "Druida";
CENSUSPlusFemale["Druidesa"] = "Druida"
CENSUSPLUS_HUNTER = "Caçador";
CENSUSPlusFemale["Caçadora"] = "Caçador";
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
CENSUSPLUS_DEATHKNIGHT = "Cavaleiro da Morte";
CENSUSPlusFemale["Cavaleira da Morte"] = "Cavaleiro da Morte"
CENSUSPLUS_MONK   = "Monge";
CENSUSPlusFemale["Monja"] = "Monge"; 


CENSUSPLUS_DWARF = "Anão";
CENSUSPlusFemale["Anã"] = "Anão";
CENSUSPLUS_GNOME = "Gnomo";
CENSUSPlusFemale["Gnoma"] = "Gnomo";
CENSUSPLUS_HUMAN = "Humano";
CENSUSPlusFemale["Humana"] = "Humano";
CENSUSPLUS_NIGHTELF = "Elfo noturno";
CENSUSPlusFemale["Elfa noturna"] = "Elfo noturno";
-- CENSUSPLUS_DRAENEI = "Draenei";
CENSUSPlusFemale["Draenaia"] = "Draenei";
CENSUSPLUS_WORGEN			= "Worgen/Worgenin";
CENSUSPlusFemale["Worgenin"] = "Worgen"
-- CENSUSPLUS_APANDAREN        = "Pandaren";  
CENSUSPlusFemale["Pandarena"] = "Pandaren"; 

-- CENSUSPLUS_ORC = "Orc";
CENSUSPlusFemale["Orquisa"] = "Orc";
-- CENSUSPLUS_TROLL = "Troll";
CENSUSPlusFemale["Trolesa"] = "Troll";
-- CENSUSPLUS_TAUREN = "Tauren";
CENSUSPlusFemale["Taurena"] = "Tauren";
CENSUSPLUS_UNDEAD = "Morto-vivo";
CENSUSPlusFemale["Morta-viva"] = "Morto-vivo";
CENSUSPLUS_BLOODELF = "Elfo sangrento";
CENSUSPlusFemale["Elfa de sangre"] = "Elfo sangrento";
-- CENSUSPLUS_GOBLIN   = "Goblin";
CENSUSPlusFemale["Goblina"] = "Gobelin"; 
-- CENSUSPLUS_HPANDAREN        = "Pandaren";  
CENSUSPlusFemale["Pandarena"] = "Pandaren"; 





CENSUSPLUS_BUTTON_OPTIONS = "Opções";
CENSUSPLUS_OPTIONS_HEADER = "Opções CensusPlusClassic";
--CENSUSPLUS_ISINBG			= "You are currently in a Battleground so a Census cannot be taken";
CENSUS_OPTIONS_BUTSHOW = "Mostrar botão";


--CENSUS_OPTIONS_AUTOCENSUS   = "Auto-Census";
--CENSUS_OPTIONS_AUTOSTART    = "Auto-Start";
--CENSUS_OPTIONS_VERBOSE      = "Verbose";
--CENSUS_OPTIONS_SOUND_ON_COMPLETE = "Play Sound When Done";
--CENSUS_OPTIONS_LOG_BARS		= "Logarithmic Level Bars";

CENSUSPLUS_VERBOSE_TOOLTIP  = "Deselect to stop the spam!";
CENSUSPlus_AUTOCENSUS_TOOLTIP = "Enable CensusPlusClassic to run automatically while playing";

CENSUSPLUS_BUTTON_CHARACTERS = "Mostrar personagens";
CENSUSPLUS_CHARACTERS = "Personagens";

CENSUS_BUTTON_TOOLTIP = "Abrir CensusPlusClassic";

-- -- -- Não utilizado

-- CENSUSPlus_BUTTON_SUBTEXT = "Estatísticas do Servidor";
-- CENSUSPlus_BUTTON_TIP = "Clique aqui para mostrar ou ocultar o CensusPlusClassic.";
-- CENSUSPLUS_HELP = " Usar /censusplus para abrir e fechar a interface do CensusPlusClassic.";
-- CENSUSPlus_SHOWMINI = "Iniciar Minimizado";
-- CENSUSPlus_MAXIMIZE = "Maximizar a janela do CensusPlusClassic";
-- CENSUSPlus_MINIMIZE = "Minimizar a janela do CensusPlusClassic";
-- CENSUSPlus_BUTTON_MINIMIZE = "Minimizar";
-- CENSUS_OPTIONS_BUTPOS = "Posição do botão";
-- CENSUS_LEVEL_NO_GUILD = "(.+): Nível (%d+) (.+) (.+) - (.+)";
-- CENSUS_LEVEL_W_GUILD = "(.+): Nível (%d+) (.+) (.+) <(.+)> - (.+)";
]]
--[[
if ( GetLocale() == "itIT" ) then

CENSUSPLUS_TEXT      = "CensusPlusClassic";

CENSUSPLUS_MSG1             = " Loaded - - tipo /censusplus o /CensusPlusClassic o /census per aprire la finestra principale";
CENSUSPLUS_UPLOAD           = "Assicurarsi di caricare i dati CensusPlusClassic a WoWClassicPopulation.com!";
CENSUSPLUS_PAUSE            = "Sospendi";
CENSUSPLUS_UNPAUSE          = "Riattiva";
CENSUSPLUS_STOP             = "Arresto";

CENSUSPLUS_PRUNE						= "Potare";
CENSUSPLUS_PRUNECENSUS		= "Prune the database by removing characters not seen in 30 days.";
CENSUSPLUS_PRUNEINFO		= "Pruned %d characters.";
CENSUSPLUS_PURGEDATABASE    = "Spurgare il database di tutti i dati";
CENSUSPLUS_PURGE            = "Purge";
CENSUSPLUS_PURGEMSG         = "Purged character database.";
CENSUSPLUS_PURGE_LOCAL_CONFIRM = "Are you sure you wish to PURGE your local database?";

CENSUSPLUS_TAKECENSUS       = "Prendete un censimento dei giocatori \nattualmente online su questo server \ne in questa fazione";
CENSUSPLUS_PAUSECENSUS      = "Sospendi il censimento in corso";
CENSUSPLUS_UNPAUSECENSUS    = "Riattiva il censimento in corso";
CENSUSPLUS_STOPCENSUS       = "Stop the currently active CensusPlusClassic";
CENSUSPLUS_ISINPROGRESS     = "A CensusPlusClassic is in progress, try again later";
CENSUSPLUS_TAKINGONLINE     = "Taking census of characters online...";
CENSUSPLUS_NOCENSUS         = "A Census is not currently in progress";
CENSUSPLUS_NOTINFACTION     = "Fazione neutrale - non consentito censimento"; 
CENSUSPLUS_FINISHED         = "Finished Taking data. Found %s new characters and saw %s. Took %s.";
CENSUSPLUS_TOOMANY          = "WARNING: Too many characters matching: %s";
CENSUSPLUS_WAITING          = "Waiting to send who request...";
CENSUSPLUS_SENDING          = "Sending /who %s";
CENSUSPLUS_WHOQUERY			= "Who query:"
CensusPlus_FOUND					= "found"
CENSUSPLUS_PROCESSING       = "Processing %s characters.";

CENSUSPLUS_REALMNAME        = "Realm: ";
CENSUSPLUS_REALMUNKNOWN     = "Realm: Unknown";
CENSUSPLUS_CONNECTED		= "I server collegati: ";
CENSUSPLUS_FACTION          = "Faction: %s";
CENSUSPLUS_FACTIONUNKNOWN   = "Faction: Unknown"; -- replace this text with notinfaction above?
CENSUSPLUS_LOCALE           = "Locale : %s";
CENSUSPLUS_LOCALEUNKNOWN    = "Locale : Unknown";
CENSUSPLUS_TOTALCHAR        = "Total Characters: %d";
CENSUSPLUS_TOTALCHAR_0      = "Total Characters: 0";
CENSUSPLUS_TOTALCHARXP      = "XP Factor: %d";
CENSUSPLUS_TOTALCHARXP_0    = "XP Factor: 0";
CENSUSPLUS_SCAN_PROGRESS    = "Scan Progress: %d queries in the queue - %s";
CENSUSPLUS_SCAN_PROGRESS_0  = "No Scan In Progress";
CENSUSPLUS_AUTOCLOSEWHO     = "Automatically Close Who";
CENSUSPLUS_UNGUILDED        = "(Unguilded)";
CENSUSPLUS_TAKE             = "Take";
CENSUSPLUS_TOPGUILD         = "Top Guilds By XP";
CENSUSPLUS_RACE             = "Races";
CENSUSPLUS_CLASS            = "Classes";
CENSUSPLUS_LEVEL            = "Levels";
CENSUSPLUS_MAXXED			= "MAXXED!";

CENSUSPLUS_DRUID            = "Druido";
CENSUSPlusFemale["Druida"] = "Druido";
CENSUSPLUS_HUNTER           = "Cacciatore";
CENSUSPlusFemale["Cacciatrice"] = "Cacciatore";
CENSUSPLUS_MAGE             = "Mago";
CENSUSPlusFemale["Maga"] = "Mago";
CENSUSPLUS_PRIEST           = "Sacerdote";
CENSUSPlusFemale["Sacerdotessa"] = "Sacerdote";
CENSUSPLUS_ROGUE            = "Ladro";
CENSUSPlusFemale["Ladra"] = "Ladro";
CENSUSPLUS_WARLOCK          = "Stregone";
CENSUSPlusFemale["Strega"] = "Stregone";
CENSUSPLUS_WARRIOR          = "Guerriero";
CENSUSPlusFemale["Guerriera"] = "Guerriero";
CENSUSPLUS_SHAMAN           = "Sciamano";
CENSUSPlusFemale["Sciamana"] = "Sciamano";
CENSUSPLUS_PALADIN          = "Paladino";
CENSUSPlusFemale["Paladina"] = "Paladino";
CENSUSPLUS_DEATHKNIGHT		= "Cavaliere della Morte";
CENSUSPLUS_MONK             = "Monaco";
CENSUSPlusFemale["Monaca"] = "Monaco";

CENSUSPLUS_DWARF            = "Nano";
CENSUSPlusFemale["Nana"] = "Nano";
CENSUSPLUS_GNOME            = "Gnomo";
CENSUSPlusFemale["Gnoma"] = "Gnomo";
CENSUSPLUS_HUMAN            = "Umano";
CENSUSPlusFemale["Umana"] = "Umano";
CENSUSPLUS_NIGHTELF         = "Elfo della Notte";
CENSUSPlusFemale["Elfa della Notte"] = "Elfo della Notte";
CENSUSPLUS_WORGEN			= "Worgen";
CENSUSPLUS_APANDAREN        = "Pandaren";

CENSUSPLUS_ORC              = "Orco";
CENSUSPlusFemale["Orchessa"] = "Orco";
CENSUSPLUS_TAUREN           = "Tauren";
CENSUSPLUS_TROLL            = "Troll";
CENSUSPLUS_UNDEAD           = "Non Morto";
CENSUSPlusFemale["Non Morta"] = "Non Morto";
CENSUSPLUS_DRAENEI          = "Draenei";
CENSUSPLUS_BLOODELF         = "Elfo del sangue";
CENSUSPlusFemale["Elfa del Sangue"] = "Elfo del sangue";
CENSUSPLUS_GOBLIN			= "Goblin";
CENSUSPLUS_HPANDAREN        = "Pandaren";

CENSUSPLUS_US_LOCALE		= "Select if you play on US Servers";
CENSUSPLUS_EU_LOCALE		= "Select if you play on EURO Servers";
CENSUSPLUS_LOCALE_SELECT	= "Select if you play on US or EURO servers";

CENSUSPLUS_BUTTON_OPTIONS	= "Options";
CENSUSPLUS_OPTIONS_HEADER	= "CensusPlusClassic Options";
CENSUSPLUS_ISINBG			= "You are currently in a Battleground so a Census cannot be taken";
CENSUS_OPTIONS_BUTSHOW      = "Show Minimap Button";
CENSUS_OPTIONS_AUTOCENSUS   = "Auto-Census";
CENSUS_OPTIONS_AUTOSTART    = "Auto-Start";
CENSUS_OPTIONS_VERBOSE      = "Verbose";
CENSUS_OPTIONS_SOUND_ON_COMPLETE = "Play Sound When Done";
CENSUS_OPTIONS_LOG_BARS		= "Logarithmic Level Bars";

CENSUSPlus_AUTOSTART_TOOLTIP = "Enable CensusPlusClassic to start automatically";
CENSUSPLUS_VERBOSE_TOOLTIP  = "Deselect to stop the spam!";
CENSUSPlus_AUTOCENSUS_TOOLTIP = "Enable CensusPlusClassic to run automatically while playing";

CENSUSPLUS_BUTTON_CHARACTERS = "Show Chars";
CENSUSPLUS_CHARACTERS		= "Characters";

CENSUS_BUTTON_TOOLTIP		= "Open CensusPlusClassic";



CENSUSPLUS_PURGE_LOCAL_CONFIRM = "Are you sure you wish to PURGE your local database?";
end
--]]
--[[ obsolete
els.eif ( GetLocale() == "koKR" ) th.en
  -- This is Korean Locale, Translated by crezol --

CENSUSPlusFemale = { };

CENSUSPLUS_TEXT      = "센서스+";
-- CENSUSPlus_BUTTON_SUBTEXT   = "서버 센서스";
-- CENSUSPlus_BUTTON_TIP       = "센서스+ 를 보이거나 숨기려면 클릭하십시오.";
-- CENSUSPLUS_HELP             = " /censusplus 를 사용해 센서스+ UI 를 열거나 닫을 수 있습니다.";

CENSUSPLUS_MSG1             = "센서스+ 로드됨 - /censusplus 나 /CensusPlusClassic 를 입력해 메인 창을 띄울 수 있습니다.";
-- CENSUSPlus_MSG2             = "/censusdate 를 사용해 오늘의 날짜를 설정하세요.(형식: MM-DD-YYYY, 예. 12-25-2004)";

CENSUSPLUS_UPLOAD           = "WoWClassicPopulation.com 에서 센서스+ 업데이트를 확인하세요!";
CENSUSPlus_SETTINGDATE      = "날짜 변경 => ";
CENSUSPLUS_PAUSE            = "일시중지";
CENSUSPLUS_UNPAUSE          = "계속";
CENSUSPLUS_STOP             = "중지";
CENSUSPLUS_PRUNE			= "간략화";

CENSUSPLUS_TAKECENSUS       = "현재 이 서버와 이 진영에 속한 \n플레이어를 센서스로 가져옵니다.";
CENSUSPLUS_PURGEDATABASE    = "모든 데이터를 소거합니다.";
CENSUSPLUS_PAUSECENSUS      = "현재 센서스를 일시중지 합니다.";
CENSUSPLUS_UNPAUSECENSUS    = "일시중지된 센서스를 계속 진행합니다.";
CENSUSPLUS_STOPCENSUS       = "활동중인 센서스+를 중지합니다.";
CENSUSPLUS_PRUNECENSUS		= "30일동안 검색되지 않은 플레이어를 \n데이터베이스에서 제거해 간략화 합니다.";

CENSUSPLUS_PRUNEINFO		= "%d 케릭터 간략화됨.";

CENSUSPLUS_PURGEMSG         = "케릭터 데이터베이스가 소거되었습니다.";
CENSUSPLUS_ISINPROGRESS     = "센서스+가 진행중입니다, 나중에 다시 시도하십시오.";
CENSUSPLUS_TAKINGONLINE     = "온라인 상태의 케릭터를 센서스로 가져오는 중입니다...";
CENSUSPlus_PLZUPDATEDATE    = "좀더 정확한 데이터를 얻기 위해 /censusdate 를 사용해 오늘 날짜를 수정하십시오. (형식 /censusdate MM-DD-YYYY, 예, /censusdate 12-25-2004)";
CENSUSPLUS_NOCENSUS         = "센서스가 현재 진행중이 아닙니다.";
CENSUSPLUS_FINISHED         = "데이터 수집 완료. %s 의 새 케릭터가 검색되어 총 %s 케릭터를 확인했습니다. 소요 시간 :%s ";
CENSUSPLUS_TOOMANY          = "경고: 너무 많은 케릭터 일치: %s";
CENSUSPLUS_WAITING          = "누구 명령어를 보내기 위해 기다리는 중...";
CENSUSPLUS_SENDING          = "검색중 : /누구 ";
CENSUSPLUS_PROCESSING       = "%s 케릭터를 수집함.";

CENSUSPLUS_REALMNAME        = "서버: %s";
CENSUSPLUS_REALMUNKNOWN     = "서버: 알수없음";
CENSUSPLUS_CONNECTED		= "연결된 서버: %s";
CENSUSPLUS_FACTION          = "진영: %s";
CENSUSPLUS_FACTIONUNKNOWN   = "진영: 알수없음";
CENSUSPLUS_LOCALE           = "Locale : %s";
CENSUSPLUS_LOCALEUNKNOWN    = "Locale : 알수없음";
CENSUSPLUS_TOTALCHAR        = "모든 케릭터: %d";
CENSUSPLUS_TOTALCHAR_0      = "모든 케릭터: 0";
CENSUSPLUS_TOTALCHARXP      = "XP 지수: %d";
CENSUSPLUS_TOTALCHARXP_0    = "XP 지수: 0";
CENSUSPLUS_SCAN_PROGRESS    = "검색 진행중: %d 개의 질의 대기중 - %s";
CENSUSPLUS_SCAN_PROGRESS_0  = "진행중인 검색이 없습니다.";
CENSUSPLUS_AUTOCLOSEWHO     = "누구 창 자동으로 닫기";
CENSUSPlus_SHOWMINI         = "시작시 최소화 보기";
CENSUSPLUS_UNGUILDED        = "(길드없음)";
CENSUSPLUS_TAKE             = "가져오기";
CENSUSPLUS_TOPGUILD         = "XP 에 의한 길드 순위";
CENSUSPLUS_RACE             = "종족";
CENSUSPLUS_CLASS            = "직업";
CENSUSPLUS_LEVEL            = "레벨";
CENSUSPLUS_PURGE            = "소거";
CENSUSPLUS_MAXXED			= "MAXXED!";

CENSUSPlus_MAXIMIZE         = "센서스+ 창 최대화";
CENSUSPlus_MINIMIZE         = "센서스+ 창 최소화";
CENSUSPlus_BUTTON_MINIMIZE  = "최소화";

CENSUSPLUS_DRUID            = "드루이드";       
CENSUSPLUS_HUNTER           = "사냥꾼";         
CENSUSPLUS_MAGE             = "마법사";         
CENSUSPLUS_PRIEST           = "사제";           
CENSUSPLUS_ROGUE            = "도적";           
CENSUSPLUS_WARLOCK          = "흑마법사";       
CENSUSPLUS_WARRIOR          = "전사";           
CENSUSPLUS_SHAMAN           = "주술사";         
CENSUSPLUS_PALADIN          = "성기사";         
CENSUSPLUS_DEATHKNIGHT		= "죽음의 기사";      
CENSUSPLUS_MONK             = "수도사";
                                                
CENSUSPLUS_DWARF            = "드워프";         
CENSUSPLUS_GNOME            = "노움";           
CENSUSPLUS_HUMAN            = "인간";           
CENSUSPLUS_NIGHTELF         = "나이트 엘프";    
CENSUSPLUS_ORC              = "오크";           
CENSUSPLUS_TAUREN           = "타우렌";         
CENSUSPLUS_TROLL            = "트롤";           
CENSUSPLUS_UNDEAD           = "언데드";         
CENSUSPLUS_DRAENEI          = "드레나이";       
CENSUSPLUS_BLOODELF         = "블러드 엘프";
CENSUSPLUS_APANDAREN        = "Pandaren";
CENSUSPLUS_HPANDAREN        = "Pandaren";    
                                                

CENSUSPLUS_US_LOCALE		= "Select if you play on US Servers";
CENSUSPLUS_EU_LOCALE		= "Select if you play on EURO Servers";
CENSUSPLUS_LOCALE_SELECT	= "Select if you play on US or EURO servers";

CENSUSPLUS_BUTTON_OPTIONS	= "설정";
CENSUSPLUS_OPTIONS_HEADER	= "센서스+ 설정";
CENSUSPLUS_ISINBG			= "현재 전장에 있기 때문에 센서스가 작동하지 않습니다.";
CENSUS_OPTIONS_BUTPOS		= "버튼 위치";
CENSUS_OPTIONS_BUTSHOW      = "미니맵 버튼 보이기";
CENSUS_OPTIONS_AUTOCENSUS   = "자동-센서스";
CENSUS_OPTIONS_THISPROFILE  = "이 케릭터를 위해 프로필 모으기";
CENSUS_OPTIONS_AUTOSTART    = "자동-시작";
CENSUS_OPTIONS_VERBOSE      = "모두 알림";
CENSUS_OPTIONS_SOUND_ON_COMPLETE = "종료시 소리 재생";
CENSUS_OPTIONS_LOG_BARS		= "로그마틱 레벨 그래프";

CENSUSPlus_AUTOSTART_TOOLTIP = "자동으로 센서스+ 활성화";
CENSUSPLUS_VERBOSE_TOOLTIP  = "스팸 메시지를 멈추려면 해제하세요!";
CENSUSPlus_AUTOCENSUS_TOOLTIP = "플레이 시 자동으로 센서스+ 검색 시작";
CENSUSPlus_THISPROFILE_TOOLTIP = "WarcraftRealms.com 에 업로드 하기 위해 이 케릭터의 프로필 데이터를 모읍니다.";

CENSUSPLUS_BUTTON_CHARACTERS = "케릭터 보기";
CENSUSPLUS_CHARACTERS		= "케릭터";

CENSUS_BUTTON_TOOLTIP		= "센서스+ 열기";



CENSUSPlus_CANCEL			= "취소";

CENSUSPlus_OVERRIDE			 = "센서스가 작업중입니다, 우선적으로 해당 명령을 수행합니다. 잠시만 기다려주세요.";
CENSUSPlus_OVERRIDE_COMPLETE = "우선 시행 완료, 센서스 검색을 재개합니다.";
CENSUSPlus_OVERRIDE_COMPLETE_BUT_PAUSED = "우선 시행 완료, 센서스 일시중지됨.";

CENSUSPLUS_PURGE_LOCAL_CONFIRM = "정말로 로컬 데이터베이스의 모든 자료를 소거하겠습니까?";
CENSUSPlus_OVERRIDE_COMPLET_PAUSED = "우선 시행이 완료되었지만 센서스가 일시중지 되었습니다. 계속 버튼을 클릭하세요.";

CENSUSPlus_YES			= "예";
CENSUSPlus_NO			= "아니오";
CENSUSPlus_CONTINUE		= "계속";

end

]]
-- print("English localization loaded")