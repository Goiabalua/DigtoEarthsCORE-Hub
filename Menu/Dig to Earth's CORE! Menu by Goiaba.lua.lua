local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "Dig to Earth's CORE! Menu",
    SubTitle = "by Goiaba.lua",
    TabWidth = 100,
    Size = UDim2.fromOffset(620, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local function createToggle(tab, name, defaultColor, callback, description)
    local toggle = tab:AddToggle(name, {
        Title = name,
        Description = description or "",
        Default = false,
        Callback = function(state)
            callback(state)
        end
    })
    return toggle
end

local PetSection = Tabs.Main:AddSection("Pets")

Tabs.Main:AddInput("PetInput", {
    Title = "Pet Name",
    Description = "Add a pet by name.\nExample: 'Star Cat'.\nUse the pet index to find out the names of pets.\nNormal pets only; gold and diamond only via crafting.",
    Default = "Star Cat",
    Placeholder = "Enter pet name.",
    Numeric = false,
    Callback = function(value)
    end
})

Tabs.Main:AddButton({
    Title = "Add Pet",
    Description = "Add the specified pet.",
    Callback = function()
        local petName = Options.PetInput.Value
        if petName and petName ~= "" then
            local success, err = pcall(function()
                local args = {petName}
                local petCageEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("PetCageEvent", 5)
                if petCageEvent then
                    petCageEvent:FireServer(unpack(args))
                end
            end)
            if not success then
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid pet name. Please enter a valid pet name.",
                Duration = 3
            })
        end
    end
})

local addPetLoopRunning = false
createToggle(Tabs.Main, "Add Pet", Color3.new(1, 0, 0), function(state)
    addPetLoopRunning = state
    if state then
        spawn(function()
            local petName = Options.PetInput.Value
            if petName and petName ~= "" then
                while addPetLoopRunning do
                    local success, err = pcall(function()
                        local args = {petName}
                        local petCageEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("PetCageEvent", 5)
                        if petCageEvent then
                            petCageEvent:FireServer(unpack(args))
                        end
                    end)
                    if not success then
                    end
                    wait(0)
                end
            end
        end)    
    end
end, "Automatically triggers Add Pet every 0 second.")

-- Função auxiliar para capitalizar o nome do pet
local function capitalizePetName(name)
    if not name or name == "" then return "" end
    return name:gsub("(%a)(%w*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

-- Toggle para Craft Gold Pet
local goldPetLoopRunning = false
createToggle(Tabs.Main, "Craft Gold Pet", Color3.new(1, 1, 0), function(state)
    goldPetLoopRunning = state
    if state then
        spawn(function()
            local petName = capitalizePetName(Options.PetInput.Value)
            if petName and petName ~= "" then
                while goldPetLoopRunning do
                    local success, err = pcall(function()
                        local args = {petName, 100}
                        local goldPetCraftEvent = ReplicatedStorage:WaitForChild("PetRemotes", 5):WaitForChild("GoldPetCraftEvent", 5)
                        if goldPetCraftEvent then
                            goldPetCraftEvent:FireServer(unpack(args))
                        end
                    end)
                    if not success then
                    end
                    wait(0.5)
                end
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Invalid pet name. Please enter a valid pet name in Pet Name.",
                    Duration = 3
                })
            end
        end)
    end
end, "Automatically crafts Gold pet from the specified pet name every 0.5 second.")

-- Toggle para Craft Diamond Pet
local diamondPetLoopRunning = false
createToggle(Tabs.Main, "Craft Diamond Pet", Color3.new(0, 1, 1), function(state)
    diamondPetLoopRunning = state
    if state then
        spawn(function()
            local petName = capitalizePetName(Options.PetInput.Value)
            if petName and petName ~= "" then
                local goldPetName = "Gold " .. petName
                while diamondPetLoopRunning do
                    local success, err = pcall(function()
                        local args = {goldPetName, 100}
                        local diamondPetCraftEvent = ReplicatedStorage:WaitForChild("PetRemotes", 5):WaitForChild("DiamondPetCraftEvent", 5)
                        if diamondPetCraftEvent then
                            diamondPetCraftEvent:FireServer(unpack(args))
                        end
                    end)
                    if not success then
                    end
                    wait(0.5)
                end
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Invalid pet name. Please enter a valid pet name in Pet Name.",
                    Duration = 3
                })
            end
        end)
    end
end, "Automatically crafts Diamond pet from the Gold version of the specified pet name every 0.5 second.")

local CashSection = Tabs.Main:AddSection("Cash")

Tabs.Main:AddInput("CashInput", {
    Title = "Cash Amount",
    Description = "It's not working as it should.",
    Default = "1500",
    Placeholder = "Enter cash amount.",
    Numeric = true,
    Callback = function(value)
    end
})

Tabs.Main:AddButton({
    Title = "Add Cash",
    Description = "Add the specified cash amount.",
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

local treasureCashStackLoopRunning = false
createToggle(Tabs.Main, "Auto Cash Stack", Color3.new(0, 0, 1), function(state)
    treasureCashStackLoopRunning = state
    if state then
        spawn(function()
            while treasureCashStackLoopRunning do
                local success, err = pcall(function()
                    local args = {"CashStack"}
                    local treasureEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("TreasureEvent", 5)
                    if treasureEvent then
                        treasureEvent:FireServer(unpack(args))
                    end
                end)
                if not success then
                end
                wait(0)
            end
        end)
    end
end, "Automatically triggers Cash Stack every 0 second.")

local GemsSection = Tabs.Main:AddSection("Gems")

Tabs.Main:AddInput("GemsInput", {
    Title = "Gems Amount",
    Description = "It's not working as it should.",
    Default = "1500",
    Placeholder = "Enter gems amount.",
    Numeric = true,
    Callback = function(value)
    end
})

Tabs.Main:AddButton({
    Title = "Add Gems",
    Description = "Add the specified gems amount.",
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

local treasureGemsLoopRunning = false
createToggle(Tabs.Main, "Auto Gems", Color3.new(0, 0, 1), function(state)
    treasureGemsLoopRunning = state
    if state then
        spawn(function()
            while treasureGemsLoopRunning do
                local success, err = pcall(function()
                    local args = {"Key"}
                    local treasureEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("TreasureEvent", 5)
                    if treasureEvent then
                        treasureEvent:FireServer(unpack(args))
                    end
                end)
                if not success then
                end
                wait(0)
            end
        end)
    end
end, "Automatically triggers Gems every 0 second.")

local SpinsSection = Tabs.Main:AddSection("Spins")

Tabs.Main:AddInput("SpinInput", {
    Title = "Spin Amount",
    Default = "10",
    Placeholder = "Enter spin Amount.",
    Numeric = true,
    Callback = function(value)
    end
})

Tabs.Main:AddButton({
    Title = "Add Spins",
    Description = "Add the specified spins amount.",
    Callback = function()
        local amount = tonumber(Options.SpinInput.Value)
        if amount and amount > 0 then
            local success, err = pcall(function()
                local args = {"Spins", amount}
                local addRewardEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("AddRewardEvent", 5)
                if addRewardEvent then
                    addRewardEvent:FireServer(unpack(args))
                end
            end)
            if not success then
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

Tabs.Main:AddInput("SpinInput1", {
    Title = "Spin Value",
    Default = "2",
    Placeholder = "Enter spin Value.",
    Numeric = true,
    Callback = function(value)
    end
})

Tabs.Main:AddButton({
    Title = "Spin",
    Description = "Add the specified spin value.",
    Callback = function()
        local value = tonumber(Options.SpinInput1.Value)
        if value and value > 0 then
            local success, err = pcall(function()
                local args = {value}
                local spinPrizeEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("SpinPrizeEvent", 5)
                if spinPrizeEvent then
                    spinPrizeEvent:FireServer(unpack(args))
                end
            end)
            if not success then
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

local WinsSection = Tabs.Main:AddSection("Wins")

local worldsDropdown = Tabs.Main:AddDropdown("WorldsDropdown", {
    Title = "Select World",
    Values = {"World1", "World2", "World3", "World4", "World5", "World6", "World7", "World8", "World9", "World10"},
    Multi = false,
    Default = ""
})

local selectedWorld = "World1"

worldsDropdown:OnChanged(function(value)
    selectedWorld = value
    local worldNumber = tonumber(string.match(value, "%d+"))
    
    if worldNumber then
        local success, err = pcall(function()
            local args = {worldNumber}
            local worldTeleportEvent = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("WorldTeleportEvent", 5)
            if worldTeleportEvent then
                worldTeleportEvent:FireServer(unpack(args))
                wait(0)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = 0
                end
            end
        end)
        if not success then
        end
    end
end)

local autoTpLoopRunning = false
createToggle(Tabs.Main, "Auto Win", Color3.new(0, 1, 0), function(state)
    autoTpLoopRunning = state
    if state then
        spawn(function()
            while autoTpLoopRunning do
                local success, err = pcall(function()
                    if selectedWorld and worldCoordinates[selectedWorld] then
                        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
                        
                        humanoidRootPart.CFrame = CFrame.new(worldCoordinates[selectedWorld])
                    end
                end)
                if not success then
                end
                wait(12)
            end
        end)
    end
end, "TP every 12 seconds, as the game does not accept winnings in less time.")

local worldCoordinates = {
    World1 = Vector3.new(4, -201, 3),
    World2 = Vector3.new(11, -201, -1007),
    World3 = Vector3.new(7, -200, -2006),
    World4 = Vector3.new(40, -200, -2990),
    World5 = Vector3.new(0, -201, -3975),
    World6 = Vector3.new(19, -202, -5003),
    World7 = Vector3.new(9, -201, -5991),
    World8 = Vector3.new(-1, -201, -6992),
    World9 = Vector3.new(-54, -201, -7988),
    World10 = Vector3.new(3, -350, -9011)
}

-- Addons
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Dig to Earth's CORE! Menu",
    Content = "The script has been loaded. Press LeftControl to toggle.",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
