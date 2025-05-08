-- MiniAH_Minimap.lua
-- Gestion du bouton de la minimap pour MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Constantes
local MINIMAP_ICON = "Interface/Icons/INV_Misc_Coin_01" -- Icône de pièce d'or

-- Variables locales
local minimapButton = nil
local isDragging = false

-- Fonction pour initialiser le bouton de la minimap
function MiniAH:InitMinimapButton()
    -- Vérifier si LibDBIcon est disponible
    if LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true) and LibStub:GetLibrary("LibDBIcon-1.0", true) then
        -- Utiliser LibDBIcon si disponible
        self:InitMinimapButtonWithLib()
    else
        -- Sinon, utiliser notre propre implémentation
        self:InitMinimapButtonBasic()
    end
end

-- Initialisation avec LibDBIcon (si disponible)
function MiniAH:InitMinimapButtonWithLib()
    local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
    local DBIcon = LibStub:GetLibrary("LibDBIcon-1.0")
    
    -- Créer le broker
    local broker = LDB:NewDataObject(ADDON_NAME, {
        type = "launcher",
        text = ADDON_NAME,
        icon = MINIMAP_ICON,
        OnClick = function(_, button)
            if button == "LeftButton" then
                MiniAH:ShowOptionsUI()
            elseif button == "RightButton" then
                if AuctionFrame and AuctionFrame:IsVisible() then
                    MiniAH:StartScan()
                else
                    print("|cFFFF0000" .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
                end
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine(ADDON_NAME)
            tooltip:AddLine("|cFFFFFFFFClic gauche:|r Ouvrir les options")
            tooltip:AddLine("|cFFFFFFFFClic droit:|r Lancer un scan")
        end,
    })
    
    -- Initialiser les variables sauvegardées
    if not MiniAHSavedVars.minimapButton then
        MiniAHSavedVars.minimapButton = {
            hide = false,
            position = 45,
        }
    end
    
    -- Enregistrer le bouton
    DBIcon:Register(ADDON_NAME, broker, MiniAHSavedVars.minimapButton)
    
    -- Mettre à jour l'affichage
    if MiniAHSavedVars.minimapButton.hide then
        DBIcon:Hide(ADDON_NAME)
    else
        DBIcon:Show(ADDON_NAME)
    end
end

-- Initialisation basique (sans bibliothèque)
function MiniAH:InitMinimapButtonBasic()
    -- Créer le bouton s'il n'existe pas déjà
    if minimapButton then return end
    
    -- Initialiser les variables sauvegardées
    if not MiniAHSavedVars.minimapButton then
        MiniAHSavedVars.minimapButton = {
            hide = false,
            position = 45, -- angle en degrés (0 = haut, 90 = droite, etc.)
        }
    end
    
    -- Créer le bouton
    minimapButton = CreateFrame("Button", "MiniAHMinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    
    -- Texture du bouton
    minimapButton.icon = minimapButton:CreateTexture(nil, "BACKGROUND")
    minimapButton.icon:SetAllPoints()
    minimapButton.icon:SetTexture(MINIMAP_ICON)
    
    -- Bordure
    minimapButton.border = minimapButton:CreateTexture(nil, "OVERLAY")
    minimapButton.border:SetSize(54, 54)
    minimapButton.border:SetPoint("CENTER")
    minimapButton.border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
    
    -- Highlight
    minimapButton:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight")
    
    -- Scripts
    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine(ADDON_NAME)
        GameTooltip:AddLine("|cFFFFFFFFClic gauche:|r Ouvrir les options")
        GameTooltip:AddLine("|cFFFFFFFFClic droit:|r Lancer un scan")
        GameTooltip:Show()
    end)
    
    minimapButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    minimapButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            MiniAH:ShowOptionsUI()
        elseif button == "RightButton" then
            if AuctionFrame and AuctionFrame:IsVisible() then
                MiniAH:StartScan()
            else
                print("|cFFFF0000" .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
            end
        end
    end)
    
    minimapButton:SetScript("OnDragStart", function()
        isDragging = true
        minimapButton:StartMoving()
    end)
    
    minimapButton:SetScript("OnDragStop", function()
        isDragging = false
        minimapButton:StopMovingOrSizing()
        local xpos, ypos = minimapButton:GetCenter()
        local xmin, ymin = Minimap:GetCenter()
        local xdelta, ydelta = xpos - xmin, ypos - ymin
        local angle = math.deg(math.atan2(ydelta, xdelta))
        MiniAHSavedVars.minimapButton.position = angle
        MiniAH:UpdateMinimapButtonPosition()
    end)
    
    -- Rendre le bouton déplaçable
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:SetMovable(true)
    
    -- Positionner le bouton
    self:UpdateMinimapButtonPosition()
    
    -- Afficher ou masquer selon les préférences
    if MiniAHSavedVars.minimapButton.hide then
        minimapButton:Hide()
    else
        minimapButton:Show()
    end
end

-- Mettre à jour la position du bouton sur la minimap
function MiniAH:UpdateMinimapButtonPosition()
    if not minimapButton then return end
    
    local angle = MiniAHSavedVars.minimapButton.position or 45
    local radian = math.rad(angle)
    local radius = 80 -- distance du centre de la minimap
    local x = radius * math.cos(radian)
    local y = radius * math.sin(radian)
    
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Afficher le bouton de la minimap
function MiniAH:ShowMinimapButton()
    if LibStub and LibStub:GetLibrary("LibDBIcon-1.0", true) then
        local DBIcon = LibStub:GetLibrary("LibDBIcon-1.0")
        MiniAHSavedVars.minimapButton.hide = false
        DBIcon:Show(ADDON_NAME)
    elseif minimapButton then
        MiniAHSavedVars.minimapButton.hide = false
        minimapButton:Show()
    end
end

-- Masquer le bouton de la minimap
function MiniAH:HideMinimapButton()
    if LibStub and LibStub:GetLibrary("LibDBIcon-1.0", true) then
        local DBIcon = LibStub:GetLibrary("LibDBIcon-1.0")
        MiniAHSavedVars.minimapButton.hide = true
        DBIcon:Hide(ADDON_NAME)
    elseif minimapButton then
        MiniAHSavedVars.minimapButton.hide = true
        minimapButton:Hide()
    end
end

-- Mettre à jour l'état du bouton de la minimap
function MiniAH:UpdateMinimapButton()
    if MiniAHSavedVars.minimapButton.hide then
        self:HideMinimapButton()
    else
        self:ShowMinimapButton()
    end
end
