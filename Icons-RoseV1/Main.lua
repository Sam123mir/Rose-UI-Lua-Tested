-- RoseUI Icons v1 - Main Loader
-- Estructura basada en Footagesus/Icons (Compatible con su API)
-- Soporte para: Lucide, Solar, Craft, Geist, SF Symbols

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local HttpService = cloneref(game:GetService("HttpService"))

local function Get(url)
    if game.HttpGet then
        return game:HttpGet(url)
    else
        return HttpService:GetAsync(url)
    end
end

local BASE_URL = "https://raw.githubusercontent.com/Sam123mir/Icons-RoseV1/main/"

local IconModule = {
    IconsType = "lucide",

    New = nil,
    IconThemeTag = nil,

    Icons = {
        lucide = loadstring(Get(BASE_URL .. "lucide/dist/Icons.lua"))(),
        solar = loadstring(Get(BASE_URL .. "solar/dist/Icons.lua"))(),
        craft = loadstring(Get(BASE_URL .. "craft/dist/Icons.lua"))(),
        geist = loadstring(Get(BASE_URL .. "geist/dist/Icons.lua"))(),
        sfsymbols = loadstring(Get(BASE_URL .. "sfsymbols/dist/Icons.lua"))(),
    }
}

local function parseIconString(iconString)
    if type(iconString) == "string" then
        local splitIndex = iconString:find(":")
        if splitIndex then
            local iconType = iconString:sub(1, splitIndex - 1)
            local iconName = iconString:sub(splitIndex + 1)
            return iconType, iconName
        end
    end
    return nil, iconString
end

function IconModule.AddIcons(packName, iconsData)
    if type(packName) ~= "string" or type(iconsData) ~= "table" then
        error("AddIcons: packName must be string, iconsData must be table")
        return
    end

    if not IconModule.Icons[packName] then
        IconModule.Icons[packName] = {}
    end

    for iconName, iconValue in pairs(iconsData) do
        if type(iconValue) == "number" then
            IconModule.Icons[packName][iconName] = "rbxassetid://" .. tostring(iconValue)
        elseif type(iconValue) == "string" and iconValue:match("^rbxassetid://") then
            IconModule.Icons[packName][iconName] = iconValue
        else
            warn("AddIcons: Unsupported data type for icon '" .. iconName .. "': " .. type(iconValue))
        end
    end
end

function IconModule.SetIconsType(iconType)
    IconModule.IconsType = iconType
end

function IconModule.Init(New, IconThemeTag)
    IconModule.New = New
    IconModule.IconThemeTag = IconThemeTag
    return IconModule
end

function IconModule.GetIcon(Icon, Type)
    local iconType, iconName = parseIconString(Icon)
    local targetType = iconType or Type or IconModule.IconsType
    local targetName = iconName

    local iconSet = IconModule.Icons[targetType]

    if iconSet and iconSet[targetName] then
        return iconSet[targetName]
    end

    return nil
end

function IconModule.Image(IconConfig)
    local iconId = IconModule.GetIcon(IconConfig.Icon or "", IconConfig.Type)
    if not iconId then return nil end

    local color = IconConfig.Color or Color3.new(1, 1, 1)
    local size = IconConfig.Size or UDim2.new(0, 24, 0, 24)

    local IconFrame = Instance.new("ImageLabel")
    IconFrame.Size = size
    IconFrame.BackgroundTransparency = 1
    IconFrame.ImageColor3 = color
    IconFrame.Image = iconId

    return {
        IconFrame = IconFrame,
        Icon = iconId
    }
end

return IconModule
