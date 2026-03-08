# 🌹 RoseUI Premium — Documentation

> **Version:** 1.3.0 | **Repo:** [Sam123mir/Rose-UI-Lua-Tested](https://github.com/Sam123mir/Rose-UI-Lua-Tested)

---

## Table of Contents

1. [Installation](#installation)
2. [Creating a Window](#creating-a-window)
3. [Pages (Tabs)](#pages-tabs)
4. [UI Elements](#ui-elements)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Button](#button)
   - [Label](#label)
   - [Section](#section)
   - [Keybind](#keybind)
   - [Dropdown](#dropdown)
   - [ColorPicker](#colorpicker)
   - [TextBox](#textbox)
5. [Notification System](#notification-system)
6. [Configuration System](#configuration-system)
7. [Update System](#update-system)
8. [Window Methods](#window-methods)
9. [Icon System](#icon-system)

---

## Installation

Load the unified build directly in your executor:

```lua
local RoseUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"
))()
```

**Recommended: wait for the game to fully load before initializing RoseUI:**

```lua
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

local RoseUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"
))()
```

---

## Creating a Window

```lua
local Window = RoseUI:CreateWindow({
    Name      = "My Hub",           -- Window title (string, required)
    Logo      = Icons.GetIcon("solar:Bolt"), -- Icon (optional, requires Icon system)
    ToggleKey = Enum.KeyCode.RightShift,     -- Key to show/hide UI (optional, default: RightShift)
})
```

| Parameter  | Type              | Required | Description                        |
|------------|-------------------|----------|------------------------------------|
| `Name`     | string            | ✅       | Title displayed in the window bar  |
| `Logo`     | Icon              | ❌       | Icon shown next to the title       |
| `ToggleKey`| Enum.KeyCode      | ❌       | Key to toggle UI visibility        |

---

## Pages (Tabs)

Create navigation pages inside the window:

```lua
local TabCombat   = Window:CreatePage("Combat")
local TabMovement = Window:CreatePage("Movement")
local TabConfig   = Window:CreatePage("Config")
```

| Parameter | Type   | Required | Description         |
|-----------|--------|----------|---------------------|
| name      | string | ✅       | Name of the tab     |

---

## UI Elements

### Toggle

A boolean on/off switch.

```lua
Tab:CreateToggle({
    Name     = "Enable Feature",
    Flag     = "FeatureToggle",  -- used for SaveConfig/LoadConfig
    Default  = false,
    Callback = function(state)   -- state: boolean
        print("Toggle is now:", state)
    end
})
```

---

### Slider

A numeric range input.

```lua
Tab:CreateSlider({
    Name     = "Walk Speed",
    Flag     = "WalkSpeedSlider",
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

A clickable action button.

```lua
Tab:CreateButton({
    Name     = "Teleport to Spawn",
    Callback = function()
        -- your action here
    end
})
```

---

### Label

A static informational text line.

```lua
Tab:CreateLabel({
    Name = "This is an informational label."
})
```

---

### Section

A visual separator between groups of elements.

```lua
Tab:CreateSection("── Advanced Settings ──")
```

---

### Keybind

An interactive key selector. Users can click it and press any key to reassign.

```lua
Tab:CreateKeybind({
    Name     = "Aim Key",
    Flag     = "AimKeybind",
    Default  = Enum.KeyCode.E,
    Callback = function(key)   -- key: Enum.KeyCode
        print("New key assigned:", key.Name)
    end
})
```

---

### Dropdown

A selection input with multiple options.

```lua
Tab:CreateDropdown({
    Name     = "Select Mode",
    Flag     = "ModeDropdown",
    Options  = { "Normal", "Silent", "Aggressive" },
    Default  = "Normal",
    Callback = function(selected)   -- selected: string
        print("Mode selected:", selected)
    end
})
```

---

### ColorPicker

A full RGB/HEX color picker with presets.

```lua
Tab:CreateColorPicker({
    Name     = "ESP Color",
    Flag     = "ESPColor",
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(color)   -- color: Color3
        print("Color changed:", color)
    end
})
```

---

### TextBox

A free-text input field.

```lua
Tab:CreateTextBox({
    Name        = "Target Player",
    Flag        = "TargetName",
    Default     = "",
    PlaceHolder = "Enter a player name...",
    Callback = function(text)   -- text: string
        print("Input received:", text)
    end
})
```

---

## Notification System

Display in-UI toast notifications with four visual types.

```lua
RoseUI:Notify({
    Title    = "Operation complete",
    Message  = "Everything worked as expected.",
    Type     = "success",   -- "success" | "error" | "warning" | "info"
    Duration = 3            -- seconds (default: 3)
})
```

| Type      | Color  | Use case                        |
|-----------|--------|---------------------------------|
| `success` | 🟢 Green  | Operation completed successfully |
| `error`   | 🔴 Red    | Something went wrong             |
| `warning` | 🟡 Yellow | Potential issue or risk          |
| `info`    | 🔵 Blue   | Neutral informational message    |

---

## Configuration System

Save and restore all element states across sessions using JSON files.

> Requires executor support for `writefile`, `readfile`, and `isfile`.

### SaveConfig

```lua
RoseUI:SaveConfig("my_script_config.json")
```

Saves all registered `Flag` values to a local JSON file.

### LoadConfig

```lua
RoseUI:LoadConfig("my_script_config.json")
```

Reads the JSON file and restores each flag value, then fires the corresponding callback.

**Safety guarantees built in:**
- Skips unknown flags — won't crash on foreign keys
- Type-checks each value — a `string` in the file will never be applied to a `boolean` flag
- Range-checks sliders — values outside `Min`/`Max` are ignored
- All callbacks are wrapped in `pcall` — a broken callback won't abort the whole load

**Recommended pattern:**

```lua
-- At the bottom of your script, auto-restore saved preferences:
task.spawn(function()
    task.wait(0.5)
    RoseUI:LoadConfig("my_script_config.json")
end)

-- In your Config tab, expose Save/Load buttons:
ConfigTab:CreateButton({
    Name     = "Save Config",
    Callback = function()
        RoseUI:SaveConfig("my_script_config.json")
        RoseUI:Notify({ Title = "Saved", Message = "Config saved.", Type = "success" })
    end
})

ConfigTab:CreateButton({
    Name     = "Load Config",
    Callback = function()
        RoseUI:LoadConfig("my_script_config.json")
        RoseUI:Notify({ Title = "Loaded", Message = "Config restored.", Type = "info" })
    end
})
```

---

## Update System

Automatically check GitHub for a newer release and notify the user.

```lua
RoseUI:CheckVersion({
    Repo           = "Sam123mir/Rose-UI-Lua-Tested",  -- GitHub repo (string, required)
    CurrentVersion = "1.3.0",                          -- Your script's version (string, required)
    Silent         = false,                            -- Suppress UI notification (boolean, optional)
    OnUpdate = function(newVersion, oldVersion)        -- Fires if update is available (optional)
        warn("Update available: " .. oldVersion .. " → " .. newVersion)
    end,
    OnCurrent = function()                             -- Fires if already up to date (optional)
        print("Up to date ✓")
    end
})
```

| Parameter        | Type     | Required | Description                                          |
|------------------|----------|----------|------------------------------------------------------|
| `Repo`           | string   | ✅       | GitHub repo in `"user/repo"` format                 |
| `CurrentVersion` | string   | ✅       | Version string, with or without leading `v`          |
| `Silent`         | boolean  | ❌       | If `true`, suppresses the in-UI notification         |
| `OnUpdate`       | function | ❌       | Called with `(newVersion, oldVersion)` if outdated   |
| `OnCurrent`      | function | ❌       | Called with no args if already on latest             |

**Important:** `CheckVersion` runs in `task.spawn` — it never blocks your script or the UI.

---

## Window Methods

| Method                       | Description                                      |
|------------------------------|--------------------------------------------------|
| `Window:CreatePage(name)`    | Creates a new tab/page                           |
| `Window:Destroy()`           | Destroys the window and cleans up all connections and drawings |
| `Window:IsDestroyed()`       | Returns `true` if the window has been destroyed  |

---

## Icon System

RoseUI supports multiple icon families via a dedicated loader.

```lua
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- Usage: "family:IconName"
Icons.GetIcon("solar:Bolt")
Icons.GetIcon("lucide:Shield")
Icons.GetIcon("craft:Star")
Icons.GetIcon("geist:Home")
```

**Supported families:** `solar`, `lucide`, `craft`, `geist`, `sf`

---

*Made with ❤️ for the Roblox community — [github.com/Sam123mir/Rose-UI-Lua-Tested](https://github.com/Sam123mir/Rose-UI-Lua-Tested)*
