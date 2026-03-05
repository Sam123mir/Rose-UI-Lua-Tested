# 🌹 Icons-RoseV1

Universal icon library for RoseUI and other UI projects on Roblox.  
Structure compatible with [Footagesus/Icons](https://github.com/Footagesus/Icons).

---

## 📂 Structure

```
Icons-RoseV1/
├── Main.lua              ← Universal loader (loadstring)
├── lucide/dist/Icons.lua ← Lucide Icons (Verified IDs)
├── solar/dist/Icons.lua  ← Solar Icons
├── craft/dist/Icons.lua  ← Craft Icons
├── geist/dist/Icons.lua  ← Geist Icons
├── sfsymbols/dist/Icons.lua ← SF Symbols
└── README.md
```

---

## 🚀 Quick Start

```lua
-- 1. Load the library
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- 2. Get an icon (uses Lucide by default)
local eyeIcon = Icons.GetIcon("eye")
-- Result: "rbxassetid://10723377953"

-- 3. Change icon family
Icons.SetIconsType("solar")
local homeIcon = Icons.GetIcon("home")

-- 4. Use "type:name" syntax to mix families
local geistIcon = Icons.GetIcon("geist:accessibility")
local lucideIcon = Icons.GetIcon("lucide:settings")

-- 5. Create an ImageLabel automatically
local icon = Icons.Image({
    Icon = "lucide:eye",
    Color = Color3.fromRGB(242, 13, 13),
    Size = UDim2.new(0, 24, 0, 24)
})
icon.IconFrame.Parent = myFrame

-- 6. Add your own custom icons
Icons.AddIcons("custom", {
    ["my-logo"] = "rbxassetid://123456789",
    ["my-star"] = 987654321, -- Also accepts numbers
})
local myLogo = Icons.GetIcon("custom:my-logo")
```

---

## 🎨 Available Families

| Family | Key | Credits |
|---------|-------|----------|
| Lucide Icons | `lucide` | [lucide.dev](https://lucide.dev) |
| Solar Icons | `solar` | [icones.js.org/solar](https://icones.js.org/collection/solar) |
| Craft Icons | `craft` | [Figma Community](https://www.figma.com/community/file/1415718327120418204) |
| Geist Icons | `geist` | [vercel.com/geist](https://vercel.com/geist/icons) |
| SF Symbols | `sfsymbols` | [sf-symbols-one.vercel.app](https://sf-symbols-one.vercel.app/) |

---

## 🔧 API

| Method | Description |
|--------|-------------|
| `Icons.GetIcon(name, type?)` | Returns the `rbxassetid://` of the icon |
| `Icons.SetIconsType(type)` | Changes the default family |
| `Icons.Image(config)` | Creates a ready-to-use `ImageLabel` |
| `Icons.AddIcons(pack, data)` | Registers custom icons |
| `Icons.Init(New, Tag)` | Integration with theme systems |

---

## 📋 Integration with RoseUI

```lua
-- In your RoseUI script:
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- Use a Lucide icon in a folder
Window:AddFolder({ 
    Name = "Combat", 
    Icon = Icons.GetIcon("zap") -- direct rbxassetid
})

-- Use a Solar icon in a file
Folder:AddFile({ 
    Name = "Players", 
    Icon = Icons.GetIcon("solar:user") 
})
```

---

## 📜 License

MIT License - Free for personal and commercial use.

---

Made with ❤️ by **RoseUI Team**
