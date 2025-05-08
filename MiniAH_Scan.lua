-- MiniAH_Scan.lua
-- Fonctions de scan de l'hôtel des ventes pour MiniAHScanner
-- Version optimisée pour minimiser l'utilisation mémoire

local ADDON_NAME, MiniAH = ...

-- Variables locales (utilisation de locals pour réduire l'empreinte mémoire)
local waitingForData = 0
local scanStartTime = 0
local scanData = {}

-- Événements à écouter (définis directement pour éviter une table supplémentaire)
local SCAN_EVENTS = {
    "REPLICATE_ITEM_LIST_UPDATE",
    "AUCTION_HOUSE_CLOSED"
}

-- Initialisation du module de scan
function MiniAH:InitScanModule()
    -- Créer un frame pour les événements
    self.scanFrame = CreateFrame("Frame")
    
    -- Initialiser les variables sauvegardées
    MiniAHSavedVars.scanStats = MiniAHSavedVars.scanStats or {}
    MiniAHSavedVars.scanStats.lastFullScan = MiniAHSavedVars.scanStats.lastFullScan or 0
    MiniAHSavedVars.scanStats.scanCount = MiniAHSavedVars.scanStats.scanCount or 0
    MiniAHSavedVars.scanStats.itemsScanned = MiniAHSavedVars.scanStats.itemsScanned or 0
    MiniAHSavedVars.scanStats.lastScanDuration = MiniAHSavedVars.scanStats.lastScanDuration or 0
    
    -- Initialiser la structure des prix
    if not MiniAHSavedVars.itemPrices then
        MiniAHSavedVars.itemPrices = {}
    end
    
    -- Définir le gestionnaire d'événements
    self.scanFrame:SetScript("OnEvent", function(_, event, ...)
        self:OnEvent(event, ...)
    end)
    
    -- Initialiser l'état du scan
    self.inProgress = false
    
    -- Enregistrer un gestionnaire d'événement pour ADDON_LOADED
    self.scanFrame:RegisterEvent("ADDON_LOADED")
    
    -- Vérifier si l'hôtel des ventes est déjà ouvert (pour le cas d'un /reload)
    if AuctionHouseFrame and AuctionHouseFrame:IsVisible() then
        -- Si un scan a été effectué précédemment et que le temps d'attente n'est pas écoulé
        if MiniAHSavedVars.scanStats.lastFullScan > 0 and not self:CanInitiateScan() then
            C_Timer.After(0.5, function()
                self:StartRealTimeTimer()
            end)
        end
    end
end

-- Vérifier si un scan peut être initié (limite de 15 minutes)
function MiniAH:CanInitiateScan()
    return
        (MiniAHSavedVars.scanStats.lastFullScan ~= nil and
         time() - MiniAHSavedVars.scanStats.lastFullScan > 60 * 15 and
         not self.inProgress
        ) or MiniAHSavedVars.scanStats.lastFullScan == nil
end

-- Obtenir le message pour le prochain scan
function MiniAH:NextScanMessage()
    local timeSinceLastScan = time() - MiniAHSavedVars.scanStats.lastFullScan
    local minutesUntilNextScan = 15 - math.ceil(timeSinceLastScan / 60)
    local secondsUntilNextScan = (15 * 60 - timeSinceLastScan) % 60
    
    return string.format("Prochain scan possible dans %d minute(s) et %d seconde(s)", minutesUntilNextScan, secondsUntilNextScan)
end

-- Démarrer un timer en temps réel pour le prochain scan possible (utilisant C_Timer.After)
function MiniAH:StartRealTimeTimer()
    -- Calculer le temps restant
    local timeSinceLastScan = time() - MiniAHSavedVars.scanStats.lastFullScan
    local timeUntilNextScan = 15 * 60 - timeSinceLastScan
    
    -- Calculer le pourcentage de progression
    local percent = math.min(100, (timeSinceLastScan / (15 * 60)) * 100)
    
    -- Formater le temps restant
    local minutesUntilNextScan = math.floor(timeUntilNextScan / 60)
    local secondsUntilNextScan = math.floor(timeUntilNextScan % 60)
    local message = string.format(self:GetText("NEXT_SCAN_TIMER"), minutesUntilNextScan, secondsUntilNextScan)
    
    -- Mettre à jour la barre de progression (rouge pour scan impossible)
    self:UpdateProgressBar(percent, message, true)
    
    -- Si le scan est maintenant possible, arrêter le timer
    if timeUntilNextScan <= 0 then
        self:UpdateProgressBar(0, "Prêt à scanner", false) -- Vert pour scan possible
        return
    end
    
    -- Continuer le timer après 1 seconde
    C_Timer.After(1, function()
        self:StartRealTimeTimer()
    end)
end

-- Enregistrer les événements pour le scan
function MiniAH:RegisterForEvents()
    FrameUtil.RegisterFrameForEvents(self.scanFrame, SCAN_EVENTS)
end

-- Désinscrire les événements
function MiniAH:UnregisterForEvents()
    FrameUtil.UnregisterFrameForEvents(self.scanFrame, SCAN_EVENTS)
end

-- Réinitialiser les données
function MiniAH:ResetData()
    scanData = {}
    waitingForData = 0
end

-- Démarrer un scan de l'hôtel des ventes
function MiniAH:StartScan(force)
    -- Vérifier si le scan peut être initié ou si force est activé
    if not force and not self:CanInitiateScan() then
        print("|cFFFF9900" .. ADDON_NAME .. ":|r " .. self:NextScanMessage())
        return
    end
    
    -- Vérifier si l'hôtel des ventes est ouvert
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then
        print("|cFFFF0000" .. ADDON_NAME .. ":|r L'hôtel des ventes doit être ouvert pour lancer un scan.")
        return
    end
    
    -- Enregistrer le temps du dernier scan immédiatement
    MiniAHSavedVars.scanStats.lastFullScan = time()
    
    -- Marquer le scan comme en cours
    self.inProgress = true
    
    -- Réinitialiser les données
    self:ResetData()
    
    -- Enregistrer les événements
    self:RegisterForEvents()
    
    -- Afficher un message de début de scan
    print("|cFF00FF00" .. ADDON_NAME .. ":|r Démarrage du scan en cours...")
    self:UpdateProgressBar(10, "Demande des données de l'hôtel des ventes...")
    
    -- Appeler ReplicateItems directement
    C_AuctionHouse.ReplicateItems()
end

-- Mise en cache des données du scan
function MiniAH:CacheScanData()
    -- Mettre à jour la barre de progression
    self:UpdateProgressBar(20, "Réponse de l'API reçue...")
    
    -- Réinitialiser les données
    self:ResetData()
    
    -- Récupérer le nombre d'objets à traiter
    waitingForData = C_AuctionHouse.GetNumReplicateItems()
    
    if waitingForData <= 0 then
        print("|cFFFF9900" .. ADDON_NAME .. ":|r Aucun résultat reçu de l'hôtel des ventes.")
        self:CompleteScan(true, "Aucun résultat")
        return
    end
    
    print("|cFF00FF00" .. ADDON_NAME .. ":|r " .. waitingForData .. " objets reçus de l'hôtel des ventes.")
    
    -- Mettre à jour la barre de progression
    self:UpdateProgressBar(25, "Traitement de " .. waitingForData .. " objets...")
    
    -- Traiter les données par lots pour éviter les problèmes de performance
    self:ProcessBatch(0, 250, waitingForData)
end

-- Traiter un lot de données (optimisé pour réduire les allocations mémoire)
function MiniAH:ProcessBatch(startIndex, stepSize, limit)
    -- Calculer la progression
    local progress = 25 + (startIndex / limit) * 75
    self:UpdateProgressBar(progress, "Traitement des objets " .. startIndex .. "/" .. limit)
    
    -- Si tous les objets ont été traités, terminer le scan
    if startIndex >= limit then
        self:EndProcessing()
        return
    end
    
    -- Variables locales pour éviter les réallocations
    local i = startIndex
    local endIndex = math.min(startIndex + stepSize, limit)
    local currentTime = time()
    local itemID, count, buyoutPrice, minPrice, link
    local info = {}
    
    -- Vider la table scanData si c'est le premier lot
    if startIndex == 0 then
        wipe(scanData)
    end
    
    -- Traiter un lot d'objets
    while i < endIndex do
        -- Récupérer les informations de l'objet (réutiliser la table locale)
        wipe(info) -- Vider la table avant de la réutiliser
        info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9], info[10], 
        info[11], info[12], info[13], info[14], info[15], info[16], info[17] = C_AuctionHouse.GetReplicateItemInfo(i)
        
        link = C_AuctionHouse.GetReplicateItemLink(i)
        
        -- Vérifier si l'objet existe
        if info[17] and link then -- info[17] contient l'itemID
            itemID = info[17]
            count = info[3] or 1
            buyoutPrice = info[10] or 0
            
            -- Calculer le prix unitaire
            minPrice = count > 0 and buyoutPrice / count or 0
            
            if minPrice > 0 then
                -- Stocker les données (réutiliser la table existante si possible)
                if not MiniAHSavedVars.itemPrices[itemID] then
                    MiniAHSavedVars.itemPrices[itemID] = {}
                end
                
                local itemData = MiniAHSavedVars.itemPrices[itemID]
                itemData.itemLink = link
                itemData.minPrice = minPrice
                itemData.lastScan = currentTime
                itemData.count = count
                
                -- Ajouter aux données du scan (sans créer de nouvelle table)
                scanData[#scanData + 1] = itemID
            end
        end
        
        i = i + 1
        
        -- Libérer les références pour aider le GC
        link = nil
        itemID = nil
    end
    
    -- Forcer une collecte des déchets après chaque lot pour libérer la mémoire
    collectgarbage("step", 100)
    
    -- Passer au lot suivant après un court délai
    C_Timer.After(0.01, function()
        self:ProcessBatch(endIndex, stepSize, limit)
    end)
end

-- Finaliser le traitement des données (optimisé pour réduire la consommation mémoire)
function MiniAH:EndProcessing()
    -- Variables locales pour éviter les réallocations
    local currentTime = time()
    local itemCount = #scanData
    
    -- Mettre à jour les statistiques
    local stats = MiniAHSavedVars.scanStats
    stats.scanCount = stats.scanCount + 1
    stats.itemsScanned = waitingForData
    stats.lastScanDuration = currentTime - stats.lastFullScan
    
    -- Terminer le scan (utiliser une seule concaténation de chaîne pour économiser de la mémoire)
    print("|cFF00FF00" .. ADDON_NAME .. ":|r Scan terminé! " .. waitingForData .. " objets traités, " .. itemCount .. " objets avec prix.")
    
    -- Jouer un son pour indiquer que le scan est terminé
    if MiniAHSavedVars.playScanCompleteSound ~= false then -- Activé par défaut
        -- Utiliser le fichier audio personnalisé dans le dossier Media
        PlaySoundFile("Interface\\AddOns\\MiniAHScanner\\Media\\AuctionWindowOpen.ogg", "Master")
    end
    
    -- Mettre à jour la barre de progression
    self:UpdateProgressBar(100, "Scan terminé - " .. itemCount .. " objets")
    
    -- Démarrer le timer en temps réel pour le prochain scan possible
    C_Timer.After(2, function()
        if not self:CanInitiateScan() then
            self:StartRealTimeTimer()
        end
    end)
    
    -- Nettoyer les ressources
    self.inProgress = false
    wipe(scanData) -- Vider la table pour libérer de la mémoire
    scanData = {}
    waitingForData = 0
    
    -- Désinscrire les événements
    self:UnregisterForEvents()
    
    -- Vider le cache des prix pour libérer la mémoire
    self:ClearPriceCache()
    
    -- Forcer une collecte des déchets complète pour libérer la mémoire
    C_Timer.After(0.5, function()
        collectgarbage("collect")
    end)
    
    -- Planifier une deuxième collecte des déchets après un délai plus long
    C_Timer.After(2, function()
        collectgarbage("collect")
    end)
end

-- Terminer le scan (avec erreur ou non)
function MiniAH:CompleteScan(isError, message)
    -- Vérifier si le scan est déjà terminé
    if not self.inProgress then
        return
    end
    
    -- Désinscrire les événements
    self:UnregisterForEvents()
    
    if isError then
        -- Afficher l'erreur
        print("|cFFFF0000" .. ADDON_NAME .. ":|r Scan interrompu: " .. (message or "Erreur inconnue"))
        self:UpdateProgressBar(0, "Scan interrompu: " .. (message or "Erreur inconnue"))
        
        -- Réinitialiser le temps du dernier scan pour permettre un nouveau scan immédiatement
        if message == "Aucune réponse de l'API" then
            MiniAHSavedVars.scanStats.lastFullScan = 0
            print("|cFF00FF00" .. ADDON_NAME .. ":|r Vous pouvez relancer un scan immédiatement.")
        end
    else
        -- Scan terminé avec succès
        self:UpdateProgressBar(100, message or "Scan terminé")
    end
    
    -- Marquer le scan comme terminé
    self.inProgress = false
    
    -- Réinitialiser les données et libérer la mémoire
    wipe(scanData)
    scanData = {}
    waitingForData = 0
    
    -- Vider le cache des prix pour libérer la mémoire
    self:ClearPriceCache()
    
    -- Forcer une collecte des déchets pour libérer la mémoire
    C_Timer.After(0.5, function()
        collectgarbage("collect")
    end)
end

-- Gestionnaire d'événements
function MiniAH:OnEvent(event, addonName, ...)
    if event == "REPLICATE_ITEM_LIST_UPDATE" then
        -- Vérifier si le scan est en cours
        if not self.inProgress then
            return
        end
        
        print("|cFF00FF00" .. ADDON_NAME .. ":|r " .. self:GetText("PROCESSING_DATA"))
        
        -- Désinscrire pour éviter les appels multiples
        FrameUtil.UnregisterFrameForEvents(self.scanFrame, { "REPLICATE_ITEM_LIST_UPDATE" })
        
        -- Traiter les données
        self:CacheScanData()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        if self.inProgress then
            self:CompleteScan(true, "L'hôtel des ventes a été fermé")
        end
    elseif event == "ADDON_LOADED" and addonName == ADDON_NAME then
        -- Désinscrire l'événement ADDON_LOADED pour éviter les appels multiples
        self.scanFrame:UnregisterEvent("ADDON_LOADED")
        
        -- Vérifier si l'hôtel des ventes est déjà ouvert (pour le cas d'un /reload)
        if AuctionHouseFrame and AuctionHouseFrame:IsVisible() then
            -- Si un scan a été effectué précédemment et que le temps d'attente n'est pas écoulé
            if MiniAHSavedVars.scanStats.lastFullScan > 0 and not self:CanInitiateScan() then
                C_Timer.After(0.5, function()
                    self:StartRealTimeTimer()
                end)
            end
        end
    end
end
