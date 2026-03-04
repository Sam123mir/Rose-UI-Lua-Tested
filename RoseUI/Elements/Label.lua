local import = ...
local Constants = import("Core/Constants")

local Label = {}

function Label:Add(parent, options, library)
    local lText = options.Name or options.Text or "Label"
    local theme = library.CurrentTheme or {
        Text = Color3.fromRGB(240, 255, 240)
    }

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = lText
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local LabelObj = {
        Type = "Label",
        Instance = label
    }

    function LabelObj:Set(newText)
        label.Text = newText
    end

    return LabelObj
end

return Label
