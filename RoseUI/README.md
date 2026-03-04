# 🌹 RoseUI Framework

RoseUI es un framework de interfaz de usuario para Roblox potente, modular y con una estética premium. Diseñado para ser fácil de usar por desarrolladores de scripts y altamente mantenible gracias a su nueva arquitectura modular.

## 🚀 Instalación y Carga

Puedes cargar RoseUI directamente desde GitHub usando `loadstring`. Este es el método recomendado para asegurar que siempre tengas la versión más reciente.

```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/RoseUI/loader.lua"))()

local Window = RoseUI:CreateWindow({
    Name = "Mi Script",
    HubType = "Rose Hub"
})
```

## ✨ Características

- **Diseño Premium**: Bordes redondeados, efectos de cristal y animaciones suaves.
- **Arquitectura Modular**: Código organizado por componentes para máxima estabilidad.
- **Sistema de Flags**: Accede al estado de cualquier elemento (Toggle, Slider, etc.) mediante `RoseUI.Flags`.
- **Carga Inteligente**: Sistema de importación de módulos recursivo.
- **Widgets Avanzados**: ColorPickers, Search Dropdowns, Inventory Grids, y más.

## 📚 Documentación

Para una guía detallada sobre cómo usar cada elemento y configurar la API, consulta [documentacion.md](./documentacion.md).

## 🛠️ Ejemplo Rápido

```lua
local Window = RoseUI:CreateWindow({ Name = "Showcase" })
local Tab = Window:MakeTab({ Name = "Principal" })
local Section = Tab:AddSection("Interacción")

Section:AddButton({
    Name = "Saludar",
    Callback = function()
        RoseUI:Notify({ Title = "Hola", Text = "¡Gracias por usar RoseUI!" })
    end
})
```

---
*Desarrollado con ❤️ para la comunidad de Roblox.*
