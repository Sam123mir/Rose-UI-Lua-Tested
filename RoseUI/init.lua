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
    
    if ok and type(data) == "table" then
        for key, value in pairs(data) do
            if self.Flags[key] ~= nil then
                self.Flags[key] = value
                
                -- Support updating elements based on loaded config
                for _, el in pairs(self.Elements) do
                    if type(el) == "table" and el.Flag == key and el.Set then
                        el:Set(value)
                    end
                end
            end
        end
    end
end

return RoseUI
