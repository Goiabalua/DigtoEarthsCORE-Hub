local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Goiaba.lua Hub - Key System",
    SubTitle = "by Goiaba.lua",
    TabWidth = 130,
    Size = UDim2.fromOffset(560, 360),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Key Verification", Icon = "key" })
}

local Options = Fluent.Options

-- Função para verificar a chave
local function verifyKey(userKey)
    local success, response = pcall(function()
        local url = "https://goiabalua-hub-key-system.glitch.me/verify/" .. userKey
        return game:HttpGet(url, true)
    end)
    
    if not success then
        return false, "Connection error. Please try again later."
    end
    
    if response == "VALID" then
        return true, "Key verified successfully!"
    elseif response == "INVALID" then
        return false, "Invalid or expired key."
    else
        return false, "Unexpected response from server."
    end
end

-- Input para inserir a chave
Tabs.Main:AddInput("KeyInput", {
    Title = "Enter your Key",
    Description = "Enter a valid key to unlock the hub.",
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
            Fluent:Notify({
                Title = "Checking",
                Content = "Checking key, please wait...",
                Duration = 3
            })
            
            local isValid, message = verifyKey(key)
            
            if isValid then
                Fluent:Notify({
                    Title = "Success!",
                    Content = "Key verified! Loading hub...",
                    Duration = 3
                })
                
                -- Destruir a tela de key
                Window:Destroy()
                
                -- Carregar a tela de seleção de jogos via loadstring
                local selectionMenuCode = [[
                    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
                    local Window = Fluent:CreateWindow({
                        Title = "Game Selection",
                        SubTitle = "by Goiaba.lua",
                        TabWidth = 120,
                        Size = UDim2.fromOffset(450, 300),
                        Acrylic = true,
                        Theme = "Dark",
                        MinimizeKey = Enum.KeyCode.LeftControl
                    })
                    local Tabs = { Main = Window:AddTab({ Title = "Escolha o Jogo", Icon = "gamepad" }) }
                    -- Botão para Dig to Earth's CORE!
                    Tabs.Main:AddButton({
                        Title = "Dig to Earth's CORE!",
                        Description = "Load the script to Dig to Earth's CORE!",
                        Callback = function()
                            Window:Destroy()
                            loadstring(game:HttpGet("https://gist.githubusercontent.com/Goiabalua/8cd1e81ce31375fbf65d480facfa9e03/raw/e5953afbcfa4de1abdfaa8df2c3cec0ec34f8cd7/gistfile1.txt",true))()
                        end
                    })
                    -- Botão para outro jogo (exemplo)
                    Tabs.Main:AddButton({
                        Title = "Coming Soon - Game 2",
                        Description = "Load the script to Game 2",
                        Callback = function()
                            Window:Destroy()
                            loadstring(game:HttpGet("https://your-game-script-link.com/jogo2.lua"))()
                        end
                    })
                    Window:SelectTab(1)
                    Fluent:Notify({
                        Title = "Game Selection",
                        Content = "Select a game to load the script.",
                        Duration = 5
                    })
                ]]
                loadstring(selectionMenuCode)()
            else
                Fluent:Notify({
                    Title = "Erro",
                    Content = message or "Invalid key.",
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

-- Botão para obter uma chave (redireciona para Work.ink)
Tabs.Main:AddButton({
    Title = "Get Key",
    Description = "Click to get a valid key.",
    Callback = function()
        Fluent:Notify({
            Title = "Redirecting",
            Content = "You will be redirected to get a key...",
            Duration = 3
        })
        -- Aqui você pode adicionar um link ou instrução para o usuário
        -- Como o Roblox não permite abrir links diretamente, você pode exibir o link para o usuário copiar
        Fluent:Notify({
            Title = "Link",
            Content = "Access: https://discord.gg/cYvRAyJaua",
            Duration = 10
        })
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Key System",
    Content = "Please enter a valid key to continue.",
    Duration = 5
})
