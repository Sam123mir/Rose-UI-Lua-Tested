# 🌹 RoseUI Framework

RoseUI is a powerful, modular UI framework for Roblox with a premium aesthetic. Designed to be easy to use for script developers and highly maintainable thanks to its new modular architecture.

## 🚀 Installation and Loading

You can load RoseUI directly from GitHub using `loadstring`. This is the recommended method to ensure you always have the latest version.

```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/loader.lua"))()

local Window = RoseUI:CreateWindow({
    Name = "My Script",
    HubType = "Rose Hub"
})
```

## ✨ Features

- **Premium Design**: Rounded corners, glass effects, and smooth animations.
- **Modular Architecture**: Code organized by components for maximum stability.
- **Flag System**: Access the state of any element (Toggle, Slider, etc.) via `RoseUI.Flags`.
- **Smart Loading**: Recursive module import system.
- **Advanced Widgets**: ColorPickers, Search Dropdowns, Inventory Grids, and more.

## 📚 Documentation

For a detailed guide on how to use each element and configure the API, see [documentation.md](./documentation.md).

## 🛠️ Quick Example

```lua
local Window = RoseUI:CreateWindow({ Name = "Showcase" })
local Tab = Window:MakeTab({ Name = "Main" })
local Section = Tab:AddSection("Interaction")

Section:AddButton({
    Name = "Greet",
    Callback = function()
        RoseUI:Notify({ Title = "Hello", Text = "Thanks for using RoseUI!" })
    end
})
```

---
*Developed with ❤️ for the Roblox community.*
