# 🌹 Icons-RoseV1

Librería de iconos universal para RoseUI y otros proyectos de UI en Roblox.  
Estructura compatible con [Footagesus/Icons](https://github.com/Footagesus/Icons).

---

## 📂 Estructura

```
Icons-RoseV1/
├── Main.lua              ← Cargador universal (loadstring)
├── lucide/dist/Icons.lua ← Lucide Icons (IDs verificados)
├── solar/dist/Icons.lua  ← Solar Icons
├── craft/dist/Icons.lua  ← Craft Icons
├── geist/dist/Icons.lua  ← Geist Icons
├── sfsymbols/dist/Icons.lua ← SF Symbols
└── README.md
```

---

## 🚀 Uso Rápido

```lua
-- 1. Cargar la librería
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- 2. Obtener un icono (por defecto usa Lucide)
local eyeIcon = Icons.GetIcon("eye")
-- Resultado: "rbxassetid://10723377953"

-- 3. Cambiar la familia de iconos
Icons.SetIconsType("solar")
local homeIcon = Icons.GetIcon("home")

-- 4. Usar sintaxis "tipo:nombre" para mezclar familias
local geistIcon = Icons.GetIcon("geist:accessibility")
local lucideIcon = Icons.GetIcon("lucide:settings")

-- 5. Crear un ImageLabel automáticamente
local icon = Icons.Image({
    Icon = "lucide:eye",
    Color = Color3.fromRGB(242, 13, 13),
    Size = UDim2.new(0, 24, 0, 24)
})
icon.IconFrame.Parent = myFrame

-- 6. Añadir tus propios iconos personalizados
Icons.AddIcons("custom", {
    ["my-logo"] = "rbxassetid://123456789",
    ["my-star"] = 987654321, -- Acepta números también
})
local myLogo = Icons.GetIcon("custom:my-logo")
```

---

## 🎨 Familias Disponibles

| Familia | Clave | Créditos |
|---------|-------|----------|
| Lucide Icons | `lucide` | [lucide.dev](https://lucide.dev) |
| Solar Icons | `solar` | [icones.js.org/solar](https://icones.js.org/collection/solar) |
| Craft Icons | `craft` | [Figma Community](https://www.figma.com/community/file/1415718327120418204) |
| Geist Icons | `geist` | [vercel.com/geist](https://vercel.com/geist/icons) |
| SF Symbols | `sfsymbols` | [sf-symbols-one.vercel.app](https://sf-symbols-one.vercel.app/) |

---

## 🔧 API

| Método | Descripción |
|--------|-------------|
| `Icons.GetIcon(name, type?)` | Devuelve el `rbxassetid://` del icono |
| `Icons.SetIconsType(type)` | Cambia la familia por defecto |
| `Icons.Image(config)` | Crea un `ImageLabel` listo para usar |
| `Icons.AddIcons(pack, data)` | Registra iconos personalizados |
| `Icons.Init(New, Tag)` | Integración con sistemas de temas |

---

## 📋 Integración con RoseUI

```lua
-- En tu script de RoseUI:
local Icons = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/Main.lua"
))()

-- Usar un icono Lucide en una carpeta
Window:AddFolder({ 
    Name = "Combate", 
    Icon = Icons.GetIcon("zap") -- rbxassetid directo
})

-- Usar un icono Solar en un archivo
Folder:AddFile({ 
    Name = "Players", 
    Icon = Icons.GetIcon("solar:user") 
})
```

---

## 📜 Licencia

MIT License - Libre para uso personal y comercial.

---

Hecho con ❤️ por **RoseUI Team**
