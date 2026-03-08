-- ============================================================
--  🌹 RoseUI Premium — showcase_rose.lua
--  Ejemplo completo de todos los componentes y sistemas.
--  Versión: 1.3.0 | github.com/Sam123mir/Rose-UI-Lua-Tested
-- ============================================================

-- ── 1. CARGA DE LIBRERÍAS ────────────────────────────────────
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
task.wait(0.5)

local RoseUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"
))()

local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

task.wait(0.3)

-- ── 2. VERIFICACIÓN DE VERSIÓN (automática al iniciar) ───────
--  Se ejecuta en segundo plano, no bloquea la UI.
RoseUI:CheckVersion({
    Repo           = "Sam123mir/Rose-UI-Lua-Tested",
    CurrentVersion = "1.3.0",
    Silent         = false,
    OnUpdate = function(newVersion, oldVersion)
        -- Callback opcional: puedes logear, deshabilitar features, etc.
        warn(string.format("RoseUI: Actualización disponible %s → %s", oldVersion, newVersion))
    end,
    OnCurrent = function()
        print("RoseUI: Estás usando la última versión ✓")
    end
})

-- ── 3. CREAR VENTANA ─────────────────────────────────────────
local Window = RoseUI:CreateWindow({
    Name      = "🌹 RoseUI — Showcase",
    Logo      = Icons.GetIcon("solar:Bolt"),
    ToggleKey = Enum.KeyCode.RightShift, -- RightShift muestra/oculta la UI
})

-- ── 4. PÁGINAS ───────────────────────────────────────────────
local TabBasicos    = Window:CreatePage("Básicos")
local TabAvanzados  = Window:CreatePage("Avanzados")
local TabNotif      = Window:CreatePage("Notificaciones")
local TabConfig     = Window:CreatePage("Configuración")

-- ============================================================
--  TAB 1 — ELEMENTOS BÁSICOS
-- ============================================================

-- TOGGLE
TabBasicos:CreateToggle({
    Name    = "Toggle de Ejemplo",
    Flag    = "ExampleToggle",
    Default = false,
    Callback = function(state)
        print("Toggle →", state)
    end
})

-- SLIDER
TabBasicos:CreateSlider({
    Name    = "Slider de Velocidad",
    Flag    = "SpeedSlider",
    Min     = 16,
    Max     = 500,
    Default = 16,
    Callback = function(value)
        print("Velocidad →", value)
        -- Ejemplo de aplicación real:
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- BUTTON
TabBasicos:CreateButton({
    Name     = "Botón de Acción",
    Callback = function()
        print("Botón presionado!")
        RoseUI:Notify({
            Title    = "Acción ejecutada",
            Message  = "El botón fue presionado correctamente.",
            Type     = "success",
            Duration = 3
        })
    end
})

-- LABEL
TabBasicos:CreateLabel({
    Name = "Esto es un Label informativo"
})

-- SECTION (separador visual)
TabBasicos:CreateSection("── Sección de Controles ──")

-- KEYBIND
TabBasicos:CreateKeybind({
    Name    = "Tecla de Acción",
    Flag    = "ActionKey",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Nueva tecla asignada →", key.Name)
        RoseUI:Notify({
            Title   = "Keybind actualizado",
            Message = "Tecla: " .. key.Name,
            Type    = "info",
            Duration = 2
        })
    end
})

-- ============================================================
--  TAB 2 — ELEMENTOS AVANZADOS
-- ============================================================

-- DROPDOWN
TabAvanzados:CreateDropdown({
    Name    = "Selecciona un Modo",
    Flag    = "ModeDropdown",
    Options = { "Normal", "Silencioso", "Agresivo", "Defensivo" },
    Default = "Normal",
    Callback = function(selected)
        print("Modo seleccionado →", selected)
    end
})

-- COLOR PICKER
TabAvanzados:CreateColorPicker({
    Name    = "Color de ESP",
    Flag    = "ESPColor",
    Default = Color3.fromRGB(255, 60, 60),
    Callback = function(color)
        print("Color →", color)
    end
})

-- TEXTBOX
TabAvanzados:CreateTextBox({
    Name        = "Nombre del jugador objetivo",
    Flag        = "TargetName",
    Default     = "",
    PlaceHolder = "Escribe un nombre...",
    Callback = function(text)
        print("Texto ingresado →", text)
    end
})

-- ============================================================
--  TAB 3 — DEMO DE NOTIFICACIONES
-- ============================================================

TabNotif:CreateButton({
    Name     = "✅ Notificación: Success",
    Callback = function()
        RoseUI:Notify({
            Title    = "Operación exitosa",
            Message  = "Todo salió bien sin errores.",
            Type     = "success",
            Duration = 4
        })
    end
})

TabNotif:CreateButton({
    Name     = "❌ Notificación: Error",
    Callback = function()
        RoseUI:Notify({
            Title    = "Error crítico",
            Message  = "No se pudo completar la operación.",
            Type     = "error",
            Duration = 4
        })
    end
})

TabNotif:CreateButton({
    Name     = "⚠️ Notificación: Warning",
    Callback = function()
        RoseUI:Notify({
            Title    = "Advertencia",
            Message  = "Esto puede causar comportamiento inesperado.",
            Type     = "warning",
            Duration = 4
        })
    end
})

TabNotif:CreateButton({
    Name     = "ℹ️ Notificación: Info",
    Callback = function()
        RoseUI:Notify({
            Title    = "Información",
            Message  = "RoseUI v1.3.0 está activo y funcionando.",
            Type     = "info",
            Duration = 4
        })
    end
})

-- ============================================================
--  TAB 4 — SISTEMA DE CONFIGURACIÓN
-- ============================================================

TabConfig:CreateButton({
    Name     = "💾 Guardar Configuración",
    Callback = function()
        RoseUI:SaveConfig("roseui_showcase.json")
        RoseUI:Notify({
            Title    = "Configuración guardada",
            Message  = "Archivo: roseui_showcase.json",
            Type     = "success",
            Duration = 3
        })
    end
})

TabConfig:CreateButton({
    Name     = "📂 Cargar Configuración",
    Callback = function()
        RoseUI:LoadConfig("roseui_showcase.json")
        RoseUI:Notify({
            Title    = "Configuración cargada",
            Message  = "Todos los valores han sido restaurados.",
            Type     = "info",
            Duration = 3
        })
    end
})

TabConfig:CreateSection("── Peligro ──")

TabConfig:CreateButton({
    Name     = "🔴 Unload RoseUI",
    Callback = function()
        RoseUI:Notify({
            Title    = "Cerrando RoseUI",
            Message  = "Hasta la próxima.",
            Type     = "warning",
            Duration = 2
        })
        task.wait(2)
        Window:Destroy()
    end
})

-- ── 5. AUTO-CARGAR CONFIG GUARDADA (al final del script) ─────
--  Si existe un archivo guardado de una sesión anterior,
--  restaura todos los valores automáticamente.
task.spawn(function()
    task.wait(0.5) -- pequeña espera para que la UI termine de renderizar
    RoseUI:LoadConfig("roseui_showcase.json")
end)

print("🌹 RoseUI Showcase cargado correctamente ✓")
