local Constants = ... 
local Services = Constants.Services
local CoreGui = Services.CoreGui
local TweenService = Services.TweenService
local RunService = Services.RunService
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")

local Notification = {}

function Notification:New(options, library)
    local title = options.Title or "Notification"
    local text = options.Text or ""
    local dur = options.Duration or 5
    
    local theme = library and library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Sidebar = Color3.fromRGB(12, 18, 14),
        Content = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(18, 26, 20),
        Text = Color3.fromRGB(240, 255, 240)
    }

    local success, notifGui = pcall(function() return CoreGui:FindFirstChild("RoseUI_Notifs") end)
    local targetParent = success and CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    notifGui = targetParent:FindFirstChild("RoseUI_Notifs")
    
    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "RoseUI_Notifs"
        notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        notifGui.Parent = CoreGui
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 250, 0, 70)
    notifFrame.Position = UDim2.new(1, 10, 1, -80)
    notifFrame.BackgroundColor3 = theme.Card
    notifFrame.BackgroundTransparency = 0.25
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 6)
    
    local camera = workspace.CurrentCamera
    local blurPart = Instance.new("Part")
    blurPart.Name = "NotifAcrylicBlur"
    blurPart.Material = Enum.Material.Glass
    blurPart.Color = Color3.fromRGB(0, 0, 0)
    blurPart.Transparency = 0.999
    blurPart.Reflectance = 0
    blurPart.CastShadow = false
    blurPart.CanCollide = false
    blurPart.CanQuery = false
    blurPart.Anchored = true
    blurPart.Parent = camera
    
    if not Lighting:FindFirstChild("AcrylicDoF") then
        local dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "AcrylicDoF"
        dof.FarIntensity = 0
        dof.NearIntensity = 0.8
        dof.FocusDistance = 10
        dof.InFocusRadius = 20
        dof.Parent = Lighting
    end
    
    local blurConn = RunService.RenderStepped:Connect(function()
        if not notifFrame or not notifFrame.Parent then
            pcall(function() blurPart:Destroy() end)
            return
        end
        local insetX = 6
        local insetY = 10
        local size = notifFrame.AbsoluteSize - Vector2.new(insetX * 2, insetY * 2)
        local pos = notifFrame.AbsolutePosition + Vector2.new(insetX, insetY)
        
        local topbarOffset = GuiService:GetGuiInset().Y
        pos = Vector2.new(pos.X, pos.Y + topbarOffset - 4)
        
        local z = 0.2
        local fov = math.rad(camera.FieldOfView)
        local h = 2 * math.tan(fov / 2) * z
        local w = h * (camera.ViewportSize.X / camera.ViewportSize.Y)
        
        local sizeX = (size.X / camera.ViewportSize.X) * w
        local sizeY = (size.Y / camera.ViewportSize.Y) * h
        local posX = (pos.X / camera.ViewportSize.X) * w - w / 2 + sizeX / 2
        local posY = -(pos.Y / camera.ViewportSize.Y) * h + h / 2 - sizeY / 2
        
        blurPart.Size = Vector3.new(math.max(0.001, sizeX), math.max(0.001, sizeY), 0)
        blurPart.CFrame = camera.CFrame * CFrame.new(posX, posY, -z)
    end)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Header
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = notifFrame

    for _, child in pairs(notifGui:GetChildren()) do
        if child:IsA("Frame") and child ~= notifFrame then
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                Position = UDim2.new(1, -260, 1, (child.Position.Y.Offset - 80))
            }):Play()
        end
    end

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifFrame

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -20, 0, 35)
    textLbl.Position = UDim2.new(0, 10, 0, 30)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Color3.fromRGB(200, 180, 190)
    textLbl.TextSize = 12
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.TextWrapped = true
    textLbl.Parent = notifFrame

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = theme.Header
    line.BorderSizePixel = 0
    line.Parent = notifFrame

    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -260, 1, -80)}):Play()
    TweenService:Create(line, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(1, -2, 0, 2)}):Play()

    task.delay(dur, function()
        local out = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, notifFrame.Position.Y.Offset)})
        out:Play()
        out.Completed:Wait()
        pcall(function() blurPart:Destroy() end)
        pcall(function() blurConn:Disconnect() end)
        notifFrame:Destroy()
    end)
end

return Notification
