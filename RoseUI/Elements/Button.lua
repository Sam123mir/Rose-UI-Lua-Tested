local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService

local Button = {}

function Button:Add(parent, options, library)
    local bName = options.Name or "Button"
    local bDesc = options.Description or nil
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Sidebar = Color3.fromRGB(12, 18, 14),
        Content = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(18, 26, 20),
        Text = Color3.fromRGB(240, 255, 240)
    }

    local h = bDesc and 56 or 38
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, h)
    btn.BackgroundColor3 = theme.Card
    btn.Text = ""
    btn.ZIndex = 11
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -40, 0, bDesc and 28 or h)
    titleLbl.Position = UDim2.new(0, 15, 0, bDesc and 4 or 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = bName
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 12
    titleLbl.Parent = btn

    if bDesc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -40, 0, 20)
        descLbl.Position = UDim2.new(0, 15, 0, 28)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = bDesc
        descLbl.TextColor3 = Color3.fromRGB(160, 140, 150)
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 11
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextWrapped = true
        descLbl.ZIndex = 12
        descLbl.Parent = btn
    end

    local clickIcon = Instance.new("TextLabel")
    clickIcon.Size = UDim2.new(0, 20, 0, 20)
    clickIcon.Position = UDim2.new(1, -30, 0.5, -10)
    clickIcon.BackgroundTransparency = 1
    clickIcon.Text = "▶"
    clickIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    clickIcon.Font = Enum.Font.GothamBold
    clickIcon.TextSize = 12
    clickIcon.ZIndex = 12
    clickIcon.Parent = btn
    
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 35, 50)}):Play()
        TweenService:Create(clickIcon, TweenInfo.new(0.2), {Position = UDim2.new(1, -25, 0.5, -10), TextColor3 = theme.Text}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Card}):Play() 
        TweenService:Create(clickIcon, TweenInfo.new(0.2), {Position = UDim2.new(1, -30, 0.5, -10), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end)
    btn.MouseButton1Down:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.98, -10, 0, h - 3)}):Play() end)
    btn.MouseButton1Up:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, h)}):Play() end)
    btn.MouseButton1Click:Connect(cb)

    return {Type = "Button", Instance = btn}
end

return Button
