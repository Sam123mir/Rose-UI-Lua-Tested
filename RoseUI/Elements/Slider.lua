local Constants = ...
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
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Sidebar = Color3.fromRGB(12, 18, 14),
        Content = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(18, 26, 20),
        Text = Color3.fromRGB(240, 255, 240)
    }

    local h = sDesc and 74 or 50
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, h)
    sliderFrame.BackgroundColor3 = theme.Card
    sliderFrame.ZIndex = 11
    sliderFrame.Parent = parent
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, sDesc and 30 or 25)
    label.Position = UDim2.new(0, 15, 0, sDesc and -2 or 0)
    label.BackgroundTransparency = 1
    label.Text = sName
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = sliderFrame

    local highlightBox = Instance.new("Frame")
    highlightBox.Size = UDim2.new(0, 45, 0, 20)
    highlightBox.Position = UDim2.new(1, -55, 0, sDesc and 12 or 5)
    highlightBox.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    highlightBox.ZIndex = 12
    highlightBox.Parent = sliderFrame
    Instance.new("UICorner", highlightBox).CornerRadius = UDim.new(0, 4)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = theme.Header
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.ZIndex = 13
    valueLabel.Parent = highlightBox

    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, -30, 0, 6)
    slideBg.Position = UDim2.new(0, 15, 0, sDesc and 54 or 32)
    slideBg.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    slideBg.ZIndex = 12
    slideBg.Parent = sliderFrame
    Instance.new("UICorner", slideBg).CornerRadius = UDim.new(1, 0)

    local slideInner = Instance.new("Frame")
    slideInner.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    slideInner.BackgroundColor3 = theme.Header
    slideInner.ZIndex = 13
    slideInner.Parent = slideBg
    Instance.new("UICorner", slideInner).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(1, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    knob.ZIndex = 14
    knob.Parent = slideInner
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

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
        TweenService:Create(slideInner, TweenInfo.new(0.08), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        if library.Flags then library.Flags[flag] = clamped end
        cb(clamped)
    end

    local function updateSlider(input)
        local relativeX = math.clamp(input.Position.X - slideBg.AbsolutePosition.X, 0, slideBg.AbsoluteSize.X)
        local percentage = relativeX / slideBg.AbsoluteSize.X
        local value = math.floor(min + (max - min) * percentage)
        SliderObj:Set(value)
    end

    local slideBtn = Instance.new("TextButton")
    slideBtn.Size = UDim2.new(1, 0, 1, 10)
    slideBtn.Position = UDim2.new(0, 0, 0, -5)
    slideBtn.BackgroundTransparency = 1
    slideBtn.Text = ""
    slideBtn.ZIndex = 15
    slideBtn.Parent = slideBg

    slideBtn.InputBegan:Connect(function(input)
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

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, SliderObj)

    return SliderObj
end

return Slider
