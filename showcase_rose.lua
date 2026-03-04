-- [[ 🌹 RoseUI v2 Premium - Comprehensive Showcase 🌹 ]]
-- Este script es la prueba de fuego para la nueva estética "Redline" y la API modular.

-- Cargamos la librería desde el repositorio oficial para evitar errores de ruta en el ejecutor.
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/loader.lua"))()

-- OPCIÓN LOCAL (Solo si pones la carpeta 'RoseUI' dentro de la carpeta 'workspace' de tu ejecutor):
-- local RoseUI = loadstring(readfile("RoseUI/loader.lua"))()

-- 1. Notificación de Bienvenida (Estilo Toast)
RoseUI:Notify({
    Title = "RoseUI v2 Premium",
    Text = "Sistema cargado con éxito. Disfruta de la mejor experiencia visual.",
    Icon = "Check",
    Duration = 5
})

-- 2. Creación de la Ventana Principal
-- El nuevo sistema de Window ahora soporta perfiles de usuario y estadísticas automáticas.
local Window = RoseUI:CreateWindow({
    Name = "ROSE UI",
    Tag = "V2 PREMIUM",
    Logo = "Rose", -- Icono de la rosa en el header
    LoadingText = "INICIALIZANDO SISTEMA...",
    Keybind = Enum.KeyCode.RightControl
})

-- 3. Organización por Pestañas y Sub-pestañas
-- Combat Tab (Aimbot, Triggerbot)
-- 3. Organización Jerárquica (Carpetas y Archivos)

-- CARPETA: COMBATE
local CombatFolder = Window:AddFolder({ Name = "Combate", Icon = "Combat" })
local AimbotTab = CombatFolder:AddFile({ Name = "Aimbot", Icon = "Crosshair" })
local SilentTab = CombatFolder:AddFile({ Name = "Silent Aim", Icon = "Target" })

-- CARPETA: VISUALS
local VisualsFolder = Window:AddFolder({ Name = "Visuals", Icon = "Visuals" })
local PlayerTab = VisualsFolder:AddFile({ Name = "Players", Icon = "User" })
local WorldTab = VisualsFolder:AddFile({ Name = "World", Icon = "Globe" })

-- CARPETA: CONFIGURACIÓN
local ConfigFolder = Window:AddFolder({ Name = "Settings", Icon = "Settings" })
local MainSettingsTab = ConfigFolder:AddFile({ Name = "Main", Icon = "Sliders" })

-- ##########################################################################
-- COMBAT -> AIMBOT
-- ##########################################################################
local AimMain = AimbotTab:AddSection("MAIN CONTROLS")

AimMain:AddToggle({
    Name = "ENABLE AIMBOT",
    Description = "Lock your camera onto target players automatically.",
    Default = false,
    Flag = "AimEnabled",
    Callback = function(v) print("Aimbot:", v) end
})

AimMain:AddKeybind({
    Name = "AIMBOT KEYBIND",
    Default = Enum.KeyCode.E,
    Flag = "AimKey",
    Callback = function(key) print("Aimbot Key set to:", key.Name) end
})

local AimConfig = AimbotTab:AddSection("CONFIGURATION")

AimConfig:AddSlider({
    Name = "FOV RADIUS",
    Description = "Adjust the field of view for the aimbot.",
    Min = 30,
    Max = 800,
    Default = 150,
    Flag = "AimFOV",
    Callback = function(v) print("FOV adjusted:", v) end
})

AimConfig:AddDropdown({
    Name = "SMOOTHING METHOD",
    Options = {"LINEAR", "QUART", "EXPONENTIAL", "ELASTIC"},
    Default = "QUART",
    Flag = "AimSmooth",
    Callback = function(v) print("Smoothing changed to:", v) end
})

-- ##########################################################################
-- VISUALS -> PLAYERS
-- ##########################################################################
local EspMain = PlayerTab:AddSection("PLAYER ESP")

EspMain:AddToggle({
    Name = "SHOW NAMES",
    Default = true,
    Flag = "EspNames"
})

EspMain:AddToggle({
    Name = "SHOW DISTANCE",
    Default = false,
    Flag = "EspDistance"
})

EspMain:AddColorPicker({
    Name = "ESP COLOR",
    Default = Color3.fromRGB(242, 13, 13),
    Flag = "EspColor"
})

-- ##########################################################################
-- SETTINGS -> MAIN
-- ##########################################################################
local ConfigSection = MainSettingsTab:AddSection("UI CONFIGURATION")

ConfigSection:AddButton({
    Name = "UNLOAD UI",
    Description = "Safely remove the interface and stop all processes.",
    Callback = function()
        RoseUI:Notify({ Title = "System", Text = "Unloading RoseUI..." })
        task.wait(1)
        local ui = game:GetService("CoreGui"):FindFirstChild("ROSE UI") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ROSE UI")
        if ui then ui:Destroy() end
    end
})

ConfigSection:AddSearchDropdown({
    Name = "FAVORITE GAMES",
    Options = {"Adopt Me", "Blox Fruits", "Pet Simulator 99", "Brookhaven", "Doors"},
    Default = {"Doors"},
    Flag = "FavGames"
})

ConfigSection:AddTextbox({
    Name = "CUSTOM TAG",
    Placeholder = "NAME YOUR CONFIG...",
    Callback = function(t) print("Config Name:", t) end
})

-- Finalizar inicialización
print("--- [ RoseUI v2 Showcase Ready ] ---")
