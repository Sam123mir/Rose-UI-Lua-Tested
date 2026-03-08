# 🌹 RoseUI Premium — Documentación

> **Versión:** 1.3.0 | **Repositorio:** [Sam123mir/Rose-UI-Lua-Tested](https://github.com/Sam123mir/Rose-UI-Lua-Tested)

---

## Índice

1. [Instalación](#instalación)
2. [Crear Ventana](#crear-ventana)
3. [Páginas (Tabs)](#páginas-tabs)
4. [Elementos de UI](#elementos-de-ui)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Button](#button)
   - [Label](#label)
   - [Section](#section)
   - [Keybind](#keybind)
   - [Dropdown](#dropdown)
   - [ColorPicker](#colorpicker)
   - [TextBox](#textbox)
5. [Sistema de Notificaciones](#sistema-de-notificaciones)
6. [Sistema de Configuración](#sistema-de-configuración)
7. [Sistema de Actualizaciones](#sistema-de-actualizaciones)
8. [Métodos de Ventana](#métodos-de-ventana)
9. [Sistema de Íconos](#sistema-de-íconos)

---

## Instalación

Carga la build unificada directamente en tu ejecutor:

```lua
local RoseUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"
))()
```

**Recomendado: esperar a que el juego cargue completamente antes de inicializar RoseUI:**

```lua
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local RoseUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"
))()
```

---

## Crear Ventana

```lua
local Window = RoseUI:CreateWindow({
    Name      = "Mi Hub",                            -- Título de la ventana (string, requerido)
    Logo      = Icons.GetIcon("solar:Bolt"),         -- Ícono (opcional, requiere sistema de íconos)
    ToggleKey = Enum.KeyCode.RightShift,             -- Tecla para mostrar/ocultar (opcional)
})
```

| Parámetro   | Tipo          | Requerido | Descripción                                 |
|-------------|---------------|-----------|---------------------------------------------|
| `Name`      | string        | ✅        | Título mostrado en la barra de la ventana   |
| `Logo`      | Icon          | ❌        | Ícono mostrado junto al título              |
| `ToggleKey` | Enum.KeyCode  | ❌        | Tecla para alternar visibilidad de la UI    |

---

## Páginas (Tabs)

Crea páginas de navegación dentro de la ventana:

```lua
local TabCombate   = Window:CreatePage("Combate")
local TabMovilidad = Window:CreatePage("Movilidad")
local TabConfig    = Window:CreatePage("Config")
```

| Parámetro | Tipo   | Requerido | Descripción          |
|-----------|--------|-----------|----------------------|
| nombre    | string | ✅        | Nombre de la página  |

---

## Elementos de UI

### Toggle

Un interruptor booleano de encendido/apagado.

```lua
Tab:CreateToggle({
    Name     = "Activar función",
    Flag     = "FeatureToggle",  -- usado por SaveConfig/LoadConfig
    Default  = false,
    Callback = function(state)   -- state: boolean
        print("Toggle ahora:", state)
    end
})
```

---

### Slider

Un control de rango numérico.

```lua
Tab:CreateSlider({
    Name     = "Velocidad",
    Flag     = "SpeedSlider",
    Min      = 16,
    Max      = 500,
    Default  = 16,
    Callback = function(value)   -- value: number
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

---

### Button

Un botón de acción clickeable.

```lua
Tab:CreateButton({
    Name     = "Teletransportar al Spawn",
    Callback = function()
        -- tu acción aquí
    end
})
```

---

### Label

Una línea de texto informativo estático.

```lua
Tab:CreateLabel({
    Name = "Este es un label informativo."
})
```

---

### Section

Un separador visual entre grupos de elementos.

```lua
Tab:CreateSection("── Configuración Avanzada ──")
```

---

### Keybind

Un selector de tecla interactivo. El usuario puede hacer click y presionar cualquier tecla para reasignarla.

```lua
Tab:CreateKeybind({
    Name     = "Tecla de Aim",
    Flag     = "AimKeybind",
    Default  = Enum.KeyCode.E,
    Callback = function(key)   -- key: Enum.KeyCode
        print("Nueva tecla asignada:", key.Name)
    end
})
```

---

### Dropdown

Un selector con múltiples opciones.

```lua
Tab:CreateDropdown({
    Name     = "Seleccionar Modo",
    Flag     = "ModeDropdown",
    Options  = { "Normal", "Silencioso", "Agresivo" },
    Default  = "Normal",
    Callback = function(selected)   -- selected: string
        print("Modo seleccionado:", selected)
    end
})
```

---

### ColorPicker

Un selector de color RGB/HEX completo con presets.

```lua
Tab:CreateColorPicker({
    Name     = "Color de ESP",
    Flag     = "ESPColor",
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(color)   -- color: Color3
        print("Color cambiado:", color)
    end
})
```

---

### TextBox

Un campo de entrada de texto libre.

```lua
Tab:CreateTextBox({
    Name        = "Jugador objetivo",
    Flag        = "TargetName",
    Default     = "",
    PlaceHolder = "Escribe un nombre...",
    Callback = function(text)   -- text: string
        print("Texto recibido:", text)
    end
})
```

---

## Sistema de Notificaciones

Muestra notificaciones tipo toast dentro de la UI con cuatro tipos visuales.

```lua
RoseUI:Notify({
    Title    = "Operación completada",
    Message  = "Todo funcionó correctamente.",
    Type     = "success",   -- "success" | "error" | "warning" | "info"
    Duration = 3            -- segundos (por defecto: 3)
})
```

| Tipo      | Color      | Cuándo usarlo                             |
|-----------|------------|-------------------------------------------|
| `success` | 🟢 Verde   | Operación completada exitosamente          |
| `error`   | 🔴 Rojo    | Algo salió mal                            |
| `warning` | 🟡 Amarillo| Riesgo potencial o advertencia            |
| `info`    | 🔵 Azul    | Mensaje informativo neutral               |

---

## Sistema de Configuración

Guarda y restaura el estado de todos los elementos entre sesiones usando archivos JSON.

> Requiere soporte del ejecutor para `writefile`, `readfile` e `isfile`.

### SaveConfig

```lua
RoseUI:SaveConfig("mi_script_config.json")
```

Guarda todos los valores de `Flag` registrados en un archivo JSON local.

### LoadConfig

```lua
RoseUI:LoadConfig("mi_script_config.json")
```

Lee el archivo JSON y restaura cada valor de flag, disparando el callback correspondiente.

**Protecciones de seguridad integradas:**
- Ignora flags desconocidos — no crashea con claves ajenas
- Verifica el tipo de cada valor — un `string` en el archivo nunca se aplica a un flag `boolean`
- Verifica rangos de sliders — valores fuera de `Min`/`Max` son ignorados
- Todos los callbacks están envueltos en `pcall` — un callback roto no aborta toda la carga

**Patrón recomendado:**

```lua
-- Al final de tu script, restaurar preferencias guardadas automáticamente:
task.spawn(function()
    task.wait(0.5)
    RoseUI:LoadConfig("mi_script_config.json")
end)

-- En el tab de configuración, exponer botones de guardar/cargar:
TabConfig:CreateButton({
    Name     = "Guardar Config",
    Callback = function()
        RoseUI:SaveConfig("mi_script_config.json")
        RoseUI:Notify({ Title = "Guardado", Message = "Config guardada.", Type = "success" })
    end
})

TabConfig:CreateButton({
    Name     = "Cargar Config",
    Callback = function()
        RoseUI:LoadConfig("mi_script_config.json")
        RoseUI:Notify({ Title = "Cargado", Message = "Config restaurada.", Type = "info" })
    end
})
```

---

## Sistema de Actualizaciones

Verifica automáticamente en GitHub si existe una versión más reciente y notifica al usuario.

```lua
RoseUI:CheckVersion({
    Repo           = "Sam123mir/Rose-UI-Lua-Tested",  -- Repositorio GitHub (string, requerido)
    CurrentVersion = "1.3.0",                          -- Versión actual de tu script (string, requerido)
    Silent         = false,                            -- Suprimir notificación en UI (boolean, opcional)
    OnUpdate = function(newVersion, oldVersion)        -- Se dispara si hay actualización (opcional)
        warn("Actualización disponible: " .. oldVersion .. " → " .. newVersion)
    end,
    OnCurrent = function()                             -- Se dispara si ya está actualizado (opcional)
        print("Estás al día ✓")
    end
})
```

| Parámetro        | Tipo     | Requerido | Descripción                                               |
|------------------|----------|-----------|-----------------------------------------------------------|
| `Repo`           | string   | ✅        | Repositorio GitHub en formato `"usuario/repo"`            |
| `CurrentVersion` | string   | ✅        | String de versión, con o sin `v` inicial                  |
| `Silent`         | boolean  | ❌        | Si `true`, suprime la notificación en UI                  |
| `OnUpdate`       | function | ❌        | Llamado con `(nuevaVersion, versionActual)` si hay update |
| `OnCurrent`      | function | ❌        | Llamado sin argumentos si ya está en la última versión    |

**Importante:** `CheckVersion` se ejecuta en `task.spawn` — nunca bloquea tu script ni la UI.

---

## Métodos de Ventana

| Método                       | Descripción                                                            |
|------------------------------|------------------------------------------------------------------------|
| `Window:CreatePage(nombre)`  | Crea una nueva página/tab                                              |
| `Window:Destroy()`           | Destruye la ventana y limpia todas las conexiones y drawings           |
| `Window:IsDestroyed()`       | Retorna `true` si la ventana ya fue destruida                          |

---

## Sistema de Íconos

RoseUI soporta múltiples familias de íconos a través de un cargador dedicado.

```lua
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- Uso: "familia:NombreIcono"
Icons.GetIcon("solar:Bolt")
Icons.GetIcon("lucide:Shield")
Icons.GetIcon("craft:Star")
Icons.GetIcon("geist:Home")
```

**Familias soportadas:** `solar`, `lucide`, `craft`, `geist`, `sf`

---

*Hecho con ❤️ para la comunidad de Roblox — [github.com/Sam123mir/Rose-UI-Lua-Tested](https://github.com/Sam123mir/Rose-UI-Lua-Tested)*
