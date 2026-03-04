# 🌹 RoseUI Premium

Una librería de interfaz de usuario moderna, modular y de alto rendimiento para Roblox. Inspirada en estéticas oscuras y elegantes.

## 🚀 Instalación (Carga Rápida)

Para cargar la versión oficial y unificada de RoseUI, usa el siguiente script en tu ejecutor:

```lua
local RoseUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Rose-UI-Lua-Tested/main/dist/roseui.lua"))()
```

## 🎨 Sistema de Iconos

RoseUI utiliza un sistema de iconos dedicado con soporte para múltiples familias: **Lucide, Solar, Craft, Geist y SF Symbols**.

```lua
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123Rose/Icons-RoseV1/main/Main.lua"))()

-- Ejemplo de uso con diferentes packs
local Window = RoseUI:CreateWindow({
    Name = "ROSE UI",
    Logo = Icons:Get("Solar", "Bolt") -- Icono del pack Solar
})
```

## ✨ Características Principales

- **Bundling con Darklua**: Carga un solo archivo unificado de alto rendimiento.
- **Barra de Búsqueda**: Navegación instantánea entre categorías y funciones.
- **Widgets en Tiempo Real**: FPS, Ping, RAM Real y Hora Local precisa.
- **Estética Redline**: Diseño premium con efectos de glassmorphism y animaciones fluidas.
- **Selector de Color Avanzado**: Con presets, entrada HEX y controles precisos.

## 📖 Documentación

Puedes encontrar la guía completa de todos los componentes en [documentacion.md](./documentacion.md).

## 🚀 Ejemplo Rápido

Consulta el archivo [showcase_rose.lua](./showcase_rose.lua) para ver una implementación con todas las características activadas.

---
*Desarrollado con ❤️ para la comunidad de Roblox.*
