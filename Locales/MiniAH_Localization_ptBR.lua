-- MiniAH_Localization_ptBR.lua
-- Localização portuguesa para MiniAHScanner

local ADDON_NAME, MiniAH = ...

-- Continuar apenas se o idioma do jogador for português
local locale = GetLocale()
if locale ~= "ptBR" then return end

-- Tabela de localização
local L = MiniAH.L

-- Traduções portuguesas
L = {
    -- Geral
    ["ADDON_LOADED"] = "%s v%s carregado. Digite %s para opções.",
    ["COMMAND_HELP"] = "Digite %s para ajuda.",
    
    -- Mensagens
    ["SCAN_IN_PROGRESS"] = "Uma varredura já está em andamento.",
    ["AH_CLOSED"] = "A Casa de Leilões deve estar aberta para iniciar uma varredura.",
    ["SCAN_STARTED"] = "Iniciando varredura automática...",
    ["SCAN_MANUAL_STARTED"] = "Iniciando varredura em andamento...",
    ["SCAN_PAGE"] = "Varrendo página %d...",
    ["SCAN_COMPLETE"] = "Varredura completa! %d itens varridos em %s.",
    ["SCAN_INTERRUPTED"] = "Varredura interrompida: %s",
    ["SCAN_WAIT"] = "Varredura automática desativada. Próxima varredura possível em %d minuto(s).",
    ["NEXT_SCAN_TIMER"] = "Próxima varredura possível em %d min %d seg",
    ["PROCESSING_DATA"] = "Processando dados...",
    
    -- Interface
    ["OPTIONS"] = "Opções",
    ["GENERAL"] = "Geral",
    ["SCAN"] = "Varredura",
    ["DISPLAY"] = "Exibição",
    ["ADVANCED"] = "Avançado",
    ["CLOSE"] = "Fechar",
    
    -- Seção Geral
    ["INFORMATION"] = "Informações",
    ["ADDON_DESCRIPTION"] = "MiniAHScanner é um addon leve para varrer a Casa de Leilões e exibir preços nas dicas de ferramentas. É projetado para ser simples e eficiente, respeitando um limite de 15 minutos para evitar desconexão do servidor.",
    ["STATISTICS"] = "Estatísticas",
    ["ITEMS_RECORDED"] = "Itens registrados: ",
    ["SCAN_COUNT"] = "Número de varreduras: ",
    ["LAST_SCAN"] = "Última varredura: ",
    ["LAST_SCAN_DURATION"] = "Duração da última varredura: ",
    ["NEVER"] = "Nunca",
    ["START_SCAN"] = "Iniciar varredura",
    ["CLEAN_DATABASE"] = "Limpar banco de dados",
    
    -- Seção de Varredura
    ["SCAN_OPTIONS"] = "Opções de varredura",
    ["AUTO_SCAN"] = "Varredura automática",
    ["AUTO_SCAN_TOOLTIP"] = "Varre automaticamente a Casa de Leilões quando é aberta",
    ["SCAN_INTERVAL"] = "Intervalo de varredura (minutos)",
    ["SCAN_INTERVAL_TOOLTIP"] = "Intervalo entre varreduras automáticas (15-60 minutos).",
    ["PLAY_SCAN_COMPLETE_SOUND"] = "Som de varredura completa",
    ["PLAY_SCAN_COMPLETE_SOUND_TOOLTIP"] = "Reproduz um som quando a varredura da Casa de Leilões é concluída.",
    ["ARCHIVE_OPTIONS"] = "Opções de arquivo",
    ["KEEP_HISTORY"] = "Manter histórico de preços",
    ["KEEP_HISTORY_TOOLTIP"] = "Mantém o histórico de preços para cada item",
    ["HISTORY_DAYS"] = "Dias de histórico para manter",
    ["HISTORY_DAYS_TOOLTIP"] = "Número de dias de histórico para manter",
    ["CLEAN_OLD_DATA"] = "Remover dados antigos (dias)",
    ["CLEAN_OLD_DATA_TOOLTIP"] = "Número de dias após os quais os dados são considerados desatualizados",
    
    -- Seção de Exibição
    ["TOOLTIP_OPTIONS"] = "Dicas de ferramentas",
    ["SHOW_AUCTION_PRICE"] = "Mostrar preços de leilão nas dicas",
    ["SHOW_AUCTION_PRICE_TOOLTIP"] = "Exibe preços de leilão nas dicas de ferramentas dos itens",
    ["SHOW_VENDOR_PRICE"] = "Mostrar preços de vendedor nas dicas",
    ["SHOW_VENDOR_PRICE_TOOLTIP"] = "Exibe preços de vendedor nas dicas de ferramentas dos itens",
    ["SHOW_AGE"] = "Mostrar idade dos dados nas dicas",
    ["SHOW_AGE_TOOLTIP"] = "Mostra há quanto tempo os preços foram varridos",
    ["COLOR_PRICES"] = "Usar cores para preços",
    ["COLOR_PRICES_TOOLTIP"] = "Mostra os preços com cores (ouro, prata, cobre)",
    ["USE_COIN_ICONS"] = "Usar ícones de moedas",
    ["USE_COIN_ICONS_TOOLTIP"] = "Mostra ícones de moedas de ouro, prata e cobre em vez das letras o/p/c nas dicas de ferramentas",
    ["UI_OPTIONS"] = "Interface",
    ["SHOW_MINIMAP"] = "Mostrar botão no minimapa",
    ["SHOW_MINIMAP_TOOLTIP"] = "Exibe um botão no minimapa para acesso rápido ao addon",
    
    -- Seção Avançada
    ["ADVANCED_OPTIONS"] = "Opções avançadas",
    ["RESET_OPTIONS"] = "Redefinir opções",
    ["RESET_DATABASE"] = "Redefinir banco de dados",
    ["YES"] = "Sim",
    ["NO"] = "Não",
    ["RESET_CONFIRM"] = "Tem certeza de que deseja redefinir todas as opções para %s?",
    ["RESET_DB_CONFIRM"] = "Tem certeza de que deseja redefinir o banco de dados para %s?\nTodos os dados de preços serão perdidos.",
    
    -- Dicas
    ["VENDOR"] = "Vendedor",
    ["AH"] = "CL",
    ["AH_STACK"] = "CL Pilha",
    ["UNKNOWN"] = "Desconhecido",
    ["SHIFT_STACK"] = "[Shift] para preço da pilha",
    
    -- Unidades de tempo
    ["DAYS"] = "d",
    ["HOURS"] = "h",
    ["MINUTES"] = "min",
    ["SECONDS"] = "s",
}
