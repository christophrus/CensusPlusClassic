--[[	CensusPlus for World of Warcraft(tm).
	
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
local	addon_name, addon_tableID = ...   -- Addon_name contains the Addon name which must be the same as the container folder name... addon_tableID is a common private table for all .lua files in the directory.
local CPp = addon_tableID  --short cut name for private shared table.
--print("Button")
--print (addon_name)
--print (addon_tableID) 

local init = false;
local PetBat_CPWin = false;

function CensusButton_OnLoad(self)	-- referenced by CensusButton.xml

self:RegisterEvent("ADDON_LOADED")
self:RegisterEvent("PET_BATTLE_OPENING_START")
self:RegisterEvent("PET_BATTLE_CLOSE")

end

function CensusButton_OnEvent(self, event, ...)	-- referenced by CensusButton.xml

  local arg1,arg2,arg3,arg4 = ...;
	if( arg1 == nil ) then
		arg1 = "nil"
	end
	if( arg2 == nil ) then
		arg2 = "nil"
	end
	if( arg3 == nil ) then
		arg3 = "nil"
	end
	if( arg4 == nil ) then
		arg4 = "nil"
	end

	if (( event == "ADDON_LOADED") and (string.upper(arg1) == "CENSUSPLUS")) then  -- need to add code to make sure CensusPlus_Database exists first.
	    if(CensusPlus_Database["Info"]["CensusButtonShown"] == nil ) then
			CensusPlus_InitializeVariables();
		end	
if(((CensusPlus_PerCharInfo["CensusButtonShown"] == nil)and (CensusPlus_Database["Info"]["CensusButtonShown"] == true )) or CensusPlus_PerCharInfo["CensusButtonShown"] == true)then
--			if(CensusPlus_Database["Info"]["CensusButtonShown"] == true) then
				CensusButtonFrame:Show()
				CensusButton:SetText("C+")
			else
				CensusButtonFrame:Hide()
			end
		init = true;
      self:UnregisterEvent("ADDON_LOADED")
	end

    if ( event =="PET_BATTLE_OPENING_START") then
		if(CensusPlus_Database["Info"]["CensusButtonShown"] == true ) then
			CensusButtonFrame:Hide()
		end
		if ( CensusPlus:IsVisible()) then
		    PetBat_CPWin = True;
			CensusPlus_Toggle();
		end
	end
	if ( event =="PET_BATTLE_CLOSE") then
		if(CensusPlus_Database["Info"]["CensusButtonShown"] == true ) then
			CensusButtonFrame:Show()
		end
		if (PetBat_CPWin == True) then
		    PetBat_CPWin = False;
			CensusPlus_Toggle();
		end
	end
	
end

function CensusPlus_ButtonDropDown_Initialize()	-- referenced for Blizzard code
		
		local info;

		if (CPp.IsCensusPlusInProgress == true) then
			if( CPp.CensusPlusManuallyPaused == true ) then
				info = {
					text = CENSUSPLUS_UNPAUSE;
					func = CENSUSPLUS_TAKE_OnClick;
				};
			else
				info = {
					text = CENSUSPLUS_PAUSE;
					func = CENSUSPLUS_TAKE_OnClick;
				};
			end
		else
			info = {
				text = CENSUSPLUS_TAKE;
				func = CENSUSPLUS_TAKE_OnClick;
			};
		end
		UIDropDownMenu_AddButton(info, 1);

		info = {
			text = CENSUSPLUS_STOP;
			func = CENSUSPLUS_STOPCENSUS;
		};
		UIDropDownMenu_AddButton(info, 1);
		
		info = {
			text = CENSUSPLUS_BUTTON_OPTIONS;
			func = CensusPlus_ToggleOptions;
		};
		UIDropDownMenu_AddButton(info, 1);		
		
		info = {
			text = CANCEL;
			func = CensusPlus_CloseDropDown;
		};
		UIDropDownMenu_AddButton(info, 1);		
		
end


function CensusPlus_CloseDropDown()
	CloseDropDownMenus();
end

function CensusPlus_Button_OnClick(self, CPB_button)	-- referenced by CensusButton.xml
	  if ( CPB_button == "LeftButton") then
			CensusPlus_Toggle();
			PlaySound(856,"Master");
		else
    	ToggleDropDownMenu( 1, nil, CP_ButtonDropDown, "CensusButtonFrame", 20, 20 ); 					
		end
end

function CensusPlus_Button_OnMouseDown( self, arg1 )	-- referenced by CensusButton.xml
	if ( ( ( not CensusButtonFrame.isLocked ) or ( CensusButtonFrame.isLocked == false ) ) and ( arg1 == "LeftButton" ) ) then
--	  print("Moving frame-CensusButtonFrame");
		CensusButtonFrame:StartMoving();
		CensusButtonFrame.isMoving = true;
	end
end
