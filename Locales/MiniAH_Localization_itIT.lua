-- MiniAH_Localization_itIT.lua
-- Localizzazione italiana per MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Continuare solo se la lingua del giocatore è italiano
local locale = GetLocale()
if locale ~= "itIT" then return end

-- Tabella di localizzazione
local L = MiniAH.L

-- Traduzioni italiane
L = {
    -- Generale
    ["ADDON_LOADED"] = "%s v%s caricato. Digita %s per le opzioni.",
    ["COMMAND_HELP"] = "Digita %s per l'aiuto.",
    
    -- Messaggi
    ["SCAN_IN_PROGRESS"] = "Una scansione è già in corso.",
    ["AH_CLOSED"] = "La Casa d'Aste deve essere aperta per iniziare una scansione.",
    ["SCAN_STARTED"] = "Avvio scansione automatica...",
    ["SCAN_MANUAL_STARTED"] = "Avvio scansione in corso...",
    ["SCAN_PAGE"] = "Scansione pagina %d...",
    ["SCAN_COMPLETE"] = "Scansione completata! %d oggetti scansionati in %s.",
    ["SCAN_INTERRUPTED"] = "Scansione interrotta: %s",
    ["SCAN_WAIT"] = "Scansione automatica disabilitata. Prossima scansione possibile in %d minuto(i).",
    ["NEXT_SCAN_TIMER"] = "Prossima scansione possibile in %d min %d sec",
    ["PROCESSING_DATA"] = "Elaborazione dati...",
    
    -- Interfaccia
    ["OPTIONS"] = "Opzioni",
    ["GENERAL"] = "Generale",
    ["SCAN"] = "Scansione",
    ["DISPLAY"] = "Visualizzazione",
    ["ADVANCED"] = "Avanzate",
    ["CLOSE"] = "Chiudi",
    
    -- Sezione Generale
    ["INFORMATION"] = "Informazioni",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner è un addon leggero per scansionare la Casa d'Aste e visualizzare i prezzi nei tooltip. È progettato per essere semplice ed efficiente, rispettando un limite di 15 minuti per evitare la disconnessione dal server.",
    ["STATISTICS"] = "Statistiche",
    ["ITEMS_RECORDED"] = "Oggetti registrati: ",
    ["SCAN_COUNT"] = "Numero di scansioni: ",
    ["LAST_SCAN"] = "Ultima scansione: ",
    ["LAST_SCAN_DURATION"] = "Durata dell'ultima scansione: ",
    ["NEVER"] = "Mai",
    ["START_SCAN"] = "Avvia scansione",
    ["CLEAN_DATABASE"] = "Pulisci database",
    
    -- Sezione Scansione
    ["SCAN_OPTIONS"] = "Opzioni di scansione",
    ["AUTO_SCAN"] = "Scansione automatica",
    ["AUTO_SCAN_TOOLTIP"] = "Scansiona automaticamente la Casa d'Aste quando viene aperta",
    ["SCAN_INTERVAL"] = "Intervallo di scansione (minuti)",
    ["SCAN_INTERVAL_TOOLTIP"] = "Intervallo tra le scansioni automatiche (15-60 minuti).",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "Suono di completamento scansione",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Riproduce un suono quando la scansione della Casa d'Aste è completata.",
    ["ARCHIVE_OPTIONS"] = "Opzioni di archiviazione",
    ["KEEP_HISTORY"] = "Mantieni cronologia prezzi",
    ["KEEP_HISTORY_TOOLTIP"] = "Mantiene la cronologia dei prezzi per ogni oggetto",
    ["HISTORY_DAYS"] = "Giorni di cronologia da mantenere",
    ["HISTORY_DAYS_TOOLTIP"] = "Numero di giorni di cronologia da mantenere",
    ["CLEAN_OLD_DATA"] = "Rimuovi dati vecchi (giorni)",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "Numero di giorni dopo i quali i dati sono considerati obsoleti",
    
    -- Sezione Visualizzazione
    ["TOOLTIP_OPTIONS"] = "Tooltip",
    ["SHOW_AUCTION_PRICE"] = "Mostra prezzi d'asta nei tooltip",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Visualizza i prezzi d'asta nei tooltip degli oggetti",
    ["SHOW_VENDOR_PRICE"] = "Mostra prezzi dei venditori nei tooltip",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Visualizza i prezzi dei venditori nei tooltip degli oggetti",
    ["SHOW_AGE"] = "Mostra età dei dati nei tooltip",
    ["SHOW_AGE_TOOLTIP"] = "Mostra quanto tempo fa sono stati scansionati i prezzi",
    ["COLOR_PRICES"] = "Usa colori per i prezzi",
    ["COLOR_PRICES_TOOLTIP"] = "Visualizza i prezzi con colori (oro, argento, rame)",
    ["UI_OPTIONS"] = "Interfaccia",
    ["SHOW_MINIMAP"] = "Mostra pulsante sulla minimappa",
    ["SHOW_MINIMAP_TOOLTIP"] = "Visualizza un pulsante sulla minimappa per un accesso rapido all'addon",
    
    -- Sezione Avanzate
    ["ADVANCED_OPTIONS"] = "Opzioni avanzate",
    ["RESET_OPTIONS"] = "Reimposta opzioni",
    ["RESET_DATABASE"] = "Reimposta database",
    ["YES"] = "Sì",
    ["NO"] = "No",
    ["RESET_CONFIRM"] = "Sei sicuro di voler reimpostare tutte le opzioni per %s?",
    ["RESET_DB_CONFIRM"] = "Sei sicuro di voler reimpostare il database per %s?\nTutti i dati sui prezzi andranno persi.",
    
    -- Tooltip
    ["VENDOR"] = "Venditore",
    ["AH"] = "CA",
    ["AH_STACK"] = "CA Pila",
    ["UNKNOWN"] = "Sconosciuto",
    ["SHIFT_STACK"] = "[Shift] per prezzo della pila",
    
    -- Unità di tempo
    ["DAYS"] = "g",
    ["HOURS"] = "h",
    ["MINUTES"] = "min",
    ["SECONDS"] = "s",
}
