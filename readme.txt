CensusPlus - by Rollie of Bloodscalp aka Cooper Sellers
    authorized modifications by Bringoutyourdead at www.warcraftrealms.com
	
	

  WEBSITE

   http://www.warcraftrealms.com/

  VERSION
   7.1.2 - 04/17/2018 - Maintenance release - Localization fixes for various non-English languages concerning new race names.
	- This version is set for WoW version 7.3.5
	- Version 7.1.0 remains valid for all other users 

   7.1.1 - 02/06/2018 - Maintenance release - Localization fixes for Italian, Portuguese, & Spanish languages only
	- This version is set for WoW version 7.3.5
	- Version 7.1.0 remains valid for all other users 

   7.1.0 - 02/03/2018 - Mandatory update - Data file will be purged.
	- This version is set for WoW version 7.3.5
	- added two new allied races per faction
	- added third race but not fully active (using demon hunter icon as placeholder) 
	- expanded display window to allow for three new races and to allow level expansion for the next few expansion packs.
	- similar to the Demon Hunter Class, the Lightforged Draenei and Highmountain Tauren are census numbers are picked up when the 
	-    previous Draenei and Tauren queries are processed.
	- Void Elf requires a separate census query as the Night Elf Druid class is replaced by Warlock class on this race.
	
   7.0.5 - 09/18/2017 - Maintenance release - more API change fixes
	- This version is set for WoW version 7.3
	- at this time all version 7.0.x Censusplus uploads will be accepted at www.WarcraftRealms.com
	- ImprovedOptionsFrames addon has not yet been updated (only needs TOC change) .. I have done this update on the copy included with CensusPlus
 
  7.0.4 - 08/30/2017 - Recommended Maintenance release - API change fix & TOC change
	- This version is set for WoW version 7.3
	- Localization update - German translation for ORC dropped, now using client standard.
	- at this time all version 7.0.x Censusplus uploads will be accepted at www.WarcraftRealms.com
	- ImprovedOptionsFrames addon has not yet been updated (only needs TOC change) .. I have done this update on the copy included with CensusPlus
	
  7.0.3 - 03/28/2017 - Maintenance release - TOC change
	- This version is set for WoW version 7.2
	- Localization updates for Russian & German.
	- at this time all version 7.0.x Censusplus uploads will be accepted at www.WarcraftRealms.com
	- ImprovedOptionsFrames addon has not yet been updated (only needs TOC change) .. I have done this update on the copy included with CensusPlus
	
  7.0.2 - 10/28/2016 - Maintenance release - TOC change
	- This version is set for WoW version 7.1
	- Localization updates for Chinese (zhCN), French & German.
	- at this time all version 7.0.x Censusplus uploads will be accepted at www.WarcraftRealms.com
	- ImprovedOptionsFrames addon has not yet been updated (only needs TOC change) .. I have done this update on the copy included with CensusPlus
	
  7.0.1 - 08/10/2016 - Maintenance release - update if new changes are important to you.
	- Fixed Class display order.. both Race and Class process in order from right to left.
	- Blizzard parses each word in the /who query so any query that contains "Hunter" as class will return both 'Hunter' and 'Demon Hunter'
	- This version skips the query for 'Demon Hunter' as it is currently redundant.. shortens census run times.
	- Note: 'Demon Hunters can be selected only by using /who c-"Demon", but the Hunter class can no longer be singled out for who results.
	
  7.0.0 - 07/19/2016 - Mandatory update - Data file will be purged.
	- Legion pre release & Legion expansion
	- main window graphics adjusted to allow space for new class
	- added Demon Hunter class
	- adjusted Level location.. with added class and starting at Blizzard minimum tracking level of 20, the level area will also be good for a future expansion
	- Gnome Hunters fully supported.
	-
	- YOU WILL NEED to configure your options.. so open the options pane and remember or write down the settings, so you can recreate them in this new version.
	
  6.4.0 - 04/26/2016 - Mandatory update 
	- While doing Legion prep work I discovered that Pandaren Class breaks were not correctly enabled.
	- This probably lead to under counts of Pandaren Shamans on high population realms.
	- Realms that did not require requeuing on result overflow of /who -r Pandaren would not under count.
	-
	- CensusPlus main window Race and Class icon order changed to match current in game character creation screen order.
	- Note the correct way to view the race/class icons is from Right to Left, as that is the order they must be processed.
	- 
	- This release will purge the main CensusPlus_Database table.
	- Upload your existing census data to www.WarcraftRealms.com before installing this update, or lose the info you collected.
	- Uploads of previous acceptable release will be allowed thru Saturday 04/30/2016 after which only this version will be accepted for upload.
	-
	- YOU WILL NEED to configure your options.. so open the options pane and remember or write down the settings, so you can recreate them in this new version.
	
  6.3.4 - 04/14/2016 - minor update previous version will remain valid until further notice
	- Resume Census run now possible. Allows resume after being disconnected from realm, or character log out, log in - if still on same realm/faction
	- for resume to trigger the following conditions must be meet:
		- an active Census run must have been in progress when you are disconnected from server, or character logged out of realm.
		- return to realm must be no later then five minutes after last census update event.
		- the reactivation of census must be for the same realm/faction
	- if a Census start event occurs where the above conditions are not meet, any pending queue entries will be purged and a new Census is run instead.
	
  6.3.3 - 10/01/2015 - Mandatory update to fix the problems I hadn't really fixed because I had spent too much focus on resetting the levels display.. sigh, sorry about that.
	- Mouseover and target tagging is now correctly disabled.
	- /census me no longer loops forever until the wow client crashes!  This option now shows a chat window message if current character is below the level 20 minimum or runs census on the player character only.
	  
  6.3.2 - 09/20/2015 - Mandatory update to fix Mercenary data corruption issues for uploaders to warcraftrealms.com
    - Blizzard's Mercenary mode and possibly some toys alter the response of mouseover and target tagging of characters.. these tagging options must be disabled.
	- I gave up.. and reset the levels display window to only include the current range of data that can be collected on a census run.
	- For some time the special /census me option would fail with no data if the player was below Blizzard's minimum returned data level of 20
  
  6.3.1 - 6/22/2015 - minor update to TOC 60200

  6.3.0 - 05/26/2015  Forces Database purge on first start.
    - fixes issue on mouse-over/ targeting of opposing faction player who is high enough to not display actual character level
    - the above error would cause uploaded data to not get included into the www.warcraftrealm.com historical database.
    - reinstates minimal itIT and esES translations.. no one has helped by adding translations via the Curseforge Localization tool.
  
  6.2.0.d - 02/01/2015
   - update libwho-2.0 and some frFR and znCN translations.

  6.2.0.c - 11/01/2014 
   - reidentified new Oceanic realm servers.. moving between US and Oceanic no longer purges local database
   - fixed tooltip problem for the STOP button
  
  6.2.0 - 10/20/2014  - valid for players using Blizzard's US, EU and TW data centers... Korea and China realms are not currently identified well enough to allow CensusPlus to run.
  
	- addon graphics completely overhauled.. now allows variable transparency of the addon panels in game.
	- addon options integrated into standard Blizzard options panel.. with major changes in options
		- mouseover tool tips for every option
		- you can now set account wide settings for the addon
		-  you can now set character by character overrides from the account wide settings
		-  chat window command line settings have been demoted to immediate and very temporary option changes that go away on logout or modification via options panel.
		- if you get confused by all the option variations there is a check box at the bottom of the options panel to turn on VERY chatty display of what options are currently valid.
		
	- three levels of information display normal, verbose and a new stealth mode that suppresses nearly every chat window display
	- census button animation - gives quick glance status of active census snapshots.
	- improved auto-start and delayed-auto census control - 2 part control enable the check box THEN set your time delay,
		auto-start activated when time setting is between 5-15 minutes
		delayed-start for time setting between 16-29 minutes 
		
	- option of 4 different end of census audio notices. none, sound 1, sound 2, sound 3 - 2 part control enable the check box THEN select your sound file number.
		- single default sound file is provided for all 3 slots, user can create their own unique sound snippets.
		Note: blizzard allows playing of .mp3 and .ogg sound file types. 
			I recommend the free audio program Audacity available at http://audacity.sourceforge.net/
			 (remember to obey any copyright rules of your country if using and sharing snippets from copyrighted works)
			 
   - Localization... all (I hope) text strings are now modifiable via Localization files.
   Note: due to the major change in Localization most older translations are invalid. 
   Help has been and continues to be requested in supplying translations via curse.com's addon author support site curseforge.com
   If you can help translate or verify(review) translations please go to http://wow.curseforge.com/addons/census-plus/localization/
  
  6.1.0e - 10/23/2013
  - reworked in game display to handle 'Connected realms'
     upon character login opening the CensusPlus window will provide minimal information, start a census run with:
	   chat line entry -   /census take,
	   CensusPlus button - right click and selecting Take,
	   or pressing the Take button in the main CensusPlus window
	   
	 Close, if open, the main CensusPlus window and open it back up again..
	 by the time you have done this CensusPlus will have learned any connected member realms and will be able to display valid data.
	 
	 By default the data displayed is for the superset connected realm. No Guild data will be displayed as this is member realm specific,
	 all other view limiter options continue to work as normal.
	 Each of the learned realm names is a selector button, click on the name to enable or disable view limit to that realm.
	 On limiting view to a realm the guild data is now valid and displays. Again all view limiter options from this point work.
	 
	 Selecting a guild limits the view to only guild data, and inverts some selectors.. 
	 the realm name is now used as the guilds home realm and the total count, race,class and level values are for all members of this guild no matter which realm they log in on.
	 
	 Selecting a different realm will invalidate the guild display which will go blank.
	 You will need to click the new realm selection to cycle back to superset which resets system and then click the realm to reactivate the guild info for the new member realm.
	 
	 Bug Fix:
	 The Pause button in the main CensusPlus window again correctly pauses Census run in progress. Pressing the button again a second time restarts processing.
	 
	 Known Caveats:
	 Character display does not work at this time.. more work is needed to keep separate characters who have the same name but log in on different realms.
	   
  
  6.1.0 - 09/10/2013   -- required update if you are submitting data to www.Warcraftrealms.com.
    -- Siege of Orgrimmar patch 5.4
	-- reworked much of the code to be able to handle 'Connected realms' .. and when Blizzard flips the switch to effectively census multiple old realms in a single run
	-- We now must track the realm information for Guilds (home/creation realm) instead of assuming it is the local realm, this is what triggered the mandatory update.
	-- Blizzard hasn't been explicitly clear on how they are handling Connected realms... so some coding  for in game display hasn't been completed.. no way to test ..
	    an update of CensusPlus is in the works for release when Blizzard flips the switch and gives us some data to work against.
	
	-- Modified /Census serverprune  to /Census serverprune X  making it somewhat the inverse of existing /census Prune X
	--     Prune X  where X is the number of days you want to keep for the current realms data.
	--     Serverprune X where X is the number of days of data you want to keep on all other realms other then the one you are currently on (which is left untouched)
    --      the default for Prune if no number entered is X = 30 days
	--      the default for Serverprune if no number entered is X = 0 days
	
	6.0.0 - 09/24/2012
    - Mists of Pandaria release
    - Added command  /census me 
       this command allows you to run census on your own character... outside of a standard census run.. 
       this is invisioned only needed when you stop and block auto-census to allow maximum resources to game mechanics
       such as battlegrounds or raid events.  /census me allows you to record any level ups you might gain during these events without do
       full census runs.
    - Added Target and Mouse-over character counting, this is independent of active census runs.   
    - Added full Cross realm tracking. Mousing over or targeted characters that are part of a different realm then your own will now get
       added to the census rolls. 

  5.0.4 - 08/27/2012 - Update
  - Updates for compatibility with Blizzard release 5.0.4 pre release before Mists of Pandaria expansion pac.
  - finished full integration of ace - wholib library for all /who related activity. No more conflicts with any other wholib enabled addon.
  - expanded the in game display to be able to handle new MoP class, race and levels.
  
  
    
   1.0 - 1/10/2005

  INTRODUCTION

    CensusPlus came about due to requested changes and desired options
    not present in the original Census UI Mod by Ian Pieragostini.
    
    I spoke with Ian and he has lost interest in World of Warcraft modding
    and encouraged me to modify the Census Mod to my liking.  Thus I
    have done so.
    
    The original Census UI Mod basically took snapshots of your current
    realm and faction.  You could keep this data and combine it with 
    other snapshots to provide greater statistical analysis.
    
    CensusPlus offers many features above and beyond what the original Census
    UI mod provided.  Here follows a list of added features:
    
        -  Abilty to minimize the main census window
            which provides you the abilty to actually play while a census
            is being taken
        -  Ability for the Friends panel not to be shown after
            each /who is sent to the server.  This keeps the UI open from 
            the main Census window
        -  Ability to pause and unpause the current census
        -  Ability to stop the current census in progress
        -  Added a date information which allows the user to place a
            date timestamp on all characters that are found during census's
            taken that day --  This helps facilitate greater accuracy in 
            results when census data is uploaded to www.warcraftrealms.com
        -  Data on number of characters seen during the census snapshot.
        -  Collection of Honor points data.

  USAGE
  
  As of V6.2.0 - 
	CensusPlus zip now contains two addon directories that need to be copied into your /Interface/addons folder
	Be sure to delete first any pre-existing folder and files  as new and renamed files are being used.
		[CensusPlus] is the main folder for CensusPlus
		[ImprovedOptionsFrame] is an optional but highly recommended as it allows you to resize and move the Blizzard Options panel.
  
    Unzip the files into your %World of Warcraft/Interface/AddOns directory.  It
    should create a CensusPlus directory with the installed files.
    
    
    By selecting the Take button from the main census panel, you will initiate a
    Census snapshot.  Depending on the population of your realm and faction, this could 
    take several minutes.
    
    Clicking the Purge button will purge all your collected data from your local Census
    database.
    
    Clicking the Stop button will stop the current census if one is in progress.
    
    Clicking the Pause button will pause the current census if one is in progress.
    
    If you so choose, you can upload your collected census information to 
    http://www.warcraftrealms.com    Doing so will greatly help in the tracking
    of your realm and faction's population numbers and statistics.
      
    
    


