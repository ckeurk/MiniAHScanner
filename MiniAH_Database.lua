-- MiniAH_Database.lua
-- Fonctions de gestion de la base de données pour MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Cache des prix pour éviter les accès répétés à la base de données
local priceCache = {}
local vendorCache = {}
local CACHE_SIZE = 50 -- Réduire la taille du cache pour limiter l'utilisation mémoire
local cacheEntries = 0
local lastCacheClear = 0

-- Fonction pour vider le cache des prix quand il devient trop grand ou trop ancien
local function CheckCacheSize(force)
    local currentTime = time()
    
    -- Vider le cache s'il est trop grand ou si 5 minutes se sont écoulées depuis le dernier vidage
    if force or cacheEntries > CACHE_SIZE or (currentTime - lastCacheClear) > 300 then
        wipe(priceCache)
        wipe(vendorCache)
        cacheEntries = 0
        lastCacheClear = currentTime
        
        -- Forcer une collecte des déchets pour libérer la mémoire
        collectgarbage("step", 100)
        return true
    end
    return false
end

-- Fonction pour vider complètement le cache (appelée après un scan)
local function ClearCache()
    wipe(priceCache)
    wipe(vendorCache)
    cacheEntries = 0
    lastCacheClear = time()
    collectgarbage("collect")
end

-- Initialisation du module de base de données
function MiniAH:InitDatabaseModule()
    -- Initialiser les variables sauvegardées si nécessaire
    if not MiniAHSavedVars then
        MiniAHSavedVars = {
            itemPrices = {},
            scanStats = {
                lastFullScan = 0,
                scanCount = 0,
                itemsScanned = 0,
                lastScanDuration = 0
            },
            -- Options générales
            autoScan = true,
            showAuctionPrice = true,
            showVendorPrice = true,
            keepHistory = true,
            showAuctionAge = true,
            colorCodePrices = true,
            useCoinIcons = false, -- Nouvelle option pour les icônes de pièces
            
            -- Options de scan
            scanInterval = 15, -- Intervalle minimum entre les scans en minutes
            historyDays = 7,   -- Nombre de jours d'historique à conserver
            cleanDays = 30,    -- Supprimer les données plus anciennes que ce nombre de jours
            lastScanTime = 0,  -- Timestamp du dernier scan
            
            -- Options de la minimap
            minimapButton = {
                hide = false,
                position = 45,
            }
        }
    end
    
    -- Assurer la compatibilité avec les versions précédentes
    if MiniAHSavedVars.itemPrices == nil then
        MiniAHSavedVars.itemPrices = {}
    end
    
    -- Initialiser les statistiques si nécessaire
    if MiniAHSavedVars.scanStats == nil then
        MiniAHSavedVars.scanStats = {
            lastFullScan = 0,
            scanCount = 0,
            itemsScanned = 0,
            lastScanDuration = 0
        }
    end
    
    -- Activer l'historique par défaut si l'option n'existe pas
    if MiniAHSavedVars.keepHistory == nil then
        MiniAHSavedVars.keepHistory = true
    end
    
    -- Nettoyer la base de données au démarrage si nécessaire
    self:PerformDatabaseMaintenance()
end

-- Obtenir le prix d'un objet depuis la base de données (optimisé avec cache)
function MiniAH:GetItemPrice(itemID)
    if not itemID or not MiniAHSavedVars.itemPrices[itemID] then
        return nil
    end
    
    -- Vérifier le cache d'abord
    if priceCache[itemID] then
        return priceCache[itemID]
    end
    
    -- Récupérer le prix depuis la base de données
    local itemData = MiniAHSavedVars.itemPrices[itemID]
    local price = itemData and itemData.minPrice or nil
    
    -- Mettre en cache le résultat seulement si le cache n'est pas plein
    if price and cacheEntries < CACHE_SIZE then
        priceCache[itemID] = price
        cacheEntries = cacheEntries + 1
        CheckCacheSize(false)
    end
    
    return price
end

-- Obtenir toutes les informations d'un objet depuis la base de données
function MiniAH:GetItemData(itemID)
    if not itemID or not MiniAHSavedVars.itemPrices[itemID] then
        return nil
    end
    
    return MiniAHSavedVars.itemPrices[itemID]
end

-- Obtenir le prix vendeur d'un objet (optimisé avec cache)
function MiniAH:GetVendorPrice(itemID)
    if not itemID then return nil end
    
    -- Vérifier le cache d'abord
    if vendorCache[itemID] then
        return vendorCache[itemID]
    end
    
    -- Récupérer le prix vendeur
    local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemID)
    local price = sellPrice or 0
    
    -- Mettre en cache le résultat seulement si le cache n'est pas plein
    if cacheEntries < CACHE_SIZE then
        vendorCache[itemID] = price
        cacheEntries = cacheEntries + 1
        CheckCacheSize(false)
    end
    
    return price
end

-- Fonction publique pour vider le cache (appelée après un scan)
function MiniAH:ClearPriceCache()
    ClearCache()
end

-- Obtenir l'historique des prix d'un objet
function MiniAH:GetPriceHistory(itemID)
    if not itemID or not MiniAHSavedVars.itemPrices[itemID] or not MiniAHSavedVars.itemPrices[itemID].history then
        return {}
    end
    
    local history = MiniAHSavedVars.itemPrices[itemID].history
    local results = {}
    
    -- Convertir les dates en nombres pour le tri
    local dates = {}
    for dateStr in pairs(history) do
        table.insert(dates, tonumber(dateStr))
    end
    
    -- Trier les dates (plus récentes en premier)
    table.sort(dates, function(a, b) return a > b end)
    
    -- Formater les résultats
    for _, dateNum in ipairs(dates) do
        local year = math.floor(dateNum / 10000)
        local month = math.floor((dateNum % 10000) / 100)
        local day = dateNum % 100
        
        table.insert(results, {
            date = string.format("%02d/%02d/%04d", day, month, year),
            price = history[tostring(dateNum)]
        })
    end
    
    return results
end

-- Calculer le prix moyen d'un objet sur une période donnée
function MiniAH:GetMeanPrice(itemID, days)
    if not itemID or not MiniAHSavedVars.itemPrices[itemID] or not MiniAHSavedVars.itemPrices[itemID].history then
        return nil
    end
    
    local history = MiniAHSavedVars.itemPrices[itemID].history
    local today = tonumber(date("%Y%m%d"))
    local total = 0
    local count = 0
    
    -- Calculer la date limite
    local limitDate = today
    if days > 0 then
        -- Soustraire le nombre de jours (approximatif mais suffisant pour notre usage)
        local year = math.floor(today / 10000)
        local month = math.floor((today % 10000) / 100)
        local day = today % 100
        
        day = day - days
        while day <= 0 do
            month = month - 1
            if month <= 0 then
                year = year - 1
                month = 12
            end
            day = day + 30 -- Approximation, mais suffisant pour notre usage
        end
        
        limitDate = year * 10000 + month * 100 + day
    end
    
    -- Calculer la moyenne
    for dateStr, price in pairs(history) do
        local dateNum = tonumber(dateStr)
        if dateNum >= limitDate then
            total = total + price
            count = count + 1
        end
    end
    
    if count > 0 then
        return math.floor(total / count)
    else
        return nil
    end
end

-- Obtenir l'âge des données d'un objet en jours
function MiniAH:GetDataAge(itemID)
    if not itemID or not MiniAHSavedVars.itemPrices[itemID] then
        return nil
    end
    
    local lastScan = MiniAHSavedVars.itemPrices[itemID].lastScan
    if not lastScan then
        return nil
    end
    
    local now = time()
    return math.floor((now - lastScan) / 86400) -- Convertir en jours
end

-- Nettoyer la base de données (optimisé pour réduire les allocations mémoire)
function MiniAH:CleanDatabase()
    local now = time()
    local cleanTime = now - (MiniAHSavedVars.cleanDays * 24 * 60 * 60)
    local count = 0
    local itemsToRemove = {}
    
    -- Identifier les objets à supprimer (en deux passes pour éviter de modifier la table pendant l'itération)
    for itemID, data in pairs(MiniAHSavedVars.itemPrices) do
        if data.lastScan and data.lastScan < cleanTime then
            itemsToRemove[#itemsToRemove + 1] = itemID
        end
    end
    
    -- Supprimer les objets identifiés
    for i = 1, #itemsToRemove do
        local itemID = itemsToRemove[i]
        MiniAHSavedVars.itemPrices[itemID] = nil
        priceCache[itemID] = nil -- Nettoyer aussi le cache
        count = count + 1
    end
    
    -- Vider les caches après un nettoyage
    wipe(priceCache)
    wipe(vendorCache)
    cacheEntries = 0
    
    print("|cFF00FF00" .. ADDON_NAME .. ":|r Base de données nettoyée! " .. count .. " objets supprimés.")
    
    return count
end

-- Maintenance de la base de données
function MiniAH:PerformDatabaseMaintenance()
    
    -- Vérifier la taille de la base de données
    local itemCount = 0
    for _ in pairs(MiniAHSavedVars.itemPrices) do
        itemCount = itemCount + 1
    end
    
    
    return count
end

-- Exporter les données de prix au format CSV
function MiniAH:ExportPriceData()
    local csv = "ItemID,Name,MinPrice,LastScan,Quantity\n"
    local count = 0
    
    for itemID, itemData in pairs(MiniAHSavedVars.itemPrices) do
        local itemName = GetItemInfo(itemID) or "Unknown"
        local lastScanDate = date("%Y-%m-%d %H:%M:%S", itemData.lastScan or 0)
        
        csv = csv .. itemID .. "," 
                  .. (itemName:gsub(",", ";")) .. "," 
                  .. (itemData.minPrice or 0) .. "," 
                  .. lastScanDate .. "," 
                  .. (itemData.quantity or 0) .. "\n"
        
        count = count + 1
    end
    
    -- Créer une fenêtre pour afficher les données exportées
    local f = AceGUI and AceGUI:Create("Frame") or CreateFrame("Frame", "MiniAHExportFrame", UIParent, "BasicFrameTemplateWithInset")
    
    if AceGUI then
        f:SetTitle(ADDON_NAME .. " - Export de données (" .. count .. " objets)")
        f:SetLayout("Fill")
        f:SetWidth(600)
        f:SetHeight(400)
        
        local editbox = AceGUI:Create("MultiLineEditBox")
        editbox:SetLabel("Données CSV (Ctrl+C pour copier)")
        editbox:SetFullWidth(true)
        editbox:SetFullHeight(true)
        editbox:SetText(csv)
        f:AddChild(editbox)
    else
        f:SetSize(600, 400)
        f:SetPoint("CENTER")
        f.title = f:CreateFontString(nil, "OVERLAY")
        f.title:SetFontObject("GameFontHighlight")
        f.title:SetPoint("TOP", 0, -5)
        f.title:SetText(ADDON_NAME .. " - Export de données (" .. count .. " objets)")
        
        local scrollFrame = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 10, -30)
        scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)
        
        local editBox = CreateFrame("EditBox", nil, scrollFrame)
        editBox:SetMultiLine(true)
        editBox:SetFontObject("ChatFontNormal")
        editBox:SetWidth(scrollFrame:GetWidth())
        editBox:SetText(csv)
        
        scrollFrame:SetScrollChild(editBox)
    end
    
    return count
end

-- Importer des données de prix au format CSV
function MiniAH:ImportPriceData(csvData)
    if not csvData or csvData == "" then
        print("|cFFFF0000" .. ADDON_NAME .. ":|r Aucune donnée à importer.")
        return 0
    end
    
    local count = 0
    local lines = {strsplit("\n", csvData)}
    
    -- Ignorer la première ligne (en-têtes)
    for i = 2, #lines do
        local line = lines[i]
        if line and line ~= "" then
            local itemID, _, minPrice, lastScanStr, quantity = strsplit(",", line)
            
            itemID = tonumber(itemID)
            minPrice = tonumber(minPrice)
            quantity = tonumber(quantity)
            
            -- Convertir la date en timestamp
            local year, month, day, hour, min, sec = string.match(lastScanStr, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
            local lastScan = time({
                year = tonumber(year),
                month = tonumber(month),
                day = tonumber(day),
                hour = tonumber(hour),
                min = tonumber(min),
                sec = tonumber(sec)
            })
            
            if itemID and minPrice and lastScan then
                if not MiniAHSavedVars.itemPrices[itemID] then
                    MiniAHSavedVars.itemPrices[itemID] = {}
                end
                
                local itemData = MiniAHSavedVars.itemPrices[itemID]
                
                -- Ne mettre à jour que si les données importées sont plus récentes
                if not itemData.lastScan or lastScan > itemData.lastScan then
                    itemData.minPrice = minPrice
                    itemData.lastScan = lastScan
                    itemData.quantity = quantity
                    
                    -- Ajouter à l'historique si activé
                    if MiniAHSavedVars.keepHistory then
                        itemData.history = itemData.history or {}
                        local dateKey = tonumber(date("%Y%m%d", lastScan))
                        itemData.history[tostring(dateKey)] = minPrice
                    end
                    
                    count = count + 1
                end
            end
        end
    end
    
    print("|cFF00FF00" .. ADDON_NAME .. ":|r Importation terminée : " .. count .. " objets importés.")
    return count
end

-- Obtenir des statistiques sur la base de données
function MiniAH:GetDatabaseStats()
    local itemCount = 0
    local oldestScan = time()
    local newestScan = 0
    local totalValue = 0
    
    for itemID, itemData in pairs(MiniAHSavedVars.itemPrices) do
        itemCount = itemCount + 1
        
        if itemData.lastScan then
            if itemData.lastScan < oldestScan then
                oldestScan = itemData.lastScan
            end
            
            if itemData.lastScan > newestScan then
                newestScan = itemData.lastScan
            end
        end
        
        if itemData.minPrice then
            totalValue = totalValue + itemData.minPrice
        end
    end
    
    -- Calculer l'âge moyen des données
    local averageAge = 0
    if itemCount > 0 and (newestScan - oldestScan) > 0 then
        averageAge = math.floor((time() - oldestScan) / 86400)
    end
    
    return {
        itemCount = itemCount,
        oldestScan = oldestScan,
        newestScan = newestScan,
        averageAge = averageAge,
        totalValue = totalValue,
        scanCount = MiniAHSavedVars.scanStats.scanCount or 0,
        lastScanTime = MiniAHSavedVars.scanStats.lastFullScan or 0,
        lastScanDuration = MiniAHSavedVars.scanStats.lastScanDuration or 0
    }
end
