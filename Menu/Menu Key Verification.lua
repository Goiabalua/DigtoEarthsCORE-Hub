local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Key System",
    SubTitle = "by Goiaba.lua",
    TabWidth = 100,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Key Verification", Icon = "key" })
}

local Options = Fluent.Options

-- Input para inserir a chave
Tabs.Main:AddInput("KeyInput", {
    Title = "Enter Key",
    Description = "Insert a valid key to unlock the menu.",
    Default = "",
    Placeholder = "Paste your key here",
    Numeric = false,
    Callback = function(value)
    end
})

-- Botão para verificar a chave
Tabs.Main:AddButton({
    Title = "Verify Key",
    Description = "Check if the key is valid.",
    Callback = function()
        local key = Options.KeyInput.Value
        if key and key ~= "" then
            local success, err = pcall(function()
                -- Lista de chaves válidas (substitua por um servidor externo em produção)
                local validKeys = {"KEY123", "ABC456"}
                if table.find(validKeys, key) then
                    Fluent:Notify({
                        Title = "Success",
                        Content = "Key verified! Loading game selection menu...",
                        Duration = 3
                    })
                    -- Destruir a tela de key
                    Window:Destroy()
                    -- Carregar a tela de seleção de jogos via loadstring
                    -- Substitua pelo seu link real
                    local selectionMenuCode = [[
                        local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
                        local Window = Fluent:CreateWindow({
                            Title = "Game Selection",
                            SubTitle = "by Goiaba.lua",
                            TabWidth = 100,
                            Size = UDim2.fromOffset(400, 300),
                            Acrylic = true,
                            Theme = "Dark",
                            MinimizeKey = Enum.KeyCode.LeftControl
                        })
                        local Tabs = { Main = Window:AddTab({ Title = "Select Game", Icon = "gamepad" }) }
                        -- Botão para Dig to Earth's CORE!
                        Tabs.Main:AddButton({
                            Title = "Dig to Earth's CORE!",
                            Description = "Load the script for Dig to Earth's CORE!",
                            Callback = function()
                                Window:Destroy()
                                -- Substitua pelo seu link real do script do jogo
                                loadstring(game:HttpGet("https://your-game-script-link.com/dig-to-earths-core.lua"))()loadstring(game:HttpGet("https://raw.githubusercontent.com/Goiabalua/Goiaba.lua-Menu/refs/heads/main/Menu/Dig%20to%20Earth's%20CORE!%20Menu%20by%20Goiaba.lua.lua",true))()
                            end
                        })
                        -- Botão para outro jogo (exemplo)
                        Tabs.Main:AddButton({
                            Title = "Jogo 2",
                            Description = "Load the script for Jogo 2",
                            Callback = function()
                                Window:Destroy()
                                loadstring(game:HttpGet("https://your-game-script-link.com/jogo2.lua"))()
                            end
                        })
                        Window:SelectTab(1)
                        Fluent:Notify({
                            Title = "Game Selection",
                            Content = "Select a game to load its script.",
                            Duration = 5
                        })
                    ]]
                    loadstring(selectionMenuCode)()
                else
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Invalid key. Please try again.",
                        Duration = 3
                    })
                end
            end)
            if not success then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to verify key. Try again later.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter a key.",
                Duration = 3
            })
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Key System",
    Content = "Please enter a valid key to proceed.",
    Duration = 5
})
