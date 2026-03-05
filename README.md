# 🌹 RoseUI Premium

A modern, modular, and high-performance user interface library for Roblox. Inspired by dark and elegant aesthetics.

## 🚀 Installation (Fast Load)

To load the official and unified version of RoseUI, use the following script in your executor:

```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"))()
```

## 🎨 Icon System

RoseUI utilizes a dedicated icon system with support for multiple families: **Lucide, Solar, Craft, Geist, and SF Symbols**.

```lua
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"))()

-- Example usage with different packs
local Window = RoseUI:CreateWindow({
    Name = "ROSE UI",
    Logo = Icons.GetIcon("solar:Bolt") -- Icon from the Solar pack
})
```

## ✨ Core Features

- **Darklua Bundling**: Loads a single high-performance unified file.
- **Search Bar**: Instant navigation between categories and functions.
- **Real-Time Widgets**: FPS, Ping, Real RAM, and accurate Local Time.
- **Redline Aesthetic**: Premium design with glassmorphism effects and fluid animations.
- **Advanced Color Picker**: With presets, HEX input, and precise controls.

## 📖 Documentation

You can find the complete guide for all components in [documentation.md](./documentation.md).

## 🚀 Quick Example

Check out [showcase_rose.lua](./showcase_rose.lua) for an implementation with all features enabled.

---
*Developed with ❤️ for the Roblox community.*
