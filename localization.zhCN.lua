--[[
	CensusPlus for World of Warcraft(tm).
	
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
-- initial translations provided by oumu323@curseforge   many phrases need translation .. and review.
-- updated translation provided by utherzt@curseforge
-- lastest translations provided by fyhcslb@curseforge

if ( GetLocale() == "zhCN" ) then

CENSUS_BUTTON_TOOLTIP = "打开CensusPlus"

CENSUS_OPTIONS_AUTOCENSUS = "自动统计"

CENSUS_OPTIONS_AUTOSTART = "自动开始"

CENSUS_OPTIONS_BACKGROUND_TRANSPARENCY_TOOLTIP = "背景透明度 - 10个级别"

CENSUS_OPTIONS_BUTSHOW = "显示小地图按钮"

CENSUS_OPTIONS_CCO_REMOVE_OVERRIDE = "移除覆盖"

CENSUS_OPTIONS_LOG_BARS = "对数统计柱形图"

CENSUS_OPTIONS_LOG_BARSTEXT = "启用对数缩放显示柱形图"

CENSUS_OPTIONS_SOUNDFILE = "选择用户提供的音频文件编号 "

CENSUS_OPTIONS_SOUNDFILETEXT = "选择想要的 .mp3 或 .OGG 音频文件"

CENSUS_OPTIONS_SOUND_ON_COMPLETE = "完成统计后播放提示音"

CENSUS_OPTIONS_SOUND_TOOLTIP = "启用提示音之后选择音频文件"

CENSUS_OPTIONS_STEALTH = "隐形模式"

CENSUS_OPTIONS_STEALTH_TOOLTIP = "隐形模式 - 无聊天信息，禁用冗余"

CENSUS_OPTIONS_TIMER_TOOLTIP = "设置自上次统计结束后的时间延迟."

CENSUS_OPTIONS_VERBOSE = "冗余模式"

CENSUS_OPTIONS_VERBOSE_TOOLTIP = "启用在聊天框显示冗余信息，禁用隐身模式"

CENSUSPLUS_ACCOUNT_WIDE = "账号通用"

CENSUSPLUS_ACCOUNT_WIDE_ONLY_OPTIONS = "仅账号通用选项"

CENSUSPLUS_AND = " 与 "

CENSUSPLUS_APANDAREN = "熊猫人"

CENSUSPLUS_AUTOCENSUS_DELAYTIME = "延迟分钟数"

CENSUSPLUS_AUTOCENSUSOFF = "自动统计 : 禁用"

CENSUSPLUS_AUTOCENSUSON = "自动统计 : 启用"

CENSUSPLUS_AUTOCENSUSTEXT = "初步延迟后开始统计"

CENSUSPLUS_AUTOCLOSEWHO = "自动关闭 /who 命令"

CENSUSPLUS_AUTOSTARTTEXT = "登录后自动开始统计，当计时器小于 "

CENSUSPLUS_BADLOCAL_1 = "你似乎安装了英文版本的CensusPlus，但你的语言设置为了法语或德语或意大利语。"

CENSUSPLUS_BADLOCAL_2 = "在问题解决之前请不要将数据上传到WarcraftRealms。"

CENSUSPLUS_BADLOCAL_3 = "如果这不正确，请将你的情况反馈给www.WarcraftRealms.com的Bringoutyourdead，他能修正这些错误。"

CENSUSPLUS_BLOODELF = "血精灵"

CENSUSPLUS_BUTTON_CHARACTERS = "显示角色名单"

CENSUSPLUS_BUTTON_OPTIONS = "选项"

CENSUSPLUS_CCO_OPTIONOVERRIDES = "为当前角色覆盖的选项"

CENSUSPLUS_CENSUSBUTTONANIMIOFF = "小地图按钮动画 : 禁用"

CENSUSPLUS_CENSUSBUTTONANIMION = "小地图按钮动画 : 启用"

CENSUSPLUS_CENSUSBUTTONANIMITEXT = "小地图按钮动画"

CENSUSPLUS_CENSUSBUTTONSHOWNOFF = "小地图按钮 : 禁用"

CENSUSPLUS_CENSUSBUTTONSHOWNON = "小地图按钮 : 启用"

CENSUSPLUS_CHARACTERS = "角色"

CENSUSPLUS_CLASS = "职业"

-- Missing translation
-- CENSUSPLUS_CMDERR_WHO2 = ""

-- Missing translation
-- CENSUSPLUS_CMDERR_WHO2NUM = ""

CENSUSPLUS_CONNECTED = "已连接:"

CENSUSPLUS_CONNECTED2 = "额外连接:"

CENSUSPLUS_CONNECTEDREALMSFOUND = "CensusPlus 已发现以下连接的服务器"

CENSUSPLUS_CONSECUTIVE = "连续统计:"

CENSUSPLUS_DEATHKNIGHT = "死亡骑士"

CENSUSPLUS_DEMONHUNTER = "恶魔猎手"

CENSUSPLUS_DRAENEI = "德莱尼"

CENSUSPLUS_DRUID = "德鲁伊"

CENSUSPLUS_DWARF = "矮人"

CENSUSPLUS_EU_LOCALE = "玩家处于欧服则选择该项"

CENSUSPLUS_FACTION = "阵营: %s"

CENSUSPLUS_FACTIONUNKNOWN = "阵营: 未知"

CENSUSPLUS_FINISHED = "获取数据完成。发现新角色：%s ，看到：%s。获取：%s。"

CENSUSPLUS_FOUND = "已发现"

CENSUSPLUS_FOUND_CAP = "已发现 "

CENSUSPLUS_GETGUILD = "选择服务器以查看公会数据"

CENSUSPLUS_GNOME = "侏儒"

CENSUSPLUS_GOBLIN = "地精"

CENSUSPLUS_GUILDREALM = "公会所属服务器"

CENSUSPLUS_HELP_0 = " 命令如下"

CENSUSPLUS_HELP_1 = " _ 启用/禁用冗余模式"

-- Missing translation
-- CENSUSPLUS_HELP_10 = ""

CENSUSPLUS_HELP_11 = " _ 启用/禁用隐身模式，启用会关闭冗余模式并不显示 CensusPlus 所有的聊天信息。"

CENSUSPLUS_HELP_2 = " _ 打开选项窗口"

CENSUSPLUS_HELP_3 = " _ 开始 Census 快照"

CENSUSPLUS_HELP_4 = " _ 停止 Census 快照"

CENSUSPLUS_HELP_5 = " X  _ 整理数据库，删除 X 天内没有发现过的角色，默认 X = 30"

CENSUSPLUS_HELP_6 = " X _ 整理数据库，删除非当前服务器中 X 天内没有发现过的角色，默认 X = 0"

CENSUSPLUS_HELP_7 = " _  将显示符合名字的信息。"

CENSUSPLUS_HELP_8 = " _  将显示该级别无公会的角色。"

CENSUSPLUS_HELP_9 = " _  将设置自动统计的计时器 (为 X 分钟)。"

CENSUSPLUS_HPANDAREN = "熊猫人"

CENSUSPLUS_HUMAN = "人类"

CENSUSPLUS_HUNTER = "猎人"

CENSUSPLUS_ISINBG = "处于战场环境下不能进行人口普查"

CENSUSPLUS_ISINPROGRESS = "人口普查正在进行，请稍后再试"

CENSUSPLUS_LANGUAGECHANGED = "客户端语言改变，数据库已清空。"

CENSUSPLUS_LASTSEEN = "最后发现"

CENSUSPLUS_LASTSEEN_COLON = " 最后发现: "

CENSUSPLUS_LEVEL = "等级"

CENSUSPLUS_LOCALE = "地区: %s"

CENSUSPLUS_LOCALE_SELECT = "玩家处于美服或者欧服则选择该项"

CENSUSPLUS_LOCALEUNKNOWN = "地区: 未知"

CENSUSPLUS_MAGE = "法师"

CENSUSPLUS_MAXXED = "最大值！"

CENSUSPLUS_MONK = "武僧"

CENSUSPLUS_MSG1 = "加载完成——输入 /censusplus 或者 /census+ 或者 /census获取更多有效的命令"

CENSUSPLUS_NIGHTELF = "暗夜精灵"

CENSUSPLUS_NOCENSUS = "当前没有正在进行的人口普查"

CENSUSPLUS_NOTINFACTION = "中立阵营 - 无法进行人口普查"

CENSUSPLUS_NOW = " 现在 "

CENSUSPLUS_OBSOLETEDATAFORMATTEXT = "数据库格式过时，数据库已清空。"

CENSUSPLUS_OPTIONS_CHATTYCONFIRM = "聊天框选项确认信息 - 勾选以启用"

CENSUSPLUS_OPTIONS_CHATTY_TOOLTIP = "启用在聊天框显示当前选项设置 - 当选项窗口打开时或者设置改变时显示"

CENSUSPLUS_OPTIONS_HEADER = "Census+ 选项"

CENSUSPLUS_OPTIONS_OVERRIDE = "覆盖"

CENSUSPLUS_OR = " 或 "

CENSUSPLUS_ORC = "兽人"

CENSUSPLUS_PALADIN = "圣骑士"

CENSUSPLUS_PAUSE = "暂停"

CENSUSPLUS_PAUSECENSUS = "暂停正在进行的人口普查"

CENSUSPLUS_PLAYERS = " 玩家。"

CENSUSPLUS_PLAYFINISHSOUNDNUM = "完成提示音 编号 "

CENSUSPLUS_PLAYFINISHSOUNDOFF = "播放统计完成提示音 : 禁用"

CENSUSPLUS_PLAYFINISHSOUNDON = "播放统计完成提示音 : 启用"

CENSUSPLUS_PRIEST = "牧师"

CENSUSPLUS_PROBLEMNAME = "当前名字存在问题 => "

CENSUSPLUS_PROBLEMNAME_ACTION = ", 名字跳过。该信息只会显示一次。"

CENSUSPLUS_PROCESSING = "进行中: 已获取 %s 个角色"

CENSUSPLUS_PRUNE = "清理数据"

CENSUSPLUS_PRUNECENSUS = "通过删除在过去30天内未查询到的角色来清理数据库"

CENSUSPLUS_PRUNEINFO = "已清理 %d 个角色"

CENSUSPLUS_PURGE = "清空"

CENSUSPLUS_PURGEDALL = "所有统计数据已清空"

CENSUSPLUS_PURGEDATABASE = "清空所有数据"

CENSUSPLUS_PURGE_LOCAL_CONFIRM = "你确定想要 清空 你的本地数据库？"

CENSUSPLUS_PURGEMSG = "清空角色数据库"

CENSUSPLUS_RACE = "种族"

CENSUSPLUS_REALM = "服务器"

CENSUSPLUS_REALMNAME = "服务器: "

CENSUSPLUS_REALMUNKNOWN = "服务器: 未知服务器"

CENSUSPLUS_ROGUE = "潜行者"

CENSUSPLUS_SCAN_PROGRESS = "扫描进展: %d 个查询正在队列中 - %s"

CENSUSPLUS_SCAN_PROGRESS_0 = "没有正在进行的扫描"

CENSUSPLUS_SENDING = "执行 /who %s 命令"

CENSUSPLUS_SHAMAN = "萨满祭司"

CENSUSPLUS_STEALTHOFF = "隐形模式 : 禁用"

CENSUSPLUS_STEALTHON = "隐形模式 : 启用"

CENSUSPLUS_STOP = "停止"

CENSUSPLUS_STOPCENSUS_TOOLTIP = "停止当前激活的CensusPlus"

CENSUSPLUS_TAKE = "开始"

CENSUSPLUS_TAKECENSUS = [=[统计玩家 
当前服务器在线 
并且处于该阵营]=]

CENSUSPLUS_TAKINGONLINE = "进行当前在线角色的人口普查"

CENSUSPLUS_TAUREN = "牛头人"

CENSUSPLUS_TEXT = "Census+"

CENSUSPLUS_TOOMANY = "警告: 相匹配的角色太多: %s"

CENSUSPLUS_TOOSLOW = "更新过慢！电脑不给力？网络连接有问题？"

CENSUSPLUS_TOPGUILD = "Top Guilds By XP"

CENSUSPLUS_TOTALCHAR = "全部角色: %d"

CENSUSPLUS_TOTALCHAR_0 = "角色总数: 0"

CENSUSPLUS_TOTALCHARXP = ""

CENSUSPLUS_TOTALCHARXP_0 = ""

CENSUSPLUS_TRANSPARENCY = "统计窗口透明度"

CENSUSPLUS_TROLL = "巨魔"

CENSUSPLUS_UNDEAD = "亡灵"

CENSUSPLUS_UNGUILDED = "(无公会)"

CENSUSPLUS_UNKNOWNRACE = "发现未知种族 ( "

CENSUSPLUS_UNKNOWNRACE_ACTION = " )，请告知WarcraftRealms.com的Bringoutyourdead"

CENSUSPLUS_UNPAUSE = "继续"

CENSUSPLUS_UNPAUSECENSUS = "继续当前的人口统计"

CENSUSPLUS_UPLOAD = "确保将你的人口统计数据上传到www.WarcraftRealms.com!"

CENSUSPLUS_USAGE = "用法:"

CENSUSPLUS_USING_WHOLIB = "使用 WhoLib"

CENSUSPLUS_US_LOCALE = "玩家处于美服则选择该项"

CENSUSPLUS_VERBOSEOFF = "冗余模式 : 禁用"

CENSUSPLUS_VERBOSEON = "冗余模式 : 启用"

CENSUSPLUS_VERBOSE_TOOLTIP = "取消勾选以阻止无用信息！"

CENSUSPLUS_WAITING = "等待发送\"who\"请求..."

CENSUSPLUS_WARLOCK = "术士"

CENSUSPLUS_WARRIOR = "战士"

CENSUSPLUS_WAS = " 曾为 "

CENSUSPLUS_WHOQUERY = "Who 查询:"

CENSUSPLUS_WORGEN = "狼人"

-- Missing translation
-- CENSUSPLUS_WRONGLOCAL_PURGE = ""
end