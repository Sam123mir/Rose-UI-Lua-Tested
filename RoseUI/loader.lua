local BaseUrl = "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/"
local Cache = {}

local function import(path)
    if Cache[path] then return Cache[path] end

    local content
    local success, err = pcall(function()
        if BaseUrl:match("^http") then
            content = game:HttpGet(BaseUrl .. path .. ".lua")
        else
            if readfile then
                content = readfile(BaseUrl .. path .. ".lua")
            else
                error("readfile no disponible")
            end
        end
    end)
    
    if not success or not content then
        error("Error descargando " .. path .. ": " .. tostring(err))
    end
    
    local func, loadErr = loadstring(content)
    if not func then 
        error("Error de sintaxis en " .. path .. ": " .. tostring(loadErr)) 
    end
    
    local result = func(import)
    Cache[path] = result
    return result
end

return import("init")
