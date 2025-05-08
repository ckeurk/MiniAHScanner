-- MiniAH_Localization.lua
-- Système de localisation pour MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Table de localisation
MiniAH.L = {}
local L = MiniAH.L

-- Langue par défaut (français)
local locale = GetLocale()

-- Table des traductions
local localizations = {
    -- Français (par défaut)
    ["frFR"] = {
        -- Général
        ["ADDON_LOADED"] = "%s v%s chargé. Tapez %s pour les options.",
        ["COMMAND_HELP"] = "Tapez %s pour l'aide.",
        
        -- Messages
        ["SCAN_IN_PROGRESS"] = "Un scan est déjà en cours.",
        ["AH_CLOSED"] = "L'hôtel des ventes doit être ouvert pour lancer un scan.",
        ["SCAN_STARTED"] = "Démarrage du scan automatique...",
        ["SCAN_MANUAL_STARTED"] = "Démarrage du scan en cours...",
        ["SCAN_PAGE"] = "Scan de la page %d...",
        ["SCAN_COMPLETE"] = "Scan terminé ! %d objets scannés en %s.",
        ["SCAN_INTERRUPTED"] = "Scan interrompu : %s",
        ["SCAN_WAIT"] = "Scan automatique désactivé. Prochain scan possible dans %d minute(s).",
        ["NEXT_SCAN_TIMER"] = "Prochain scan possible dans %d min %d sec",
        ["PROCESSING_DATA"] = "Traitement des données...",
        
        -- Interface
        ["OPTIONS"] = "Options",
        ["GENERAL"] = "Général",
        ["SCAN"] = "Scan",
        ["DISPLAY"] = "Affichage",
        ["ADVANCED"] = "Avancé",
        ["CLOSE"] = "Fermer",
        
        -- Section Général
        ["INFORMATION"] = "Informations",
        ["ADDON_DESCRIPTION"] = "MiniAHScanner est un addon léger pour scanner l'hôtel des ventes et afficher les prix dans les infobulles. Il est conçu pour être simple et efficace, tout en respectant une limite de 15 minutes pour éviter la déconnexion du serveur.",
        ["STATISTICS"] = "Statistiques",
        ["ITEMS_RECORDED"] = "Objets enregistrés: ",
        ["SCAN_COUNT"] = "Nombre de scans: ",
        ["LAST_SCAN"] = "Dernier scan: ",
        ["LAST_SCAN_DURATION"] = "Durée du dernier scan: ",
        ["NEVER"] = "Jamais",
        ["START_SCAN"] = "Lancer un scan",
        ["CLEAN_DATABASE"] = "Nettoyer la base de données",
        
        -- Section Scan
        ["SCAN_OPTIONS"] = "Options de scan",
        ["AUTO_SCAN"] = "Scan automatique",
        ["AUTO_SCAN_TOOLTIP"] = "Active le scan automatique de l'hôtel des ventes lorsqu'il est ouvert.",
        ["SCAN_INTERVAL"] = "Intervalle de scan (minutes)",
        ["SCAN_INTERVAL_TOOLTIP"] = "Intervalle entre les scans automatiques (15-60 minutes).",
        ["PLAY_SCAN_COMPLETE_SOUND"] = "Son de fin de scan",
        ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Joue un son lorsque le scan de l'hôtel des ventes est terminé.",
        ["ARCHIVE_OPTIONS"] = "Options d'archivage",
        ["KEEP_HISTORY"] = "Conserver l'historique des prix",
        ["KEEP_HISTORY_TOOLTIP"] = "Conserve l'historique des prix pour chaque objet",
        ["HISTORY_DAYS"] = "Jours d'historique à conserver",
        ["HISTORY_DAYS_TOOLTIP"] = "Nombre de jours d'historique à conserver",
        ["CLEAN_OLD_DATA"] = "Supprimer données anciennes (jours)",
        ["CLEAN_OLD_DATA_TOOLTIP"] = "Nombre de jours après lesquels les données sont considérées comme périmées",
        
        -- Section Affichage
        ["TOOLTIP_OPTIONS"] = "Infobulles",
        ["SHOW_AUCTION_PRICE"] = "Afficher les prix de l'hôtel des ventes dans l'infobulle",
        ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Affiche les prix de l'hôtel des ventes dans l'infobulle des objets",
        ["SHOW_VENDOR_PRICE"] = "Afficher les prix vendeur dans l'infobulle",
        ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Affiche les prix vendeur dans l'infobulle des objets",
        ["SHOW_AGE"] = "Afficher le temps des données dans l'infobulle",
        ["SHOW_AGE_TOOLTIP"] = "Affiche depuis quand les prix ont été scannés",
        ["COLOR_PRICES"] = "Utiliser des couleurs pour les prix",
        ["COLOR_PRICES_TOOLTIP"] = "Affiche les prix avec des couleurs (or, argent, cuivre)",
        ["UI_OPTIONS"] = "Interface",
        ["SHOW_MINIMAP"] = "Afficher le bouton sur la minimap",
        ["SHOW_MINIMAP_TOOLTIP"] = "Affiche un bouton sur la minimap pour accéder rapidement à l'addon",
        
        -- Section Avancé
        ["ADVANCED_OPTIONS"] = "Options avancées",
        ["RESET_OPTIONS"] = "Réinitialiser les options",
        ["RESET_DATABASE"] = "Réinitialiser la base de données",
        ["YES"] = "Oui",
        ["NO"] = "Non",
        ["RESET_CONFIRM"] = "Êtes-vous sûr de vouloir réinitialiser toutes les options de %s ?",
        ["RESET_DB_CONFIRM"] = "Êtes-vous sûr de vouloir réinitialiser la base de données de %s ?\nToutes les données de prix seront perdues.",
        
        -- Infobulles
        ["VENDOR"] = "Vendeur",
        ["AH"] = "AH",
        ["AH_STACK"] = "AH Stack",
        ["UNKNOWN"] = "Inconnu",
        ["SHIFT_STACK"] = "[Shift] pour prix par stack",
        
        -- Unités de temps
        ["DAYS"] = "j",
        ["HOURS"] = "h",
        ["MINUTES"] = "min",
        ["SECONDS"] = "s",
    },
    
    -- Anglais
    ["enUS"] = {
        -- General
        ["ADDON_LOADED"] = "%s v%s loaded. Type %s for options.",
        ["COMMAND_HELP"] = "Type %s for help.",
        
        -- Messages
        ["SCAN_IN_PROGRESS"] = "A scan is already in progress.",
        ["AH_CLOSED"] = "The Auction House must be open to start a scan.",
        ["SCAN_STARTED"] = "Starting automatic scan...",
        ["SCAN_MANUAL_STARTED"] = "Starting scan in progress...",
        ["SCAN_PAGE"] = "Scanning page %d...",
        ["SCAN_COMPLETE"] = "Scan complete! %d items scanned in %s.",
        ["SCAN_INTERRUPTED"] = "Scan interrupted: %s",
        ["SCAN_WAIT"] = "Automatic scan disabled. Next scan possible in %d minute(s).",
        ["NEXT_SCAN_TIMER"] = "Next scan possible in %d min %d sec",
        ["PROCESSING_DATA"] = "Processing data...",
        
        -- Interface
        ["OPTIONS"] = "Options",
        ["GENERAL"] = "General",
        ["SCAN"] = "Scan",
        ["DISPLAY"] = "Display",
        ["ADVANCED"] = "Advanced",
        ["CLOSE"] = "Close",
        
        -- General Section
        ["INFORMATION"] = "Information",
        ["ADDON_DESCRIPTION"] = "MiniAHScanner is a lightweight addon for scanning the Auction House and displaying prices in tooltips. It is designed to be simple and efficient, while respecting a 15-minute limit to avoid server disconnection.",
        ["STATISTICS"] = "Statistics",
        ["ITEMS_RECORDED"] = "Items recorded: ",
        ["SCAN_COUNT"] = "Scan count: ",
        ["LAST_SCAN"] = "Last scan: ",
        ["LAST_SCAN_DURATION"] = "Last scan duration: ",
        ["NEVER"] = "Never",
        ["START_SCAN"] = "Start Scan",
        ["CLEAN_DATABASE"] = "Clean Database",
        
        -- Scan Section
        ["SCAN_OPTIONS"] = "Scan Options",
        ["AUTO_SCAN"] = "Auto-scan",
        ["AUTO_SCAN_TOOLTIP"] = "Automatically scans the Auction House when you open it",
        ["SCAN_INTERVAL"] = "Scan interval (minutes)",
        ["SCAN_INTERVAL_TOOLTIP"] = "Interval between automatic scans (15-60 minutes).",
        ["PLAY_SCAN_COMPLETE_SOUND"] = "Scan complete sound",
        ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Plays a sound when the Auction House scan is complete.",
        ["ARCHIVE_OPTIONS"] = "Archive Options",
        ["KEEP_HISTORY"] = "Keep price history",
        ["KEEP_HISTORY_TOOLTIP"] = "Keeps price history for each item",
        ["HISTORY_DAYS"] = "Days of history to keep",
        ["HISTORY_DAYS_TOOLTIP"] = "Number of days of history to keep",
        ["CLEAN_OLD_DATA"] = "Remove old data (days)",
        ["CLEAN_OLD_DATA_TOOLTIP"] = "Number of days after which data is considered outdated",
        
        -- Display Section
        ["TOOLTIP_OPTIONS"] = "Tooltips",
        ["SHOW_AUCTION_PRICE"] = "Show auction prices in tooltips",
        ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Displays auction prices in item tooltips",
        ["SHOW_VENDOR_PRICE"] = "Show vendor prices in tooltips",
        ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Displays vendor prices in item tooltips",
        ["SHOW_AGE"] = "Show data age in tooltips",
        ["SHOW_AGE_TOOLTIP"] = "Shows how long ago prices were scanned",
        ["COLOR_PRICES"] = "Use colors for prices",
        ["COLOR_PRICES_TOOLTIP"] = "Displays prices with colors (gold, silver, copper)",
        ["UI_OPTIONS"] = "Interface",
        ["SHOW_MINIMAP"] = "Show minimap button",
        ["SHOW_MINIMAP_TOOLTIP"] = "Displays a button on the minimap for quick access to the addon",
        
        -- Advanced Section
        ["ADVANCED_OPTIONS"] = "Advanced Options",
        ["RESET_OPTIONS"] = "Reset Options",
        ["RESET_DATABASE"] = "Reset Database",
        ["YES"] = "Yes",
        ["NO"] = "No",
        ["RESET_CONFIRM"] = "Are you sure you want to reset all options for %s?",
        ["RESET_DB_CONFIRM"] = "Are you sure you want to reset the database for %s?\nAll price data will be lost.",
        
        -- Tooltips
        ["VENDOR"] = "Vendor",
        ["AH"] = "AH",
        ["AH_STACK"] = "AH Stack",
        ["UNKNOWN"] = "Unknown",
        ["SHIFT_STACK"] = "[Shift] for stack price",
        
        -- Time units
        ["DAYS"] = "d",
        ["HOURS"] = "h",
        ["MINUTES"] = "min",
        ["SECONDS"] = "s",
    },
    
    -- Allemand (déplacé vers MiniAH_Localization_deDE.lua)
    ["deDE"] = {},
    
    -- Espagnol (à compléter)
    ["esES"] = {},
    ["esMX"] = {},
    
    -- Italien (à compléter)
    ["itIT"] = {},
    
    -- Portugais (à compléter)
    ["ptBR"] = {},
    
    -- Russe (déplacé vers MiniAH_Localization_ruRU.lua)
    ["ruRU"] = {},
    
    -- Coréen (à compléter)
    ["koKR"] = {},
    
    -- Chinois (à compléter)
    ["zhCN"] = {},
    ["zhTW"] = {},
}

-- Fonction pour récupérer une chaîne localisée
function MiniAH:GetText(key, ...)
    -- Récupérer la table de localisation pour la langue actuelle ou utiliser le français par défaut
    local strings = localizations[locale] or localizations["frFR"]
    
    -- Récupérer la chaîne localisée ou utiliser la clé si elle n'existe pas
    local text = strings[key]
    if not text then
        -- Essayer de trouver la chaîne en français
        text = localizations["frFR"][key]
        if not text then
            -- Si toujours pas trouvé, utiliser la clé
            return key
        end
    end
    
    -- Formater la chaîne avec les arguments supplémentaires
    if ... then
        return string.format(text, ...)
    else
        return text
    end
end

-- Alias plus court pour faciliter l'utilisation
MiniAH.T = MiniAH.GetText

