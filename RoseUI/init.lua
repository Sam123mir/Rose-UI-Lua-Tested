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

function RoseUI:SaveConfig()
    if not self.Config or not self.Config.SaveFile or not isfile or not writefile then return end
    local HttpService = game:GetService("HttpService")
    pcall(function()
        local data = {}
        for key, value in pairs(self.Flags) do
            data[key] = value
        end
        writefile(self.Config.SaveFile, HttpService:JSONEncode(data))
    end)
end

function RoseUI:LoadConfig()
    if not self.Config or not self.Config.SaveFile or not isfile or not readfile then return end
    local HttpService = game:GetService("HttpService")
    if isfile(self.Config.SaveFile) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(self.Config.SaveFile))
            if type(decoded) == "table" then
                for key, value in pairs(decoded) do
                    for _, el in pairs(self.Elements) do
                        if type(el) == "table" and el.Flag == key and el.Set then
                            el:Set(value)
                        end
                    end
                end
            end
        end)
    end
end

return RoseUI
