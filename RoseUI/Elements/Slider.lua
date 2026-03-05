local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local Slider = {}

function Slider:Add(parent, options, library)
    local sName = options.Name or "Slider"
    local sDesc = options.Description or nil
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or 50
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local h = sDesc and 60 or 52
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sName .. "_Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, h)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = sliderFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, sDesc and 24 or 30)
    label.Position = UDim2.new(0, 12, 0, sDesc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = sName
    label.TextColor3 = theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Inter
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -24, 0, 14)
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = theme.MutedText
        descLabel.Font = Enum.Font.Inter
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = bg
    end

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -52, 0, sDesc and 6 or 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = theme.Primary
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = bg

    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, -24, 0, 6)
    slideBg.Position = UDim2.new(0, 12, 1, -14)
    slideBg.BackgroundColor3 = theme.Background
    slideBg.Parent = bg
    Instance.new("UICorner", slideBg).CornerRadius = UDim.new(1, 0)

    local slideInner = Instance.new("Frame")
    slideInner.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    slideInner.BackgroundColor3 = theme.Primary
    slideInner.Parent = slideBg
    Instance.new("UICorner", slideInner).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 6, 0, 14)
    knob.Position = UDim2.new(1, -3, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = slideInner
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = theme.Primary
    knobStroke.Transparency = 0.5
    knobStroke.Thickness = 1
    knobStroke.Parent = knob

    local SliderObj = {
        Type = "Slider",
        Value = default,
        Flag = flag,
        Instance = sliderFrame,
        Dragging = false
    }

    function SliderObj:Set(val)
        local clamped = math.clamp(val, min, max)
        SliderObj.Value = clamped
        valueLabel.Text = tostring(clamped)
        local percentage = (clamped - min) / (max - min)
        TweenService:Create(slideInner, TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        if library.Flags then library.Flags[flag] = clamped end
        cb(clamped)
    end

    local function updateSlider(input)
        local relativeX = math.clamp(input.Position.X - slideBg.AbsolutePosition.X, 0, slideBg.AbsoluteSize.X)
        local percentage = relativeX / slideBg.AbsoluteSize.X
        local value = math.floor(min + (max - min) * percentage)
        SliderObj:Set(value)
    end

    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, 0, 0, 20)
    trigger.Position = UDim2.new(0, 0, 1, -20)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderObj.Dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderObj.Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if SliderObj.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
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
    table.insert(library.Elements, SliderObj)

    return SliderObj
end

return Slider
