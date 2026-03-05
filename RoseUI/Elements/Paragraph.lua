local import = ...
local Constants = import("Core/Constants")

local Paragraph = {}

function Paragraph:Add(parent, options, library)
    local pName = options.Name or "Paragraph"
    local pText = options.Text or "Input text here."
    local theme = library.CurrentTheme or { 
        Text = Color3.fromRGB(240, 255, 240),
        SecondaryText = Color3.fromRGB(180, 180, 180),
        Surface = Color3.fromRGB(30, 30, 30)
    }

    local paragraphFrame = Instance.new("Frame")
    paragraphFrame.Name = pName .. "_Paragraph"
    paragraphFrame.Size = UDim2.new(1, 0, 0, 50)
    paragraphFrame.BackgroundColor3 = theme.Surface
    paragraphFrame.BackgroundTransparency = 0.5
    paragraphFrame.Parent = parent
    Instance.new("UICorner", paragraphFrame).CornerRadius = UDim.new(0, 6)
    
    local pStroke = Instance.new("UIStroke")
    pStroke.Color = Color3.new(1,1,1)
    pStroke.Transparency = 0.95
    pStroke.Thickness = 1
    pStroke.Parent = paragraphFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = pName
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = paragraphFrame
    
    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -16, 1, -26)
    textLbl.Position = UDim2.new(0, 8, 0, 22)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = pText
    textLbl.TextColor3 = theme.SecondaryText
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 10
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.TextYAlignment = Enum.TextYAlignment.Top
    textLbl.TextWrapped = true
    textLbl.Parent = paragraphFrame
    
    textLbl.AutomaticSize = Enum.AutomaticSize.Y
    paragraphFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local ParagraphObj = {
        Type = "Paragraph",
        Instance = paragraphFrame
    }

    function ParagraphObj:Set(newText)
        textLbl.Text = newText
    end

    return ParagraphObj
end

return Paragraph
