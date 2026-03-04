local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService

local TargetList = {}

function TargetList:Add(parent, options, library)
    local lName = options.Name or "Target List"
    local optionsList = options.Options or {}
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20)
    }

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, -10, 0, 120)
    listFrame.BackgroundColor3 = theme.Card
    listFrame.Parent = parent
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = lName
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = listFrame

    local scrollBg = Instance.new("Frame")
    scrollBg.Size = UDim2.new(1, -20, 1, -45)
    scrollBg.Position = UDim2.new(0, 10, 0, 35)
    scrollBg.BackgroundColor3 = Color3.fromRGB(25, 12, 18)
    scrollBg.Parent = listFrame
    Instance.new("UICorner", scrollBg).CornerRadius = UDim.new(0, 4)

    local scrollMenu = Instance.new("ScrollingFrame")
    scrollMenu.Size = UDim2.new(1, -4, 1, -4)
    scrollMenu.Position = UDim2.new(0, 2, 0, 2)
    scrollMenu.BackgroundTransparency = 1
    scrollMenu.BorderSizePixel = 0
    scrollMenu.ScrollBarThickness = 3
    scrollMenu.ScrollBarImageColor3 = theme.Header
    scrollMenu.Parent = scrollBg
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollMenu
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)

    local ListObj = {
        Type = "TargetList",
        Value = optionsList
    }

    function ListObj:Refresh()
        for _, child in pairs(scrollMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, target in ipairs(ListObj.Value) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -6, 0, 25)
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
            optBtn.Text = "  ✕  " .. target
            optBtn.TextColor3 = theme.Text
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 12
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.Parent = scrollMenu
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

            optBtn.MouseButton1Click:Connect(function()
                table.remove(ListObj.Value, i)
                ListObj:Refresh()
                cb(ListObj.Value)
            end)
        end
        scrollMenu.CanvasSize = UDim2.new(0, 0, 0, #ListObj.Value * 27)
    end

    ListObj:Refresh()

    return ListObj
end

return TargetList
