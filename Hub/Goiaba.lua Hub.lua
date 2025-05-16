-- Função wrapper para aceitar a chave como argumento
return function(providedKey)
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
    local HttpService = game:GetService("HttpService")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- Configurações
    local PASTEBIN_KEYS_URL = "https://pastebin.com/raw/m3mipH5v"

    -- Função para verificar a chave
    local function verifyKey(key)
        if not key or key == "" then
            return false, "No key provided."
        end

        key = key:gsub("%s+", "")

        local success, keyList = pcall(function()
            return HttpService:GetAsync(PASTEBIN_KEYS_URL)
        end)

        if not success then
            return false, "Connection error. Please try again later."
        end

        local keys = {}
        for k in keyList:gmatch("[^\n]+") do
            keys[k:gsub("%s+", "")] = true
        end

        if keys[key] then
            return true, "Key verified!"
        else
            return false, "Invalid key."
        end
    end

    -- Verificar a chave fornecida
    local isValid, message = verifyKey(providedKey)

    if not isValid then
        Fluent:Notify({
            Title = "Key Error",
            Content = message,
            Duration = 5
        })
        return -- Impede a execução do menu
    end

    -- Código original do menu
    local Window = Fluent:CreateWindow({
        Title = "Dig to Earth's CORE! Menu",
        SubTitle = "by Goiaba.lua",
        TabWidth = 100,
        Size = UDim2.fromOffset(670, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "home" }),
        Movement = Window:AddTab({ Title = "Movement", Icon = "user" }),
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
        Numeric = false
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
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Failed to add pet.",
                        Duration = 3
                    })
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
                            Fluent:Notify({
                                Title = "Error",
                                Content = "Failed to add pet in loop.",
                                Duration = 3
                            })
                        end
                        wait(0)
                    end
                end
            end)
        end
    end, "Automatically triggers Add Pet every 0 second.")

    local function capitalizePetName(name)
        if not name or name == "" then return "" end
        return name:gsub("(%a)(%w*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)
    end

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
                            Fluent:Notify({
                                Title = "Error",
                                Content = "Failed to craft gold pet.",
                                Duration = 3
                            })
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
                            Fluent:Notify({
                                Title = "Error",
                                Content = "Failed to craft diamond pet.",
                                Duration = 3
                            })
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
        Numeric = true
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
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Failed to add cash.",
                        Duration = 3
                    })
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
                        Fluent:Notify({
                            Title = "Error",
                            Content = "Failed to trigger cash stack.",
                            Duration = 3
                        })
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
        Numeric = true
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
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Failed to add gems.",
                        Duration = 3
                    })
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
                        Fluent:Notify({
                            Title = "Error",
                            Content = "Failed to trigger gems.",
                            Duration = 3
                        })
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
        Numeric = true
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
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Failed to add spins.",
                        Duration = 3
                    })
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
        Numeric = true
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
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Failed to spin.",
                        Duration = 3
                    })
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
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to teleport to world.",
                    Duration = 3
                })
            end
        end
    end)

    local autoTpLoopRunning = false
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
                        Fluent:Notify({
                            Title = "Error",
                            Content = "Failed to auto win.",
                            Duration = 3
                        })
                    end
                    wait(12)
                end
            end)
        end
    end, "TP every 12 seconds, as the game does not accept winnings in less time.")

    local PlayerSection = Tabs.Movement:AddSection("Movement")

    local WalkspeedSlider = Tabs.Movement:AddSlider("Walkspeed", {
        Title = "Walkspeed",
        Description = "Adjust your player's walkspeed.",
        Default = 16,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
            end
        end
    })

    local JumpPowerSlider = Tabs.Movement:AddSlider("JumpPower", {
        Title = "Jump Power",
        Description = "Adjust your player's jump power.",
        Default = 50,
        Min = 50,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
            end
        end
    })

    local defaultGravity = workspace.Gravity

    local GravitySlider = Tabs.Movement:AddSlider("Gravity", {
        Title = "Gravity",
        Description = "Adjust the game gravity.",
        Default = workspace.Gravity,
        Min = 0,
        Max = 999,
        Rounding = 0,
        Callback = function(Value)
            workspace.Gravity = Value
        end
    })

    local FOVSlider = Tabs.Movement:AddSlider("FOV", {
        Title = "Field of View",
        Description = "Adjust the camera's field of view.",
        Default = Camera.FieldOfView,
        Min = 20,
        Max = 120,
        Rounding = 1,
        Callback = function(Value)
            Camera.FieldOfView = Value
        end
    })

    local InfJumpToggle = Tabs.Movement:AddToggle("InfJump", {
        Title = "Infinite Jump",
        Default = false,
        Description = "Enable infinite jump."
    })

    local InfJumpEnabled = false
    local InfJumpConnection

    InfJumpToggle:OnChanged(function()
        InfJumpEnabled = InfJumpToggle.Value
        if InfJumpEnabled then
            InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if InfJumpConnection then
                InfJumpConnection:Disconnect()
            end
        end
    end)

    local NoclipToggle = Tabs.Movement:AddToggle("Noclip", {
        Title = "Noclip",
        Default = false,
        Description = "Enable noclip (walk through walls)."
    })

    local NoclipEnabled = false
    NoclipToggle:OnChanged(function()
        NoclipEnabled = NoclipToggle.Value
    })

    RunService.Stepped:Connect(function()
        if NoclipEnabled and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    local FlyToggle = Tabs.Movement:AddToggle("Fly", {
        Title = "Fly",
        Default = false,
        Description = "Enable flying mode."
    })

    local FlySpeedSlider = Tabs.Movement:AddSlider("FlySpeed", {
        Title = "Fly Speed",
        Description = "Adjust your fly speed.",
        Default = 50,
        Min = 10,
        Max = 999,
        Rounding = 0
    })

    local FlyEnabled = false
    local FlyBodyVelocity, FlyBodyGyro
    local FlyConnection

    FlyToggle:OnChanged(function()
        FlyEnabled = FlyToggle.Value
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")

        if FlyEnabled then
            FlyBodyVelocity = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            FlyBodyVelocity.Parent = hrp

            FlyBodyGyro = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            FlyBodyGyro.CFrame = hrp.CFrame
            FlyBodyGyro.Parent = hrp

            FlyConnection = RunService.RenderStepped:Connect(function()
                local direction = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (Camera.CFrame.LookVector)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (Camera.CFrame.LookVector)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (Camera.CFrame.RightVector)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (Camera.CFrame.RightVector)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    direction = direction - Vector3.new(0, 1, 0)
                end

                FlyBodyVelocity.Velocity = direction * FlySpeedSlider.Value
                if direction.Magnitude > 0 then
                    FlyBodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
                else
                    FlyBodyGyro.CFrame = hrp.CFrame
                end
            end)
        else
            if FlyConnection then
                FlyConnection:Disconnect()
            end
            if FlyBodyVelocity then
                FlyBodyVelocity:Destroy()
            end
            if FlyBodyGyro then
                FlyBodyGyro:Destroy()
            end
        end
    end)

    Tabs.Movement:AddButton({
        Title = "Reset Player",
        Description = "Reset WalkSpeed and JumpPower to default values.",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
                WalkspeedSlider:SetValue(16)
                JumpPowerSlider:SetValue(50)
                workspace.Gravity = defaultGravity
                GravitySlider:SetValue(defaultGravity)
            end
            Fluent:Notify({
                Title = "Reset",
                Content = "Player settings reset to default.",
                Duration = 3
            })
        end
    })

    local TeleportSection = Tabs.Movement:AddSection("Player Teleport")

    local playerAddedConnection, playerRemovedConnection

    local function getPlayerNames()
        local names = {}
        local players = Players:GetPlayers()
        for _, player in ipairs(players) do
            if player ~= LocalPlayer and player:IsA("Player") then
                table.insert(names, player.Name)
            end
        end
        return names
    end

    local TeleportDropdown = Tabs.Movement:AddDropdown("TeleportToPlayer", {
        Title = "Teleport to Player",
        Description = "Select a player to teleport to their position.",
        Values = getPlayerNames(),
        Multi = false,
        Default = nil
    })

    TeleportDropdown:OnChanged(function(selected)
        if not selected or selected == "" then return end

        local target = Players:FindFirstChild(selected)
        if not target then
            Fluent:Notify({
                Title = "Teleport Failed",
                Content = "Player not found: " .. tostring(selected),
                Duration = 3
            })
            return
        end

        local success, err = pcall(function()
            local targetChar = target.Character or target.CharacterAdded:Wait()
            local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
            local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local localHRP = localChar:WaitForChild("HumanoidRootPart")
            localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
            Fluent:Notify({
                Title = "Teleport Success",
                Content = "Teleported to " .. target.Name,
                Duration = 3
            })
        end)

        if not success then
            Fluent:Notify({
                Title = "Teleport Error",
                Content = "Failed to teleport: " .. tostring(err),
                Duration = 5
            })
        end
    end)

    Tabs.Movement:AddButton({
        Title = "Refresh Player List",
        Description = "Update the teleport dropdown with current players.",
        Callback = function()
            TeleportDropdown:SetValues(getPlayerNames())
            Fluent:Notify({
                Title = "Player List",
                Content = "Player list has been updated",
                Duration = 2
            })
        end
    })

    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        TeleportDropdown:SetValues(getPlayerNames())
    end)

    playerRemovedConnection = Players.PlayerRemoving:Connect(function(player)
        TeleportDropdown:SetValues(getPlayerNames())
    end)

    game:GetService("UserInputService").WindowFocused:Connect(function()
        if playerAddedConnection then
            playerAddedConnection:Disconnect()
        end
        if playerRemovedConnection then
            playerRemovedConnection:Disconnect()
        end
    end)

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
end
