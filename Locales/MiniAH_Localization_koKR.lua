-- MiniAH_Localization_koKR.lua
-- MiniAHScanner를 위한 한국어 지역화

local ADDON_NAME, MiniAH = ...

-- 플레이어의 언어가 한국어인 경우에만 계속
local locale = GetLocale()
if locale ~= "koKR" then return end

-- 지역화 테이블
local L = MiniAH.L

-- 한국어 번역
L = {
    -- 일반
    ["ADDON_LOADED"] = "%s v%s 로드됨. 옵션을 보려면 %s를 입력하세요.",
    ["COMMAND_HELP"] = "도움말을 보려면 %s를 입력하세요.",
    
    -- 메시지
    ["SCAN_IN_PROGRESS"] = "스캔이 이미 진행 중입니다.",
    ["AH_CLOSED"] = "스캔을 시작하려면 경매장이 열려 있어야 합니다.",
    ["SCAN_STARTED"] = "자동 스캔 시작 중...",
    ["SCAN_MANUAL_STARTED"] = "스캔 시작 중...",
    ["SCAN_PAGE"] = "%d 페이지 스캔 중...",
    ["SCAN_COMPLETE"] = "스캔 완료! %d 아이템을 %s 동안 스캔했습니다.",
    ["SCAN_INTERRUPTED"] = "스캔 중단: %s",
    ["SCAN_WAIT"] = "자동 스캔이 비활성화되었습니다. 다음 스캔은 %d분 후에 가능합니다.",
    ["NEXT_SCAN_TIMER"] = "다음 스캔 가능 시간: %d분 %d초",
    ["PROCESSING_DATA"] = "데이터 처리 중...",
    
    -- 인터페이스
    ["OPTIONS"] = "옵션",
    ["GENERAL"] = "일반",
    ["SCAN"] = "스캔",
    ["DISPLAY"] = "표시",
    ["ADVANCED"] = "고급",
    ["CLOSE"] = "닫기",
    
    -- 일반 섹션
    ["INFORMATION"] = "정보",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner는 경매장을 스캔하고 툴팁에 가격을 표시하는 경량 애드온입니다. 서버 연결 끊김을 방지하기 위해 15분 제한을 준수하면서 단순하고 효율적으로 설계되었습니다.",
    ["STATISTICS"] = "통계",
    ["ITEMS_RECORDED"] = "기록된 아이템: ",
    ["SCAN_COUNT"] = "스캔 횟수: ",
    ["LAST_SCAN"] = "마지막 스캔: ",
    ["LAST_SCAN_DURATION"] = "마지막 스캔 지속 시간: ",
    ["NEVER"] = "없음",
    ["START_SCAN"] = "스캔 시작",
    ["CLEAN_DATABASE"] = "데이터베이스 정리",
    
    -- 스캔 섹션
    ["SCAN_OPTIONS"] = "스캔 옵션",
    ["AUTO_SCAN"] = "자동 스캔",
    ["AUTO_SCAN_TOOLTIP"] = "경매장을 열 때 자동으로 스캔합니다",
    ["SCAN_INTERVAL"] = "스캔 간격 (분)",
    ["SCAN_INTERVAL_TOOLTIP"] = "자동 스캔 사이의 간격 (15-60분).",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "스캔 완료 소리",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "경매장 스캔이 완료되면 소리를 재생합니다.",
    ["ARCHIVE_OPTIONS"] = "보관 옵션",
    ["KEEP_HISTORY"] = "가격 기록 유지",
    ["KEEP_HISTORY_TOOLTIP"] = "각 아이템의 가격 기록을 유지합니다",
    ["HISTORY_DAYS"] = "유지할 기록 일수",
    ["HISTORY_DAYS_TOOLTIP"] = "유지할 기록의 일수",
    ["CLEAN_OLD_DATA"] = "오래된 데이터 제거 (일)",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "데이터가 오래된 것으로 간주되는 일수",
    
    -- 표시 섹션
    ["TOOLTIP_OPTIONS"] = "툴팁",
    ["SHOW_AUCTION_PRICE"] = "툴팁에 경매 가격 표시",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "아이템 툴팁에 경매 가격을 표시합니다",
    ["SHOW_VENDOR_PRICE"] = "툴팁에 상인 가격 표시",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "아이템 툴팁에 상인 가격을 표시합니다",
    ["SHOW_AGE"] = "툴팁에 데이터 나이 표시",
    ["SHOW_AGE_TOOLTIP"] = "가격이 스캔된 지 얼마나 지났는지 표시합니다",
    ["COLOR_PRICES"] = "가격에 색상 사용",
    ["COLOR_PRICES_TOOLTIP"] = "가격을 색상으로 표시합니다 (금, 은, 동)",
    ["USE_COIN_ICONS"] = "동전 아이콘 사용",
    ["USE_COIN_ICONS_TOOLTIP"] = "툴팁에서 금/은/동 글자 대신 금화, 은화, 동화 아이콘을 표시합니다",
    ["UI_OPTIONS"] = "인터페이스",
    ["SHOW_MINIMAP"] = "미니맵 버튼 표시",
    ["SHOW_MINIMAP_TOOLTIP"] = "애드온에 빠르게 접근할 수 있는 미니맵 버튼을 표시합니다",
    
    -- 고급 섹션
    ["ADVANCED_OPTIONS"] = "고급 옵션",
    ["RESET_OPTIONS"] = "옵션 초기화",
    ["RESET_DATABASE"] = "데이터베이스 초기화",
    ["YES"] = "예",
    ["NO"] = "아니오",
    ["RESET_CONFIRM"] = "%s의 모든 옵션을 초기화하시겠습니까?",
    ["RESET_DB_CONFIRM"] = "%s의 데이터베이스를 초기화하시겠습니까?\n모든 가격 데이터가 손실됩니다.",
    
    -- 툴팁
    ["VENDOR"] = "상인",
    ["AH"] = "경매",
    ["AH_STACK"] = "경매 묶음",
    ["UNKNOWN"] = "알 수 없음",
    ["SHIFT_STACK"] = "[Shift] 묶음 가격",
    
    -- 시간 단위
    ["DAYS"] = "일",
    ["HOURS"] = "시간",
    ["MINUTES"] = "분",
    ["SECONDS"] = "초",
}
