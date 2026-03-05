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

-- CARPETA: COMBATE
local CombatFolder = Window:AddFolder({ 
    Name = "Combate", 
    Icon = Icons.GetIcon("lucide:zap") 
})
local MiscTab = CombatFolder:AddFile({ 
    Name = "Misceláneo", 
    Icon = Icons.GetIcon("lucide:box") 
})
local MainTab = CombatFolder:AddFile({ 
    Name = "Principal", 
    Icon = Icons.GetIcon("lucide:target") 
})

Window:AddDivider()

-- CARPETA: DOCUMENTACION
local DocFolder = Window:AddFolder({ 
    Name = "Documentacion", 
    Icon = Icons.GetIcon("lucide:file-text") 
})
local InfoTab = DocFolder:AddFile({ 
    Name = "API Docs", 
    Icon = Icons.GetIcon("lucide:layout-list") 
})

-- ##########################################################################
-- DOCUMENTACION -> API Docs
-- ##########################################################################
InfoTab:AddDocTitle({ Text = "API DOCUMENTATION" })

InfoTab:AddVersionCard({
    Version = "v2.1.0",
    Title = "Drawing Library",
    Description = "Advanced rendering capabilities for shapes, lines, and custom text rendering on screen."
})

InfoTab:AddVersionCard({
    Version = "v1.5.2",
    Title = "Environment API",
    Description = "Access to custom execution environment variables and specialized thread management functions."
})

InfoTab:AddVersionCard({
    Version = "v3.0.1",
    Title = "Memory Hacks",
    Description = "Functions for direct memory manipulation, hook management, and metatable hooking."
})

InfoTab:AddVersionCard({
    Version = "v1.0.0",
    Title = "WebSockets",
    Description = "Establish persistent connections with external servers and manage data streams efficiently."
})

InfoTab:AddDocTitle({ Text = "THEME COLOR PICKER" })

InfoTab:AddColorPicker({
    Name = "Theme Accent",
    Default = Color3.fromRGB(242, 13, 13),
    Flag = "AccentColor",
    Callback = function(c) 
        print("Changing Accent Color:", c)
    end
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

-- Removed old ThemeTab from here

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
