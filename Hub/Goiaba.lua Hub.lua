local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Key System",
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

-- Função melhorada para verificar a chave
local function verifyKey(userKey)
    local success, response = pcall(function()
        -- URL do seu Pastebin (substitua pela sua URL real)
        -- Você deve criar um Work.ink que redireciona para este Pastebin
        local pastebinUrl = "https://pastebin.com/raw/m3mipH5v"  -- Substitua XXXXXX pelo ID do seu Pastebin

        -- Obter a chave válida do Pastebin
        local validKey = game:HttpGet(pastebinUrl, true)
        validKey = validKey:gsub("%s+", "")  -- Remove espaços e quebras de linha
 
        -- Verificar se a chave do usuário corresponde
        return userKey:gsub("%s+", "") == validKey
    end)
    
    if not success then
        return false, "Connection error. Please try again later."
    end
    
    return response, success and "Key verified!" or "Invalid key."
end

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
            Fluent:Notify({
                Title = "Verifying",
                Content = "Checking key, please wait...",
                Duration = 3
            })
            
            local isValid, message = verifyKey(key)
            
            if isValid then
                Fluent:Notify({
                    Title = "Success",
                    Content = "Key verified! Loading menu...",
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
                    local Tabs = { Main = Window:AddTab({ Title = "Select Game", Icon = "gamepad" }) }
                    -- Botão para Dig to Earth's CORE!
                    Tabs.Main:AddButton({
                        Title = "Dig to Earth's CORE!",
                        Description = "Load the script for Dig to Earth's CORE!",
                        Callback = function()
                            Window:Destroy()
                            loadstring(game:HttpGet("https://gist.githubusercontent.com/Goiabalua/8cd1e81ce31375fbf65d480facfa9e03/raw/e5953afbcfa4de1abdfaa8df2c3cec0ec34f8cd7/gistfile1.txt",true))()
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

Window:SelectTab(1)

Fluent:Notify({
    Title = "Key System",
    Content = "Please enter a valid key to proceed.",
    Duration = 5
})
