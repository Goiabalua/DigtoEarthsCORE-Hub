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

-- Função para verificar a chave
local function verifyKey(userKey)
    local success, response = pcall(function()
        local url = "https://goiabalua-hub-key-system.glitch.me/verify/" .. userKey
        return game:HttpGet(url, true)
    end)
    
    if not success then
        return false, "Erro de conexão. Tente novamente mais tarde."
    end
    
    if response == "VALID" then
        return true, "Chave verificada com sucesso!"
    elseif response == "INVALID" then
        return false, "Chave inválida ou expirada."
    else
        return false, "Resposta inesperada do servidor."
    end
end

-- Input para inserir a chave
Tabs.Main:AddInput("KeyInput", {
    Title = "Digite sua Chave",
    Description = "Insira uma chave válida para desbloquear o menu.",
    Default = "",
    Placeholder = "Cole sua chave aqui",
    Numeric = false,
    Callback = function(value)
    end
})

-- Botão para verificar a chave
Tabs.Main:AddButton({
    Title = "Verificar Chave",
    Description = "Verifique se a chave é válida.",
    Callback = function()
        local key = Options.KeyInput.Value
        if key and key ~= "" then
            Fluent:Notify({
                Title = "Verificando",
                Content = "Checando a chave, por favor aguarde...",
                Duration = 3
            })
            
            local isValid, message = verifyKey(key)
            
            if isValid then
                Fluent:Notify({
                    Title = "Sucesso",
                    Content = "Chave verificada! Carregando o menu...",
                    Duration = 3
                })
                
                -- Destruir a tela de key
                Window:Destroy()
                
                -- Carregar a tela de seleção de jogos via loadstring
                local selectionMenuCode = [[
                    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
                    local Window = Fluent:CreateWindow({
                        Title = "Seleção de Jogos",
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
                        Description = "Carregar o script para Dig to Earth's CORE!",
                        Callback = function()
                            Window:Destroy()
                            loadstring(game:HttpGet("https://gist.githubusercontent.com/Goiabalua/8cd1e81ce31375fbf65d480facfa9e03/raw/e5953afbcfa4de1abdfaa8df2c3cec0ec34f8cd7/gistfile1.txt",true))()
                        end
                    })
                    -- Botão para outro jogo (exemplo)
                    Tabs.Main:AddButton({
                        Title = "Jogo 2",
                        Description = "Carregar o script para Jogo 2",
                        Callback = function()
                            Window:Destroy()
                            loadstring(game:HttpGet("https://your-game-script-link.com/jogo2.lua"))()
                        end
                    })
                    Window:SelectTab(1)
                    Fluent:Notify({
                        Title = "Seleção de Jogos",
                        Content = "Selecione um jogo para carregar o script.",
                        Duration = 5
                    })
                ]]
                loadstring(selectionMenuCode)()
            else
                Fluent:Notify({
                    Title = "Erro",
                    Content = message or "Chave inválida.",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "Erro",
                Content = "Por favor, insira uma chave.",
                Duration = 3
            })
        end
    end
})

-- Botão para obter uma chave (redireciona para Work.ink)
Tabs.Main:AddButton({
    Title = "Obter Chave",
    Description = "Clique para obter uma chave válida.",
    Callback = function()
        Fluent:Notify({
            Title = "Redirecionando",
            Content = "Você será redirecionado para obter uma chave...",
            Duration = 3
        })
        -- Aqui você pode adicionar um link ou instrução para o usuário
        -- Como o Roblox não permite abrir links diretamente, você pode exibir o link para o usuário copiar
        Fluent:Notify({
            Title = "Link",
            Content = "Acesse: https://workink.net/1ZDH/2e7f6r2y",
            Duration = 10
        })
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Sistema de Chaves",
    Content = "Por favor, insira uma chave válida para continuar.",
    Duration = 5
})
