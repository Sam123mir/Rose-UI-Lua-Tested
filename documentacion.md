# 🌹 Documentación Completa de RoseUI

RoseUI está diseñada para ser intuitiva y personalizable. Aquí tienes la referencia completa de la API.

## 🛠️ Global API

### Carga del Sistema
```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"))()
```

### Carga de Iconos
```lua
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"))()
```

### `RoseUI:CreateWindow(options)`
Configura la base de tu interfaz.
- `Name` (string): Título principal.
- `Tag` (string): Versión o tag pequeño al lado del título.
- `Logo` (string/id): Asset ID o icono de la librería.
- `Keybind` (Enum.KeyCode): Tecla para ocultar/mostrar (Default: RightControl).

---

## 📑 Organización: Carpetas y Pestañas

### `Window:AddFolder(options)`
Crea una categoría colapsable en la barra lateral.
- `Name` (string): Nombre visible.
- `Icon` (string): Icono de la librería.

### `Folder:AddFile(options)` o `Window:MakeTab(options)`
Crea una página de contenido.
- `Name` (string): Nombre.
- `Icon` (string): Icono.

---

## 🧱 Elementos y Componentes

### `Tab:AddSection(name)`
Divide tu página en bloques lógicos.

#### Botones
```lua
Section:AddButton({
    Name = "Click Me",
    Description = "Describe qué hace este botón",
    Callback = function() print("Clicked!") end
})
```

#### Toggles
```lua
Section:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(state) print("State:", state) end
})
```

#### Sliders
```lua
Section:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Flag = "ws",
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})
```

#### Selector de Color (Rediseñado)
```lua
Section:AddColorPicker({
    Name = "Team Color",
    Default = Color3.fromRGB(242, 13, 13),
    Flag = "TeamColor",
    Callback = function(color) print("Color changed") end
})
```

---

## 📊 Widgets y Búsqueda

- **Búsqueda**: La barra de búsqueda en el sidebar filtra automáticamente todas las carpetas y archivos.
- **Widgets**: Muestran automáticamente **FPS**, **Ping**, **RAM** y **Hora Local** en tiempo real.

---
*RoseUI v2.5.0 Premium Edition*
