local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService

local Keybind = {}

function Keybind:Add(parent, options, library)
    local kbName = options.Name or "Keybind"
    local default = options.Default or Enum.KeyCode.F
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local currentKey = default
    local isWaiting = false
    local h = 42
    
    local kbFrame = Instance.new("Frame")
    kbFrame.Name = kbName .. "_Keybind"
    kbFrame.Size = UDim2.new(1, 0, 0, h)
    kbFrame.BackgroundTransparency = 1
    kbFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = kbFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = kbName
    label.TextColor3 = theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Inter
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 60, 0, 22)
    bindBtn.Position = UDim2.new(1, -72, 0.5, -11)
    bindBtn.BackgroundColor3 = theme.Background
    bindBtn.BackgroundTransparency = 0.5
    bindBtn.Text = currentKey.Name:upper()
    bindBtn.TextColor3 = theme.Primary
    bindBtn.Font = Enum.Font.Code
    bindBtn.TextSize = 10
    bindBtn.Parent = bg
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)
    local bindStroke = Instance.new("UIStroke", bindBtn)
    bindStroke.Color = theme.Primary
    bindStroke.Transparency = 0.5

    local KeybindObj = {
        Type = "Keybind",
        Value = default,
        Flag = flag
    }

    bindBtn.MouseButton1Click:Connect(function()
        isWaiting = true
        bindBtn.Text = "..."
        TweenService:Create(bindStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, proc)
        if isWaiting and input.UserInputType == Enum.UserInputType.Keyboard then
            isWaiting = false
            currentKey = input.KeyCode
            bindBtn.Text = currentKey.Name:upper()
            KeybindObj.Value = currentKey
            if library.Flags then library.Flags[flag] = currentKey end
            TweenService:Create(bindStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            cb(currentKey)
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
    return KeybindObj
end

return Keybind
