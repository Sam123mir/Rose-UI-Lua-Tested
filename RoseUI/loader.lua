local BaseUrl = "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/" -- URL oficial de GitHub

local function import(path)
    local content
    if BaseUrl:match("^http") then
        content = game:HttpGet(BaseUrl .. path .. ".lua")
    else
        -- Simulación para entorno local de Roblox
        if readfile then
            content = readfile(BaseUrl .. path .. ".lua")
        else
            error("Entorno no compatible con readfile/HttpGet")
        end
    end
    
    local func, err = loadstring(content)
    if not func then error("Error cargando " .. path .. ": " .. tostring(err)) end
    return func(import)
end

return import("init")
