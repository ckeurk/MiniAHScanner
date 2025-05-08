-- MiniAH_Localization_zhTW.lua
-- MiniAHScanner的繁體中文本地化

local ADDON_NAME, MiniAH = ...

-- 僅在玩家語言為繁體中文時繼續
local locale = GetLocale()
if locale ~= "zhTW" then return end

-- 本地化表
local L = MiniAH.L

-- 繁體中文翻譯
L = {
    -- 一般
    ["ADDON_LOADED"] = "%s v%s 已載入。輸入 %s 查看選項。",
    ["COMMAND_HELP"] = "輸入 %s 獲取幫助。",
    
    -- 訊息
    ["SCAN_IN_PROGRESS"] = "掃描已在進行中。",
    ["AH_CLOSED"] = "必須打開拍賣行才能開始掃描。",
    ["SCAN_STARTED"] = "開始自動掃描...",
    ["SCAN_MANUAL_STARTED"] = "開始掃描...",
    ["SCAN_PAGE"] = "正在掃描第 %d 頁...",
    ["SCAN_COMPLETE"] = "掃描完成！在 %s 內掃描了 %d 個物品。",
    ["SCAN_INTERRUPTED"] = "掃描中斷：%s",
    ["SCAN_WAIT"] = "自動掃描已禁用。下次掃描可在 %d 分鐘後進行。",
    ["NEXT_SCAN_TIMER"] = "下次掃描可在 %d 分 %d 秒後進行",
    ["PROCESSING_DATA"] = "正在處理數據...",
    
    -- 界面
    ["OPTIONS"] = "選項",
    ["GENERAL"] = "一般",
    ["SCAN"] = "掃描",
    ["DISPLAY"] = "顯示",
    ["ADVANCED"] = "進階",
    ["CLOSE"] = "關閉",
    
    -- 一般部分
    ["INFORMATION"] = "資訊",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner是一個輕量級插件，用於掃描拍賣行並在滑鼠提示中顯示價格。它設計簡單高效，同時遵守15分鐘限制以避免伺服器斷開連接。",
    ["STATISTICS"] = "統計",
    ["ITEMS_RECORDED"] = "記錄的物品：",
    ["SCAN_COUNT"] = "掃描次數：",
    ["LAST_SCAN"] = "上次掃描：",
    ["LAST_SCAN_DURATION"] = "上次掃描持續時間：",
    ["NEVER"] = "從未",
    ["START_SCAN"] = "開始掃描",
    ["CLEAN_DATABASE"] = "清理資料庫",
    
    -- 掃描部分
    ["SCAN_OPTIONS"] = "掃描選項",
    ["AUTO_SCAN"] = "自動掃描",
    ["AUTO_SCAN_TOOLTIP"] = "打開拍賣行時自動掃描",
    ["SCAN_INTERVAL"] = "掃描間隔（分鐘）",
    ["SCAN_INTERVAL_TOOLTIP"] = "自動掃描之間的間隔（15-60分鐘）。",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "掃描完成音效",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "拍賣行掃描完成時播放音效。",
    ["ARCHIVE_OPTIONS"] = "存檔選項",
    ["KEEP_HISTORY"] = "保留價格歷史",
    ["KEEP_HISTORY_TOOLTIP"] = "為每個物品保留價格歷史",
    ["HISTORY_DAYS"] = "保留歷史天數",
    ["HISTORY_DAYS_TOOLTIP"] = "要保留的歷史天數",
    ["CLEAN_OLD_DATA"] = "刪除舊數據（天）",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "數據被視為過時的天數",
    
    -- 顯示部分
    ["TOOLTIP_OPTIONS"] = "滑鼠提示",
    ["SHOW_AUCTION_PRICE"] = "在滑鼠提示中顯示拍賣價格",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "在物品滑鼠提示中顯示拍賣價格",
    ["SHOW_VENDOR_PRICE"] = "在滑鼠提示中顯示商人價格",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "在物品滑鼠提示中顯示商人價格",
    ["SHOW_AGE"] = "在滑鼠提示中顯示數據年齡",
    ["SHOW_AGE_TOOLTIP"] = "顯示價格掃描的時間",
    ["COLOR_PRICES"] = "使用顏色顯示價格",
    ["COLOR_PRICES_TOOLTIP"] = "使用顏色顯示價格（金，銀，銅）",
    ["UI_OPTIONS"] = "界面",
    ["SHOW_MINIMAP"] = "顯示小地圖按鈕",
    ["SHOW_MINIMAP_TOOLTIP"] = "在小地圖上顯示按鈕以快速訪問插件",
    
    -- 進階部分
    ["ADVANCED_OPTIONS"] = "進階選項",
    ["RESET_OPTIONS"] = "重置選項",
    ["RESET_DATABASE"] = "重置資料庫",
    ["YES"] = "是",
    ["NO"] = "否",
    ["RESET_CONFIRM"] = "您確定要重置 %s 的所有選項嗎？",
    ["RESET_DB_CONFIRM"] = "您確定要重置 %s 的資料庫嗎？\n所有價格數據將丟失。",
    
    -- 滑鼠提示
    ["VENDOR"] = "商人",
    ["AH"] = "拍賣",
    ["AH_STACK"] = "拍賣堆疊",
    ["UNKNOWN"] = "未知",
    ["SHIFT_STACK"] = "[Shift] 查看堆疊價格",
    
    -- 時間單位
    ["DAYS"] = "天",
    ["HOURS"] = "小時",
    ["MINUTES"] = "分",
    ["SECONDS"] = "秒",
}
