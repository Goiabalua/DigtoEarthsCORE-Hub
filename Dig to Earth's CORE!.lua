local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- LocalScript para um menu GUI com Fluent Library
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Configuração da Fluent Window
local Window = Fluent:CreateWindow({
    Title = "Dig to Earth's CORE! Menu " .. Fluent.Version,
    SubTitle = "by Goiaba.lua",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.F -- Used when theres no MinimizeKeybind
})

-- Criação das abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Função para criar toggles (adaptada para Fluent)
local function createToggle(tab, name, defaultColor, callback)
    local toggle = tab:AddToggle(name, {
        Title = name,
        Default = false,
        Callback = function(state)
            callback(state)
        end
    })
    return toggle
end

-- Toggles
local dominusLoopRunning = false
createToggle(Tabs.Main, "Dominus Pet", Color3.new(1, 0, 0), function(state)
    dominusLoopRunning = state
    if state then
        spawn(function()
            while dominusLoopRunning do
                local success, err = pcall(function()
                    local args = {4}
                    local spinPrizeEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("SpinPrizeEvent", 5)
                    if spinPrizeEvent then
                        spinPrizeEvent:FireServer(unpack(args))
                    end
                end)
                if not success then
                    -- Erro silencioso, conforme original
                end
                wait(3.5)
            end
        end)
    end
end)

local goldDominusLoopRunning = false
createToggle(Tabs.Main, "Gold Triple Dominus", Color3.new(1, 1, 0), function(state)
    goldDominusLoopRunning = state
    if state then
        spawn(function()
            while goldDominusLoopRunning do
                local success, err = pcall(function()
                    local args = {"Triple Dominus", 100}
                    local goldPetCraftEvent = ReplicatedStorage:WaitForChild("PetRemotes", 5):WaitForChild("GoldPetCraftEvent", 5)
                    if goldPetCraftEvent then
                        goldPetCraftEvent:FireServer(unpack(args))
                    end
                end)
                if not success then
                    -- Erro silencioso
                end
                wait(1)
            end
        end)
    end
end)

local diamondDominusLoopRunning = false
createToggle(Tabs.Main, "Diamond Triple Dominus", Color3.new(0, 1, 1), function(state)
    diamondDominusLoopRunning = state
    if state then
        spawn(function()
            while diamondDominusLoopRunning do
                local success, err = pcall(function()
                    local args = {"Gold Triple Dominus", 100}
                    local diamondPetCraftEvent = ReplicatedStorage:WaitForChild("PetRemotes", 5):WaitForChild("DiamondPetCraftEvent", 5)
                    if diamondPetCraftEvent then
                        diamondPetCraftEvent:FireServer(unpack(args))
                    end
                end)
                if not success then
                    -- Erro silencioso
                end
                wait(1)
            end
        end)
    end
end)

-- Inputs e Botões para AddRewardEvent (Cash)
Tabs.Main:AddInput("CashInput", {
    Title = "Cash Amount",
    Default = "1500",
    Placeholder = "Enter cash amount",
    Numeric = true, -- Aceita apenas números
    Callback = function(value)
        -- Armazena o valor, mas não executa até o botão ser clicado
    end
})

Tabs.Main:AddButton({
    Title = "Add Cash",
    Description = "Add the specified cash amount",
    Callback = function()
        local amount = tonumber(Options.CashInput.Value)
        if amount and amount > 0 then
            local success, err = pcall(function()
                local args = {"Cash", amount}
                local addRewardEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("AddRewardEvent", 5)
                if addRewardEvent then
                    addRewardEvent:FireServer(unpack(args))
                end
            end)
            if not success then
                -- Erro silencioso
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid amount entered. Please enter a positive number.",
                Duration = 3
            })
        end
    end
})

-- Inputs e Botões para AddRewardEvent (Gems)
Tabs.Main:AddInput("GemsInput", {
    Title = "Gems Amount",
    Default = "1500",
    Placeholder = "Enter gems amount",
    Numeric = true,
    Callback = function(value)
        -- Armazena o valor
    end
})

Tabs.Main:AddButton({
    Title = "Add Gems",
    Description = "Add the specified gems amount",
    Callback = function()
        local amount = tonumber(Options.GemsInput.Value)
        if amount and amount > 0 then
            local success, err = pcall(function()
                local args = {"Gems", amount}
                local addRewardEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("AddRewardEvent", 5)
                if addRewardEvent then
                    addRewardEvent:FireServer(unpack(args))
                end
            end)
            if not success then
                -- Erro silencioso
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid amount entered. Please enter a positive number.",
                Duration = 3
            })
        end
    end
})

-- Inputs e Botões para SpinPrizeEvent
Tabs.Main:AddInput("SpinInput", {
    Title = "Spin Value",
    Default = "4",
    Placeholder = "Enter spin value",
    Numeric = true,
    Callback = function(value)
        -- Armazena o valor
    end
})

Tabs.Main:AddButton({
    Title = "Spin",
    Description = "Add the specified spin value",
    Callback = function()
        local value = tonumber(Options.SpinInput.Value)
        if value and value > 0 then
            local success, err = pcall(function()
                local args = {value}
                local spinPrizeEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("SpinPrizeEvent", 5)
                if spinPrizeEvent then
                    spinPrizeEvent:FireServer(unpack(args))
                end
            end)
            if not success then
                -- Erro silencioso
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid value entered. Please enter a positive number.",
                Duration = 3
            })
        end
    end
})

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Inicializa a janela
Window:SelectTab(1)

-- Notificação de inicialização
Fluent:Notify({
    Title = "Dig to Earth's CORE! Menu",
    Content = "The script has been loaded. Press F to toggle.",
    Duration = 5
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()