-- MiniAH_OptionsUI.lua
-- Interface utilisateur améliorée pour MiniAHScanner, inspirée d'Auctionator

local ADDON_NAME, MiniAH = ...

-- Couleurs
local COLORS = {
    TITLE = "|cFFFFD700", -- Or
    HEADER = "|cFF00AAFF", -- Bleu clair
    NORMAL = "|cFFFFFFFF", -- Blanc
    HIGHLIGHT = "|cFF00FFFF", -- Cyan
    SUCCESS = "|cFF00FF00", -- Vert
    WARNING = "|cFFFF9900", -- Orange
    ERROR = "|cFFFF0000", -- Rouge
    GRAY = "|cFF808080", -- Gris
    DISABLED = "|cFF666666", -- Gris foncé
}

-- Constantes
local CATEGORY_PADDING = 10
local OPTION_HEIGHT = 25
local OPTION_PADDING = 5
local SECTION_PADDING = 15

-- Variables locales
local optionsFrame = nil
local categories = {}
local currentCategory = nil

-- Créer l'interface des options
function MiniAH:CreateOptionsUI()
    if optionsFrame then
        return optionsFrame
    end
    
    -- Utiliser un type de cadre standard pour les options WoW
    optionsFrame = CreateFrame("Frame", "MiniAHOptionsFrame", UIParent)
    optionsFrame:SetSize(550, 500)
    optionsFrame:SetPoint("CENTER")
    optionsFrame:SetFrameStrata("DIALOG")
    optionsFrame:SetMovable(true)
    optionsFrame:EnableMouse(true)
    optionsFrame:RegisterForDrag("LeftButton")
    optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
    optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
    
    -- Ajouter uniquement un fond noir sans bordure
    if optionsFrame.SetBackdrop then
        optionsFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tile = true, tileSize = 16,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        optionsFrame:SetBackdropColor(0, 0, 0, 0.8)
    else
        -- Créer un cadre de fond sans bordure avec BackdropTemplate
        local backdrop = CreateFrame("Frame", nil, optionsFrame, "BackdropTemplate")
        backdrop:SetAllPoints()
        backdrop:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tile = true, tileSize = 16,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        backdrop:SetBackdropColor(0, 0, 0, 0.8)
        backdrop:SetFrameLevel(optionsFrame:GetFrameLevel())
        optionsFrame.backdrop = backdrop
    end
    
    -- Important: Ne pas bloquer les clics de souris en dehors de la fenêtre
    optionsFrame:SetClampedToScreen(true) -- Empêcher la fenêtre de sortir de l'écran
    optionsFrame:SetClipsChildren(false) -- Ne pas couper les éléments enfants
    optionsFrame:SetHitRectInsets(0, 0, 0, 0) -- Zone de clic exactement égale à la taille du cadre
    
    -- Ajouter un gestionnaire d'événements pour les touches
    optionsFrame:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            self:Hide()
        end
        return false -- Ne pas consommer l'événement
    end)
    optionsFrame:SetPropagateKeyboardInput(true) -- Permet aux saisies clavier de passer à travers
    
    -- Créer une barre inférieure pour le bouton Fermer (comme dans l'image)
    optionsFrame.bottomBar = CreateFrame("Frame", nil, optionsFrame, "BackdropTemplate")
    optionsFrame.bottomBar:SetPoint("BOTTOMLEFT", 0, 0)
    optionsFrame.bottomBar:SetPoint("BOTTOMRIGHT", 0, 0)
    optionsFrame.bottomBar:SetHeight(30)
    
    -- Appliquer un fond noir pour la barre inférieure sans bordure
    if optionsFrame.bottomBar.SetBackdrop then
        optionsFrame.bottomBar:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tile = true, tileSize = 16,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        optionsFrame.bottomBar:SetBackdropColor(0, 0, 0, 0.9)
    end
    
    -- Compatibilité avec ElvUI
    -- Vérifier si ElvUI est présent et activé
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            -- Appliquer le skin ElvUI au cadre principal
            if optionsFrame.SetTemplate then
                optionsFrame:SetTemplate("Transparent")
                optionsFrame.elvuiSkinned = true
            end
            
            -- Appliquer le skin ElvUI à la barre inférieure
            if optionsFrame.bottomBar and optionsFrame.bottomBar.SetTemplate then
                optionsFrame.bottomBar:SetTemplate("Transparent")
            end
        end
    end
    
    optionsFrame.bottomBar:SetBackdropBorderColor(0.6, 0.6, 0.6, 0)
    
    -- Ajouter un bouton Fermer dans la barre inférieure avec une bordure
    optionsFrame.closeButtonBottom = CreateFrame("Button", nil, optionsFrame.bottomBar, "UIPanelButtonTemplate")
    optionsFrame.closeButtonBottom:SetSize(100, 22)
    optionsFrame.closeButtonBottom:SetPoint("BOTTOMRIGHT", optionsFrame.bottomBar, "BOTTOMRIGHT", -10, 4)
    optionsFrame.closeButtonBottom:SetText("Fermer")
    optionsFrame.closeButtonBottom:SetScript("OnClick", function() optionsFrame:Hide() end)
    
    -- Ajouter une bordure personnalisée au bouton Fermer
    if not optionsFrame.elvuiSkinned then
        -- Créer un cadre de bordure autour du bouton
        local border = CreateFrame("Frame", nil, optionsFrame.closeButtonBottom, "BackdropTemplate")
        border:SetPoint("TOPLEFT", optionsFrame.closeButtonBottom, "TOPLEFT", -2, 2)
        border:SetPoint("BOTTOMRIGHT", optionsFrame.closeButtonBottom, "BOTTOMRIGHT", 2, -2)
        border:SetFrameLevel(optionsFrame.closeButtonBottom:GetFrameLevel() - 1)
        
        if border.SetBackdrop then
            border:SetBackdrop({
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 12,
                insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
            border:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
        end
    end
    
    -- Appliquer le skin ElvUI au bouton Fermer
    -- Appliquer le skin ElvUI si disponible
    if optionsFrame.elvuiSkinned and ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins and E.Skins.HandleButton then
            E.Skins:HandleButton(optionsFrame.closeButtonBottom)
        end
    end
    
    -- Appliquer un fond sans bordure au cadre principal
    if optionsFrame.SetBackdrop and not optionsFrame.elvuiSkinned then
        optionsFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            tile = true, tileSize = 16,
            insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
        optionsFrame:SetBackdropColor(0, 0, 0, 0.8)
    end
    
    -- Titre
    optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    optionsFrame.title:SetPoint("TOPLEFT", 15, -15)
    optionsFrame.title:SetText(COLORS.TITLE .. ADDON_NAME .. " v1.1.0")
    
    -- Bouton de fermeture
    optionsFrame.closeButton = CreateFrame("Button", nil, optionsFrame, "UIPanelCloseButton")
    optionsFrame.closeButton:SetPoint("TOPRIGHT", -5, -5)
    optionsFrame.closeButton:SetScript("OnClick", function() optionsFrame:Hide() end)
    
    -- Appliquer le skin ElvUI au bouton de fermeture
    if optionsFrame.elvuiSkinned and ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins and E.Skins.HandleCloseButton then
            E.Skins:HandleCloseButton(optionsFrame.closeButton)
        end
    end
    
    -- Créer le panneau de catégories (à gauche)
    optionsFrame.categoriesPanel = CreateFrame("Frame", nil, optionsFrame, "BackdropTemplate")
    optionsFrame.categoriesPanel:SetPoint("TOPLEFT", 15, -40)
    optionsFrame.categoriesPanel:SetPoint("BOTTOMLEFT", 15, 15)
    optionsFrame.categoriesPanel:SetWidth(130)
    
    -- Appliquer le skin ElvUI au panneau de catégories
    if optionsFrame.elvuiSkinned and ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if optionsFrame.categoriesPanel and optionsFrame.categoriesPanel.SetTemplate then
                optionsFrame.categoriesPanel:SetTemplate("Transparent")
            end
        end
    elseif optionsFrame.categoriesPanel.SetBackdrop then
        optionsFrame.categoriesPanel:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        optionsFrame.categoriesPanel:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        optionsFrame.categoriesPanel:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end
    
    -- Créer le panneau de contenu (à droite)
    optionsFrame.contentPanel = CreateFrame("Frame", nil, optionsFrame, "BackdropTemplate")
    optionsFrame.contentPanel:SetPoint("TOPLEFT", optionsFrame.categoriesPanel, "TOPRIGHT", 15, 0)
    optionsFrame.contentPanel:SetPoint("BOTTOMRIGHT", -15, 15)
    optionsFrame.contentPanel:SetWidth(390) -- Largeur fixe pour le panneau de contenu
    
    -- Appliquer le skin ElvUI au panneau de contenu
    if optionsFrame.elvuiSkinned and ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if optionsFrame.contentPanel and optionsFrame.contentPanel.SetTemplate then
                optionsFrame.contentPanel:SetTemplate("Transparent")
            end
        end
    elseif optionsFrame.contentPanel.SetBackdrop then
        optionsFrame.contentPanel:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        optionsFrame.contentPanel:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        optionsFrame.contentPanel:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end
    
    -- Créer les catégories
    self:CreateCategories()
    
    -- Sélectionner la première catégorie par défaut
    self:SelectCategory("general")
    
    -- Enregistrer le cadre pour qu'il se ferme avec la touche Echap
    tinsert(UISpecialFrames, "MiniAHOptionsFrame")
    
    -- Ajouter un gestionnaire d'événements pour la touche Echap
    optionsFrame:SetScript("OnKeyDown", function(self, key)
        if key == "ESCAPE" then
            self:Hide()
        end
    end)
    
    -- Approche simple : ne pas bloquer les clics de souris en dehors de la fenêtre
    optionsFrame:SetScript("OnShow", function(self)
        -- Permettre l'utilisation de la touche Echap pour fermer la fenêtre
        self:EnableKeyboard(true)
        
        -- Définir la fenêtre comme non-modale (ne bloque pas les interactions avec le jeu)
        self:SetToplevel(false)
        
        -- Utiliser le style de fenêtre standard de WoW qui permet les raccourcis souris
        self:SetFrameLevel(100) -- S'assurer que la fenêtre est au-dessus des autres éléments
    end)
    
    -- Permettre aux raccourcis souris de fonctionner même quand la fenêtre est ouverte
    optionsFrame:HookScript("OnMouseDown", function(self, button)
        if button == "RightButton" and not MouseIsOver(self) then
            self:EnableMouse(false)
            C_Timer.After(0.1, function() self:EnableMouse(true) end)
        end
    end)
    
    -- Désactiver la capture du clavier quand le cadre est caché
    optionsFrame:SetScript("OnHide", function(self)
        self:EnableKeyboard(false)
        self:SetPropagateKeyboardInput(true)
    end)
    
    -- Masquer l'interface par défaut
    optionsFrame:Hide()
    
    return optionsFrame
end

-- Créer les catégories de l'interface
function MiniAH:CreateCategories()
    -- Définir les catégories
    categories = {
        general = {
            name = "Général",
            order = 1,
            frame = nil
        },
        scan = {
            name = "Scan",
            order = 2,
            frame = nil
        },
        display = {
            name = "Affichage",
            order = 3,
            frame = nil
        },
        advanced = {
            name = "Avancé",
            order = 4,
            frame = nil
        }
    }
    
    -- Trier les catégories par ordre
    local sortedCategories = {}
    for id, category in pairs(categories) do
        category.id = id
        table.insert(sortedCategories, category)
    end
    
    table.sort(sortedCategories, function(a, b) return a.order < b.order end)
    
    -- Créer les boutons de catégorie
    local previousButton = nil
    for _, category in ipairs(sortedCategories) do
        local button = CreateFrame("Button", nil, optionsFrame.categoriesPanel)
        button:SetHeight(30)
        button:SetPoint("LEFT", 5, 0)
        button:SetPoint("RIGHT", -5, 0)
        
        if previousButton then
            button:SetPoint("TOP", previousButton, "BOTTOM", 0, -5)
        else
            button:SetPoint("TOP", 0, -5)
        end
        
        button.category = category.id
        
        -- Texte du bouton
        button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        button.text:SetPoint("LEFT", 10, 0)
        button.text:SetText(category.name)
        
        -- Highlight
        button.highlight = button:CreateTexture(nil, "BACKGROUND")
        button.highlight:SetAllPoints()
        button.highlight:SetColorTexture(1, 1, 1, 0.2)
        button.highlight:Hide()
        
        -- Selected
        button.selected = button:CreateTexture(nil, "BACKGROUND")
        button.selected:SetAllPoints()
        button.selected:SetColorTexture(0, 0.5, 1, 0.3)
        button.selected:Hide()
        
        -- Scripts
        button:SetScript("OnClick", function(self)
            MiniAH:SelectCategory(self.category)
        end)
        
        button:SetScript("OnEnter", function(self)
            if currentCategory ~= self.category then
                self.highlight:Show()
            end
        end)
        
        button:SetScript("OnLeave", function(self)
            self.highlight:Hide()
        end)
        
        -- Stocker le bouton dans la catégorie
        category.button = button
        
        -- Créer le cadre de contenu pour cette catégorie
        local contentFrame = CreateFrame("Frame", nil, optionsFrame.contentPanel)
        contentFrame:SetAllPoints()
        contentFrame:Hide()
        
        -- Titre de la catégorie
        contentFrame.title = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        contentFrame.title:SetPoint("TOPLEFT", 15, -15)
        contentFrame.title:SetText(COLORS.HEADER .. category.name)
        
        -- Conteneur sans scrolling
        contentFrame.scrollFrame = CreateFrame("Frame", nil, contentFrame)
        contentFrame.scrollFrame:SetPoint("TOPLEFT", 10, -40)
        contentFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -10, 10)
        
        -- Contenu direct sans scrolling
        contentFrame.scrollChild = contentFrame.scrollFrame
        contentFrame.scrollChild:SetWidth(contentFrame.scrollFrame:GetWidth())
        contentFrame.scrollChild:SetHeight(contentFrame.scrollFrame:GetHeight())
        
        -- Stocker le cadre dans la catégorie
        category.frame = contentFrame
        
        previousButton = button
    end
    
    -- Remplir le contenu des catégories
    self:FillGeneralCategory()
    self:FillScanCategory()
    self:FillDisplayCategory()
    self:FillAdvancedCategory()
end

-- Sélectionner une catégorie
function MiniAH:SelectCategory(categoryId)
    if not categories[categoryId] then return end
    
    -- Masquer toutes les catégories
    for id, category in pairs(categories) do
        if category.frame then
            category.frame:Hide()
        end
        if category.button then
            category.button.selected:Hide()
            category.button.highlight:Hide()
        end
    end
    
    -- Afficher la catégorie sélectionnée
    if categories[categoryId].frame then
        categories[categoryId].frame:Show()
    end
    if categories[categoryId].button then
        categories[categoryId].button.selected:Show()
    end
    
    currentCategory = categoryId
end

-- Créer un titre de section
function MiniAH:CreateSectionTitle(parent, text, anchorPoint, xOffset, yOffset)
    local title = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint(anchorPoint or "TOPLEFT", xOffset or 0, yOffset or 0)
    title:SetText(COLORS.HIGHLIGHT .. text)
    title:SetJustifyH("LEFT")
    
    -- Ligne horizontale
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    line:SetPoint("RIGHT", parent, "RIGHT", -5, 0)
    line:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    
    return title
end

-- Créer une case à cocher
function MiniAH:CreateCheckbox(parent, text, tooltip, variable, anchorPoint, relativeFrame, xOffset, yOffset, callback)
    local checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    checkbox:SetPoint(anchorPoint or "TOPLEFT", relativeFrame or parent, anchorPoint == "TOP" and "BOTTOM" or "TOPLEFT", xOffset or 0, yOffset or 0)
    
    -- Ajuster le texte pour qu'il soit complètement visible
    checkbox.Text:ClearAllPoints()
    checkbox.Text:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    checkbox.Text:SetWidth(350) -- Augmenter la largeur pour éviter la troncature
    checkbox.Text:SetJustifyH("LEFT") -- Aligner à gauche
    checkbox.Text:SetText(text)
    
    checkbox.tooltipText = tooltip
    
    -- Vérifier si la variable existe
    if MiniAHSavedVars[variable] ~= nil then
        checkbox:SetChecked(MiniAHSavedVars[variable])
    end
    
    checkbox:SetScript("OnClick", function(self)
        MiniAHSavedVars[variable] = self:GetChecked()
        if callback then
            callback(self:GetChecked())
        end
    end)
    
    -- Appliquer le skin ElvUI si disponible
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins and E.Skins.HandleCheckBox then
            E.Skins:HandleCheckBox(checkbox)
        end
    end
    
    return checkbox
end

-- Créer un curseur
function MiniAH:CreateSlider(parent, text, tooltip, variable, min, max, step, anchorPoint, relativeFrame, xOffset, yOffset, callback, width)
    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
    slider:SetPoint(anchorPoint or "TOPLEFT", relativeFrame or parent, anchorPoint == "TOP" and "BOTTOM" or "TOPLEFT", xOffset or 0, yOffset or 0)
    slider:SetWidth(width or 200)
    slider:SetHeight(20)
    slider:SetMinMaxValues(min, max)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    
    -- Configurer les textes
    -- Ajuster la position du texte pour qu'il soit complètement visible
    slider.Text:ClearAllPoints()
    slider.Text:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 2)
    slider.Text:SetWidth(300) -- Augmenter la largeur pour éviter la troncature
    slider.Text:SetJustifyH("LEFT") -- Aligner à gauche
    slider.Text:SetText(text)
    
    -- Ajuster la position des valeurs min/max pour un meilleur alignement
    slider.Low:ClearAllPoints()
    slider.Low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -2)
    slider.Low:SetText(min)
    
    slider.High:ClearAllPoints()
    slider.High:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, -2)
    slider.High:SetText(max)
    
    -- Ajouter une infobulle
    slider.tooltipText = tooltip
    
    -- Vérifier si la variable existe
    if MiniAHSavedVars[variable] ~= nil then
        slider:SetValue(MiniAHSavedVars[variable])
    end
    
    -- Texte de la valeur actuelle avec un meilleur alignement
    slider.Value = slider:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    slider.Value:SetPoint("CENTER", slider, "BOTTOM", 0, -15) -- Centrer la valeur sous le slider
    slider.Value:SetWidth(50) -- Largeur fixe pour éviter les décalages
    slider.Value:SetJustifyH("CENTER") -- Centrer le texte
    slider.Value:SetText(slider:GetValue())
    
    -- Appliquer le skin ElvUI si disponible
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if E.Skins.HandleSliderFrame then
                E.Skins:HandleSliderFrame(slider)
            end
        end
    end
    
    slider:SetScript("OnValueChanged", function(self, value)
        self.Value:SetText(value)
        MiniAHSavedVars[variable] = value
        if callback then
            callback(value)
        end
    end)
    
    return slider
end

-- Créer un bouton
function MiniAH:CreateButton(parent, text, width, height, anchorPoint, relativeFrame, xOffset, yOffset, callback)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width or 120, height or 25)
    button:SetPoint(anchorPoint or "TOPLEFT", relativeFrame or parent, anchorPoint == "TOP" and "BOTTOM" or "TOPLEFT", xOffset or 0, yOffset or 0)
    button:SetText(text)
    
    -- Appliquer le skin ElvUI si disponible
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if E.Skins.HandleButton then
                E.Skins:HandleButton(button)
            end
        end
    end
    
    button:SetScript("OnClick", function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Remplir la catégorie Général
function MiniAH:FillGeneralCategory()
    local category = categories.general
    if not category or not category.frame then return end
    
    local content = category.frame.scrollChild
    
    -- Informations générales
    local infoTitle = self:CreateSectionTitle(content, self:GetText("INFORMATION"), "TOPLEFT", 10, -10)
    
    local infoText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    infoText:SetPoint("TOPLEFT", infoTitle, "BOTTOMLEFT", 0, -10)
    infoText:SetWidth(content:GetWidth() - 30) -- Réduit la largeur pour éviter le chevauchement
    infoText:SetJustifyH("LEFT")
    infoText:SetSpacing(2) -- Ajoute un espacement entre les lignes
    infoText:SetText(COLORS.NORMAL .. self:GetText("ADDON_DESCRIPTION"))
    
    -- Statistiques
    local statsTitle = self:CreateSectionTitle(content, self:GetText("STATISTICS"), "TOPLEFT", 10, -120) -- Ajustement de la position verticale de -80 à -120
    
    local stats = self:GetDatabaseStats()
    
    local statsText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    statsText:SetPoint("TOPLEFT", statsTitle, "BOTTOMLEFT", 0, -10)
    statsText:SetWidth(content:GetWidth() - 20)
    statsText:SetJustifyH("LEFT")
    statsText:SetSpacing(3) -- Ajoute un espacement de 3 pixels entre les lignes
    statsText:SetText(
        COLORS.NORMAL .. self:GetText("ITEMS_RECORDED") .. COLORS.HIGHLIGHT .. stats.itemCount .. "\n" ..
        COLORS.NORMAL .. self:GetText("SCAN_COUNT") .. COLORS.HIGHLIGHT .. stats.scanCount .. "\n" ..
        COLORS.NORMAL .. self:GetText("LAST_SCAN") .. COLORS.HIGHLIGHT .. (stats.lastScanTime > 0 and date("%d/%m/%Y %H:%M:%S", stats.lastScanTime) or self:GetText("NEVER")) .. "\n" ..
        COLORS.NORMAL .. self:GetText("LAST_SCAN_DURATION") .. COLORS.HIGHLIGHT .. (stats.lastScanDuration > 0 and self:FormatTime(stats.lastScanDuration) or "N/A")
    )
    
    -- Boutons d'action
    local scanButton = self:CreateButton(content, self:GetText("START_SCAN"), 150, 25, "TOPLEFT", statsText, 0, -80, function() -- Augmenté de 20 pixels pour plus d'espace après le texte
        if C_AuctionHouse and C_AuctionHouse.IsAuctionHouseOpen and C_AuctionHouse.IsAuctionHouseOpen() then
            self:StartScan()
            optionsFrame:Hide()
        else
            print(COLORS.ERROR .. ADDON_NAME .. ":|r " .. self:GetText("AH_CLOSED"))
        end
    end)
    
    local cleanButton = self:CreateButton(content, self:GetText("CLEAN_DATABASE"), 200, 25, "TOPLEFT", scanButton, 0, -50, function() -- Augmenté de 20 pixels pour plus d'espace entre les boutons
        local count = self:CleanDatabase(30)
        statsText:SetText(
            COLORS.NORMAL .. self:GetText("ITEMS_RECORDED") .. COLORS.HIGHLIGHT .. self:GetDatabaseStats().itemCount .. "\n" ..
            COLORS.NORMAL .. self:GetText("SCAN_COUNT") .. COLORS.HIGHLIGHT .. stats.scanCount .. "\n" ..
            COLORS.NORMAL .. self:GetText("LAST_SCAN") .. COLORS.HIGHLIGHT .. (stats.lastScanTime > 0 and date("%d/%m/%Y %H:%M:%S", stats.lastScanTime) or self:GetText("NEVER")) .. "\n" ..
            COLORS.NORMAL .. self:GetText("LAST_SCAN_DURATION") .. COLORS.HIGHLIGHT .. (stats.lastScanDuration > 0 and self:FormatTime(stats.lastScanDuration) or "N/A")
        )
    end)
    
    -- Ajuster la hauteur du contenu
    content:SetHeight(200)
end

-- Remplir la catégorie Scan
function MiniAH:FillScanCategory()
    local category = categories.scan
    if not category or not category.frame then return end
    
    local content = category.frame.scrollChild
    content:SetWidth(400) -- Augmenter la largeur pour éviter le retour à la ligne
    
    -- Définir une marge constante pour tous les éléments
    local leftMargin = 15
    
    -- Options de scan
    local scanTitle = self:CreateSectionTitle(content, self:GetText("SCAN_OPTIONS"), "TOPLEFT", 10, -10)
    
    local autoScan = self:CreateCheckbox(
        content,
        self:GetText("AUTO_SCAN"),
        self:GetText("AUTO_SCAN_TOOLTIP"),
        "autoScan",
        "TOPLEFT",
        scanTitle,
        leftMargin,
        -21 -- Descendu de 6 pixels (de -15 à -21)
    )
    
    -- Option pour activer/désactiver le son de fin de scan (sur la même ligne que autoScan)
    local playScanCompleteSound = self:CreateCheckbox(
        content,
        self:GetText("PLAY_SCAN_COMPLETE_SOUND"),
        self:GetText("PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"),
        "playScanCompleteSound",
        "TOPLEFT",
        autoScan,
        leftMargin + 160, -- Décalage horizontal réduit de 40 pixels
        0 -- Même niveau vertical que autoScan
    )
    
    -- Initialiser la valeur par défaut à true si elle n'est pas déjà définie
    if MiniAHSavedVars.playScanCompleteSound == nil then
        MiniAHSavedVars.playScanCompleteSound = true
        playScanCompleteSound:SetChecked(true)
    end
    
    -- Appliquer le skin ElvUI si disponible
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if E.Skins.HandleCheckBox then
                E.Skins:HandleCheckBox(playScanCompleteSound)
            end
        end
    end
    
    local scanInterval = self:CreateSlider(
        content,
        self:GetText("SCAN_INTERVAL"),
        self:GetText("SCAN_INTERVAL_TOOLTIP"),
        "scanInterval",
        15,
        60,
        5,
        "TOPLEFT",
        autoScan,
        leftMargin,
        -60, -- Espace vertical augmenté de 20 pixels (de -40 à -60)
        nil,
        250 -- Largeur réduite comme les autres curseurs
    )
    
    -- Options d'archivage
    local archiveTitle = self:CreateSectionTitle(content, self:GetText("ARCHIVE_OPTIONS"), "TOPLEFT", 10, -140) -- Plus d'espace après la section précédente
    
    local keepHistory = self:CreateCheckbox(
        content,
        self:GetText("KEEP_HISTORY"),
        self:GetText("KEEP_HISTORY_TOOLTIP"),
        "keepHistory",
        "TOPLEFT",
        archiveTitle,
        leftMargin,
        -20 -- Plus d'espace après le titre
    )
    
    -- Placer les curseurs l'un en dessous de l'autre pour un style plus responsive (comme ElvUI)
    
    -- Premier curseur (jours d'historique)
    local historyDays = self:CreateSlider(
        content,
        self:GetText("HISTORY_DAYS"),
        self:GetText("HISTORY_DAYS_TOOLTIP"),
        "historyDays",
        1,
        30,
        1,
        "TOPLEFT",
        keepHistory,
        leftMargin,
        -70, -- Espace vertical augmenté après la case à cocher
        nil,
        250 -- Largeur réduite comme demandé
    )
    
    -- Deuxième curseur (jours de nettoyage)
    local cleanDays = self:CreateSlider(
        content,
        self:GetText("CLEAN_OLD_DATA"),
        self:GetText("CLEAN_OLD_DATA_TOOLTIP"),
        "cleanDays",
        1,
        90,
        1,
        "TOPLEFT",
        historyDays,
        0,
        -70, -- Espace vertical augmenté entre les curseurs
        nil,
        250 -- Largeur réduite comme demandé
    )
    
    -- Pas besoin d'ajuster la hauteur car nous n'utilisons plus de scrolling
end
-- Remplir la catégorie Affichage
function MiniAH:FillDisplayCategory()
    local category = categories.display
    if not category or not category.frame then return end
    
    local content = category.frame.scrollChild
    content:SetWidth(400) -- Augmenter la largeur pour éviter le retour à la ligne
    
    -- Options des infobulles
    local tooltipTitle = self:CreateSectionTitle(content, self:GetText("TOOLTIP_OPTIONS"), "TOPLEFT", 10, -10)
    
    local showAuctionPrice = self:CreateCheckbox(
        content,
        self:GetText("SHOW_AUCTION_PRICE"),
        self:GetText("SHOW_AUCTION_PRICE_TOOLTIP"),
        "showAuctionPrice",
        "TOPLEFT",
        tooltipTitle,
        15,
        -35 -- Augmenté de 20 pixels pour plus d'espace après le titre
    )
    
    local showVendorPrice = self:CreateCheckbox(
        content,
        self:GetText("SHOW_VENDOR_PRICE"),
        self:GetText("SHOW_VENDOR_PRICE_TOOLTIP"),
        "showVendorPrice",
        "TOPLEFT",
        showAuctionPrice,
        0,
        -25
    )
    
    local showAuctionAge = self:CreateCheckbox(
        content,
        self:GetText("SHOW_AGE"),
        self:GetText("SHOW_AGE_TOOLTIP"),
        "showAuctionAge",
        "TOPLEFT",
        showVendorPrice,
        0,
        -25
    )
    
    local colorCodePrices = self:CreateCheckbox(
        content,
        self:GetText("COLOR_PRICES"),
        self:GetText("COLOR_PRICES_TOOLTIP"),
        "colorCodePrices",
        "TOPLEFT",
        showAuctionAge,
        0,
        -25
    )
    
    -- Options de l'interface
    local uiTitle = self:CreateSectionTitle(content, self:GetText("UI_OPTIONS"), "TOPLEFT", 10, -170)
    
    local showMinimap = self:CreateCheckbox(
        content,
        self:GetText("SHOW_MINIMAP"),
        self:GetText("SHOW_MINIMAP_TOOLTIP"),
        "minimapButton.hide",
        "TOPLEFT",
        uiTitle,
        15,
        -35, -- Augmenté de 20 pixels pour plus d'espace après le titre
        function(checked)
            MiniAHSavedVars.minimapButton.hide = not checked
            self:UpdateMinimapButton()
        end
    )
    
    -- Inverser la valeur pour la case à cocher (hide -> show)
    showMinimap:SetChecked(not MiniAHSavedVars.minimapButton.hide)
    
    -- Pas besoin d'ajuster la hauteur car nous n'utilisons plus de scrolling
end

-- Remplir la catégorie Avancé
function MiniAH:FillAdvancedCategory()
    local category = categories.advanced
    if not category or not category.frame then return end
    
    local content = category.frame.scrollChild
    
    -- Options avancées
    local advancedTitle = self:CreateSectionTitle(content, self:GetText("ADVANCED_OPTIONS"), "TOPLEFT", 10, -10)
    
    local resetButton = self:CreateButton(content, self:GetText("RESET_OPTIONS"), 200, 25, "TOPLEFT", advancedTitle, 0, -35, function() -- Augmenté de 15 pixels pour plus d'espace après le titre
        StaticPopupDialogs["MINIAHSCANNER_RESET_OPTIONS"] = {
            text = self:GetText("RESET_CONFIRM"):format(ADDON_NAME),
            button1 = self:GetText("YES"),
            button2 = self:GetText("NO"),
            OnAccept = function()
                self:ResetOptions()
                optionsFrame:Hide()
                self:ShowOptionsUI() -- Rouvrir avec les options réinitialisées
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("MINIAHSCANNER_RESET_OPTIONS")
    end)
    
    -- Le bouton "Forcer un scan immédiat" a été supprimé car il n'est plus nécessaire avec la nouvelle implémentation du scan
    
    local resetDBButton = self:CreateButton(content, self:GetText("RESET_DATABASE"), 200, 25, "TOPLEFT", resetButton, 0, -30, function()
        StaticPopupDialogs["MINIAHSCANNER_RESET_DB"] = {
            text = self:GetText("RESET_DB_CONFIRM"):format(ADDON_NAME),
            button1 = self:GetText("YES"),
            button2 = self:GetText("NO"),
            OnAccept = function()
                self:ResetDatabase()
                optionsFrame:Hide()
                self:ShowOptionsUI() -- Rouvrir avec la base de données réinitialisée
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("MINIAHSCANNER_RESET_DB")
    end)
    
    -- Ajuster la hauteur du contenu
    content:SetHeight(200)
end

-- Afficher l'interface des options
function MiniAH:ShowOptionsUI()
    local frame = self:CreateOptionsUI()
    
    -- Utiliser la méthode standard de WoW pour les fenêtres d'options
    -- Cette méthode permet aux raccourcis souris de fonctionner même quand la fenêtre est ouverte
    if not frame:IsShown() then
        frame:Show()
        
        -- Désactiver temporairement la capture de la souris pour permettre les raccourcis souris
        frame:EnableMouse(false)
        C_Timer.After(0.01, function() 
            if frame:IsShown() then
                frame:EnableMouse(true) 
                
                -- Créer un gestionnaire d'événements pour les clics en dehors de la fenêtre
                if not frame.mouseWatcher then
                    frame.mouseWatcher = CreateFrame("Frame")
                    frame.mouseWatcher:SetScript("OnUpdate", function()
                        if frame:IsShown() and IsMouseButtonDown() and not frame:IsMouseOver() then
                            -- Désactiver temporairement la capture de la souris pour permettre le clic
                            frame:EnableMouse(false)
                            C_Timer.After(0.1, function() 
                                if frame:IsShown() then 
                                    frame:EnableMouse(true) 
                                end 
                            end)
                        end
                    end)
                end
                frame.mouseWatcher:Show()
            end
        end)
    end
    
    -- Mettre à jour les statistiques
    self:FillGeneralCategory()
    
    return frame
end

-- Réinitialiser les options
function MiniAH:ResetOptions()
    MiniAHSavedVars.autoScan = true
    MiniAHSavedVars.showAuctionPrice = true
    MiniAHSavedVars.showVendorPrice = true
    MiniAHSavedVars.keepHistory = true
    MiniAHSavedVars.showAuctionAge = true
    MiniAHSavedVars.colorCodePrices = true
    MiniAHSavedVars.scanInterval = 15
    MiniAHSavedVars.historyDays = 7
    MiniAHSavedVars.cleanDays = 30
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
