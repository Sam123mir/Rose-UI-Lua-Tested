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
    
    local finalLogo = options.Logo or "Logo"
    if tonumber(finalLogo) or string.find(tostring(finalLogo), "rbxassetid://") then
        finalLogo = string.find(tostring(finalLogo), "rbxassetid://") and finalLogo or "rbxassetid://" .. finalLogo
    else
        finalLogo = assets.Icons[finalLogo] or assets.Icons.Logo
    end
    
    logoIcon.Image = finalLogo
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
    statsFrame.Size = UDim2.new(0, 420, 1, 0)
    statsFrame.Position = UDim2.new(0.5, 40, 0, 0)
    statsFrame.AnchorPoint = Vector2.new(0.5, 0)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Parent = header

    -- Bottom Glow (Refined Red)
    local bottomGlow = Instance.new("ImageLabel")
    bottomGlow.Name = "BottomGlow"
    bottomGlow.Size = UDim2.new(1.2, 0, 0, 150)
    bottomGlow.Position = UDim2.new(0.5, 0, 1, 0)
    bottomGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    bottomGlow.BackgroundTransparency = 1
    bottomGlow.Image = "rbxassetid://6015667101" -- Blur Circle
    bottomGlow.ImageColor3 = theme.Primary
    bottomGlow.ImageTransparency = 0.85
    bottomGlow.ZIndex = 0
    bottomGlow.Parent = mainFrame
    
    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statsLayout.Padding = UDim.new(0, 0)
    statsLayout.Parent = statsFrame

    local function createStat(iconName, shortName, defaultVal)
        local item = Instance.new("Frame")
        item.Size = UDim2.new(0, 100, 1, 0)
        item.BackgroundTransparency = 1
        item.Parent = statsFrame
        
        -- Icon (will show if asset is valid)
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 14, 0, 14)
        icon.Position = UDim2.new(0, 8, 0.5, -7)
        icon.BackgroundTransparency = 1
        icon.Image = assets.Icons[iconName] or ""
        icon.ImageColor3 = theme.SecondaryText
        icon.Parent = item

        -- Text fallback label (always visible, shows short name when icon fails)
        local fallbackLabel = Instance.new("TextLabel")
        fallbackLabel.Size = UDim2.new(0, 14, 0, 14)
        fallbackLabel.Position = UDim2.new(0, 8, 0.5, -7)
        fallbackLabel.BackgroundTransparency = 1
        fallbackLabel.Text = shortName
        fallbackLabel.TextColor3 = theme.SecondaryText
        fallbackLabel.Font = Enum.Font.GothamBlack
        fallbackLabel.TextSize = 7
        fallbackLabel.ZIndex = 2
        fallbackLabel.Parent = item
        
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

    local gameStat = createStat("Game", "G", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Game")
    local fpsStat = createStat("FPS", "F", "60")
    local ramStat = createStat("RAM", "R", "0.0 GB")
    local pingStat = createStat("Ping", "P", "0ms")
    local timeStat = createStat("Time", "T", "00:00")

    -- Auto Stats Update
    local lastUpdate = tick()
    local frames = 0
    local statsUpdateConn = RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        local now = tick()
        
        if now - lastUpdate >= 1 then
            -- FPS
            fpsStat.Text = tostring(frames)
            frames = 0
            lastUpdate = now
            
            -- RAM (Total memory usage in MB)
            local totalMem = Services.Stats:GetTotalMemoryUsageMb()
            ramStat.Text = string.format("%.0f MB", totalMem)
            
            -- Ping
            local ping = math.floor(Services.Players.LocalPlayer:GetNetworkPing() * 1000)
            pingStat.Text = ping .. "ms"
            
            -- Time (User's local time)
            timeStat.Text = os.date("%H:%M:%S")
        end
    end)
    table.insert(_G.RoseUI_Connections, statsUpdateConn)

    -- ========================================================================
    -- Window Controls (Text-based fallback for missing icons)
    -- ========================================================================
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 110, 1, 0)
    controls.Position = UDim2.new(1, -8, 0, 0)
    controls.AnchorPoint = Vector2.new(1, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header
    
    local cLayout = Instance.new("UIListLayout")
    cLayout.FillDirection = Enum.FillDirection.Horizontal
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = controls

    local function createControl(fallbackText, hoverColor, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.95
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = controls
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        -- Text label for the control symbol
        local symbolLabel = Instance.new("TextLabel")
        symbolLabel.Size = UDim2.new(1, 0, 1, 0)
        symbolLabel.BackgroundTransparency = 1
        symbolLabel.Text = fallbackText
        symbolLabel.TextColor3 = theme.SecondaryText
        symbolLabel.Font = Enum.Font.GothamBold
        symbolLabel.TextSize = 14
        symbolLabel.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, BackgroundColor3 = hoverColor}):Play()
            TweenService:Create(symbolLabel, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            TweenService:Create(symbolLabel, TweenInfo.new(0.2), {TextColor3 = theme.SecondaryText}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ========================================================================
    -- Minimized State Bar
    -- ========================================================================
    local minBar = Instance.new("Frame")
    minBar.Name = "MinimizedBar"
    minBar.Size = UDim2.new(0, 220, 0, 42)
    minBar.Position = UDim2.new(0.5, -110, 0.05, 0)
    minBar.BackgroundColor3 = theme.Background
    minBar.BackgroundTransparency = 0.05
    minBar.BorderSizePixel = 0
    minBar.Visible = false
    minBar.Active = true
    minBar.Parent = screenGui
    Instance.new("UICorner", minBar).CornerRadius = UDim.new(0, 8)
    
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = theme.Primary
    minStroke.Transparency = 0.7
    minStroke.Thickness = 1
    minStroke.Parent = minBar
    
    -- Hitbox for dragging
    local minGripHitbox = Instance.new("Frame")
    minGripHitbox.Size = UDim2.new(0, 40, 1, 0)
    minGripHitbox.BackgroundTransparency = 1
    minGripHitbox.Parent = minBar
    
    library.Utilities:MakeDraggable(minBar, minGripHitbox)

    local minGrip = Instance.new("ImageLabel")
    minGrip.Size = UDim2.new(0, 16, 0, 16)
    minGrip.Position = UDim2.new(0.5, -8, 0.5, -8)
    minGrip.BackgroundTransparency = 1
    minGrip.Image = assets.Icons.Sliders or "rbxassetid://10734914191"
    minGrip.ImageColor3 = theme.SecondaryText
    minGrip.Parent = minGripHitbox
    
    local minSep = Instance.new("Frame")
    minSep.Size = UDim2.new(0, 1, 0, 20)
    minSep.Position = UDim2.new(0, 40, 0.5, -10)
    minSep.BackgroundColor3 = Color3.new(1,1,1)
    minSep.BackgroundTransparency = 0.9
    minSep.BorderSizePixel = 0
    minSep.Parent = minBar
    
    -- Button for restoring
    local restoreBtn = Instance.new("TextButton")
    restoreBtn.Size = UDim2.new(1, -41, 1, 0)
    restoreBtn.Position = UDim2.new(0, 41, 0, 0)
    restoreBtn.BackgroundColor3 = Color3.new(1,1,1)
    restoreBtn.BackgroundTransparency = 1
    restoreBtn.Text = ""
    restoreBtn.AutoButtonColor = false
    restoreBtn.Parent = minBar
    Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(0, 8)
    
    local minLogo = Instance.new("ImageLabel")
    minLogo.Size = UDim2.new(0, 18, 0, 18)
    minLogo.Position = UDim2.new(0, 12, 0.5, -9)
    minLogo.BackgroundTransparency = 1
    minLogo.Image = finalLogo
    minLogo.ImageColor3 = theme.Primary
    minLogo.Parent = restoreBtn
    
    local minTitle = Instance.new("TextLabel")
    minTitle.Size = UDim2.new(1, -40, 1, 0)
    minTitle.Position = UDim2.new(0, 38, 0, 0)
    minTitle.BackgroundTransparency = 1
    minTitle.Text = titleText:upper()
    minTitle.TextColor3 = theme.Text
    minTitle.Font = Enum.Font.GothamBlack
    minTitle.TextSize = 12
    minTitle.TextXAlignment = Enum.TextXAlignment.Left
    minTitle.Parent = restoreBtn
    
    restoreBtn.MouseEnter:Connect(function()
        TweenService:Create(restoreBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
    end)
    restoreBtn.MouseLeave:Connect(function()
        TweenService:Create(restoreBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    restoreBtn.MouseButton1Click:Connect(function()
        minBar.Visible = false
        mainFrame.Visible = true
    end)

    createControl("-", theme.Primary, function() 
        mainFrame.Visible = false
        minBar.Visible = true
    end) -- Minimize
    createControl("□", theme.Primary, function() print("Toggle Size") end)       -- Maximize
    createControl("×", Color3.fromRGB(220, 50, 50), function() screenGui:Destroy() end)  -- Close

    -- ========================================================================
    -- Body
    -- ========================================================================
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -40)
    body.Position = UDim2.new(0, 0, 0, 40)
    body.BackgroundTransparency = 1
    body.Parent = mainFrame

    -- ========================================================================
    -- Sidebar (192px) - Enhanced
    -- ========================================================================
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 192, 1, 0)
    sidebar.BackgroundColor3 = theme.Accent
    sidebar.BackgroundTransparency = 0.4
    sidebar.BorderSizePixel = 0
    sidebar.Parent = body
    
    -- Sidebar subtle gradient overlay
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    sidebarGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(1, 1)
    })
    sidebarGradient.Rotation = 90
    sidebarGradient.Parent = sidebar

    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    sidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    sidebarBorder.BackgroundColor3 = theme.Primary
    sidebarBorder.BackgroundTransparency = 0.88
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
    local avatarStroke = Instance.new("UIStroke", avatarFrame)
    avatarStroke.Color = theme.Primary
    avatarStroke.Thickness = 1.5
    
    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, -4, 1, -4)
    avatarImg.Position = UDim2.new(0, 2, 0, 2)
    avatarImg.BackgroundTransparency = 1
    
    local userId = Services.Players.LocalPlayer.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Services.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    avatarImg.Image = content or assets.Icons.User
    avatarImg.ImageColor3 = Color3.new(1,1,1)
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
    userStatus.TextColor3 = Color3.fromRGB(80, 200, 80) -- Green for active
    userStatus.Font = Enum.Font.GothamBold
    userStatus.TextSize = 9
    userStatus.TextXAlignment = Enum.TextXAlignment.Left
    userStatus.Parent = profile

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -30, 0, 1)
    sep.Position = UDim2.new(0, 15, 1, 0)
    sep.BackgroundColor3 = theme.Primary
    sep.BackgroundTransparency = 0.75
    sep.BorderSizePixel = 0
    sep.Parent = profile

    -- ========================================================================
    -- Search Bar (Between Profile and Navigation)
    -- ========================================================================
    local searchBarFrame = Instance.new("Frame")
    searchBarFrame.Size = UDim2.new(1, -24, 0, 32)
    searchBarFrame.Position = UDim2.new(0, 12, 0, 78)
    searchBarFrame.BackgroundColor3 = theme.Surface
    searchBarFrame.BackgroundTransparency = 0.3
    searchBarFrame.Parent = sidebar
    Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(0, 10)
    
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.new(1,1,1)
    searchStroke.Transparency = 0.92
    searchStroke.Thickness = 1
    searchStroke.Parent = searchBarFrame

    -- Search icon (text fallback)
    local searchIcon = Instance.new("TextLabel")
    searchIcon.Size = UDim2.new(0, 20, 0, 20)
    searchIcon.Position = UDim2.new(0, 8, 0.5, -10)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.TextSize = 12
    searchIcon.Parent = searchBarFrame

    -- Also try image icon
    local searchIconImg = Instance.new("ImageLabel")
    searchIconImg.Size = UDim2.new(0, 14, 0, 14)
    searchIconImg.Position = UDim2.new(0, 10, 0.5, -7)
    searchIconImg.BackgroundTransparency = 1
    searchIconImg.Image = assets.Icons.Search or ""
    searchIconImg.ImageColor3 = theme.MutedText
    searchIconImg.ZIndex = 3
    searchIconImg.Parent = searchBarFrame

    local searchTextbox = Instance.new("TextBox")
    searchTextbox.Size = UDim2.new(1, -38, 1, 0)
    searchTextbox.Position = UDim2.new(0, 30, 0, 0)
    searchTextbox.BackgroundTransparency = 1
    searchTextbox.Text = ""
    searchTextbox.PlaceholderText = "Search..."
    searchTextbox.PlaceholderColor3 = theme.MutedText
    searchTextbox.TextColor3 = theme.Text
    searchTextbox.Font = Enum.Font.Gotham
    searchTextbox.TextSize = 10
    searchTextbox.TextXAlignment = Enum.TextXAlignment.Left
    searchTextbox.ClearTextOnFocus = false
    searchTextbox.Parent = searchBarFrame

    -- Focus effects
    searchTextbox.Focused:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.2), {Color = theme.Primary, Transparency = 0.5}):Play()
        TweenService:Create(searchBarFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    end)
    searchTextbox.FocusLost:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.2), {Color = Color3.new(1,1,1), Transparency = 0.92}):Play()
        TweenService:Create(searchBarFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)

    -- Navigation (adjusted position to account for search bar)
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -150)
    navScroll.Position = UDim2.new(0, 0, 0, 118)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 2
    navScroll.ScrollBarImageColor3 = theme.Primary
    navScroll.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.Parent = navScroll

    -- ========================================================================
    -- Content Area
    -- ========================================================================
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -192, 1, 0)
    contentArea.Position = UDim2.new(0, 192, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = body
    
    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, 0, 1, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = contentArea

    -- "No Results Found" Message (hidden by default)
    local noResultsFrame = Instance.new("Frame")
    noResultsFrame.Size = UDim2.new(1, 0, 1, 0)
    noResultsFrame.BackgroundTransparency = 1
    noResultsFrame.Visible = false
    noResultsFrame.ZIndex = 50
    noResultsFrame.Parent = contentArea

    local noResultsLabel = Instance.new("TextLabel")
    noResultsLabel.Size = UDim2.new(1, 0, 0, 30)
    noResultsLabel.Position = UDim2.new(0, 0, 0.5, -40)
    noResultsLabel.BackgroundTransparency = 1
    noResultsLabel.Text = "No results found"
    noResultsLabel.TextColor3 = theme.MutedText
    noResultsLabel.Font = Enum.Font.GothamBold
    noResultsLabel.TextSize = 16
    noResultsLabel.Parent = noResultsFrame

    local noResultsSub = Instance.new("TextLabel")
    noResultsSub.Size = UDim2.new(1, 0, 0, 20)
    noResultsSub.Position = UDim2.new(0, 0, 0.5, -8)
    noResultsSub.BackgroundTransparency = 1
    noResultsSub.Text = "Try a different search term"
    noResultsSub.TextColor3 = theme.MutedText
    noResultsSub.Font = Enum.Font.Gotham
    noResultsSub.TextSize = 11
    noResultsSub.TextTransparency = 0.4
    noResultsSub.Parent = noResultsFrame

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

    -- ========================================================================
    -- Window Object
    -- ========================================================================
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
        NavScroll = navScroll,
        NoResultsFrame = noResultsFrame
    }

    -- ========================================================================
    -- Search Filtering Logic
    -- ========================================================================
    local function performSearch(query)
        query = string.lower(query)
        local anyVisible = false

        if query == "" then
            -- Show everything
            for _, child in pairs(navScroll:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = true
                end
            end
            noResultsFrame.Visible = false
            -- Show current tab's page
            if WindowObj.CurrentTab then
                WindowObj.CurrentTab.Page.Visible = true
            end
            return
        end

        -- Hide all pages while searching
        for _, tab in pairs(WindowObj.Tabs) do
            tab.Page.Visible = false
        end

        for _, child in pairs(navScroll:GetChildren()) do
            if child:IsA("Frame") then
                local childName = string.lower(child.Name)
                -- Check if the name contains the query
                if string.find(childName, query, 1, true) then
                    child.Visible = true
                    anyVisible = true
                else
                    -- For folders, also check children (files inside)
                    local filesContainer = child:FindFirstChild("Files")
                    if filesContainer then
                        local folderHasMatch = false
                        for _, fileChild in pairs(filesContainer:GetChildren()) do
                            if fileChild:IsA("Frame") then
                                if string.find(string.lower(fileChild.Name), query, 1, true) then
                                    folderHasMatch = true
                                    break
                                end
                            end
                        end
                        if folderHasMatch then
                            child.Visible = true
                            anyVisible = true
                        else
                            child.Visible = false
                        end
                    else
                        child.Visible = false
                    end
                end
            end
        end

        noResultsFrame.Visible = not anyVisible
        -- If we found results, show the tab of the first visible match
        if anyVisible and WindowObj.CurrentTab then
            WindowObj.CurrentTab.Page.Visible = true
        end
    end

    searchTextbox:GetPropertyChangedSignal("Text"):Connect(function()
        performSearch(searchTextbox.Text)
    end)

    -- Window Resize Handler (Bottom-Right)
    local resizeHandle = Instance.new("ImageButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Image = "rbxassetid://10723415903" -- Small indicator
    resizeHandle.ImageColor3 = theme.Primary
    resizeHandle.ImageTransparency = 0.8
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = mainFrame
    
    library.Utilities:MakeResizable(resizeHandle, mainFrame, Vector2.new(600, 400))

    function WindowObj:MakeTab(tabOptions)
        return library.Tab:New(tabOptions, self)
    end

    function WindowObj:AddFolder(folderOptions)
        return library.Folder:New(folderOptions, self)
    end
    
    -- Auto Update Canvas Size & Layout Adjustments
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

    mainFrame:GetPropertyChangedSignal("Size"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

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
