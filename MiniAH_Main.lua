-- MiniAH_Main.lua
-- Fichier principal pour l'addon MiniAHScanner

local ADDON_NAME = "MiniAHScanner"
local VERSION = "1.1.0"

-- Créer le namespace global pour l'addon
local _, MiniAH = ...

-- Fonction pour formater les prix en or/argent/cuivre avec couleurs et/ou icônes
local function FormatMoney(amount)
    if not amount then return "N/A" end
    
    local gold = math.floor(amount / 10000)
    local silver = math.floor((amount % 10000) / 100)
    local copper = amount % 100
    
    -- Définir les icônes des pièces
    local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
    local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
    local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"
    
    -- Vérifier si on doit utiliser les icônes
    if MiniAHSavedVars and MiniAHSavedVars.useCoinIcons then
        local result = ""
        if gold > 0 then result = result .. gold .. goldIcon .. " " end
        if silver > 0 or gold > 0 then result = result .. silver .. silverIcon .. " " end
        result = result .. copper .. copperIcon
        return result
    -- Vérifier si on doit utiliser les couleurs
    elseif MiniAHSavedVars and MiniAHSavedVars.colorCodePrices then
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
    else
        -- Version sans couleurs ni icônes
        local result = ""
        if gold > 0 then result = result .. gold .. "g " end
        if silver > 0 or gold > 0 then result = result .. silver .. "s " end
        result = result .. copper .. "c"
        return result
    end
end

-- Fonction pour créer une chaîne de caractères avec le nombre d'objets
local function CreateCountString(count)
    if count and count > 1 then
        return " x" .. count
    else
        return ""
    end
end

-- Fonction pour formater l'âge des données
local function FormatAge(timestamp)
    if not timestamp then return nil end
    
    local timeSince = time() - timestamp
    local days = math.floor(timeSince / 86400)
    
    if days < 1 then
        local hours = math.floor(timeSince / 3600)
        if hours < 1 then
            local minutes = math.floor(timeSince / 60)
            return minutes .. " min"
        else
            return hours .. " h"
        end
    else
        return days .. " j"
    end
end

-- Créer le frame principal pour les événements
local mainFrame = CreateFrame("Frame")
MiniAH.mainFrame = mainFrame

-- Modifier les infobulles pour afficher les prix
-- Cache pour éviter les appels répétés à GetBagItemCount
local bagItemCountCache = {}
local lastCacheUpdate = 0
local CACHE_DURATION = 2 -- Durée du cache en secondes

-- Fonction pour vider le cache des objets dans les sacs
local function ClearBagItemCountCache()
    wipe(bagItemCountCache)
    lastCacheUpdate = GetTime()
end
local function GetBagItemCount(itemId)
    -- Vérifier le cache d'abord
    if bagItemCountCache[itemId] then
        return bagItemCountCache[itemId]
    end
    
    -- Calculer la quantité d'objets dans les sacs normaux
    local count = 0
    for bag = 0, NUM_BAG_SLOTS do
        local slots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, slots do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info and info.itemID == itemId then
                count = count + info.stackCount
            end
        end
    end
    
    -- Vérifier aussi le sac de composants porté par le joueur (sac 5)
    local REAGENT_BAG = 5
    if C_Container.GetContainerNumSlots(REAGENT_BAG) and C_Container.GetContainerNumSlots(REAGENT_BAG) > 0 then
        for slot = 1, C_Container.GetContainerNumSlots(REAGENT_BAG) do
            local info = C_Container.GetContainerItemInfo(REAGENT_BAG, slot)
            if info and info.itemID == itemId then
                count = count + info.stackCount
            end
        end
    end
    
    -- Mettre en cache le résultat
    bagItemCountCache[itemId] = count
    return count
end

-- Fonction optimisée pour les tooltips
local function OnTooltipSetItem(tooltip, ...)
    -- Vérifications rapides pour sortir au plus tôt
    if not tooltip or not tooltip.GetItem then return end
    if not MiniAHSavedVars.showAuctionPrice and not MiniAHSavedVars.showVendorPrice then return end
    
    local name, link = tooltip:GetItem()
    if not name or not link then return end
    
    local itemID = GetItemInfoInstant(link)
    if not itemID then return end
    
    -- Définir une quantité par défaut et une quantité de stack pour les prix
    local itemCount = 1
    local stackSize = 20  -- Taille de stack par défaut pour les matériaux
    
    -- Récupérer la quantité réelle d'objets dans le sac (utilise le cache)
    local bagCount = GetBagItemCount(itemID)
    if bagCount > 0 then
        itemCount = bagCount
    end
    
    -- Parcourir toutes les lignes du tooltip pour trouver les informations sur la taille de pile
    for i = 1, tooltip:NumLines() do
        local text = _G[tooltip:GetName() .. "TextLeft" .. i]:GetText() or ""
        
        -- Recherche spécifique de la taille de pile (version française)
        if text:find("Taille de pile") then
            local number = string.match(text, "(%d+)")
            if number then
                stackSize = tonumber(number)
            end
        end
        
        -- Recherche spécifique de la taille de pile (version anglaise)
        if text:find("Stack size") or text:find("Stack:") then
            local number = string.match(text, "(%d+)")
            if number then
                stackSize = tonumber(number)
            end
        end
    end
    
    -- Cas spécial pour le Bœuf (ou presque) qui a une taille de pile de 1000
    if name and name:find("Bœuf") then
        stackSize = 1000
    else
        -- Pour les autres objets, essayer de déterminer la taille de stack à partir des infos de l'objet
        local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, maxStack = GetItemInfo(link)
        if maxStack and type(maxStack) == "number" and maxStack > 0 then
            stackSize = maxStack
        end
    end
    
    -- Ajouter un séparateur avant nos informations
    tooltip:AddLine(" ")
    
    -- Afficher le prix vendeur si activé
    if MiniAHSavedVars.showVendorPrice then
        local vendorPrice = MiniAH:GetVendorPrice(itemID)
        if vendorPrice and vendorPrice > 0 then
            -- Afficher le prix unitaire
            tooltip:AddDoubleLine(
                "|cFFFFFFFFVendeur (unité):|r",
                FormatMoney(vendorPrice)
            )
            
            -- Afficher le prix pour la quantité actuelle dans le sac
            if itemCount > 1 then
                tooltip:AddDoubleLine(
                    "|cFFFFFFFFVendeur (" .. itemCount .. "):|r",
                    FormatMoney(vendorPrice * itemCount)
                )
            end
        end
    end
    
    -- Afficher le prix de l'hôtel des ventes si activé (optimisé pour réduire les concaténations)
    if MiniAHSavedVars.showAuctionPrice then
        local auctionPrice = MiniAH:GetItemPrice(itemID)
        
        if auctionPrice and auctionPrice > 0 then
            -- Variables locales pour éviter les réallocations
            local itemData = MiniAHSavedVars.itemPrices[itemID]
            local lastScan = itemData and itemData.lastScan
            local ageText = ""
            
            -- Préparer le texte de l'âge une seule fois
            if lastScan and MiniAHSavedVars.showAuctionAge then
                ageText = " |cFF808080(" .. FormatAge(lastScan) .. ")|r"
            end
            
            -- Précalculer les valeurs formatées
            local unitPriceText = FormatMoney(auctionPrice) .. ageText
            
            -- Afficher le prix unitaire (utiliser des constantes pour éviter les allocations)
            tooltip:AddDoubleLine(
                "|cFFAAAAFFAH (unité):|r",
                unitPriceText
            )
            
            -- Afficher le prix du stack si nécessaire
            if itemCount > 1 then
                -- Réutiliser la même chaîne ageText pour économiser de la mémoire
                local stackLabel = "|cFFAAAAFFAH Stack ("
                stackLabel = stackLabel .. itemCount .. "):|r"
                
                tooltip:AddDoubleLine(
                    stackLabel,
                    FormatMoney(auctionPrice * itemCount) .. ageText
                )
            end
        else
            -- Utiliser une constante pour éviter les allocations
            tooltip:AddDoubleLine(
                "|cFFAAAAFFAH:|r",
                "|cFF808080Inconnu|r"
            )
        end
    end
    
    -- Aucune ligne d'aide nécessaire car les prix unitaires et par stack sont déjà affichés
    
    tooltip:Show()
end

-- Gestionnaire d'événements
function MiniAH:SetupEventHandlers()
    -- Enregistrer les événements
    mainFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
    mainFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")
    mainFrame:RegisterEvent("PLAYER_LOGOUT")
    mainFrame:RegisterEvent("BAG_UPDATE")
    mainFrame:RegisterEvent("REAGENTBANK_UPDATE")
    
    -- Définir le gestionnaire d'événements
    mainFrame:SetScript("OnEvent", function(frame, event, ...)
        if event == "AUCTION_HOUSE_SHOW" then
            -- Attendre un court instant pour s'assurer que l'hôtel des ventes est complètement chargé
            C_Timer.After(0.5, function()
                -- Vérifier si le scan automatique est activé
                if MiniAHSavedVars.autoScan then
                    -- Vérifier s'il faut respecter l'intervalle minimum entre les scans
                    local canScan = true
                    local now = time()
                    
                    if MiniAHSavedVars.lastScanTime and MiniAHSavedVars.scanInterval then
                        local timeSinceLastScan = now - MiniAHSavedVars.lastScanTime
                        local minInterval = MiniAHSavedVars.scanInterval * 60 -- Convertir en secondes
                        
                        if timeSinceLastScan < minInterval then
                            canScan = false
                            local timeRemaining = math.ceil((minInterval - timeSinceLastScan) / 60)
                            print("|cFFFF9900" .. ADDON_NAME .. ":|r Scan automatique désactivé. Prochain scan possible dans " .. timeRemaining .. " minute(s).")
                        end
                    end
                    
                    if canScan then
                        print("|cFF00FF00" .. ADDON_NAME .. ":|r Démarrage du scan automatique...")
                        -- L'hôtel des ventes est forcément ouvert puisque nous sommes dans l'événement AUCTION_HOUSE_SHOW
                        MiniAH:StartScan()
                    end
                else
                    -- Afficher un message si le scan automatique est désactivé
                    print("|cFFFF9900" .. ADDON_NAME .. ":|r Scan automatique désactivé. Pour lancer un scan manuellement, tapez |cFFFFFFFF/mah scan|r")
                end
            end)
        elseif event == "AUCTION_HOUSE_CLOSED" then
            -- Arrêter le scan si l'hôtel des ventes est fermé
            if MiniAH.scanInProgress then
                MiniAH:CompleteScan(true, "L'hôtel des ventes a été fermé")
            end
        elseif event == "PLAYER_LOGOUT" then
            -- Sauvegarder les données avant la déconnexion
            MiniAH:SaveData()
        elseif event == "BAG_UPDATE" or event == "REAGENTBANK_UPDATE" then
            -- Vider le cache des objets dans les sacs lorsque leur contenu change
            ClearBagItemCountCache()
        end
    end)
end

-- Initialisation de l'addon
function MiniAH:Init()
    -- Initialiser les modules
    self:InitDatabaseModule()
    self:InitScanModule()
    self:InitUIModule()
    
    -- Initialiser le bouton de la minimap
    self:InitMinimapButton()
    
    -- Initialiser la barre de progression
    self:InitProgressBar()
    
    -- Configurer les gestionnaires d'événements
    self:SetupEventHandlers()
    
    -- Hook pour les infobulles
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
    
    -- Créer un frame pour détecter les changements d'état de la touche Shift
    local shiftFrame = CreateFrame("Frame", "MiniAHShiftDetector")
    shiftFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
    
    -- Gestionnaire d'événements pour la touche Shift
    shiftFrame:SetScript("OnEvent", function(self, event, key, down)
        if key == "LSHIFT" or key == "RSHIFT" then
            -- Mettre à jour l'infobulle si elle est visible
            if GameTooltip:IsShown() then
                local name, link = GameTooltip:GetItem()
                if name and link then
                    -- Effacer et reconstruire l'infobulle
                    GameTooltip:ClearLines()
                    GameTooltip:SetHyperlink(link)
                end
            end
        end
    end)
    
    -- Créer un hook pour GameTooltip:SetHyperlink
    local originalSetHyperlink = GameTooltip.SetHyperlink
    GameTooltip.SetHyperlink = function(self, ...)
        -- Appeler la fonction originale
        originalSetHyperlink(self, ...)
        
        -- Ajouter un timer pour vérifier l'état de la touche Shift
        C_Timer.After(0.1, function()
            if self:IsShown() then
                OnTooltipSetItem(self)
            end
        end)
    end
    
    -- Enregistrer les commandes slash
    self:RegisterSlashCommands()
    
    print("|cFF00FF00" .. self:GetText("ADDON_LOADED", ADDON_NAME, VERSION, "|cFFFFD700/mah|r") .. "|r")
end

-- Enregistrer les commandes slash
function MiniAH:RegisterSlashCommands()
    
    SLASH_MINIAHSCANNER1 = "/miniahscanner"
    SLASH_MINIAHSCANNER2 = "/mah"
    
    SlashCmdList["MINIAHSCANNER"] = function(msg)
        -- Débug pour vérifier si la commande est reçue
        print("Commande reçue: /mah " .. msg)
        
        msg = msg:lower()
        
        if msg == "scan" then
            -- Lancer un scan
            print("Tentative de lancement du scan...")
            -- Vérifier si l'hôtel des ventes est ouvert
            -- Support pour les versions récentes (Dragonflight et au-delà) et les versions classiques
            local isAHOpen = false
            
            -- Vérification pour les versions récentes (Dragonflight et au-delà)
            if AuctionHouseFrame and AuctionHouseFrame:IsVisible() then
                isAHOpen = true
            -- Vérification pour les versions classiques
            elseif AuctionFrame and AuctionFrame:IsVisible() then
                isAHOpen = true
            end
            
            if isAHOpen then
                self:StartScan()
            else
                print("|cFFFF0000" .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
            end
        elseif msg == "options" or msg == "config" then
            -- Afficher les options
            print("Ouverture de l'interface des options...")
            self:ShowOptionsUI()
        elseif msg == "stats" then
            -- Afficher les statistiques
            print("Affichage des statistiques...")
            local stats = self:GetDatabaseStats()
            print("|cFFFFD700" .. ADDON_NAME .. " - Statistiques:|r")
            print("Objets enregistrés: " .. stats.itemCount)
            print("Nombre de scans: " .. stats.scanCount)
            if stats.lastScanTime > 0 then
                print("Dernier scan: " .. date("%d/%m/%Y %H:%M:%S", stats.lastScanTime))
            else
                print("Dernier scan: Jamais")
            end
        elseif msg == "help" or msg == "" then
            -- Afficher l'aide
            print("|cFFFFD700" .. ADDON_NAME .. " - Aide:|r")
            print("|cFFFFFFFF/mah scan|r - Lancer un scan de l'hôtel des ventes")
            print("|cFFFFFFFF/mah options|r - Afficher les options")
            print("|cFFFFFFFF/mah stats|r - Afficher les statistiques")
            print("|cFFFFFFFF/mah help|r - Afficher cette aide")
        else
            print("|cFFFF0000" .. ADDON_NAME .. ":|r Commande inconnue. Tapez |cFFFFD700/mah help|r pour l'aide.")
        end
    end
end

-- Créer un bouton (minimap ou flottant)
function MiniAH:CreateButton()
    -- Vérifier si LibDBIcon est disponible
    local hasLibraries = false
    
    -- Vérifier prudemment si les bibliothèques sont disponibles
    if _G["LibStub"] then
        local success, LDB = pcall(function() return LibStub:GetLibrary("LibDataBroker-1.1", true) end)
        local success2, LDBIcon = pcall(function() return LibStub:GetLibrary("LibDBIcon-1.0", true) end)
        
        if success and success2 and LDB and LDBIcon then
            hasLibraries = true
            
            -- Créer un bouton sur la minimap avec LibDBIcon
            local minimapButton = LDB:NewDataObject(ADDON_NAME, {
                type = "launcher",
                icon = "Interface\\Icons\\INV_Misc_Coin_01",
                OnClick = function(self, button)
                    if button == "LeftButton" then
                        MiniAH:ShowUI()
                    elseif button == "RightButton" then
                        if C_AuctionHouse.IsAuctionHouseOpen() then
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
            
            LDBIcon:Register(ADDON_NAME, minimapButton, MiniAHSavedVars.minimapButton)
            
            -- Fonctions pour afficher/masquer le bouton
            function self:ShowMinimapButton()
                MiniAHSavedVars.minimapButton.hide = false
                LDBIcon:Show(ADDON_NAME)
            end
            
            function self:HideMinimapButton()
                MiniAHSavedVars.minimapButton.hide = true
                LDBIcon:Hide(ADDON_NAME)
            end
        end
    end
    
    -- Si les bibliothèques ne sont pas disponibles, créer un bouton flottant
    if not hasLibraries then
        print("|cFFFFFF00" .. ADDON_NAME .. ":|r Bibliothèques optionnelles non trouvées, utilisation du bouton flottant.")
        
        local button = CreateFrame("Button", "MiniAHButton", UIParent, "UIPanelButtonTemplate")
        button:SetSize(40, 40)
        button:SetPoint("TOPRIGHT", -100, -100)
        button:SetMovable(true)
        button:EnableMouse(true)
        button:RegisterForDrag("LeftButton")
        button:SetScript("OnDragStart", button.StartMoving)
        button:SetScript("OnDragStop", button.StopMovingOrSizing)
        
        -- Texture du bouton
        local texture = button:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints()
        texture:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
        
        -- Bordure du bouton
        local border = button:CreateTexture(nil, "OVERLAY")
        border:SetAllPoints()
        border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        
        -- Événements du bouton
        button:SetScript("OnClick", function(self, mouseButton)
            if mouseButton == "LeftButton" then
                MiniAH:ShowUI()
            elseif mouseButton == "RightButton" then
                if C_AuctionHouse.IsAuctionHouseOpen() then
                    MiniAH:StartScan()
                else
                    print("|cFFFF0000" .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
                end
            end
        end)
        
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(ADDON_NAME)
            GameTooltip:AddLine("|cFFFFFFFFClic gauche:|r Ouvrir les options")
            GameTooltip:AddLine("|cFFFFFFFFClic droit:|r Lancer un scan")
            GameTooltip:Show()
        end)
        
        button:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        
        self.floatingButton = button
        
        -- Fonctions pour afficher/masquer le bouton
        function self:ShowMinimapButton()
            self.floatingButton:Show()
        end
        
        function self:HideMinimapButton()
            self.floatingButton:Hide()
        end
    end
    
    -- Afficher ou masquer le bouton selon les préférences
    if MiniAHSavedVars.minimapButton.hide then
        self:HideMinimapButton()
    else
        self:ShowMinimapButton()
    end
end

-- Enregistrer les événements
mainFrame:RegisterEvent("ADDON_LOADED")

-- Gestionnaire d'événements
mainFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == ADDON_NAME then
        MiniAH:Init()
    end
end)
