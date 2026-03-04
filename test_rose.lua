-- Simulación de carga (Local)
local RoseUI = loadstring(readfile("c:/Users/samir/OneDrive/Desktop/Update UI Rose/RoseUI/loader.lua"))()

-- Prueba de Notificación
RoseUI:Notify({
    Title = "RoseUI Modular",
    Text = "¡La librería se ha cargado correctamente!",
    Duration = 5
})

-- Prueba de Creación de Ventana
local Window = RoseUI:CreateWindow({
    Name = "RoseUI Test Mode",
    HubType = "Modular Test"
})

-- Prueba de Pestañas
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998"
})

-- Prueba de Secciones y Elementos
local Section = MainTab:AddSection("Interactions")

Section:AddButton({
    Name = "Test Button",
    Description = "Checks button functionality",
    Callback = function()
        print("Button Clicked!")
        RoseUI:Notify({Title = "Button", Text = "Clicked!"})
    end
})

Section:AddToggle({
    Name = "Test Toggle",
    Flag = "Toggle1",
    Callback = function(val)
        print("Toggle:", val)
    end
})

Section:AddSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Flag = "Slider1",
    Callback = function(val)
        print("Slider:", val)
    end
})

local ElementsSection = SettingsTab:AddSection("Elements")

ElementsSection:AddDropdown({
    Name = "Test Dropdown",
    Options = {"Option A", "Option B", "Option C"},
    Default = "Option A",
    Flag = "Dropdown1",
    Callback = function(val)
        print("Dropdown:", val)
    end
})

ElementsSection:AddTextbox({
    Name = "Test Textbox",
    Placeholder = "Enter message...",
    Callback = function(val)
        print("Textbox:", val)
    end
})

ElementsSection:AddKeybind({
    Name = "Test Keybind",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Keybind Pressed!")
    end
})

ElementsSection:AddColorPicker({
    Name = "Test Color",
    Default = Color3.fromRGB(255, 0, 150),
    Callback = function(color)
        print("Color Selected:", color)
    end
})

print("RoseUI Modular Test Loaded!")
