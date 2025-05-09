-- MiniAH_Localization_deDE.lua
-- Deutsche Lokalisierung für MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Nur fortfahren, wenn die Spielersprache Deutsch ist
local locale = GetLocale()
if locale ~= "deDE" then return end

-- Lokalisierungstabelle
local L = MiniAH.L

-- Deutsche Übersetzungen
L = {
    -- Allgemein
    ["ADDON_LOADED"] = "%s v%s geladen. Tippen Sie %s für Optionen.",
    ["COMMAND_HELP"] = "Tippen Sie %s für Hilfe.",
    
    -- Nachrichten
    ["SCAN_IN_PROGRESS"] = "Ein Scan läuft bereits.",
    ["AH_CLOSED"] = "Das Auktionshaus muss geöffnet sein, um einen Scan zu starten.",
    ["SCAN_STARTED"] = "Automatischer Scan wird gestartet...",
    ["SCAN_MANUAL_STARTED"] = "Scan wird gestartet...",
    ["SCAN_PAGE"] = "Scanne Seite %d...",
    ["SCAN_COMPLETE"] = "Scan abgeschlossen! %d Gegenstände in %s gescannt.",
    ["SCAN_INTERRUPTED"] = "Scan unterbrochen: %s",
    ["SCAN_WAIT"] = "Automatischer Scan deaktiviert. Nächster Scan möglich in %d Minute(n).",
    ["NEXT_SCAN_TIMER"] = "Nächster Scan möglich in %d Min %d Sek",
    ["PROCESSING_DATA"] = "Daten werden verarbeitet...",
    
    -- Oberfläche
    ["OPTIONS"] = "Optionen",
    ["GENERAL"] = "Allgemein",
    ["SCAN"] = "Scan",
    ["DISPLAY"] = "Anzeige",
    ["ADVANCED"] = "Erweitert",
    ["CLOSE"] = "Schließen",
    
    -- Allgemeine Sektion
    ["INFORMATION"] = "Informationen",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner ist ein leichtgewichtiges Addon zum Scannen des Auktionshauses und zur Anzeige von Preisen in Tooltips. Es ist einfach und effizient gestaltet und respektiert eine 15-Minuten-Grenze, um Servertrennungen zu vermeiden.",
    ["STATISTICS"] = "Statistiken",
    ["ITEMS_RECORDED"] = "Erfasste Gegenstände: ",
    ["SCAN_COUNT"] = "Anzahl der Scans: ",
    ["LAST_SCAN"] = "Letzter Scan: ",
    ["LAST_SCAN_DURATION"] = "Dauer des letzten Scans: ",
    ["NEVER"] = "Nie",
    ["START_SCAN"] = "Scan starten",
    ["CLEAN_DATABASE"] = "Datenbank bereinigen",
    
    -- Scan-Sektion
    ["SCAN_OPTIONS"] = "Scan-Optionen",
    ["AUTO_SCAN"] = "Auto-Scan",
    ["AUTO_SCAN_TOOLTIP"] = "Scannt das Auktionshaus automatisch, wenn es geöffnet wird",
    ["SCAN_INTERVAL"] = "Scan-Intervall (Minuten)",
    ["SCAN_INTERVAL_TOOLTIP"] = "Intervall zwischen automatischen Scans (15-60 Minuten).",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "Ton bei Scan-Abschluss",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Spielt einen Ton ab, wenn der Auktionshaus-Scan abgeschlossen ist.",
    ["ARCHIVE_OPTIONS"] = "Archivierungsoptionen",
    ["KEEP_HISTORY"] = "Preishistorie behalten",
    ["KEEP_HISTORY_TOOLTIP"] = "Behält die Preishistorie für jeden Gegenstand",
    ["HISTORY_DAYS"] = "Tage der Historie zum Behalten",
    ["HISTORY_DAYS_TOOLTIP"] = "Anzahl der Tage der Historie, die behalten werden sollen",
    ["CLEAN_OLD_DATA"] = "Alte Daten entfernen (Tage)",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "Anzahl der Tage, nach denen Daten als veraltet gelten",
    
    -- Anzeige-Sektion
    ["TOOLTIP_OPTIONS"] = "Tooltips",
    ["SHOW_AUCTION_PRICE"] = "Auktionspreise in Tooltips anzeigen",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Zeigt Auktionspreise in Gegenstandstooltips an",
    ["SHOW_VENDOR_PRICE"] = "Händlerpreise in Tooltips anzeigen",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Zeigt Händlerpreise in Gegenstandstooltips an",
    ["SHOW_AGE"] = "Datenalter in Tooltips anzeigen",
    ["SHOW_AGE_TOOLTIP"] = "Zeigt an, wie lange die Preise bereits gescannt wurden",
    ["COLOR_PRICES"] = "Farben für Preise verwenden",
    ["COLOR_PRICES_TOOLTIP"] = "Zeigt Preise mit Farben an (Gold, Silber, Kupfer)",
    ["USE_COIN_ICONS"] = "Münzsymbole verwenden",
    ["USE_COIN_ICONS_TOOLTIP"] = "Zeigt Gold-, Silber- und Kupfermünzsymbole anstelle der Buchstaben g/s/c in Tooltips an",
    ["UI_OPTIONS"] = "Benutzeroberfläche",
    ["SHOW_MINIMAP"] = "Minimap-Button anzeigen",
    ["SHOW_MINIMAP_TOOLTIP"] = "Zeigt einen Button auf der Minimap für schnellen Zugriff auf das Addon an",
    
    -- Erweiterte Sektion
    ["ADVANCED_OPTIONS"] = "Erweiterte Optionen",
    ["RESET_OPTIONS"] = "Optionen zurücksetzen",
    ["RESET_DATABASE"] = "Datenbank zurücksetzen",
    ["YES"] = "Ja",
    ["NO"] = "Nein",
    ["RESET_CONFIRM"] = "Sind Sie sicher, dass Sie alle Optionen für %s zurücksetzen möchten?",
    ["RESET_DB_CONFIRM"] = "Sind Sie sicher, dass Sie die Datenbank für %s zurücksetzen möchten?\nAlle Preisdaten gehen verloren.",
    
    -- Tooltips
    ["VENDOR"] = "Händler",
    ["AH"] = "AH",
    ["AH_STACK"] = "AH Stapel",
    ["UNKNOWN"] = "Unbekannt",
    ["SHIFT_STACK"] = "[Shift] für Stapelpreis",
    
    -- Zeiteinheiten
    ["DAYS"] = "T",
    ["HOURS"] = "Std",
    ["MINUTES"] = "Min",
    ["SECONDS"] = "Sek",
}

-- Setze die Lokalisierungstabelle
MiniAH.L = L
