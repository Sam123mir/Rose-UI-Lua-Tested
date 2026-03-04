local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local GuiService = Services.GuiService
local Lighting = game:GetService("Lighting")

local Window = {}

function Window:New(options, library)
    local titleText = options.Name or "Rose Hub"
    local hubType = options.HubType or "Rose Hub"
    local theme = library.CurrentTheme or import("Core/Themes")["Dark Rose"]
    
    _G.RoseBase_ID = (_G.RoseBase_ID or 0) + 1
    local currentID = _G.RoseBase_ID

    -- Purge old global event connections
    if _G.RoseUI_Connections then
        for _, conn in pairs(_G.RoseUI_Connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
    end
    _G.RoseUI_Connections = {}

    local success, targetContainer = pcall(function() return Services.CoreGui:FindFirstChild("RoseUI_Window") and Services.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui") end)
    if not success then targetContainer = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    if targetContainer:FindFirstChild("RoseUI_Window") then
        targetContainer.RoseUI_Window:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RoseUI_Window"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = targetContainer

    local openBtnGui = Instance.new("ScreenGui")
    openBtnGui.Name = "RoseUI_OpenBtn"
    openBtnGui.ResetOnSpawn = false
    openBtnGui.Enabled = false
    openBtnGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    openBtnGui.Parent = targetContainer

    local mobileOpenBtn = Instance.new("ImageButton")
    mobileOpenBtn.Size = UDim2.new(0, 45, 0, 45)
    mobileOpenBtn.Position = UDim2.new(1, -60, 0, 15)
    mobileOpenBtn.BackgroundColor3 = theme.Card
    mobileOpenBtn.Image = library.Assets.Icons.Logo
    mobileOpenBtn.ZIndex = 100
    mobileOpenBtn.Parent = openBtnGui
    Instance.new("UICorner", mobileOpenBtn).CornerRadius = UDim.new(1, 0)
    
    local mbStroke = Instance.new("UIStroke")
    mbStroke.Color = theme.Header
    mbStroke.Thickness = 2
    mbStroke.Parent = mobileOpenBtn

    local viewportSize = workspace.CurrentCamera.ViewportSize
    local finalWidth = math.clamp(Constants.DefaultSize.X.Offset, Constants.MinSize.Width, viewportSize.X - Constants.Padding)
    local finalHeight = math.clamp(Constants.DefaultSize.Y.Offset, Constants.MinSize.Height, viewportSize.Y - Constants.Padding)

    local dragFrame = Instance.new("Frame")
    dragFrame.Name = "DragBox"
    dragFrame.Size = UDim2.new(0, finalWidth, 0, finalHeight)
    dragFrame.Position = UDim2.new(0.5, -finalWidth/2, 0.5, -finalHeight/2)
    dragFrame.BackgroundColor3 = theme.Content
    dragFrame.BackgroundTransparency = 0.15
    dragFrame.Active = true
    dragFrame.Parent = screenGui
    Instance.new("UICorner", dragFrame).CornerRadius = UDim.new(0, 8)

    -- Acrylic Blur
    local camera = workspace.CurrentCamera
    local blurPart = Instance.new("Part")
    blurPart.Name = "AcrylicBlur"
    blurPart.Material = Enum.Material.Glass
    blurPart.Color = Color3.fromRGB(0, 0, 0)
    blurPart.Transparency = 0.995
    blurPart.Anchored = true
    blurPart.CanCollide = false
    blurPart.Parent = camera
    
    local blurConn = RunService.RenderStepped:Connect(function()
        if not dragFrame or not dragFrame.Parent or not screenGui.Enabled then
            blurPart.CFrame = CFrame.new(0, 9999, 0)
            return
        end
        local insetX, insetY = 6, 10
        local size = dragFrame.AbsoluteSize - Vector2.new(insetX * 2, insetY * 2)
        local pos = dragFrame.AbsolutePosition + Vector2.new(insetX, insetY)
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
        
        blurPart.Size = Vector3.new(sizeX, sizeY, 0)
        blurPart.CFrame = camera.CFrame * CFrame.new(posX, posY, -z)
    end)
    table.insert(_G.RoseUI_Connections, blurConn)

    library.Utilities:MakeDraggable(dragFrame, dragFrame)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = theme.Header
    mainStroke.Transparency = 0.5
    mainStroke.Thickness = 2
    mainStroke.Parent = dragFrame

    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 45)
    headerFrame.BackgroundTransparency = 1
    headerFrame.ZIndex = 5
    headerFrame.Parent = dragFrame
    
    local headerLogo = Instance.new("ImageLabel")
    headerLogo.Size = UDim2.new(0, 24, 0, 24)
    headerLogo.Position = UDim2.new(0, 10, 0.5, -12)
    headerLogo.BackgroundTransparency = 1
    headerLogo.Image = library.Assets.Icons.Logo
    headerLogo.ScaleType = Enum.ScaleType.Fit
    headerLogo.ZIndex = 6
    headerLogo.Parent = headerFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -150, 1, 0)
    title.Position = UDim2.new(0, 42, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6
    title.Parent = headerFrame

    -- Window Controls
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 160, 1, 0)
    controlsFrame.Position = UDim2.new(1, -175, 0, 0)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.ZIndex = 6
    controlsFrame.Parent = headerFrame
    
    local controlLayout = Instance.new("UIListLayout")
    controlLayout.FillDirection = Enum.FillDirection.Horizontal
    controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlLayout.Padding = UDim.new(0, 8)
    controlLayout.Parent = controlsFrame

    local function createControlBtn(icon, order, imageIcon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundTransparency = 1
        btn.Text = icon
        btn.TextColor3 = Color3.fromRGB(255, 180, 190)
        btn.TextSize = 18
        btn.Font = Enum.Font.GothamBold
        btn.LayoutOrder = order
        btn.ZIndex = 6
        btn.Parent = controlsFrame
        
        local img
        if imageIcon then
            img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0.5, -8, 0.5, -8)
            img.BackgroundTransparency = 1
            img.Image = imageIcon
            img.ImageColor3 = Color3.fromRGB(255, 180, 190)
            img.ScaleType = Enum.ScaleType.Fit
            img.ZIndex = 6
            img.Parent = btn
        end

        btn.MouseEnter:Connect(function() 
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            if img then TweenService:Create(img, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end
        end)
        btn.MouseLeave:Connect(function() 
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 180, 190)}):Play()
            if img then TweenService:Create(img, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 180, 190)}):Play() end
        end)
        return btn
    end

    local discordBtn = createControlBtn("", 0, library.Assets.Icons.Discord)
    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/rosehub")
            library:Notify({Title = "Discord", Text = "Copied Discord link to clipboard!", Duration = 3})
        end
    end)

    local minBtn = createControlBtn("-", 1)
    minBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
        openBtnGui.Enabled = true
        library:Notify({Title = "Rose Hub Minimized", Text = "Tap the logo at the top right or press Right Alt to reopen.", Duration = 4})
    end)
    mobileOpenBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = true
        openBtnGui.Enabled = false
    end)

    local maxBtn = createControlBtn("", 2, library.Assets.Icons.TabOut)
    local closeBtn = createControlBtn("", 3, library.Assets.Icons.Cross)
    closeBtn.MouseButton1Click:Connect(function()
        pcall(function() blurPart:Destroy() end)
        blurConn:Disconnect()
        screenGui:Destroy()
    end)

    local bodyContainer = Instance.new("Frame")
    bodyContainer.Name = "Body"
    bodyContainer.Size = UDim2.new(1, 0, 1, -45)
    bodyContainer.Position = UDim2.new(0, 0, 0, 45)
    bodyContainer.BackgroundTransparency = 1
    bodyContainer.ZIndex = 1
    bodyContainer.Parent = dragFrame
    bodyContainer.ClipsDescendants = true

    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "Sidebar"
    sidebarFrame.Size = UDim2.new(0, 160, 1, 0)
    sidebarFrame.BackgroundTransparency = 1
    sidebarFrame.Parent = bodyContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentArea"
    contentFrame.Size = UDim2.new(1, -160, 1, 0)
    contentFrame.Position = UDim2.new(0, 160, 0, 0)
    contentFrame.BackgroundColor3 = theme.Content
    contentFrame.BackgroundTransparency = 0.15
    contentFrame.Parent = bodyContainer
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, 0, 1, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.ClipsDescendants = true
    pageContainer.Parent = contentFrame

    local WindowObj = {
        Instance = screenGui,
        CurrentTab = nil,
        Tabs = {},
        Elements = {},
        ID = currentID,
        Library = library,
        Theme = theme,
        PageContainer = pageContainer
    }

    function WindowObj:MakeTab(tabOptions)
        return library.Tab:New(tabOptions, self)
    end

    return WindowObj
end

return Window
