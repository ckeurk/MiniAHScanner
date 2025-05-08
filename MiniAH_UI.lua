-- MiniAH_UI.lua
-- Interface utilisateur améliorée pour MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Variables locales
local scanFrame = nil
local statsFrame = nil
local optionsFrame = nil

-- Couleurs
local COLORS = {
    TITLE = "|cFFFFD700", -- Or
    NORMAL = "|cFFFFFFFF", -- Blanc
    HIGHLIGHT = "|cFF00FFFF", -- Cyan
    SUCCESS = "|cFF00FF00", -- Vert
    WARNING = "|cFFFF9900", -- Orange
    ERROR = "|cFFFF0000", -- Rouge
    GRAY = "|cFF808080", -- Gris
}

-- Initialisation du module UI
function MiniAH:InitUIModule()
    -- Créer le cadre d'événements si nécessaire
    if not self.eventFrame then
        self.eventFrame = CreateFrame("Frame")
        self.eventFrame.callbacks = {}
        
        function self.eventFrame:RegisterCallback(event, callback)
            self.callbacks[event] = self.callbacks[event] or {}
            table.insert(self.callbacks[event], callback)
        end
        
        function self.eventFrame:Fire(event, ...)
            if self.callbacks[event] then
                for _, callback in ipairs(self.callbacks[event]) do
                    callback(...)
                end
            end
        end
    end
    
    -- Enregistrer les événements pour l'interface
    self.eventFrame:RegisterCallback("MINIAHSCANNER_SCAN_COMPLETE", function(itemsCount, totalScanned)
        if statsFrame and statsFrame:IsShown() then
            self:UpdateStatsFrame()
        end
    end)
end

-- Créer le cadre principal de l'interface
function MiniAH:CreateMainFrame()
    if not self.mainFrame then
        -- Débug pour vérifier si la fonction est appelée
        print("Création de l'interface MiniAHScanner...")
        
        -- Créer le cadre principal avec BackdropTemplate
        self.mainFrame = CreateFrame("Frame", "MiniAHMainFrame", UIParent, "BackdropTemplate")
        self.mainFrame:SetSize(600, 400)
        self.mainFrame:SetPoint("CENTER")
        self.mainFrame:SetFrameStrata("HIGH")
        self.mainFrame:SetMovable(true)
        self.mainFrame:EnableMouse(true)
        self.mainFrame:RegisterForDrag("LeftButton")
        self.mainFrame:SetScript("OnDragStart", self.mainFrame.StartMoving)
        self.mainFrame:SetScript("OnDragStop", self.mainFrame.StopMovingOrSizing)
        
        -- Appliquer le fond et la bordure
        if self.mainFrame.SetBackdrop then
            self.mainFrame:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            self.mainFrame:SetBackdropColor(0, 0, 0, 0.9)
            self.mainFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
        end
        
        self.mainFrame:Hide()
        
        -- Titre
        self.mainFrame.title = self.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        self.mainFrame.title:SetPoint("TOP", 0, -10)
        self.mainFrame.title:SetText(COLORS.TITLE .. ADDON_NAME)
        
        -- Bouton de fermeture
        self.mainFrame.closeButton = CreateFrame("Button", nil, self.mainFrame, "UIPanelCloseButton")
        self.mainFrame.closeButton:SetPoint("TOPRIGHT", -5, -5)
        self.mainFrame.closeButton:SetScript("OnClick", function() self.mainFrame:Hide() end)
        
        -- Onglets
        self.mainFrame.tabs = {}
        self.mainFrame.tabFrames = {}
        
        local function OnTabClick(tab)
            for i, t in ipairs(self.mainFrame.tabs) do
                if t == tab then
                    PanelTemplates_SelectTab(t)
                    self.mainFrame.tabFrames[i]:Show()
                else
                    PanelTemplates_DeselectTab(t)
                    self.mainFrame.tabFrames[i]:Hide()
                end
            end
        end
        
        -- Créer les onglets
        local tabNames = {"Scan", "Statistiques", "Options"}
        for i, name in ipairs(tabNames) do
            local tab = CreateFrame("Button", "MiniAHMainFrameTab"..i, self.mainFrame, "CharacterFrameTabButtonTemplate")
            tab:SetID(i)
            tab:SetText(name)
            tab:SetScript("OnClick", function() OnTabClick(tab) end)
            
            if i == 1 then
                tab:SetPoint("TOPLEFT", self.mainFrame, "BOTTOMLEFT", 5, 0)
            else
                tab:SetPoint("LEFT", self.mainFrame.tabs[i-1], "RIGHT", -15, 0)
            end
            
            table.insert(self.mainFrame.tabs, tab)
            
            -- Créer le cadre pour cet onglet
            local frame = CreateFrame("Frame", "MiniAHMainFrameTabFrame"..i, self.mainFrame)
            frame:SetPoint("TOPLEFT", 10, -30)
            frame:SetPoint("BOTTOMRIGHT", -10, 10)
            frame:Hide()
            
            table.insert(self.mainFrame.tabFrames, frame)
        end
        
        -- Sélectionner le premier onglet par défaut
        OnTabClick(self.mainFrame.tabs[1])
        
        -- Créer les contenus des onglets
        self:CreateScanFrame(self.mainFrame.tabFrames[1])
        self:CreateStatsFrame(self.mainFrame.tabFrames[2])
        self:CreateOptionsFrame(self.mainFrame.tabFrames[3])
    end
    
    return self.mainFrame
end

-- Créer le cadre de scan
function MiniAH:CreateScanFrame(parent)
    scanFrame = parent
    
    -- Titre
    scanFrame.title = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.title:SetPoint("TOP", 0, -10)
    scanFrame.title:SetText(COLORS.HIGHLIGHT .. "Scan de l'hôtel des ventes")
    
    -- Description
    scanFrame.desc = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.desc:SetPoint("TOP", scanFrame.title, "BOTTOM", 0, -10)
    scanFrame.desc:SetText(COLORS.NORMAL .. "Scannez l'hôtel des ventes pour mettre à jour les prix des objets.")
    
    -- Statut
    scanFrame.status = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.status:SetPoint("TOP", scanFrame.desc, "BOTTOM", 0, -20)
    scanFrame.status:SetText(COLORS.GRAY .. "Aucun scan en cours")
    
    -- Barre de progression
    scanFrame.progressBar = CreateFrame("StatusBar", nil, scanFrame, "TextStatusBar")
    scanFrame.progressBar:SetPoint("TOP", scanFrame.status, "BOTTOM", 0, -10)
    scanFrame.progressBar:SetSize(400, 20)
    scanFrame.progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    scanFrame.progressBar:SetStatusBarColor(0, 0.7, 0)
    scanFrame.progressBar:SetMinMaxValues(0, 100)
    scanFrame.progressBar:SetValue(0)
    
    -- Bordure de la barre de progression
    scanFrame.progressBar.border = CreateFrame("Frame", nil, scanFrame.progressBar, "BackdropTemplate")
    scanFrame.progressBar.border:SetPoint("TOPLEFT", -2, 2)
    scanFrame.progressBar.border:SetPoint("BOTTOMRIGHT", 2, -2)
    scanFrame.progressBar.border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    scanFrame.progressBar.border:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
    
    -- Texte de la barre de progression
    scanFrame.progressBar.text = scanFrame.progressBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    scanFrame.progressBar.text:SetPoint("CENTER", scanFrame.progressBar, "CENTER", 0, 0)
    scanFrame.progressBar.text:SetText("0%")
    
    -- Bouton de scan
    scanFrame.scanButton = CreateFrame("Button", nil, scanFrame, "UIPanelButtonTemplate")
    scanFrame.scanButton:SetPoint("TOP", scanFrame.progressBar, "BOTTOM", 0, -20)
    scanFrame.scanButton:SetSize(150, 25)
    scanFrame.scanButton:SetText("Démarrer le scan")
    scanFrame.scanButton:SetScript("OnClick", function()
        if self:IsScanInProgress() then
            -- Impossible d'arrêter un scan en cours pour l'instant
            print(COLORS.WARNING .. ADDON_NAME .. ":|r Impossible d'arrêter un scan en cours.")
        else
            self:StartScan()
            self:UpdateScanFrame()
        end
    end)
    
    -- Bouton pour forcer un scan immédiat sans attendre le délai de 15 minutes
    scanFrame.forceScanButton = CreateFrame("Button", nil, scanFrame, "UIPanelButtonTemplate")
    scanFrame.forceScanButton:SetPoint("TOP", scanFrame.scanButton, "BOTTOM", 0, -5)
    scanFrame.forceScanButton:SetSize(150, 25)
    scanFrame.forceScanButton:SetText("Forcer un scan")
    scanFrame.forceScanButton:SetScript("OnClick", function()
        if self:IsScanInProgress() then
            print(COLORS.WARNING .. ADDON_NAME .. ":|r Impossible d'arrêter un scan en cours.")
        else
            print(COLORS.HIGHLIGHT .. ADDON_NAME .. ":|r Lancement d'un scan forcé sans attendre le délai de 15 minutes.")
            self:StartScan(true) -- Passer true pour forcer le scan
            self:UpdateScanFrame()
        end
    end)
    
    -- Derniers résultats
    scanFrame.resultsTitle = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.resultsTitle:SetPoint("TOP", scanFrame.forceScanButton, "BOTTOM", 0, -20)
    scanFrame.resultsTitle:SetText(COLORS.HIGHLIGHT .. "Derniers résultats")
    
    -- Statistiques du dernier scan
    scanFrame.lastScanTime = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.lastScanTime:SetPoint("TOPLEFT", scanFrame.resultsTitle, "BOTTOMLEFT", -100, -10)
    scanFrame.lastScanTime:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.GRAY .. "Jamais")
    
    scanFrame.lastScanDuration = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.lastScanDuration:SetPoint("TOPLEFT", scanFrame.lastScanTime, "BOTTOMLEFT", 0, -5)
    scanFrame.lastScanDuration:SetText(COLORS.NORMAL .. "Durée : " .. COLORS.GRAY .. "N/A")
    
    scanFrame.lastScanItems = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    scanFrame.lastScanItems:SetPoint("TOPLEFT", scanFrame.lastScanDuration, "BOTTOMLEFT", 0, -5)
    scanFrame.lastScanItems:SetText(COLORS.NORMAL .. "Objets scannés : " .. COLORS.GRAY .. "0")
    
    -- Mettre à jour l'interface
    self:UpdateScanFrame()
    
    -- Timer pour mettre à jour l'interface pendant un scan
    scanFrame.updateTimer = C_Timer.NewTicker(0.5, function()
        if self:IsScanInProgress() then
            self:UpdateScanFrame()
        end
    end)
end

-- Mettre à jour le cadre de scan
function MiniAH:UpdateScanFrame()
    if not scanFrame then return end
    
    local scanStatus = self:GetScanStatus()
    
    if scanStatus.inProgress then
        -- Scan en cours
        scanFrame.status:SetText(COLORS.WARNING .. "Scan en cours - Page " .. scanStatus.currentPage .. " - " .. scanStatus.itemsScanned .. " objets scannés")
        scanFrame.scanButton:SetText("Scan en cours...")
        scanFrame.scanButton:Disable()
        
        -- Mettre à jour la barre de progression
        scanFrame.progressBar:SetValue(scanStatus.percentComplete)
        scanFrame.progressBar.text:SetText(scanStatus.percentComplete .. "% - " .. self:FormatTime(scanStatus.timeElapsed) .. " / " .. self:FormatTime(scanStatus.timeRemaining))
    else
        -- Pas de scan en cours
        scanFrame.status:SetText(COLORS.GRAY .. "Aucun scan en cours")
        scanFrame.scanButton:SetText("Démarrer le scan")
        scanFrame.scanButton:Enable()
        
        -- Réinitialiser la barre de progression
        scanFrame.progressBar:SetValue(0)
        scanFrame.progressBar.text:SetText("0%")
        
        -- Mettre à jour les statistiques du dernier scan
        if scanStatus.lastScan and scanStatus.lastScan > 0 then
            scanFrame.lastScanTime:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.HIGHLIGHT .. date("%d/%m/%Y %H:%M:%S", scanStatus.lastScan))
            scanFrame.lastScanDuration:SetText(COLORS.NORMAL .. "Durée : " .. COLORS.HIGHLIGHT .. self:FormatTime(scanStatus.lastDuration))
            scanFrame.lastScanItems:SetText(COLORS.NORMAL .. "Objets scannés : " .. COLORS.HIGHLIGHT .. scanStatus.itemsScanned)
        else
            scanFrame.lastScanTime:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.GRAY .. "Jamais")
            scanFrame.lastScanDuration:SetText(COLORS.NORMAL .. "Durée : " .. COLORS.GRAY .. "N/A")
            scanFrame.lastScanItems:SetText(COLORS.NORMAL .. "Objets scannés : " .. COLORS.GRAY .. "0")
        end
    end
end

-- Créer le cadre de statistiques
function MiniAH:CreateStatsFrame(parent)
    statsFrame = parent
    
    -- Titre
    statsFrame.title = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.title:SetPoint("TOP", 0, -10)
    statsFrame.title:SetText(COLORS.HIGHLIGHT .. "Statistiques de la base de données")
    
    -- Conteneur pour les statistiques
    statsFrame.container = CreateFrame("Frame", nil, statsFrame)
    statsFrame.container:SetPoint("TOPLEFT", 20, -40)
    statsFrame.container:SetPoint("BOTTOMRIGHT", -20, 60)
    
    -- Statistiques générales
    statsFrame.itemCount = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.itemCount:SetPoint("TOPLEFT", 0, 0)
    statsFrame.itemCount:SetText(COLORS.NORMAL .. "Nombre d'objets : " .. COLORS.HIGHLIGHT .. "0")
    
    statsFrame.scanCount = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.scanCount:SetPoint("TOPLEFT", statsFrame.itemCount, "BOTTOMLEFT", 0, -10)
    statsFrame.scanCount:SetText(COLORS.NORMAL .. "Nombre de scans : " .. COLORS.HIGHLIGHT .. "0")
    
    statsFrame.lastScan = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.lastScan:SetPoint("TOPLEFT", statsFrame.scanCount, "BOTTOMLEFT", 0, -10)
    statsFrame.lastScan:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.GRAY .. "Jamais")
    
    statsFrame.oldestData = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.oldestData:SetPoint("TOPLEFT", statsFrame.lastScan, "BOTTOMLEFT", 0, -10)
    statsFrame.oldestData:SetText(COLORS.NORMAL .. "Données les plus anciennes : " .. COLORS.GRAY .. "N/A")
    
    statsFrame.averageAge = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.averageAge:SetPoint("TOPLEFT", statsFrame.oldestData, "BOTTOMLEFT", 0, -10)
    statsFrame.averageAge:SetText(COLORS.NORMAL .. "Âge moyen des données : " .. COLORS.GRAY .. "N/A")
    
    statsFrame.totalValue = statsFrame.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsFrame.totalValue:SetPoint("TOPLEFT", statsFrame.averageAge, "BOTTOMLEFT", 0, -10)
    statsFrame.totalValue:SetText(COLORS.NORMAL .. "Valeur totale : " .. COLORS.GRAY .. "N/A")
    
    -- Bouton de nettoyage
    statsFrame.cleanButton = CreateFrame("Button", nil, statsFrame, "UIPanelButtonTemplate")
    statsFrame.cleanButton:SetPoint("BOTTOMLEFT", 20, 20)
    statsFrame.cleanButton:SetSize(180, 25)
    statsFrame.cleanButton:SetText("Nettoyer les données anciennes")
    statsFrame.cleanButton:SetScript("OnClick", function()
        local count = self:CleanDatabase(30) -- Nettoyer les données plus vieilles que 30 jours
        self:UpdateStatsFrame()
    end)
    
    -- Bouton d'exportation
    statsFrame.exportButton = CreateFrame("Button", nil, statsFrame, "UIPanelButtonTemplate")
    statsFrame.exportButton:SetPoint("BOTTOMRIGHT", -20, 20)
    statsFrame.exportButton:SetSize(180, 25)
    statsFrame.exportButton:SetText("Exporter les données")
    statsFrame.exportButton:SetScript("OnClick", function()
        self:ExportPriceData()
    end)
    
    -- Mettre à jour l'interface
    self:UpdateStatsFrame()
end

-- Mettre à jour le cadre de statistiques
function MiniAH:UpdateStatsFrame()
    if not statsFrame then return end
    
    local stats = self:GetDatabaseStats()
    
    statsFrame.itemCount:SetText(COLORS.NORMAL .. "Nombre d'objets : " .. COLORS.HIGHLIGHT .. stats.itemCount)
    statsFrame.scanCount:SetText(COLORS.NORMAL .. "Nombre de scans : " .. COLORS.HIGHLIGHT .. stats.scanCount)
    
    if stats.lastScanTime > 0 then
        statsFrame.lastScan:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.HIGHLIGHT .. date("%d/%m/%Y %H:%M:%S", stats.lastScanTime))
    else
        statsFrame.lastScan:SetText(COLORS.NORMAL .. "Dernier scan : " .. COLORS.GRAY .. "Jamais")
    end
    
    if stats.oldestScan > 0 and stats.oldestScan < time() then
        statsFrame.oldestData:SetText(COLORS.NORMAL .. "Données les plus anciennes : " .. COLORS.HIGHLIGHT .. date("%d/%m/%Y", stats.oldestScan))
    else
        statsFrame.oldestData:SetText(COLORS.NORMAL .. "Données les plus anciennes : " .. COLORS.GRAY .. "N/A")
    end
    
    if stats.averageAge > 0 then
        statsFrame.averageAge:SetText(COLORS.NORMAL .. "Âge moyen des données : " .. COLORS.HIGHLIGHT .. stats.averageAge .. " jours")
    else
        statsFrame.averageAge:SetText(COLORS.NORMAL .. "Âge moyen des données : " .. COLORS.GRAY .. "N/A")
    end
    
    if stats.totalValue > 0 then
        statsFrame.totalValue:SetText(COLORS.NORMAL .. "Valeur totale : " .. COLORS.HIGHLIGHT .. self:FormatMoney(stats.totalValue))
    else
        statsFrame.totalValue:SetText(COLORS.NORMAL .. "Valeur totale : " .. COLORS.GRAY .. "N/A")
    end
end

-- Créer le cadre d'options
function MiniAH:CreateOptionsFrame(parent)
    optionsFrame = parent
    
    -- Titre
    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    optionsFrame.title:SetPoint("TOP", 0, -10)
    optionsFrame.title:SetText(COLORS.HIGHLIGHT .. "Options")
    
    -- Conteneur pour les options
    optionsFrame.container = CreateFrame("Frame", nil, optionsFrame)
    optionsFrame.container:SetPoint("TOPLEFT", 20, -40)
    optionsFrame.container:SetPoint("BOTTOMRIGHT", -20, 60)
    
    -- Options
    local function CreateCheckbox(parent, text, tooltip, variable, callback)
        local checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
        checkbox.Text:SetText(text)
        checkbox.tooltipText = tooltip
        checkbox:SetChecked(MiniAHSavedVars[variable])
        checkbox:SetScript("OnClick", function(self)
            MiniAHSavedVars[variable] = self:GetChecked()
            if callback then callback(self:GetChecked()) end
        end)
        return checkbox
    end
    
    -- Option : Scan automatique
    optionsFrame.autoScan = CreateCheckbox(
        optionsFrame.container,
        "Scan automatique à l'ouverture de l'hôtel des ventes",
        "Scanne automatiquement l'hôtel des ventes lorsque vous l'ouvrez",
        "autoScan"
    )
    optionsFrame.autoScan:SetPoint("TOPLEFT", 0, 0)
    
    -- Option : Afficher les prix de l'hôtel des ventes
    optionsFrame.showAuctionPrice = CreateCheckbox(
        optionsFrame.container,
        "Afficher les prix de l'hôtel des ventes dans les infobulles",
        "Affiche les prix de l'hôtel des ventes dans les infobulles des objets",
        "showAuctionPrice"
    )
    optionsFrame.showAuctionPrice:SetPoint("TOPLEFT", optionsFrame.autoScan, "BOTTOMLEFT", 0, -10)
    
    -- Option : Afficher les prix vendeur
    optionsFrame.showVendorPrice = CreateCheckbox(
        optionsFrame.container,
        "Afficher les prix vendeur dans les infobulles",
        "Affiche les prix vendeur dans les infobulles des objets",
        "showVendorPrice"
    )
    optionsFrame.showVendorPrice:SetPoint("TOPLEFT", optionsFrame.showAuctionPrice, "BOTTOMLEFT", 0, -10)
    
    -- Option : Conserver l'historique des prix
    optionsFrame.keepHistory = CreateCheckbox(
        optionsFrame.container,
        "Conserver l'historique des prix",
        "Conserve l'historique des prix pour chaque objet",
        "keepHistory"
    )
    optionsFrame.keepHistory:SetPoint("TOPLEFT", optionsFrame.showVendorPrice, "BOTTOMLEFT", 0, -10)
    
    -- Option : Afficher le bouton sur la minimap
    optionsFrame.showMinimapButton = CreateCheckbox(
        optionsFrame.container,
        "Afficher le bouton sur la minimap",
        "Affiche un bouton sur la minimap pour accéder rapidement à l'addon",
        "showMinimapButton",
        function(checked)
            if checked then
                self:ShowMinimapButton()
            else
                self:HideMinimapButton()
            end
        end
    )
    optionsFrame.showMinimapButton:SetPoint("TOPLEFT", optionsFrame.keepHistory, "BOTTOMLEFT", 0, -10)
    
    -- Bouton de réinitialisation
    optionsFrame.resetButton = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    optionsFrame.resetButton:SetPoint("BOTTOMLEFT", 20, 20)
    optionsFrame.resetButton:SetSize(180, 25)
    optionsFrame.resetButton:SetText("Réinitialiser les options")
    optionsFrame.resetButton:SetScript("OnClick", function()
        StaticPopupDialogs["MINIAHSCANNER_RESET_OPTIONS"] = {
            text = "Êtes-vous sûr de vouloir réinitialiser toutes les options de " .. ADDON_NAME .. " ?",
            button1 = "Oui",
            button2 = "Non",
            OnAccept = function()
                self:ResetOptions()
                self:UpdateOptionsFrame()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("MINIAHSCANNER_RESET_OPTIONS")
    end)
    
    -- Bouton de réinitialisation de la base de données
    optionsFrame.resetDBButton = CreateFrame("Button", nil, optionsFrame, "UIPanelButtonTemplate")
    optionsFrame.resetDBButton:SetPoint("BOTTOMRIGHT", -20, 20)
    optionsFrame.resetDBButton:SetSize(180, 25)
    optionsFrame.resetDBButton:SetText("Réinitialiser la base de données")
    optionsFrame.resetDBButton:SetScript("OnClick", function()
        StaticPopupDialogs["MINIAHSCANNER_RESET_DB"] = {
            text = "Êtes-vous sûr de vouloir réinitialiser la base de données de " .. ADDON_NAME .. " ?\nToutes les données de prix seront perdues.",
            button1 = "Oui",
            button2 = "Non",
            OnAccept = function()
                self:ResetDatabase()
                self:UpdateStatsFrame()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("MINIAHSCANNER_RESET_DB")
    end)
end

-- Mettre à jour le cadre d'options
function MiniAH:UpdateOptionsFrame()
    if not optionsFrame then return end
    
    optionsFrame.autoScan:SetChecked(MiniAHSavedVars.autoScan)
    optionsFrame.showAuctionPrice:SetChecked(MiniAHSavedVars.showAuctionPrice)
    optionsFrame.showVendorPrice:SetChecked(MiniAHSavedVars.showVendorPrice)
    optionsFrame.keepHistory:SetChecked(MiniAHSavedVars.keepHistory)
    optionsFrame.showMinimapButton:SetChecked(not MiniAHSavedVars.minimapButton.hide)
end

-- Réinitialiser les options
function MiniAH:ResetOptions()
    MiniAHSavedVars.autoScan = true
    MiniAHSavedVars.showAuctionPrice = true
    MiniAHSavedVars.showVendorPrice = true
    MiniAHSavedVars.keepHistory = true
    MiniAHSavedVars.minimapButton = {
        hide = false,
        position = 45,
    }
    
    print(COLORS.SUCCESS .. ADDON_NAME .. ":|r Options réinitialisées.")
    
    -- Mettre à jour l'affichage du bouton de la minimap
    if MiniAHSavedVars.minimapButton.hide then
        self:HideMinimapButton()
    else
        self:ShowMinimapButton()
    end
end

-- Réinitialiser la base de données
function MiniAH:ResetDatabase()
    MiniAHSavedVars.itemPrices = {}
    MiniAHSavedVars.scanStats = {
        lastFullScan = 0,
        scanCount = 0,
        itemsScanned = 0,
        lastScanDuration = 0
    }
    
    print(COLORS.SUCCESS .. ADDON_NAME .. ":|r Base de données réinitialisée.")
end

-- Afficher l'interface
function MiniAH:ShowUI()
    -- Débug pour vérifier si la fonction est appelée
    print("Ouverture de l'interface MiniAHScanner...")
    
    -- Créer une interface simplifiée pour éviter les erreurs
    if not self.mainFrame then
        print("Création d'une interface simplifiée...")
        
        -- Créer le cadre principal
        self.mainFrame = CreateFrame("Frame", "MiniAHSimpleFrame", UIParent, "BackdropTemplate")
        self.mainFrame:SetSize(400, 300)
        self.mainFrame:SetPoint("CENTER")
        self.mainFrame:SetFrameStrata("HIGH")
        self.mainFrame:SetMovable(true)
        self.mainFrame:EnableMouse(true)
        self.mainFrame:RegisterForDrag("LeftButton")
        self.mainFrame:SetScript("OnDragStart", self.mainFrame.StartMoving)
        self.mainFrame:SetScript("OnDragStop", self.mainFrame.StopMovingOrSizing)
        
        -- Appliquer le fond et la bordure
        if self.mainFrame.SetBackdrop then
            self.mainFrame:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            self.mainFrame:SetBackdropColor(0, 0, 0, 0.9)
            self.mainFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
        end
        
        -- Titre
        self.mainFrame.title = self.mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        self.mainFrame.title:SetPoint("TOP", 0, -10)
        self.mainFrame.title:SetText(COLORS.TITLE .. ADDON_NAME)
        
        -- Bouton de fermeture
        self.mainFrame.closeButton = CreateFrame("Button", nil, self.mainFrame, "UIPanelCloseButton")
        self.mainFrame.closeButton:SetPoint("TOPRIGHT", -5, -5)
        self.mainFrame.closeButton:SetScript("OnClick", function() self.mainFrame:Hide() end)
        
        -- Contenu
        self.mainFrame.content = CreateFrame("Frame", nil, self.mainFrame)
        self.mainFrame.content:SetPoint("TOPLEFT", 10, -30)
        self.mainFrame.content:SetPoint("BOTTOMRIGHT", -10, 10)
        
        -- Texte d'information
        self.mainFrame.info = self.mainFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        self.mainFrame.info:SetPoint("TOP", 0, -10)
        self.mainFrame.info:SetText(COLORS.NORMAL .. "MiniAHScanner est un addon léger pour scanner l'hôtel des ventes\net afficher les prix dans les infobulles.")
        
        -- Statistiques
        local stats = self:GetDatabaseStats()
        
        self.mainFrame.stats = self.mainFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        self.mainFrame.stats:SetPoint("TOP", self.mainFrame.info, "BOTTOM", 0, -20)
        self.mainFrame.stats:SetText(
            COLORS.HIGHLIGHT .. "Statistiques:\n" ..
            COLORS.NORMAL .. "Objets enregistrés: " .. COLORS.HIGHLIGHT .. stats.itemCount .. "\n" ..
            COLORS.NORMAL .. "Nombre de scans: " .. COLORS.HIGHLIGHT .. stats.scanCount .. "\n" ..
            COLORS.NORMAL .. "Dernier scan: " .. COLORS.HIGHLIGHT .. (stats.lastScanTime > 0 and date("%d/%m/%Y %H:%M:%S", stats.lastScanTime) or "Jamais")
        )
        
        -- Bouton de scan
        self.mainFrame.scanButton = CreateFrame("Button", nil, self.mainFrame.content, "UIPanelButtonTemplate")
        self.mainFrame.scanButton:SetPoint("BOTTOM", 0, 40)
        self.mainFrame.scanButton:SetSize(150, 25)
        self.mainFrame.scanButton:SetText("Lancer un scan")
        self.mainFrame.scanButton:SetScript("OnClick", function()
            if C_AuctionHouse and C_AuctionHouse.IsAuctionHouseOpen and C_AuctionHouse.IsAuctionHouseOpen() then
                self:StartScan()
                self.mainFrame:Hide()
            else
                print(COLORS.ERROR .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
            end
        end)
        
        -- Options
        self.mainFrame.optionsTitle = self.mainFrame.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        self.mainFrame.optionsTitle:SetPoint("BOTTOM", 0, 100)
        self.mainFrame.optionsTitle:SetText(COLORS.HIGHLIGHT .. "Options:")
        
        -- Créer des cases à cocher pour les options
        local function CreateCheckbox(parent, text, tooltip, variable, yOffset)
            local checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
            checkbox:SetPoint("BOTTOM", 0, yOffset)
            checkbox.Text:SetText(text)
            checkbox.tooltipText = tooltip
            checkbox:SetChecked(MiniAHSavedVars[variable])
            checkbox:SetScript("OnClick", function(self)
                MiniAHSavedVars[variable] = self:GetChecked()
            end)
            return checkbox
        end
        
        -- Options
        self.mainFrame.autoScan = CreateCheckbox(
            self.mainFrame.content,
            "Scan automatique à l'ouverture de l'hôtel des ventes",
            "Scanne automatiquement l'hôtel des ventes lorsque vous l'ouvrez",
            "autoScan",
            80
        )
        
        self.mainFrame.showAuctionPrice = CreateCheckbox(
            self.mainFrame.content,
            "Afficher les prix de l'hôtel des ventes dans les infobulles",
            "Affiche les prix de l'hôtel des ventes dans les infobulles des objets",
            "showAuctionPrice",
            60
        )
        
        self.mainFrame.showVendorPrice = CreateCheckbox(
            self.mainFrame.content,
            "Afficher les prix vendeur dans les infobulles",
            "Affiche les prix vendeur dans les infobulles des objets",
            "showVendorPrice",
            40
        )
        
        self.mainFrame.keepHistory = CreateCheckbox(
            self.mainFrame.content,
            "Conserver l'historique des prix",
            "Conserve l'historique des prix pour chaque objet",
            "keepHistory",
            20
        )
    end
    
    -- Afficher l'interface
    self.mainFrame:Show()
end

-- Formater le prix en or/argent/cuivre avec couleurs
function MiniAH:FormatMoney(amount)
    if not amount then return "N/A" end
    
    local gold = math.floor(amount / 10000)
    local silver = math.floor((amount % 10000) / 100)
    local copper = amount % 100
    
    local goldText = gold > 0 and "|cFFFFD700" .. gold .. "g|r" or ""
    local silverText = silver > 0 and "|cFFC0C0C0" .. silver .. "s|r" or ""
    local copperText = copper > 0 and "|cFFB87333" .. copper .. "c|r" or ""
    
    local result = goldText
    if silver > 0 then
        result = result .. (gold > 0 and " " or "") .. silverText
    end
    if copper > 0 then
        result = result .. ((gold > 0 or silver > 0) and " " or "") .. copperText
    end
    
    if result == "" then
        return "|cFFB87333" .. "0c" .. "|r"
    else
        return result
    end
end

-- Formater le temps en heures, minutes, secondes
function MiniAH:FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if hours > 0 then
        return string.format("%dh %02dm %02ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %02ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end
