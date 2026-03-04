local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Textbox = {}

function Textbox:Add(parent, options, library)
    local tName = options.Name or "Textbox"
    local default = options.Default or ""
    local placeholder = options.Placeholder or "Type here..."
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20)
    }

    local txtFrame = Instance.new("Frame")
    txtFrame.Size = UDim2.new(1, -10, 0, 42)
    txtFrame.BackgroundColor3 = theme.Card
    txtFrame.Parent = parent
    Instance.new("UICorner", txtFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = tName
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = txtFrame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.4, 0, 0, 28)
    box.Position = UDim2.new(1, -15, 0.5, -14)
    box.AnchorPoint = Vector2.new(1, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    box.Text = default
    box.PlaceholderText = placeholder
    box.TextColor3 = theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.Parent = txtFrame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    local boxObj = {
        Type = "Textbox",
        Value = default
    }

    box.FocusLost:Connect(function(enter)
        boxObj.Value = box.Text
        cb(box.Text)
    end)

    return boxObj
end

return Textbox
