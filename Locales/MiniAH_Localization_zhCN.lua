-- MiniAH_Localization_zhCN.lua
-- MiniAHScanner的简体中文本地化

local ADDON_NAME, MiniAH = ...

-- 仅在玩家语言为简体中文时继续
local locale = GetLocale()
if locale ~= "zhCN" then return end

-- 本地化表
local L = MiniAH.L

-- 简体中文翻译
L = {
    -- 一般
    ["ADDON_LOADED"] = "%s v%s 已加载。输入 %s 查看选项。",
    ["COMMAND_HELP"] = "输入 %s 获取帮助。",
    
    -- 消息
    ["SCAN_IN_PROGRESS"] = "扫描已在进行中。",
    ["AH_CLOSED"] = "必须打开拍卖行才能开始扫描。",
    ["SCAN_STARTED"] = "开始自动扫描...",
    ["SCAN_MANUAL_STARTED"] = "开始扫描...",
    ["SCAN_PAGE"] = "正在扫描第 %d 页...",
    ["SCAN_COMPLETE"] = "扫描完成！在 %s 内扫描了 %d 个物品。",
    ["SCAN_INTERRUPTED"] = "扫描中断：%s",
    ["SCAN_WAIT"] = "自动扫描已禁用。下次扫描可在 %d 分钟后进行。",
    ["NEXT_SCAN_TIMER"] = "下次扫描可在 %d 分 %d 秒后进行",
    ["PROCESSING_DATA"] = "正在处理数据...",
    
    -- 界面
    ["OPTIONS"] = "选项",
    ["GENERAL"] = "一般",
    ["SCAN"] = "扫描",
    ["DISPLAY"] = "显示",
    ["ADVANCED"] = "高级",
    ["CLOSE"] = "关闭",
    
    -- 一般部分
    ["INFORMATION"] = "信息",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner是一个轻量级插件，用于扫描拍卖行并在鼠标提示中显示价格。它设计简单高效，同时遵守15分钟限制以避免服务器断开连接。",
    ["STATISTICS"] = "统计",
    ["ITEMS_RECORDED"] = "记录的物品：",
    ["SCAN_COUNT"] = "扫描次数：",
    ["LAST_SCAN"] = "上次扫描：",
    ["LAST_SCAN_DURATION"] = "上次扫描持续时间：",
    ["NEVER"] = "从未",
    ["START_SCAN"] = "开始扫描",
    ["CLEAN_DATABASE"] = "清理数据库",
    
    -- 扫描部分
    ["SCAN_OPTIONS"] = "扫描选项",
    ["AUTO_SCAN"] = "自动扫描",
    ["AUTO_SCAN_TOOLTIP"] = "打开拍卖行时自动扫描",
    ["SCAN_INTERVAL"] = "扫描间隔（分钟）",
    ["SCAN_INTERVAL_TOOLTIP"] = "自动扫描之间的间隔（15-60分钟）。",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "扫描完成声音",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "拍卖行扫描完成时播放声音。",
    ["ARCHIVE_OPTIONS"] = "存档选项",
    ["KEEP_HISTORY"] = "保留价格历史",
    ["KEEP_HISTORY_TOOLTIP"] = "为每个物品保留价格历史",
    ["HISTORY_DAYS"] = "保留历史天数",
    ["HISTORY_DAYS_TOOLTIP"] = "要保留的历史天数",
    ["CLEAN_OLD_DATA"] = "删除旧数据（天）",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "数据被视为过时的天数",
    
    -- 显示部分
    ["TOOLTIP_OPTIONS"] = "鼠标提示",
    ["SHOW_AUCTION_PRICE"] = "在鼠标提示中显示拍卖价格",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "在物品鼠标提示中显示拍卖价格",
    ["SHOW_VENDOR_PRICE"] = "在鼠标提示中显示商人价格",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "在物品鼠标提示中显示商人价格",
    ["SHOW_AGE"] = "在鼠标提示中显示数据年龄",
    ["SHOW_AGE_TOOLTIP"] = "显示价格扫描的时间",
    ["COLOR_PRICES"] = "使用颜色显示价格",
    ["COLOR_PRICES_TOOLTIP"] = "使用颜色显示价格（金，银，铜）",
    ["UI_OPTIONS"] = "界面",
    ["SHOW_MINIMAP"] = "显示小地图按钮",
    ["SHOW_MINIMAP_TOOLTIP"] = "在小地图上显示按钮以快速访问插件",
    
    -- 高级部分
    ["ADVANCED_OPTIONS"] = "高级选项",
    ["RESET_OPTIONS"] = "重置选项",
    ["RESET_DATABASE"] = "重置数据库",
    ["YES"] = "是",
    ["NO"] = "否",
    ["RESET_CONFIRM"] = "您确定要重置 %s 的所有选项吗？",
    ["RESET_DB_CONFIRM"] = "您确定要重置 %s 的数据库吗？\n所有价格数据将丢失。",
    
    -- 鼠标提示
    ["VENDOR"] = "商人",
    ["AH"] = "拍卖",
    ["AH_STACK"] = "拍卖堆叠",
    ["UNKNOWN"] = "未知",
    ["SHIFT_STACK"] = "[Shift] 查看堆叠价格",
    
    -- 时间单位
    ["DAYS"] = "天",
    ["HOURS"] = "小时",
    ["MINUTES"] = "分",
    ["SECONDS"] = "秒",
}
