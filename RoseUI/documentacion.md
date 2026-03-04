# 🌹 Documentación de RoseUI

Esta guía detalla el uso de todos los componentes y elementos disponibles en RoseUI.

## 🛠️ Global API

### `RoseUI:CreateWindow(options)`
Crea la ventana principal.
- `Name` (string): Título de la ventana.
- `HubType` (string): Subtítulo o tipo de hub.

### `RoseUI:Notify(options)`
Envía una notificación al usuario.
- `Title` (string): Título de la notificación.
- `Text` (string): Mensaje.
- `Duration` (number): Tiempo en pantalla.

---

## 📑 Ventana y Navegación

### `Window:MakeTab(options)`
Crea una pestaña en la barra lateral.
- `Name` (string): Nombre de la pestaña.
- `Icon` (string/id): Icono (rbxassetid:// o nombre de archivo).

### `Tab:AddSection(name)`
Crea una sección para agrupar elementos dentro de una pestaña.

---

## 🧱 Elementos de Sección

### `Section:AddButton(options)`
- `Name` (string): Texto del botón.
- `Description` (string): Descripción debajo del título.
- `Callback` (function): Se ejecuta al hacer clic.

### `Section:AddToggle(options)`
- `Name` (string): Texto del interruptor.
- `Default` (boolean): Estado inicial.
- `Flag` (string): Identificador único en `RoseUI.Flags`.
- `Callback` (function): Recibe el nuevo estado (`boolean`).

### `Section:AddSlider(options)`
- `Name` (string): Título.
- `Min` / `Max` (number): Rango.
- `Default` (number): Valor inicial.
- `Flag` (string): Identificador único.
- `Callback` (function): Recibe el valor actual.

### `Section:AddDropdown(options)`
- `Name` (string): Título.
- `Options` (table): Lista de strings.
- `Default` (string): Opción inicial.
- `Flag` (string): Identificador único.
- `Callback` (function): Recibe la opción seleccionada.

### `Section:AddSearchDropdown(options)`
Versión avanzada de Dropdown con buscador y selección múltiple.

### `Section:AddColorPicker(options)`
Abre un selector HSV.
- `Default` (Color3): Color inicial.

### `Section:AddKeybind(options)`
Permite asignar una tecla.
- `Default` (Enum.KeyCode): Tecla inicial.

### `Section:AddTextbox(options)`
Campo de entrada de texto.
- `Placeholder` (string): Texto de guía.

---

## 💾 Sistema de Flags

Puedes leer el valor de cualquier elemento con una `Flag` configurada en cualquier momento:

```lua
local isAutoFarm = RoseUI.Flags.AutoFarm
if isAutoFarm then
    -- hacer algo
end
```

---
*Para soporte, únete a nuestro Discord: [discord.gg/rosehub](https://discord.gg/rosehub)*
