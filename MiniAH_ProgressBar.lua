-- MiniAH_ProgressBar.lua
-- Barre de progression pour MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Variables locales
local progressBar = nil
local isBarCreated = false

-- Créer la barre de progression
function MiniAH:CreateProgressBar()
    if isBarCreated and progressBar then
        return progressBar
    end
    
    -- Créer le cadre de la barre de progression
    progressBar = CreateFrame("Frame", "MiniAHProgressBar", UIParent, "BackdropTemplate")
    progressBar:SetSize(830, 20) -- Taille par défaut
    progressBar:SetPoint("CENTER", UIParent, "CENTER", 0, 200) -- Position temporaire
    
    -- Appliquer le fond et la bordure
    if progressBar.SetBackdrop then
        progressBar:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        progressBar:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
        progressBar:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end
    
    -- Créer la texture de la barre
    progressBar.bar = progressBar:CreateTexture(nil, "ARTWORK")
    progressBar.bar:SetPoint("TOPLEFT", 5, -5)
    progressBar.bar:SetPoint("BOTTOMLEFT", 5, 5)
    progressBar.bar:SetWidth(1)
    progressBar.bar:SetTexture("Interface/TargetingFrame/UI-StatusBar")
    progressBar.bar:SetVertexColor(0, 0.7, 0) -- Vert par défaut
    
    -- Texte de la barre
    progressBar.text = progressBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    progressBar.text:SetPoint("CENTER")
    progressBar.text:SetText("")
    
    -- Cacher la barre par défaut
    progressBar:Hide()
    
    -- Compatibilité avec ElvUI
    if ElvUI then
        local E = unpack(ElvUI)
        if E and E.Skins then
            if progressBar.SetTemplate then
                progressBar:SetTemplate("Transparent")
            end
        end
    end
    
    isBarCreated = true
    return progressBar
end

-- Initialiser la barre de progression
function MiniAH:InitProgressBar()
    -- Créer la barre si elle n'existe pas
    if not isBarCreated then
        self:CreateProgressBar()
    end
    
    -- Enregistrer les événements pour montrer/cacher la barre
    progressBar:RegisterEvent("AUCTION_HOUSE_SHOW")
    progressBar:RegisterEvent("AUCTION_HOUSE_CLOSED")
    
    progressBar:SetScript("OnEvent", function(self, event)
        if event == "AUCTION_HOUSE_SHOW" then
            -- Attendre un peu que l'interface de l'hôtel des ventes soit complètement chargée
            C_Timer.After(0.5, function()
                -- Récupérer le cadre de l'hôtel des ventes
                local ahFrame = AuctionHouseFrame
                
                if ahFrame then
                    -- Ajuster la position et la taille de la barre
                    progressBar:SetParent(ahFrame)
                    progressBar:ClearAllPoints()
                    progressBar:SetPoint("TOPLEFT", ahFrame, "TOPLEFT", 0, 25)
                    progressBar:SetPoint("TOPRIGHT", ahFrame, "TOPRIGHT", 0, 25)
                    progressBar:SetHeight(20)
                    
                    -- Afficher la barre
                    progressBar:Show()
                    
                    -- Afficher "Prêt à scanner" par défaut
                    if MiniAH:CanInitiateScan() then
                        MiniAH:UpdateProgressBar(0, "Prêt à scanner", false) -- Vert pour scan possible
                    else
                        -- Démarrer le timer en temps réel si un scan a été effectué précédemment
                        if MiniAHSavedVars.scanStats.lastFullScan > 0 then
                            -- Démarrer le timer en temps réel
                            C_Timer.After(0.1, function()
                                MiniAH:StartRealTimeTimer()
                            end)
                        else
                            -- Afficher un message statique sans timer
                            MiniAH:UpdateProgressBar(0, "Prêt à scanner", false) -- Vert pour scan possible
                        end
                    end
                end
            end)
        elseif event == "AUCTION_HOUSE_CLOSED" then
            progressBar:Hide()
        end
    end)
end

-- Mettre à jour la barre de progression
function MiniAH:UpdateProgressBar(percent, text, isError)
    if not progressBar then
        return
    end
    
    -- S'assurer que la barre est visible
    if not progressBar:IsShown() then
        progressBar:Show()
    end
    
    -- Limiter le pourcentage entre 0 et 100
    percent = math.max(0, math.min(100, percent))
    
    -- Calculer la largeur de la barre
    local width = (progressBar:GetWidth() - 10) * (percent / 100)
    progressBar.bar:SetWidth(width)
    
    -- Mettre à jour le texte
    if text then
        progressBar.text:SetText(text)
    end
    
    -- Changer la couleur en fonction de l'état
    if isError then
        progressBar.bar:SetVertexColor(0.7, 0, 0) -- Rouge pour les erreurs
    else
        progressBar.bar:SetVertexColor(0, 0.7, 0) -- Vert par défaut
    end
end



-- Montrer la barre avec un message d'erreur
function MiniAH:ShowErrorBar(text)
    if not progressBar then
        self:CreateProgressBar()
    end
    
    progressBar:Show()
    self:UpdateProgressBar(100, text, true)
    
    -- Garder la barre visible pour que l'utilisateur puisse voir le message d'erreur
    -- La barre sera masquée uniquement lorsque l'hôtel des ventes est fermé
end
