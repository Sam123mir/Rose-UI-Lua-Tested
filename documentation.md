# 🌹 RoseUI Complete Documentation

RoseUI is designed to be intuitive and customizable. Here is the complete API reference.

## 🛠️ Global API

### Loading the System
```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"))()
```

### Loading Icons
```lua
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"))()
```

### Icon Usage
The icon library allows access to multiple design families (Lucide, Solar, Craft, Geist, SF Symbols).

**Get Icon ID**
To use an icon in RoseUI, simply call the `Icons.GetIcon` function specifying the name and, optionally, the family with a prefix.

```lua
-- Format "Library:IconName" or just "IconName" (defaults to Lucide)
local lucideHome = Icons.GetIcon("Home") -- Returns rbxassetid://...
local solarBolt = Icons.GetIcon("solar:Bolt")
local geistUser = Icons.GetIcon("geist:User")
```

Available libraries: `lucide`, `solar`, `craft`, `geist`, `sfsymbols`.

**Integration with RoseUI**
Pass the result directly to the interface components:
```lua
Window:AddFolder({ 
    Name = "Visuals", 
    Icon = Icons.GetIcon("solar:Eye") -- This is how icons are passed to the UI
})
```

### `RoseUI:CreateWindow(options)`
Configure your interface base.
- `Name` (string): Main title.
- `Tag` (string): Small tag or version next to the title.
- `Logo` (string/id): Asset ID or library icon.
- `Keybind` (Enum.KeyCode): Key to hide/show (Default: RightControl).

---

## 📑 Organization: Folders and Tabs

### `Window:AddFolder(options)`
Creates a collapsible category in the sidebar.
- `Name` (string): Visible name.
- `Icon` (string): Library icon.

### `Folder:AddFile(options)` or `Window:MakeTab(options)`
Creates a content page.
- `Name` (string): Name.
- `Icon` (string): Icon.

---

## 🧱 Elements and Components

### `Tab:AddSection(name)`
Divides your page into logical blocks.

#### Buttons
```lua
Section:AddButton({
    Name = "Click Me",
    Description = "Describe what this button does",
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

#### Color Picker (Redesigned)
```lua
Section:AddColorPicker({
    Name = "Team Color",
    Default = Color3.fromRGB(242, 13, 13),
    Flag = "TeamColor",
    Callback = function(color) print("Color changed") end
})
```

---

## 📊 Widgets and Search

- **Search**: The search bar in the sidebar automatically filters all folders and files.
- **Widgets**: Automatically shows **FPS**, **Ping**, **RAM**, and accurate **Local Time** in real-time.

---
*RoseUI v2.5.0 Premium Edition*
