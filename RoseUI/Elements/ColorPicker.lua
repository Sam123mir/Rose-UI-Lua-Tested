local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local ColorPicker = {}

function ColorPicker:Add(parent, options, library)
    local cpName = options.Name or "Color Picker"
    local default = options.Default or Color3.fromRGB(255, 255, 255)
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local h, s, v = default:ToHSV()
    local currentColor = default
    local isOpen = false

    local cpFrame = Instance.new("Frame")
    cpFrame.Name = cpName .. "_ColorPicker"
    cpFrame.Size = UDim2.new(1, 0, 0, 42)
    cpFrame.BackgroundTransparency = 1
    cpFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = cpFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 0, 42)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = cpName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 36, 0, 18)
    colorDisplay.Position = UDim2.new(1, -48, 0.5, -9)
    colorDisplay.BackgroundColor3 = default
    colorDisplay.Parent = bg
    Instance.new("UICorner", colorDisplay).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", colorDisplay).Color = theme.Primary
    
    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg

    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, -24, 0, 0)
    pickerFrame.Position = UDim2.new(0, 12, 0, 42)
    pickerFrame.BackgroundTransparency = 1
    pickerFrame.ClipsDescendants = true
    pickerFrame.Parent = bg

    local satMap = Instance.new("ImageButton")
    satMap.Size = UDim2.new(1, -40, 0, 100)
    satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    satMap.Image = "rbxassetid://4155801252"
    satMap.AutoButtonColor = false
    satMap.Parent = pickerFrame
    Instance.new("UICorner", satMap).CornerRadius = UDim.new(0, 6)

    local mapCursor = Instance.new("Frame")
    mapCursor.Size = UDim2.new(0, 8, 0, 8)
    mapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
    mapCursor.BackgroundColor3 = Color3.new(1,1,1)
    mapCursor.Parent = satMap
    Instance.new("UICorner", mapCursor).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", mapCursor).Thickness = 1

    local hueSlider = Instance.new("ImageButton")
    hueSlider.Size = UDim2.new(0, 20, 0, 100)
    hueSlider.Position = UDim2.new(1, -25, 0, 0)
    hueSlider.Image = "rbxassetid://4155801332"
    hueSlider.AutoButtonColor = false
    hueSlider.Parent = pickerFrame
    Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 6)

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(1, 4, 0, 2)
    hueCursor.Position = UDim2.new(0, -2, h, 0)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.Parent = hueSlider
    Instance.new("UIStroke", hueCursor).Thickness = 1

    local ColorObj = {
        Type = "ColorPicker",
        Value = default,
        Flag = flag
    }

    local function updateColor()
        currentColor = Color3.fromHSV(h, s, v)
        colorDisplay.BackgroundColor3 = currentColor
        satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        if library.Flags then library.Flags[flag] = currentColor end
        cb(currentColor)
    end

    local draggingHue = false
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            h = 1 - math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
            hueCursor.Position = UDim2.new(0, -2, 1-h, 0)
            updateColor()
        end
    end)

    local draggingSat = false
    satMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSat and input.UserInputType == Enum.UserInputType.MouseMovement then
            s = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            updateColor()
        end
    end)

    function ColorObj:Set(nc)
        h, s, v = nc:ToHSV()
        hueCursor.Position = UDim2.new(0, -2, 1-h, 0)
        mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
        updateColor()
    end

    trigger.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local goalH = isOpen and 150 or 42
        local goalPH = isOpen and 100 or 0
        TweenService:Create(cpFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, goalH)}):Play()
        TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -24, 0, goalPH)}):Play()
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, ColorObj)

    return ColorObj
end

return ColorPicker
