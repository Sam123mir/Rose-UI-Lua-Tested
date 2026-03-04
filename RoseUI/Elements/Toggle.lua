local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local Toggle = {}

function Toggle:Add(parent, options, library)
    local tName = options.Name or "Toggle"
    local tDesc = options.Description or nil
    local cb = options.Callback or options.OnToggle or function() end
    local default = options.Default or false
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Sidebar = Color3.fromRGB(12, 18, 14),
        Content = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(18, 26, 20),
        Text = Color3.fromRGB(240, 255, 240)
    }

    local isToggled = default
    local h = tDesc and 56 or 42
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, h)
    toggleFrame.BackgroundColor3 = theme.Card
    toggleFrame.ZIndex = 11
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, tDesc and 28 or h)
    label.Position = UDim2.new(0, 15, 0, tDesc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = tName
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = toggleFrame

    -- Custom Toggle Toggle UI
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and theme.Header or Color3.fromRGB(30, 15, 20)
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleFrame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, default and 24 or 2, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local ToggleObj = {
        Type = "Toggle",
        Value = default,
        Flag = flag,
        Instance = toggleFrame
    }

    function ToggleObj:Set(state)
        isToggled = state
        ToggleObj.Value = state
        if library.Flags then library.Flags[flag] = state end
        
        local colorGoal = isToggled and theme.Header or Color3.fromRGB(30, 15, 20)
        local posGoal = isToggled and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = colorGoal}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = posGoal}):Play()
        
        cb(isToggled)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        ToggleObj:Set(not isToggled)
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, ToggleObj)

    return ToggleObj
end

return Toggle
