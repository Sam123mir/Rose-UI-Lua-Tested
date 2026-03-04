-- [[ 🌹 RoseUI - Comprehensive Showcase Script 🌹 ]]
-- Este script demuestra todas las capacidades del framework modular RoseUI.

-- Carga desde GitHub (Recomendado)
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/loader.lua"))()

-- Local Fallback (Solo para desarrollo)
-- local RoseUI = loadstring(readfile("c:/Users/samir/OneDrive/Desktop/Update UI Rose/RoseUI/loader.lua"))()

-- 1. Notificación de Inicio
RoseUI:Notify({
    Title = "RoseUI Showcase",
    Text = "Cargando todos los módulos y elementos...",
    Duration = 5
})

-- 2. Creación de la Ventana Principal
local Window = RoseUI:CreateWindow({
    Name = "RoseUI | Showcase Modular",
    HubType = "Developer Edition"
})

-- 3. Pestañas
local GeneralTab = Window:MakeTab({ Name = "General", Icon = "rbxassetid://4483345998" })
local AdvancedTab = Window:MakeTab({ Name = "Avanzado", Icon = "rbxassetid://4483345998" })
local GameTab = Window:MakeTab({ Name = "Juego", Icon = "rbxassetid://4483345998" })

-- ##########################################################################
-- PESTAÑA GENERAL
-- ##########################################################################
local Basics = GeneralTab:AddSection("Elementos Básicos")

Basics:AddButton({
    Name = "Botón de Prueba",
    Description = "Este botón imprime en consola y envía una notificación.",
    Callback = function()
        print("¡Botón presionado!")
        RoseUI:Notify({ Title = "Interacción", Text = "Has presionado el botón correctamente." })
    end
})

Basics:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(v)
        print("Auto Farm cambiado a:", v)
    end
})

Basics:AddSlider({
    Name = "Velocidad de Caminado",
    Min = 16,
    Max = 200,
    Default = 16,
    Flag = "WalkSpeed",
    Callback = function(v)
        print("Velocidad ajustada a:", v)
    end
})

Basics:AddTextbox({
    Name = "Nombre de Usuario",
    Placeholder = "Escribe tu nombre...",
    Callback = function(t)
        print("Texto ingresado:", t)
    end
})

-- ##########################################################################
-- PESTAÑA AVANZADA
-- ##########################################################################
local Advanced = AdvancedTab:AddSection("Controles Avanzados")

Advanced:AddDropdown({
    Name = "Seleccionar Tema",
    Options = {"Dark Rose", "Midnight Blue", "Forest Green"},
    Default = "Dark Rose",
    Flag = "ThemeSelector",
    Callback = function(v)
        print("Tema seleccionado:", v)
    end
})

Advanced:AddSearchDropdown({
    Name = "Filtro de Jugadores (Multiselección)",
    Options = {"Jugador 1", "Jugador 2", "Jugador 3", "Admin", "Moderador"},
    Default = {"Admin"},
    Flag = "TargetPlayers",
    Callback = function(list)
        print("Objetivos actuales:", table.concat(list, ", "))
    end
})

Advanced:AddColorPicker({
    Name = "Color de la Interfaz",
    Default = Color3.fromRGB(255, 100, 130),
    Flag = "MainColor",
    Callback = function(c)
        print("Nuevo color seleccionado:", c)
    end
})

Advanced:AddKeybind({
    Name = "Abrir/Cerrar Menú",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        print("¡Keybind ejecutado!")
    end
})

-- ##########################################################################
-- PESTAÑA DE JUEGO (GRIDS Y LISTAS)
-- ##########################################################################
local Lists = GameTab:AddSection("Gestión de Datos")

local MyTargetList = Lists:AddTargetList({
    Name = "Lista de Prioridades",
    Options = {"Enemigo Alpha", "Jefe Final"},
    Callback = function(newList)
        print("Lista actualizada, total elementos:", #newList)
    end
})

Lists:AddButton({
    Name = "Agregar Item Aleatorio",
    Callback = function()
        table.insert(MyTargetList.Value, "Objetivo #" .. math.random(1, 100))
        MyTargetList:Refresh()
    end
})

local InvGrid = Lists:AddInventoryGrid({
    Name = "Inventario de Armas",
    OnSell = function(item)
        print("Vendiendo item:", item.Name)
    end
})

-- Llenar inventario de prueba
InvGrid:Refresh({
    {Name = "Espada de Madera", Value = 10, Rank = "Common"},
    {Name = "Daga de Hierro", Value = 50, Rank = "Rare"},
    {Name = "Excalibur", Value = 9999, Rank = "Divine"}
})

-- ##########################################################################
-- FINALIZACIÓN
-- ##########################################################################

print("--- [ RoseUI Showcase ] ---")
print("Flags iniciales:")
for flag, val in pairs(RoseUI.Flags) do
    print(string.format("  [%s] = %s", tostring(flag), tostring(val)))
end
