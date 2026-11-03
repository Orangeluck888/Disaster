local function GetLanguage()
    return locale ~= nil and locale or "zh"
end

local is_chinese = GetLanguage():find("zh") ~= nil

local MOD_VERSION = "0.1"

name = is_chinese and "灾难" or "Disaster"
description = is_chinese and [[
所有人都要面对灾难，存活到最后的人获胜！
单人游玩&合作模式：活下去！
版本: ]]..MOD_VERSION..[[

每分钟随机降临致命灾难！

请根据需要在自定义中调整残酷程度~
]] or [[
Everyone must face disasters, the last one standing wins!

Version: ]]..MOD_VERSION..[[

Fatal disasters strike randomly every minute!

Adjust the cruelty level in custom settings~
]]

author = "Salt510"
version = MOD_VERSION

forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

-- 必须全客户端加载，因为需要按 R 键
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = is_chinese and {"disaster", "灾难", "Salt510"} or {"disaster", "Salt510"}

local function Title(title)
    return {
        name = title,
        hover = "",
        options = {{description = "", data = 0}},
        default = 0,
    }
end

local labels = {
    basic_settings = is_chinese and "========== 基础设置 ==========" or "========== Basic Settings ==========",
    event_count = is_chinese and "每次降临灾难数量" or "Disaster Count",
    event_count_hover = is_chinese and "每分钟触发的灾难事件数量" or "Number of disaster events to trigger every minute",
    events = function(n) return is_chinese and n.."个灾难" or n.." disasters" end,
    debug_all = is_chinese and "DEBUG-触发所有灾难" or "DEBUG-Trigger All Disasters",
    news_style = is_chinese and "灾难播报风格" or "Disaster Style",
    news_style_hover = is_chinese and "选择灾难播报的语言风格" or "Choose the language style of disaster broadcast",
    formal = is_chinese and "正式恐怖" or "Formal",
    playful = is_chinese and "戏谑嘲讽" or "Playful",
    news_language = is_chinese and "灾难语言" or "Disaster Language",
    news_language_hover = is_chinese and "选择游戏内灾难播报的语言" or "Choose the language for in-game disaster broadcast",
    chinese = is_chinese and "中文" or "Chinese",
    english = is_chinese and "英语" or "English",
    news_interval = is_chinese and "灾难降临间隔" or "Disaster Interval",
    news_interval_hover = is_chinese and "每隔多久降临一次灾难" or "How often to trigger a disaster",
    every_day = is_chinese and "每分钟 (60秒)" or "Every Minute (60s)",
    half_day = is_chinese and "每半分钟 (30秒)" or "Every 30 Seconds",
    daily = is_chinese and "每两分钟 (120秒)" or "Every 2 Minutes (120s)",
    days = function(n) return is_chinese and "每"..n.."秒降临" or "Every "..n.." seconds" end,
    event_types = is_chinese and "========== 灾难类型 ==========" or "========== Disaster Types ==========",
    enable_negative = is_chinese and "启用致命灾难" or "Enable Fatal Disasters",
    enable_negative_hover = is_chinese and "是否生成致命灾难事件" or "Whether to generate fatal disaster events",
    enable_neutral = is_chinese and "启用中立灾难" or "Enable Neutral Disasters",
    enable_neutral_hover = is_chinese and "是否生成中立灾难事件" or "Whether to generate neutral disaster events",
    enable = is_chinese and "启用" or "Enable",
    disable = is_chinese and "禁用" or "Disable",
    broadcast_style = is_chinese and "========== 播报样式 ==========" or "========== Broadcast Style ==========",
    news_header = is_chinese and "灾难标题样式" or "Disaster Header Style",
    news_header_hover = is_chinese and "选择灾难播报的标题样式" or "Choose the header style of disaster broadcast",
    beautiful = is_chinese and "美观" or "Beautiful",
    simple = is_chinese and "简约" or "Simple",
    elegant = is_chinese and "大方" or "Elegant",
    solemn = is_chinese and "庄重" or "Solemn",
    warning_settings = is_chinese and "========== 预警设置 ==========" or "========== Warning Settings ==========",
    enable_warning = is_chinese and "启用灾难预警" or "Enable Disaster Warning",
    enable_warning_hover = is_chinese and "在灾难降临前提前预警" or "Warn before disaster strikes",
    warning_time = is_chinese and "预警提前时间" or "Warning Time",
    warning_time_hover = is_chinese and "灾难降临前多少秒进行预警" or "How many seconds before disaster to warn",
    experimental = is_chinese and "========== 实验性功能 ==========" or "========== Experimental Features ==========",
    experimental_warning = is_chinese and "警告：以下功能可能无法正常工作！" or "Warning: The following features may not work properly!",
    enable_no_repeat = is_chinese and "启用灾难不重复" or "Enable No Repeat",
    enable_no_repeat_hover = is_chinese and "【实验性】出现过的灾难达到指定次数后不再出现（可能无效）" or "[Experimental] Disasters will not appear again after reaching the specified count (may not work)",
    repeat_limit = is_chinese and "灾难重复次数限制" or "Repeat Limit",
    repeat_limit_hover = is_chinese and "【实验性】同一条灾难最多出现几次后不再出现（可能无效）" or "[Experimental] Maximum times a disaster can appear (may not work)",
    times = function(n) return is_chinese and n.."次" or n.." times" end,
    mod_info = is_chinese and "========== 模组信息 ==========" or "========== Mod Info ==========",
    version_info = is_chinese and "版本: "..MOD_VERSION.." | 灾难: 100" or "Version: "..MOD_VERSION.." | Disasters: 100",
    event_breakdown = is_chinese and "致命: 10 | 正面: 80 | 中立: 10" or "Fatal: 10 | Positive: 80 | Neutral: 10",
    greeting = is_chinese and "愿灾难眷顾你。" or "May disasters favor you.",
    author_info = is_chinese and "作者：Salt510" or "Author: Salt510",
    contact = is_chinese and "Q群:1042944194 欢迎交流。" or "QQ Group: 1042944194 Welcome!",
    thanks = is_chinese and "感谢您的大力支持！" or "Thank you for your support!",
}

configuration_options = {
    Title(labels.basic_settings),
    {
        name = "event_count",
        label = labels.event_count,
        hover = labels.event_count_hover,
        options = {
            {description = labels.events(1), data = 1},
            {description = labels.events(2), data = 2},
            {description = labels.events(3), data = 3},
            {description = labels.events(4), data = 4},
            {description = labels.events(5), data = 5},
            {description = labels.events(6), data = 6},
            {description = labels.events(7), data = 7},
            {description = labels.events(8), data = 8},
            {description = labels.events(9), data = 9},
            {description = labels.events(10), data = 10},
            {description = labels.debug_all, data = 999},
        },
        default = 4,
    },
    {
        name = "news_style",
        label = labels.news_style,
        hover = labels.news_style_hover,
        options = {
            {description = labels.formal, data = "formal"},
            {description = labels.playful, data = "playful"},
        },
        default = "playful",
    },
    {
        name = "news_language",
        label = labels.news_language,
        hover = labels.news_language_hover,
        options = {
            {description = labels.chinese, data = "zh"},
            {description = labels.english, data = "en"},
        },
        default = "zh",
    },
    {
        name = "news_interval",
        label = labels.news_interval,
        hover = labels.news_interval_hover,
        options = {
            {description = labels.half_day, data = 0.5}, -- 30秒
            {description = labels.every_day, data = 1},  -- 60秒
            {description = labels.daily, data = 2},      -- 120秒
        },
        default = 1,
    },
    
    Title(""),
    Title(labels.event_types),
    {
        name = "enable_negative",
        label = labels.enable_negative,
        hover = labels.enable_negative_hover,
        options = {
            {description = labels.enable, data = true},
            {description = labels.disable, data = false},
        },
        default = true,
    },
    {
        name = "enable_neutral",
        label = labels.enable_neutral,
        hover = labels.enable_neutral_hover,
        options = {
            {description = labels.enable, data = true},
            {description = labels.disable, data = false},
        },
        default = false,
    },
    
    Title(""),
    Title(labels.broadcast_style),
    {
        name = "news_header",
        label = labels.news_header,
        hover = labels.news_header_hover,
        options = {
            {description = labels.beautiful, data = "beautiful"},
            {description = labels.simple, data = "simple"},
            {description = labels.elegant, data = "elegant"},
            {description = labels.solemn, data = "solemn"},
        },
        default = "simple",
    },
    
    Title(""),
    Title(labels.warning_settings),
    {
        name = "enable_warning",
        label = labels.enable_warning,
        hover = labels.enable_warning_hover,
        options = {
            {description = labels.enable, data = true},
            {description = labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "warning_time",
        label = labels.warning_time,
        hover = labels.warning_time_hover,
        options = {
            {description = "10", data = 10},
            {description = "20", data = 20},
            {description = "30", data = 30},
            {description = "40", data = 40},
            {description = "50", data = 50},
            {description = "60", data = 60},
        },
        default = 60,
    },
    
    Title(""),
    Title(labels.experimental),
    Title(labels.experimental_warning),
    {
        name = "enable_no_repeat",
        label = labels.enable_no_repeat,
        hover = labels.enable_no_repeat_hover,
        options = {
            {description = labels.enable, data = true},
            {description = labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "repeat_limit",
        label = labels.repeat_limit,
        hover = labels.repeat_limit_hover,
        options = {
            {description = labels.times(1), data = 1},
            {description = labels.times(2), data = 2},
            {description = labels.times(3), data = 3},
            {description = labels.times(4), data = 4},
            {description = labels.times(5), data = 5},
            {description = labels.times(6), data = 6},
            {description = labels.times(7), data = 7},
            {description = labels.times(8), data = 8},
            {description = labels.times(9), data = 9},
            {description = labels.times(10), data = 10},
        },
        default = 5,
    },
    
    Title(""),
    Title(labels.mod_info),
    Title(labels.version_info),
    Title(labels.event_breakdown),
    Title(labels.greeting),
    Title(labels.author_info),
    Title(labels.contact),
    Title(labels.thanks)
}