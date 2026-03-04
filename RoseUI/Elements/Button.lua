local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Button = {}

function Button:Add(parent, options, library)
    local bName = options.Name or "Button"
    local bDesc = options.Description or nil
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]
    local assets = library.Assets

    local h = bDesc and 45 or 38
    
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, 0, 0, h)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = theme.Surface
    btn.BackgroundTransparency = 0.3
    btn.Text = ""
    btn.Parent = btnFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.new(1,1,1)
    btnStroke.Transparency = 0.95
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -40, 0, bDesc and 24 or h)
    titleLbl.Position = UDim2.new(0, 12, 0, bDesc and 4 or 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = bName
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = btn

    if bDesc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -40, 0, 14)
        descLbl.Position = UDim2.new(0, 12, 0, 24)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = bDesc
        descLbl.TextColor3 = theme.SecondaryText
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 9
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextWrapped = true
        descLbl.Parent = btn
    end

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(1, -28, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = assets.Icons.Expand or ""
    icon.ImageColor3 = theme.SecondaryText
    icon.ImageTransparency = 0.5
    icon.Rotation = -90
    icon.Parent = btn
    
    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = theme.Primary, ImageTransparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
        TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = theme.SecondaryText, ImageTransparency = 0.5}):Play()
    end)
    
    btn.MouseButton1Down:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.95, 0), Position = UDim2.new(0.01, 0, 0.025, 0)}):Play() end)
    btn.MouseButton1Up:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play() end)
    btn.MouseButton1Click:Connect(cb)

    return {Type = "Button", Instance = btn}
end

return Button
