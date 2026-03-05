-- [[ 🌹 RoseUI v2.5 Premium Showcase 🌹 ]]
-- Versión Unificada: https://github.com/Sam123mir/Rose-UI-Lua-Tested

-- 1. Cargar Librería (Versión Dist para mejor rendimiento)
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"))()

-- 2. Cargar Iconos (Repositorio Dedicado)
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"))()

-- Notificación de Bienvenida
RoseUI:Notify({
    Title = "RoseUI Cargado",
    Text = "Sistema de Build y Iconos detectado. Bienvenido.",
    Duration = 5
})

-- 3. Crear Ventana
local Window = RoseUI:CreateWindow({
    Name = "ROSE HUB",
    Tag = "V2.6 STABLE",
    Logo = Icons.GetIcon("solar:bolt"), -- Usando icono de Solar
    LoadingText = "SYNCING WITH GITHUB...",
    Language = "en", -- Multi-Language Support (en, es, br, fr)
    Keybind = Enum.KeyCode.RightControl,
    Icons = Icons -- Inyectando la API de iconos al Core
})

-- 4. Estructura de Navegación (Carpetas y Archivos)
-- INFO STANDALONE FILE
local InfoTab = Window:AddFile({
    Name = "Rose Info",
    Icon = Icons.GetIcon("lucide:info")
})

Window:AddDivider()

-- CARPETA: COMBATE
local CombatFolder = Window:AddFolder({ 
    Name = "Combate", 
    Icon = Icons.GetIcon("lucide:zap") -- Usando Lucide
})
local MainTab = CombatFolder:AddFile({ 
    Name = "Principal", 
    Icon = Icons.GetIcon("lucide:target") -- Icons repair
})
local MiscTab = CombatFolder:AddFile({ 
    Name = "Misceláneo", 
    Icon = Icons.GetIcon("lucide:box") 
})

-- CARPETA: CONFIGURACIÓN
local ConfigFolder = Window:AddFolder({ 
    Name = "Config", 
    Icon = Icons.GetIcon("lucide:settings") 
})
local ThemeTab = ConfigFolder:AddFile({ 
    Name = "Visuales", 
    Icon = Icons.GetIcon("lucide:eye") 
})

-- ##########################################################################
-- ROSE INFO
-- ##########################################################################
local WelcomeSection = InfoTab:AddSection("ABOUT ROSE UI")

WelcomeSection:AddParagraph({
    Name = "Welcome to Rose UI v2.6",
    Text = "Rose UI is a modern, lightweight, and highly customizable library built for Lua scripts. Designed with performance and aesthetics in mind, it provides a premium experience."
})

WelcomeSection:AddParagraph({
    Name = "For Developers",
    Text = "This framework simplifies UI creation with modular components, dynamic icons, robust animations, and multi-language support. It lets you focus purely on your script logic."
})

-- ##########################################################################
-- COMBATE -> MAIN
-- ##########################################################################
local AimSection = MainTab:AddSection("AIMBOT CONTROLS")

AimSection:AddToggle({
    Name = "Silent Aim",
    Description = "Automatically redirects your bullets to targets.",
    Default = false,
    Flag = "SilentAim",
    NotifyOnChange = true,
    Callback = function(v) print("Silent Aim:", v) end
})

AimSection:AddSlider({
    Name = "Target Distance",
    Min = 50,
    Max = 1000,
    Default = 500,
    Flag = "Dist",
    Callback = function(v) print("Distance:", v) end
})

-- ##########################################################################
-- VISUALS (Dropdown & ColorPicker)
-- ##########################################################################
local Appearance = ThemeTab:AddSection("INTERFACE STYLE")

Appearance:AddColorPicker({
    Name = "Theme Accent",
    Default = Color3.fromRGB(242, 13, 13),
    Flag = "AccentColor",
    Callback = function(c) print("New Color:", c) end
})

Appearance:AddDropdown({
    Name = "ESP Type",
    Options = {"Boxes", "Skeleton", "Tracer", "Highlights", "Head Circle"},
    Default = "Boxes",
    Flag = "EspType",
    Callback = function(v) print("ESP:", v) end
})

-- ##########################################################################
-- MISC (Buscador y Utilidades)
-- ##########################################################################
local Utils = MiscTab:AddSection("EXTRA FEATURES")

Utils:AddSearchDropdown({
    Name = "Teleport Places",
    Options = {"Prison Life", "Adopt Me", "Blox Fruits", "Arsenal", "Doors", "Brookhaven"},
    Default = {"Arsenal"},
    Flag = "TPs"
})

Utils:AddButton({
    Name = "Force Unload",
    Description = "Removes all RoseUI traces from game memory.",
    Callback = function()
        local ui = game:GetService("CoreGui"):FindFirstChild("ROSE HUB")
        if ui then ui:Destroy() end
    end
})

Utils:AddParagraph({
    Name = "Notice",
    Text = "This UI library was built with performance and modern aesthetics in mind."
})

Utils:AddLabel({
    Name = "Status: Undetected"
})

local ExtraFields = MiscTab:AddSection("INPUT FIELDS")

ExtraFields:AddTextbox({
    Name = "Target Username",
    Default = "Player1",
    Placeholder = "Enter name here...",
    Flag = "TargetUser",
    NotifyOnChange = true,
    Callback = function(v) print("Target Set:", v) end
})

ExtraFields:AddKeybind({
    Name = "Toggle Menu Bind",
    Default = Enum.KeyCode.RightControl,
    Flag = "MenuBind",
    Callback = function(key) 
        print("Menu bind changed to:", key)
    end
})

ExtraFields:AddButton({
    Name = "Test Notification",
    Description = "Spawns a custom test notification.",
    Callback = function()
        RoseUI:Notify({
            Title = "Test Alert",
            Text = "Notifications are fully working now!",
            Icon = Icons.GetIcon("lucide:bell-ring") or "rbxassetid://10723376188",
            Duration = 4
        })
    end
})

-- Mensaje en consola
print("--- [ RoseUI v2.6 Showcase Loaded Successfully ] ---")
