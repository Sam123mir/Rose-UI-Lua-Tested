local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Textbox = {}

function Textbox:Add(parent, options, library)
    local tName = options.Name or "Textbox"
    local default = options.Default or ""
    local placeholder = options.Placeholder or "TYPE HERE..."
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local h = 42
    
    local txtFrame = Instance.new("Frame")
    txtFrame.Name = tName .. "_Textbox"
    txtFrame.Size = UDim2.new(1, 0, 0, h)
    txtFrame.BackgroundTransparency = 1
    txtFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = txtFrame
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
    label.Text = tName
    label.TextColor3 = theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Montserrat
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local boxBg = Instance.new("Frame")
    boxBg.Size = UDim2.new(0.5, -12, 0, 26)
    boxBg.Position = UDim2.new(0.5, 0, 0.5, -13)
    boxBg.BackgroundColor3 = theme.Background
    boxBg.BackgroundTransparency = 0.5
    boxBg.Parent = bg
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 0, 32)
    box.Position = UDim2.new(0, 12, 0, options.Description and 42 or 28)
    box.BackgroundColor3 = theme.Surface
    box.BackgroundTransparency = 0.5
    box.Text = default
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = theme.SecondaryText
    box.TextColor3 = theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 10
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = boxBg

    local boxObj = {
        Type = "Textbox",
        Value = default
    }

    box.FocusLost:Connect(function(enter)
        boxObj.Value = box.Text
        cb(box.Text)
        
        if options.NotifyOnChange and library.Window then
            library.Window:Notify({
                Title = tName,
                Text = "Value changed to: " .. box.Text,
                Duration = 2
            })
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

    return boxObj
end

return Textbox
