local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local GuiService = Services.GuiService
local Lighting = Services.Lighting

local Window = {}

function Window:New(options, library)
    local titleText = options.Name or "RoseUI"
    local hubType = options.HubType or "v1.2.4 Premium"
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]
    local assets = library.Assets
    
    _G.RoseBase_ID = (_G.RoseBase_ID or 0) + 1
    local currentID = _G.RoseBase_ID

    -- Cleanup old connections
    if _G.RoseUI_Connections then
        for _, conn in pairs(_G.RoseUI_Connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
    end
    _G.RoseUI_Connections = {}

    local targetContainer = Services.CoreGui:FindFirstChild("RoseUI_Window") and Services.CoreGui or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    if targetContainer:FindFirstChild("RoseUI_Window") then targetContainer.RoseUI_Window:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RoseUI_Window"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = targetContainer

    -- Main Container (Glass Panel)
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local finalWidth = 720
    local finalHeight = 440

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, finalWidth, 0, finalHeight)
    mainFrame.Position = UDim2.new(0.5, -finalWidth/2, 0.5, -finalHeight/2)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = theme.Primary
    mainStroke.Transparency = 0.8
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    -- Acrylic Blur Part
    local camera = workspace.CurrentCamera
    local blurPart = Instance.new("Part")
    blurPart.Name = "AcrylicBlur"
    blurPart.Material = Enum.Material.Glass
    blurPart.Transparency = 0.99
    blurPart.Anchored = true
    blurPart.CanCollide = false
    blurPart.Parent = camera
    
    local blurConn = RunService.RenderStepped:Connect(function()
        if not mainFrame or not mainFrame.Parent or not screenGui.Enabled then
            blurPart.CFrame = CFrame.new(0, 9999, 0)
            return
        end
        local size = mainFrame.AbsoluteSize
        local pos = mainFrame.AbsolutePosition
        local topbarOffset = GuiService:GetGuiInset().Y
        pos = Vector2.new(pos.X, pos.Y + topbarOffset)
        
        local z = 0.2
        local fov = math.rad(camera.FieldOfView)
        local h = 2 * math.tan(fov / 2) * z
        local w = h * (camera.ViewportSize.X / camera.ViewportSize.Y)
        
        local sizeX = (size.X / camera.ViewportSize.X) * w
        local sizeY = (size.Y / camera.ViewportSize.Y) * h
        local posX = (pos.X / camera.ViewportSize.X) * w - w / 2 + sizeX / 2
        local posY = -(pos.Y / camera.ViewportSize.Y) * h + h / 2 - sizeY / 2
        
        blurPart.Size = Vector3.new(sizeX, sizeY, 0.01)
        blurPart.CFrame = camera.CFrame * CFrame.new(posX, posY, -z)
    end)
    table.insert(_G.RoseUI_Connections, blurConn)

    library.Utilities:MakeDraggable(mainFrame, mainFrame)

    -- Header (40px)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = theme.Accent
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
    
    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, -1)
    headerLine.BackgroundColor3 = Color3.new(1,1,1)
    headerLine.BackgroundTransparency = 0.95
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header

    local logoIcon = Instance.new("ImageLabel")
    logoIcon.Size = UDim2.new(0, 20, 0, 20)
    logoIcon.Position = UDim2.new(0, 12, 0.5, -10)
    logoIcon.BackgroundTransparency = 1
    logoIcon.Image = assets.Icons.Logo
    logoIcon.ImageColor3 = theme.Primary
    logoIcon.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 60, 1, 0)
    title.Position = UDim2.new(0, 38, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ROSEUI"
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- Stats Container (Centered)
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0, 400, 1, 0)
    statsFrame.Position = UDim2.new(0.5, 0, 0, 0)
    statsFrame.AnchorPoint = Vector2.new(0.5, 0)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Parent = header
    
    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statsLayout.Padding = UDim.new(0, 0)
    statsLayout.Parent = statsFrame

    local function createStat(iconName, name, defaultVal)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(0, 100, 1, 0)
        item.BackgroundTransparency = 1
        item.Parent = statsFrame
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 14, 0, 14)
        icon.Position = UDim2.new(0, 8, 0.5, -7)
        icon.BackgroundTransparency = 1
        icon.Image = assets.Icons[iconName] or ""
        icon.ImageColor3 = theme.SecondaryText
        icon.Parent = item
        
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -28, 1, 0)
        val.Position = UDim2.new(0, 26, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = defaultVal
        val.TextColor3 = theme.Primary
        val.Font = Enum.Font.Code
        val.TextSize = 10
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.Parent = item
        
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(0, 1, 0, 16)
        separator.Position = UDim2.new(1, -1, 0.5, -8)
        separator.BackgroundColor3 = Color3.new(1,1,1)
        separator.BackgroundTransparency = 0.9
        separator.BorderSizePixel = 0
        separator.Parent = item
        
        item.Size = UDim2.new(0, val.TextBounds.X + 40, 1, 0)
        val:GetPropertyChangedSignal("Text"):Connect(function()
            item.Size = UDim2.new(0, val.TextBounds.X + 40, 1, 0)
        end)
        
        return val
    end

    local gameStat = createStat("Game", "Game", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Game")
    local fpsStat = createStat("FPS", "FPS", "60")
    local ramStat = createStat("RAM", "RAM", "0.0 GB")
    local pingStat = createStat("Ping", "Ping", "0ms")
    local timeStat = createStat("Time", "Time", "00:00")

    -- Auto Stats Update
    local lastTime = tick()
    local frameCount = 0
    local statsUpdateConn = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTime >= 1 then
            fpsStat.Text = tostring(frameCount)
            frameCount = 0
            lastTime = tick()
            
            -- Simple RAM/Ping estimation for showcase (can be refined)
            ramStat.Text = string.format("%.1f GB", collectgarbage("count") / 1024 / 1024)
            pingStat.Text = math.floor(Services.Players.LocalPlayer:GetNetworkPing() * 1000) .. "ms"
            timeStat.Text = os.date("%H:%M")
        end
    end)
    table.insert(_G.RoseUI_Connections, statsUpdateConn)

    -- Window Controls
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 110, 1, 0)
    controls.Position = UDim2.new(1, -110, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header
    
    local cLayout = Instance.new("UIListLayout")
    cLayout.FillDirection = Enum.FillDirection.Horizontal
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    cLayout.Padding = UDim.new(0, 4)
    cLayout.Parent = controls

    local function createControl(iconName, callback)
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.BackgroundTransparency = 1
        btn.Image = assets.Icons[iconName]
        btn.ImageColor3 = theme.SecondaryText
        btn.ImageTransparency = 0.2
        btn.Parent = controls
        
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = theme.Primary, ImageTransparency = 0}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = theme.SecondaryText, ImageTransparency = 0.2}):Play() end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createControl("Minimize", function() screenGui.Enabled = false end)
    createControl("Restore", function() print("Toggle Size") end) -- Placeholder for Maximize
    createControl("Close", function() screenGui:Destroy() end)

    -- Body
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -40)
    body.Position = UDim2.new(0, 0, 0, 40)
    body.BackgroundTransparency = 1
    body.Parent = mainFrame

    -- Sidebar (192px)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 192, 1, 0)
    sidebar.BackgroundColor3 = theme.Accent
    sidebar.BackgroundTransparency = 0.7
    sidebar.BorderSizePixel = 0
    sidebar.Parent = body
    
    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    sidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    sidebarBorder.BackgroundColor3 = Color3.new(1,1,1)
    sidebarBorder.BackgroundTransparency = 0.95
    sidebarBorder.BorderSizePixel = 0
    sidebarBorder.Parent = sidebar

    -- Profile Section
    local profile = Instance.new("Frame")
    profile.Size = UDim2.new(1, 0, 0, 70)
    profile.BackgroundTransparency = 1
    profile.Parent = sidebar
    
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 40, 0, 40)
    avatarFrame.Position = UDim2.new(0, 15, 0.5, -20)
    avatarFrame.BackgroundColor3 = theme.DeepAccent
    avatarFrame.Parent = profile
    Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", avatarFrame).Color = theme.Primary
    
    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, -4, 1, -4)
    avatarImg.Position = UDim2.new(0, 2, 0, 2)
    avatarImg.BackgroundTransparency = 1
    
    local userId = Services.Players.LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Services.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    avatarImg.Image = content or assets.Icons.User
    avatarImg.ImageColor3 = Color3.new(1,1,1) -- No tint for real avatar
    avatarImg.Parent = avatarFrame
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
    
    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(1, -70, 0, 14)
    userName.Position = UDim2.new(0, 65, 0.5, -12)
    userName.BackgroundTransparency = 1
    userName.Text = Services.Players.LocalPlayer.Name
    userName.TextColor3 = theme.Text
    userName.Font = Enum.Font.GothamBold
    userName.TextSize = 11
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = profile
    
    local userStatus = Instance.new("TextLabel")
    userStatus.Size = UDim2.new(1, -70, 0, 12)
    userStatus.Position = UDim2.new(0, 65, 0.5, 2)
    userStatus.BackgroundTransparency = 1
    userStatus.Text = "ACTIVE NOW"
    userStatus.TextColor3 = theme.SecondaryText
    userStatus.Font = Enum.Font.GothamBold
    userStatus.TextSize = 9
    userStatus.TextXAlignment = Enum.TextXAlignment.Left
    userStatus.Parent = profile

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -30, 0, 1)
    sep.Position = UDim2.new(0, 15, 1, 0)
    sep.BackgroundColor3 = Color3.new(1,1,1)
    sep.BackgroundTransparency = 0.95
    sep.BorderSizePixel = 0
    sep.Parent = profile

    -- Navigation
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -110)
    navScroll.Position = UDim2.new(0, 0, 0, 70)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 2
    navScroll.ScrollBarImageColor3 = theme.Primary
    navScroll.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.Parent = navScroll

    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "ContentArea"
    content.Size = UDim2.new(1, -192, 1, 0)
    content.Position = UDim2.new(0, 192, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = body
    
    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, 0, 1, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = content

    -- Footer
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.Parent = sidebar
    
    local versionLbl = Instance.new("TextLabel")
    versionLbl.Size = UDim2.new(1, 0, 1, 0)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = hubType
    versionLbl.TextColor3 = theme.MutedText
    versionLbl.Font = Enum.Font.GothamBold
    versionLbl.TextSize = 9
    versionLbl.Parent = footer

    local WindowObj = {
        Instance = screenGui,
        MainFrame = mainFrame,
        CurrentTab = nil,
        Tabs = {},
        Elements = {},
        ID = currentID,
        Library = library,
        Theme = theme,
        PageContainer = pageContainer,
        NavScroll = navScroll
    }

    function WindowObj:MakeTab(tabOptions)
        return library.Tab:New(tabOptions, self)
    end

    -- Toggle Hotkey
    local toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    table.insert(_G.RoseUI_Connections, toggleConn)

    return WindowObj
end

return Window
