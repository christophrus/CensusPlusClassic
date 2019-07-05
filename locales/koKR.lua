--[[
	CensusPlusClassic for World of Warcraft(tm).
	
	Copyright 2005 - 2012 Cooper Sellers and WarcraftRealms.com
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
-- initial translations provided by kisswow@curseforge   many phrases need translation .. and review.
-- WARNING: Phrase keys "CensusPlus_LastSeen", "CENSUSPlus_LASTSEEN" evaluate to the same lua identifier "CENSUSPLUS_LASTSEEN". Only the value of "CENSUSPlus_LASTSEEN" will be used. To fix this, rename one or more of the phrase keys.
-- WARNING: Phrase keys "CensusPlus_Found", "CensusPlus_FOUND" evaluate to the same lua identifier "CENSUSPLUS_FOUND". Only the value of "CensusPlus_FOUND" will be used. To fix this, rename one or more of the phrase keys.
if ( GetLocale() == "koKR" ) then
	-- translation needed
	CENSUSPLUS_ACCOUNT_WIDE = "Account wide"
	
	-- translation needed
	CENSUSPLUS_ACCOUNT_WIDE_ONLY_OPTIONS = "Account Wide Only options"
	CENSUSPLUS_AND = " 과 "
	
	-- translation needed
	CENSUSPLUS_AUTOCENSUSOFF = "AutoCensus Mode : OFF"
	
	-- translation needed
	CENSUSPLUS_AUTOCENSUSON = "AutoCensus Mode : ON"
	
	-- translation needed
	CENSUSPLUS_AUTOCENSUSTEXT = "Start Census after initial delay"
	
	-- translation needed
	CENSUSPLUS_AUTOCENSUS_DELAYTIME = "Delay in minutes"
	
	CENSUSPLUS_AUTOCLOSEWHO = "누구 창 자동으로 닫기"
	
	-- translation needed
	CENSUSPLUS_AUTOSTARTTEXT = "Auto Start on login when timer less then "
	CENSUSPLUS_BADLOCAL_1 = "You appear to have a US Census version, yet your localization is set to French or German or Italian."
	CENSUSPLUS_BADLOCAL_2 = "Please do not upload data to WarcraftRealms until this has been resolved."
	CENSUSPLUS_BADLOCAL_3 = "If this is incorrect, please let Bringoutyourdead know at WoWClassicPopulation.com about your situation so he can make corrections."
	CENSUSPLUS_BUTTON_CHARACTERS = "캐릭터 보기"
	CENSUSPLUS_BUTTON_OPTIONS = "설정"
	
	-- translation needed
	CENSUSPLUS_CCO_OPTIONOVERRIDES = "Option overrides for this character only"
	
	-- translation needed
	CENSUSPLUS_CENSUSBUTTONANIMIOFF = "CensusButton Animation : OFF"
	
	-- translation needed
	CENSUSPLUS_CENSUSBUTTONANIMION = "CensusButton Animation : ON"
	
	-- translation needed
	CENSUSPLUS_CENSUSBUTTONANIMITEXT = "Census button animation"
	
	-- translation needed
	CENSUSPLUS_CENSUSBUTTONSHOWNOFF = "CensusButton Mode : OFF"
	
	-- translation needed
	CENSUSPLUS_CENSUSBUTTONSHOWNON = "CensusButton Mode : ON"
	
	
	CENSUSPLUS_CHARACTERS = "캐릭터"
	CENSUSPLUS_CLASS = "직업"
	
	-- translation needed
	CENSUSPLUS_CMDERR_WHO2 = "Who commands should be:  who name level  _ no name found, level is optional"
	
	-- translation needed
	CENSUSPLUS_CMDERR_WHO2NUM = "Who commands can be: who name  _ no numbers in name"
	
	-- translation needed
	CENSUSPLUS_CONSECUTIVE		= "Consecutive Census: %d";
	
	-- translation needed
	CENSUSPLUS_CONSECUTIVE_0	= "Consecutive Census: 0";
	
	CENSUSPLUS_FACTION = "진영: %s"
	CENSUSPLUS_FACTIONUNKNOWN = "진영: 알수없음"
	CENSUSPLUS_FINISHED = "데이터 수집 완료. %s 의 새 캐릭터가 검색되어 총 %s 캐릭터를 확인했습니다. 소요 시간 :%s"
	CENSUSPLUS_FOUND = "발견"
	
	-- translation needed
	CENSUSPLUS_FOUND_CAP	= "Found ";
	
	-- translation needed
	CENSUSPLUS_GETGUILD = "Click Realm for Guild data"
	
	-- translation needed
	CENSUSPLUS_HELP_0 = " following command as shown below"
	
	-- translation needed
	CENSUSPLUS_HELP_1 = " _ Toggle verbose mode off/on"
	
	-- translation needed
	CENSUSPLUS_HELP_10 = " _ Does Census update of player only.. this is done automatically when /CensusPlusClassic take finishes."
	
	-- translation needed
	CENSUSPLUS_HELP_11 = " _ Toggles stealth mode off/on - disables Verbose and all CensusPlusClassic chat messages."
	
	-- translation needed
	CENSUSPLUS_HELP_2 = " _ Brings up the Option window"
	
	-- translation needed
	CENSUSPLUS_HELP_3 = " _ Start a Census snapshot"
	
	-- translation needed
	CENSUSPLUS_HELP_4 = " _ Stop a Census snapshot"
	
	-- translation needed
	CENSUSPLUS_HELP_5 = " X  _ Prune the database by removing characters not seen in X days - default X = 30"
	
	-- translation needed
	CENSUSPLUS_HELP_6 = " X _ Prune the database by removing all characters not seen in X days from servers other than the one you are currently on. - default X = 0"
	
	-- translation needed
	CENSUSPLUS_HELP_7 = " _  Will display info that matches names."
	
	-- translation needed
	CENSUSPLUS_HELP_8 = " _  Will list unguilded characters of that level."
	
	-- translation needed
	CENSUSPLUS_HELP_9 = " _  Will set the autocensus timer (to X minutes)."
	
	CENSUSPLUS_ISINBG = "현재 전장에 있기 때문에 센서스가 작동하지 않습니다."
	CENSUSPLUS_ISINPROGRESS = "센서스+가 진행중입니다, 나중에 다시 시도하십시오."
	
	-- translation needed
	CENSUSPLUS_LANGUAGECHANGED = "Client Language changed, Database purged."
	
	-- translation needed
	CENSUSPLUS_LASTSEEN = " Last Seen: "
	
	-- translation needed
	CENSUSPLUS_LASTSEEN = "Last Seen"
	
	CENSUSPLUS_LEVEL = "레벨"
	CENSUSPLUS_LOCALE = "지역 : %s"
	CENSUSPLUS_LOCALEUNKNOWN = "지역 : 알수없음"
	CENSUSPLUS_MAXXED = "최대화 된!"
	CENSUSPLUS_MSG1 = "센서스+ 로드됨 - /censusplus 나 /CensusPlusClassic 를 입력해 메인 창을 띄울 수 있습니다."
	CENSUSPLUS_NOCENSUS = "센서스가 현재 진행중이 아닙니다."
	CENSUSPLUS_NOTINFACTION = "중립 진영 -  캐릭터가 없습니다."
	CENSUSPLUS_NOW = " 지금 "
	CENSUSPLUS_OBSOLETEDATAFORMATTEXT = "Old Database format found, Database purged."
	CENSUSPLUS_OPTIONS_HEADER = "센서스+ 설정"
	
	-- translation needed
	CENSUSPLUS_OPTIONS_OVERRIDE = "Override"
	CENSUSPLUS_OR = " 또는 "
	CENSUSPLUS_PAUSE = "일시중지"
	CENSUSPLUS_PAUSECENSUS = "현재 센서스를 일시중지 합니다."
	CENSUSPLUS_PLAYERS = " 플레이어."
	
	-- translation needed
	CENSUSPLUS_PLAYFINISHSOUNDNUM = "FinishSound number "
	
	-- translation needed
	CENSUSPLUS_PLAYFINISHSOUNDOFF = "PlayFinishSound Mode : OFF"
	
	-- translation needed
	CENSUSPLUS_PLAYFINISHSOUNDON = "PlayFinishSound Mode : ON"
	
	-- translation needed
	CENSUSPLUS_PROBLEMNAME = "This name is problematic => "
	
	-- translation needed
	CENSUSPLUS_PROBLEMNAME_ACTION = ", name skipped.  This message will only be shown once."
	
	CENSUSPLUS_PROCESSING = "%s 캐릭터를 수집함."
	CENSUSPLUS_PRUNE = "간략화"
	CENSUSPLUS_PRUNECENSUS = "30일동안 검색되지 않은 플레이어를 데이터베이스에서 제거해 간략화 합니다."
	CENSUSPLUS_PRUNEINFO = "%d 캐릭터 간략화됨."
	CENSUSPLUS_PURGE = "삭제"
	CENSUSPLUS_PURGEDALL = "All Census Data Purged"
	CENSUSPLUS_PURGEDATABASE = "모든 데이터를 삭제합니다."
	CENSUSPLUS_PURGEMSG = "캐릭터 데이터베이스가 삭제되었습니다."
	CENSUSPLUS_PURGE_LOCAL_CONFIRM = "정말로 로컬 데이터베이스의 모든 자료를 삭제하겠습니까?"
	CENSUSPLUS_RACE = "종족"
	CENSUSPLUS_REALM = "Realm"
	CENSUSPLUS_REALMNAME = "서버: %s"
	CENSUSPLUS_REALMUNKNOWN = "서버: 알수없음"
	CENSUSPLUS_SCAN_PROGRESS = "검색 진행중: %d 개의 질의 대기중 - %s"
	CENSUSPLUS_SCAN_PROGRESS_0 = "진행중인 검색이 없습니다."
	CENSUSPLUS_SENDING = "검색중 : /누구 %s"
	
	-- translation needed
	CENSUSPLUS_STEALTHOFF = "Stealth Mode : OFF"
	
	-- translation needed
	CENSUSPLUS_STEALTHON = "Stealth Mode : ON"
	CENSUSPLUS_STOP = "중지"
	CENSUSPLUS_STOPCENSUS_TOOLTIP = "활성중인 센서스+를 중지합니다."
	CENSUSPLUS_TAKE = "가져오기"
	CENSUSPLUS_TAKECENSUS = "현재 이 서버와 이 진영에 속한\n플레이어를 센서스로 가져옵니다."
	CENSUSPLUS_TAKINGONLINE = "온라인 상태의 캐릭터를 센서스로 가져오는 중입니다..."
	CENSUSPLUS_TEXT = "센서스+"
	CENSUSPLUS_TOOMANY = "경고: 너무 많은 캐릭터 일치: %s"
	
	-- translation needed
	CENSUSPLUS_TOOSLOW = "Update too slow! Computer overloaded?Connection problems?"
	
	CENSUSPLUS_TOPGUILD = "XP 에 의한 길드 순위"
	CENSUSPLUS_TOTALCHAR = "모든 캐릭터: %d"
	CENSUSPLUS_TOTALCHAR_0 = "모든 캐릭터: 0"
	
	-- translation needed
	CENSUSPLUS_TRANSPARENCY = "Census window transparency"
	
	CENSUSPLUS_UNGUILDED = "(길드없음)"
	
	-- translation needed
	CENSUSPLUS_UNKNOWNRACE = "Found an unknown race ( "
	
	CENSUSPLUS_UNKNOWNRACE_ACTION = " ), please tell christophrus at WoWClassicPopulation.com"
	CENSUSPLUS_UNPAUSE = "계속"
	CENSUSPLUS_UNPAUSECENSUS = "일시중지된 센서스를 계속 진행합니다."
	CENSUSPLUS_UPLOAD = "WoWClassicPopulation.com 에서 센서스+ 업데이트를 확인하세요!"
	CENSUSPLUS_USAGE = "Usage:"
	CENSUSPLUS_USING = "Using "
	CENSUSPLUS_VERBOSEOFF = "Verbose Mode : OFF"
	CENSUSPLUS_VERBOSEON = "Verbose Mode : ON"
	CENSUSPLUS_VERBOSE_TOOLTIP = "스팸 메시지를 멈추려면 해제하세요!"
	CENSUSPLUS_WAITING = "누구 명령어를 보내기 위해 기다리는 중..."
	CENSUSPLUS_WAS = " was "
	CENSUSPLUS_WHOQUERY = "누구 조회:"
	
	-- translation needed
	CENSUSPLUS_WRONGLOCAL_PURGE = "Locale differs from previous setting, purging database."
	
	CENSUS_BUTTON_TOOLTIP = "센서스+ 열기"
	CENSUS_OPTIONS_AUTOCENSUS = "자동-센서스"
	CENSUS_OPTIONS_AUTOSTART = "자동-시작"
	
	-- translation needed
	CENSUS_OPTIONS_BACKGROUND_TRANSPARENCY_TOOLTIP = "Background transparency - ten steps"
	
	CENSUS_OPTIONS_BUTSHOW = "미니맵 버튼 보이기"
	
	-- translation needed
	CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE = "Remove Override"
	
	CENSUS_OPTIONS_LOG_BARS = "로그마틱 레벨 그래프"
	
	-- translation needed
	CENSUS_OPTIONS_LOG_BARSTEXT = "Enables Logarithmic scaling on display bars"
	
	-- translation needed
	CENSUS_OPTIONS_SOUNDFILE = "Select User provided SoundFile number "
	
	-- translation needed
	CENSUS_OPTIONS_SOUNDFILEDEFAULT = "Select default SoundFile number "
	
	-- translation needed
	CENSUS_OPTIONS_SOUNDFILETEXT = "Select desired .mp3 or .OGG sound file"
	
	CENSUS_OPTIONS_SOUND_ON_COMPLETE = "종료시 소리 재생"
	
	-- translation needed
	CENSUS_OPTIONS_SOUND_TOOLTIP = "Enable Sound then select Sound File"
	
	-- translation needed
	CENSUS_OPTIONS_STEALTH = "Stealth"
	
	-- translation needed
	CENSUS_OPTIONS_STEALTH_TOOLTIP = "Stealth mode - no chat messages, diaables Verbose"
	
	-- translation needed
	CENSUS_OPTIONS_TIMER_TOOLTIP = "Sets delay in minutes from the last Census ending."
	
	CENSUS_OPTIONS_VERBOSE = "모두 알림"
	
	-- translation needed
	CENSUS_OPTIONS_VERBOSE_TOOLTIP = "Enables verbose text in chat window, disables Stealth mode"
end