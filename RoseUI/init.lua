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

-- API Principal
function RoseUI:Notify(options)
    return self.Notification:New(options, self)
end

function RoseUI:CreateWindow(options)
    return self.Window:New(options, self)
end

return RoseUI
