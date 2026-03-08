local import = ... -- Recibido desde el cargador

local RoseUI = {
    Flags = {},
    Elements = {},
    CurrentTheme = nil
}

-- Cargar Núcleo
RoseUI.Constants = import("Core/Constants")
RoseUI.Themes = import("Core/Themes")
RoseUI.Assets = import("Core/Assets")
RoseUI.Utilities = import("Core/Utilities")

-- Configurar Tema por Defecto
RoseUI.CurrentTheme = RoseUI.Themes["Rose v2 (Premium)"]

-- Cargar Componentes
RoseUI.Notification = import("Components/Notification")
RoseUI.Window = import("Components/Window")
RoseUI.Folder = import("Components/Folder")
RoseUI.Tab = import("Components/Tab")
RoseUI.Section = import("Components/Section")

-- Cargar Elementos
RoseUI.Elements.Button = import("Elements/Button")
RoseUI.Elements.Toggle = import("Elements/Toggle")
RoseUI.Elements.Slider = import("Elements/Slider")
RoseUI.Elements.Dropdown = import("Elements/Dropdown")
RoseUI.Elements.SearchDropdown = import("Elements/SearchDropdown")
RoseUI.Elements.Textbox = import("Elements/Textbox")
RoseUI.Elements.Keybind = import("Elements/Keybind")
RoseUI.Elements.ColorPicker = import("Elements/ColorPicker")
RoseUI.Elements.Label = import("Elements/Label")
RoseUI.Elements.TargetList = import("Elements/TargetList")
RoseUI.Elements.InventoryGrid = import("Elements/InventoryGrid")
RoseUI.Elements.PlotGrid = import("Elements/PlotGrid")
RoseUI.Elements.Paragraph = import("Elements/Paragraph")
RoseUI.Elements.Documentation = import("Elements/Documentation")

-- API Principal
function RoseUI:Notify(options)
    assert(options, "RoseUI: Faltan opciones para Notify")
    assert(type(options) == "table", "RoseUI: Las opciones de Notify deben ser una tabla")
    return self.Notification:New(options, self)
end

function RoseUI:CreateWindow(options)
    assert(options, "RoseUI: Faltan opciones para CreateWindow")
    assert(type(options) == "table", "RoseUI: Las opciones de CreateWindow deben ser una tabla")
    return self.Window:New(options, self)
end

function RoseUI:SetConfig(options)
    assert(type(options) == "table" and type(options.SaveFile) == "string", "RoseUI: SaveFile debe ser un string")
    self.Config = options
end

function RoseUI:SaveConfig(filename)
    local saveName = filename or (self.Config and self.Config.SaveFile) or "roseui_config.json"
    if not isfile or not writefile then return end
    
    local HttpService = game:GetService("HttpService")
    pcall(function()
        local data = {}
        for key, value in pairs(self.Flags) do
            data[key] = value
        end
        writefile(saveName, HttpService:JSONEncode(data))
    end)
end

function RoseUI:LoadConfig(filename)
    local loadName = filename or (self.Config and self.Config.SaveFile) or "roseui_config.json"
    if not isfile or not readfile or not isfile(loadName) then return end
    
    local HttpService = game:GetService("HttpService")
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(loadName))
    end)
    
    if not ok or type(data) ~= "table" then
        warn("RoseUI: LoadConfig — archivo corrupto o JSON inválido en '" .. loadName .. "'")
        return
    end
    
    for key, value in pairs(data) do
        if self.Flags[key] == nil then
            warn("RoseUI: LoadConfig — flag desconocido ignorado: '" .. tostring(key) .. "'")
            continue
        end

        if type(value) ~= type(self.Flags[key]) then
            warn(string.format(
                "RoseUI: LoadConfig — tipo incorrecto para '%s': esperado %s, recibido %s",
                tostring(key),
                type(self.Flags[key]),
                type(value)
            ))
            continue
        end

        if type(value) == "number" then
            local meta = self.FlagsMeta and self.FlagsMeta[key]
            if meta and meta.Min and meta.Max then
                if value < meta.Min or value > meta.Max then
                    warn(string.format(
                        "RoseUI: LoadConfig — valor fuera de rango para '%s': %d (rango: %d-%d)",
                        key, value, meta.Min, meta.Max
                    ))
                    continue
                end
            end
        end

        self.Flags[key] = value
        for _, el in pairs(self.Elements) do
            if type(el) == "table" and el.Flag == key and el.Set then
                local cbOk, cbErr = pcall(function() el:Set(value) end)
                if not cbOk then
                    warn("RoseUI: LoadConfig — callback de '" .. key .. "' falló: " .. tostring(cbErr))
                end
            end
        end
    end
end

function RoseUI:CheckVersion(options)
    assert(type(options) == "table", "RoseUI: CheckVersion requiere una tabla de opciones")
    assert(type(options.Repo) == "string", "RoseUI: CheckVersion requiere options.Repo (ej: 'Sam123mir/Rose-UI-Lua-Tested')")
    assert(type(options.CurrentVersion) == "string", "RoseUI: CheckVersion requiere options.CurrentVersion (ej: '1.2.4')")

    local onUpdate  = options.OnUpdate
    local onCurrent = options.OnCurrent
    local silent    = options.Silent or false

    task.spawn(function()
        local HttpService = game:GetService("HttpService")
        local url = "https://api.github.com/repos/" .. options.Repo .. "/releases/latest"

        local requestFunc = request or http_request or (syn and syn.request)
        local ok, response = false, nil

        if requestFunc then
            local reqOk, reqResult = pcall(function()
                return requestFunc({
                    Url = url,
                    Method = "GET"
                })
            end)
            if reqOk and type(reqResult) == "table" and type(reqResult.Body) == "string" then
                ok = true
                response = reqResult.Body
            else
                response = reqResult and type(reqResult) == "table" and tostring(reqResult.StatusCode) or tostring(reqResult)
            end
        else
            ok, response = pcall(function()
                return HttpService:GetAsync(url)
            end)
        end


        if not ok then
            if not silent then
                warn("RoseUI: CheckVersion — request HTTP falló: " .. tostring(response))
                self:Notify({
                    Title   = "RoseUI",
                    Message = "No se pudo verificar actualizaciones.",
                    Type    = "warning",
                    Duration = 4
                })
            end
            return
        end

        local parseOk, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)

        if not parseOk or type(data) ~= "table" or not data.tag_name then
            if not silent then
                warn("RoseUI: CheckVersion — respuesta de GitHub inesperada o rate limit alcanzado. Detalles: " .. tostring(response))
            end
            return
        end

        local latest  = tostring(data.tag_name):gsub("^v", "")
        local current = tostring(options.CurrentVersion):gsub("^v", "")

        if latest ~= current then
            if not silent then
                self:Notify({
                    Title    = "🌹 RoseUI — Actualización disponible",
                    Message  = "v" .. current .. " → v" .. latest .. ". Actualiza tu script.",
                    Type     = "info",
                    Duration = 8
                })
            end
            if onUpdate then
                local cbOk, cbErr = pcall(onUpdate, latest, current)
                if not cbOk then
                    warn("RoseUI: CheckVersion — onUpdate callback falló: " .. tostring(cbErr))
                end
            end
        else
            if onCurrent then
                pcall(onCurrent)
            end
            if not silent then
                print("RoseUI: v" .. current .. " — estás al día ✓")
            end
        end
    end)
end

return RoseUI
