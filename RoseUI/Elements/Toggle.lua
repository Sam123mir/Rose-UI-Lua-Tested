local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Toggle = {}

function Toggle:Add(parent, options, library)
    local tName = options.Name or "Toggle"
    local tDesc = options.Description or nil
    local cb = options.Callback or options.OnToggle or function() end
    local default = options.Default or false
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local isToggled = default
    local h = tDesc and 45 or 38
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = tName .. "_Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, h)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = toggleFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, tDesc and 24 or h)
    label.Position = UDim2.new(0, 12, 0, tDesc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = tName
    label.Font = Enum.Font.Montserrat
    label.TextSize = 12
    label.TextColor3 = theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    if options.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -60, 0, 14)
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = options.Description
        descLabel.TextColor3 = theme.MutedText
        descLabel.Font = Enum.Font.Montserrat
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = bg
    end

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and theme.Primary or theme.Background
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = bg
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, default and 19 or 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.new(1,1,1)
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
        
        local colorGoal = isToggled and theme.Primary or theme.Background
        local posGoal = isToggled and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = colorGoal}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = posGoal}):Play()
        
        cb(isToggled)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        ToggleObj:Set(not isToggled)
    end)
    
    -- Main trigger (clicks anywhere on the row)
    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, -50, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg
    trigger.MouseButton1Click:Connect(function()
        ToggleObj:Set(not isToggled)
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
    table.insert(library.Elements, ToggleObj)

    return ToggleObj
end

return Toggle
