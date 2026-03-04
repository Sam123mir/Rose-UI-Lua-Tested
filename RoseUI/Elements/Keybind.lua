local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local UserInputService = Services.UserInputService

local Keybind = {}

function Keybind:Add(parent, options, library)
    local kbName = options.Name or "Keybind"
    local default = options.Default or Enum.KeyCode.F
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20)
    }

    local currentKey = default
    local isWaiting = false

    local kbFrame = Instance.new("Frame")
    kbFrame.Size = UDim2.new(1, -10, 0, 42)
    kbFrame.BackgroundColor3 = theme.Card
    kbFrame.Parent = parent
    Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = kbName
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = kbFrame

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 100, 0, 28)
    bindBtn.Position = UDim2.new(1, -115, 0.5, -14)
    bindBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    bindBtn.Text = currentKey.Name
    bindBtn.TextColor3 = theme.Header
    bindBtn.Font = Enum.Font.GothamBold
    bindBtn.TextSize = 12
    bindBtn.Parent = kbFrame
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)

    local KeybindObj = {
        Type = "Keybind",
        Value = default
    }

    bindBtn.MouseButton1Click:Connect(function()
        isWaiting = true
        bindBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, proc)
        if isWaiting and input.UserInputType == Enum.UserInputType.Keyboard then
            isWaiting = false
            currentKey = input.KeyCode
            bindBtn.Text = currentKey.Name
            cb(currentKey)
        elseif not proc and input.KeyCode == currentKey then
            cb(currentKey)
        end
    end)

    return KeybindObj
end

return Keybind
