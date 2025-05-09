-- MiniAH_Localization_esES.lua
-- Localización española para MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Solo continuar si el idioma del jugador es español
local locale = GetLocale()
if locale ~= "esES" and locale ~= "esMX" then return end

-- Tabla de localización
local L = MiniAH.L

-- Traducciones españolas
L = {
    -- General
    ["ADDON_LOADED"] = "%s v%s cargado. Escribe %s para opciones.",
    ["COMMAND_HELP"] = "Escribe %s para ayuda.",
    
    -- Mensajes
    ["SCAN_IN_PROGRESS"] = "Un escaneo ya está en progreso.",
    ["AH_CLOSED"] = "La Casa de Subastas debe estar abierta para iniciar un escaneo.",
    ["SCAN_STARTED"] = "Iniciando escaneo automático...",
    ["SCAN_MANUAL_STARTED"] = "Iniciando escaneo en progreso...",
    ["SCAN_PAGE"] = "Escaneando página %d...",
    ["SCAN_COMPLETE"] = "¡Escaneo completo! %d objetos escaneados en %s.",
    ["SCAN_INTERRUPTED"] = "Escaneo interrumpido: %s",
    ["SCAN_WAIT"] = "Escaneo automático desactivado. Próximo escaneo posible en %d minuto(s).",
    ["NEXT_SCAN_TIMER"] = "Próximo escaneo posible en %d min %d seg",
    ["PROCESSING_DATA"] = "Procesando datos...",
    
    -- Interfaz
    ["OPTIONS"] = "Opciones",
    ["GENERAL"] = "General",
    ["SCAN"] = "Escaneo",
    ["DISPLAY"] = "Visualización",
    ["ADVANCED"] = "Avanzado",
    ["CLOSE"] = "Cerrar",
    
    -- Sección General
    ["INFORMATION"] = "Información",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner es un addon ligero para escanear la Casa de Subastas y mostrar precios en tooltips. Está diseñado para ser simple y eficiente, respetando un límite de 15 minutos para evitar la desconexión del servidor.",
    ["STATISTICS"] = "Estadísticas",
    ["ITEMS_RECORDED"] = "Objetos registrados: ",
    ["SCAN_COUNT"] = "Número de escaneos: ",
    ["LAST_SCAN"] = "Último escaneo: ",
    ["LAST_SCAN_DURATION"] = "Duración del último escaneo: ",
    ["NEVER"] = "Nunca",
    ["START_SCAN"] = "Iniciar escaneo",
    ["CLEAN_DATABASE"] = "Limpiar base de datos",
    
    -- Sección de Escaneo
    ["SCAN_OPTIONS"] = "Opciones de escaneo",
    ["AUTO_SCAN"] = "Escaneo automático",
    ["AUTO_SCAN_TOOLTIP"] = "Escanea automáticamente la Casa de Subastas cuando se abre",
    ["SCAN_INTERVAL"] = "Intervalo de escaneo (minutos)",
    ["SCAN_INTERVAL_TOOLTIP"] = "Intervalo entre escaneos automáticos (15-60 minutos).",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "Sonido de escaneo completo",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Reproduce un sonido cuando el escaneo de la Casa de Subastas está completo.",
    ["ARCHIVE_OPTIONS"] = "Opciones de archivo",
    ["KEEP_HISTORY"] = "Mantener historial de precios",
    ["KEEP_HISTORY_TOOLTIP"] = "Mantiene el historial de precios para cada objeto",
    ["HISTORY_DAYS"] = "Días de historial a mantener",
    ["HISTORY_DAYS_TOOLTIP"] = "Número de días de historial a mantener",
    ["CLEAN_OLD_DATA"] = "Eliminar datos antiguos (días)",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "Número de días después de los cuales los datos se consideran obsoletos",
    
    -- Sección de Visualización
    ["TOOLTIP_OPTIONS"] = "Tooltips",
    ["SHOW_AUCTION_PRICE"] = "Mostrar precios de subasta en tooltips",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Muestra los precios de subasta en los tooltips de objetos",
    ["SHOW_VENDOR_PRICE"] = "Mostrar precios de vendedor en tooltips",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Muestra los precios de vendedor en los tooltips de objetos",
    ["SHOW_AGE"] = "Mostrar antigüedad de datos en tooltips",
    ["SHOW_AGE_TOOLTIP"] = "Muestra cuánto tiempo hace que se escanearon los precios",
    ["COLOR_PRICES"] = "Usar colores para los precios",
    ["COLOR_PRICES_TOOLTIP"] = "Muestra los precios con colores (oro, plata, cobre)",
    ["USE_COIN_ICONS"] = "Usar iconos de monedas",
    ["USE_COIN_ICONS_TOOLTIP"] = "Muestra iconos de monedas de oro, plata y cobre en lugar de las letras o/p/c en las descripciones emergentes",
    ["UI_OPTIONS"] = "Interfaz",
    ["SHOW_MINIMAP"] = "Mostrar botón en minimapa",
    ["SHOW_MINIMAP_TOOLTIP"] = "Muestra un botón en el minimapa para acceso rápido al addon",
    
    -- Sección Avanzada
    ["ADVANCED_OPTIONS"] = "Opciones avanzadas",
    ["RESET_OPTIONS"] = "Restablecer opciones",
    ["RESET_DATABASE"] = "Restablecer base de datos",
    ["YES"] = "Sí",
    ["NO"] = "No",
    ["RESET_CONFIRM"] = "¿Estás seguro de que quieres restablecer todas las opciones para %s?",
    ["RESET_DB_CONFIRM"] = "¿Estás seguro de que quieres restablecer la base de datos para %s?\nTodos los datos de precios se perderán.",
    
    -- Tooltips
    ["VENDOR"] = "Vendedor",
    ["AH"] = "CS",
    ["AH_STACK"] = "CS Pila",
    ["UNKNOWN"] = "Desconocido",
    ["SHIFT_STACK"] = "[Shift] para precio por pila",
    
    -- Unidades de tiempo
    ["DAYS"] = "d",
    ["HOURS"] = "h",
    ["MINUTES"] = "min",
    ["SECONDS"] = "s",
}
