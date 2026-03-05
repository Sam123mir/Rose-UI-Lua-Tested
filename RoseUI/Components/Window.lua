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
    local iconAPI = options.Icons

    local function resolveIcon(iconAsset)
        if not iconAsset or iconAsset == "" then return "" end
        if type(iconAsset) == "table" then return iconAsset end
        
        if iconAPI and type(iconAsset) == "string" and string.find(iconAsset, ":") then
            local resolved = iconAPI.GetIcon(iconAsset)
            if resolved then return resolved end
        end
        return iconAsset
    end

    _G.RoseBase_ID = (_G.RoseBase_ID or 0) + 1
    local currentID = _G.RoseBase_ID

    local language = options.Language or "en"
    local locales = {
        en = {
            searchFeatures = "Type to search features...",
            noFeatures = "No features found",
            inText = "in",
            activeNow = "ACTIVE NOW",
            dialogConfirm = "Confirm",
            dialogCancel = "Cancel",
            confirmExit = "Are you sure you want to close the UI? You can reopen it by running the script again.",
            exitTitle = "Confirm Exit"
        },
        es = {
            searchFeatures = "Buscar funciones...",
            noFeatures = "No se encontraron funciones",
            inText = "en",
            activeNow = "ACTIVO AHORA",
            dialogConfirm = "Confirmar",
            dialogCancel = "Cancelar",
            confirmExit = "¿Estás seguro de que deseas cerrar la UI? Podrás volver a abrirla ejecutando el script.",
            exitTitle = "Confirmar Cierre"
        },
        br = {
            searchFeatures = "Pesquisar funções...",
            noFeatures = "Nenhuma função encontrada",
            inText = "em",
            activeNow = "ATIVO AGORA",
            dialogConfirm = "Confirmar",
            dialogCancel = "Cancelar",
            confirmExit = "Tem certeza que deseja fechar a UI? Você pode reabri-la executando o script novamente.",
            exitTitle = "Confirmar Fechadura"
        },
        fr = {
            searchFeatures = "Rechercher...",
            noFeatures = "Aucune fonction trouvée",
            inText = "dans",
            activeNow = "ACTIF",
            dialogConfirm = "Confirmer",
            dialogCancel = "Annuler",
            confirmExit = "Êtes-vous sûr de vouloir fermer l'interface ? Vous pourrez la rouvrir en exécutant le script.",
            exitTitle = "Confirmer la Fermeture"
        }
    }
    local langData = locales[language] or locales["en"]
    
    local WindowObj = {} -- Forward declaration para que todo el stack de UI tenga alcance

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
    local finalWidth = 860
    local finalHeight = 540

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
        if not mainFrame or not mainFrame.Parent or not screenGui.Enabled or not mainFrame.Visible then
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
    if type(finalLogo) == "string" then
        if tonumber(finalLogo) or string.find(tostring(finalLogo), "rbxassetid://") then
            finalLogo = string.find(tostring(finalLogo), "rbxassetid://") and finalLogo or "rbxassetid://" .. finalLogo
        else
            finalLogo = resolveIcon(assets.Icons[finalLogo] or assets.Icons.Logo)
        end
    end
    
    if type(finalLogo) == "table" then
        logoIcon.Image = finalLogo.Image or ""
        logoIcon.ImageRectOffset = finalLogo.ImageRectOffset or Vector2.new(0,0)
        logoIcon.ImageRectSize = finalLogo.ImageRectSize or Vector2.new(0,0)
    else
        logoIcon.Image = finalLogo
    end
    logoIcon.ImageColor3 = theme.Primary
    logoIcon.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 70, 1, 0)
    title.Position = UDim2.new(0, 38, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ROSEUI"
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Removed discordBtn from header as requested

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
        
        local iconAsset = resolveIcon(assets.Icons[iconName] or "")
        if type(iconAsset) == "table" then
            icon.Image = iconAsset.Image or ""
            icon.ImageRectOffset = iconAsset.ImageRectOffset or Vector2.new(0,0)
            icon.ImageRectSize = iconAsset.ImageRectSize or Vector2.new(0,0)
        else
            icon.Image = iconAsset
        end
        icon.ImageColor3 = theme.SecondaryText
        icon.Parent = item

        -- Text fallback label (hidden if icon exists)
        local fallbackLabel = Instance.new("TextLabel")
        fallbackLabel.Size = UDim2.new(0, 14, 0, 14)
        fallbackLabel.Position = UDim2.new(0, 8, 0.5, -7)
        fallbackLabel.BackgroundTransparency = 1
        fallbackLabel.Text = shortName
        fallbackLabel.TextColor3 = theme.SecondaryText
        fallbackLabel.Font = Enum.Font.GothamBlack
        fallbackLabel.TextSize = 7
        fallbackLabel.ZIndex = 2
        fallbackLabel.Visible = (icon.Image == "")
        fallbackLabel.Parent = item
        
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -32, 1, 0)
        val.Position = UDim2.new(0, 30, 0, 0)
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
        
        item.Size = UDim2.new(0, val.TextBounds.X + 44, 1, 0)
        val:GetPropertyChangedSignal("Text"):Connect(function()
            item.Size = UDim2.new(0, val.TextBounds.X + 44, 1, 0)
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

    local function createControl(iconName, fallbackText, hoverColor, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.95
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = controls
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        local btnIcon = Instance.new("ImageLabel")
        btnIcon.Size = UDim2.new(0, 14, 0, 14)
        btnIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
        btnIcon.BackgroundTransparency = 1
        local iAsset = resolveIcon(assets.Icons[iconName] or "")
        if type(iAsset) == "table" then
            btnIcon.Image = iAsset.Image or ""
            btnIcon.ImageRectOffset = iAsset.ImageRectOffset or Vector2.new(0,0)
            btnIcon.ImageRectSize = iAsset.ImageRectSize or Vector2.new(0,0)
        else
            btnIcon.Image = iAsset
        end
        btnIcon.ImageColor3 = theme.SecondaryText
        btnIcon.Parent = btn

        -- Text label for fallback
        local symbolLabel = Instance.new("TextLabel")
        symbolLabel.Size = UDim2.new(1, 0, 1, 0)
        symbolLabel.BackgroundTransparency = 1
        symbolLabel.Text = fallbackText
        symbolLabel.TextColor3 = theme.SecondaryText
        symbolLabel.Font = Enum.Font.GothamBold
        symbolLabel.TextSize = 14
        symbolLabel.Visible = (btnIcon.Image == "")
        symbolLabel.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7, BackgroundColor3 = hoverColor}):Play()
            TweenService:Create(symbolLabel, TweenInfo.new(0.2), {TextColor3 = Color3.new(1,1,1)}):Play()
            TweenService:Create(btnIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1,1,1)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            TweenService:Create(symbolLabel, TweenInfo.new(0.2), {TextColor3 = theme.SecondaryText}):Play()
            TweenService:Create(btnIcon, TweenInfo.new(0.2), {ImageColor3 = theme.SecondaryText}):Play()
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
    minGripHitbox.Active = true -- Asegura que reciba inputs
    minGripHitbox.BackgroundTransparency = 1
    minGripHitbox.Parent = minBar
    
    library.Utilities:MakeDraggable(minGripHitbox, minBar)

    local minGrip = Instance.new("ImageLabel")
    minGrip.Size = UDim2.new(0, 16, 0, 16)
    minGrip.Position = UDim2.new(0.5, -8, 0.5, -8)
    minGrip.BackgroundTransparency = 1
    
    local safeMinGrip = resolveIcon(options.MiniGripIcon or "lucide:grip-vertical")
    if type(safeMinGrip) == "table" then
        minGrip.Image = safeMinGrip.Image or ""
        minGrip.ImageRectOffset = safeMinGrip.ImageRectOffset or Vector2.new(0,0)
        minGrip.ImageRectSize = safeMinGrip.ImageRectSize or Vector2.new(0,0)
    else
        minGrip.Image = safeMinGrip or ""
    end
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
    if type(finalLogo) == "table" then
        minLogo.Image = finalLogo.Image or ""
        minLogo.ImageRectOffset = finalLogo.ImageRectOffset or Vector2.new(0,0)
        minLogo.ImageRectSize = finalLogo.ImageRectSize or Vector2.new(0,0)
    else
        minLogo.Image = finalLogo
    end
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

    local isMaximized = false
    local prevSize = mainFrame.Size
    local prevPos = mainFrame.Position

    createControl("Minimize", "-", theme.Primary, function() 
        mainFrame.Visible = false
        minBar.Visible = true
    end)
    
    createControl("Maximize", "□", theme.Primary, function() 
        if not isMaximized then
            prevSize = mainFrame.Size
            prevPos = mainFrame.Position
            
            local viewSize = workspace.CurrentCamera.ViewportSize
            local targetWidth = math.min(viewSize.X * 0.95, 1100)
            local targetHeight = math.min(viewSize.Y * 0.95, 750)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, targetWidth, 0, targetHeight),
                Position = UDim2.new(0.5, -targetWidth/2, 0.5, -targetHeight/2)
            }):Play()
            isMaximized = true
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = prevSize,
                Position = prevPos
            }):Play()
            isMaximized = false
        end
    end)

    createControl("Close", "×", Color3.fromRGB(220, 50, 50), function() 
        if WindowObj.ShowDialog then
            WindowObj:ShowDialog({
                Title = langData.exitTitle,
                Message = langData.confirmExit,
                ConfirmText = langData.dialogConfirm,
                CancelText = langData.dialogCancel,
                OnConfirm = function()
                    screenGui:Destroy()
                end
            })
        else
            screenGui:Destroy()
        end
    end)

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
    -- Sidebar (220px) - Enhanced & Centered
    -- ========================================================================
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 240, 1, 0)
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

    -- Profile Section (Centered)
    local profile = Instance.new("Frame")
    profile.Size = UDim2.new(1, 0, 0, 90)
    profile.BackgroundTransparency = 1
    profile.Parent = sidebar
    
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(0, 44, 0, 44)
    avatarFrame.Position = UDim2.new(0.5, -22, 0, 12)
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
    
    avatarImg.Image = content or resolveIcon(assets.Icons.User)
    avatarImg.ImageColor3 = Color3.new(1,1,1)
    avatarImg.Parent = avatarFrame
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
    
    local userName = Instance.new("TextLabel")
    userName.Size = UDim2.new(1, 0, 0, 14)
    userName.Position = UDim2.new(0, 0, 0, 62)
    userName.BackgroundTransparency = 1
    userName.Text = Services.Players.LocalPlayer.Name
    userName.TextColor3 = theme.Text
    userName.Font = Enum.Font.GothamBold
    userName.TextSize = 12
    userName.TextXAlignment = Enum.TextXAlignment.Center
    userName.Parent = profile
    
    local userStatus = Instance.new("TextLabel")
    userStatus.Size = UDim2.new(1, 0, 0, 12)
    userStatus.Position = UDim2.new(0, 0, 0, 78)
    userStatus.BackgroundTransparency = 1
    userStatus.Text = "● " .. langData.activeNow
    userStatus.TextColor3 = Color3.fromRGB(0, 255, 128) -- Vibrant Green for active
    userStatus.Font = Enum.Font.GothamBold
    userStatus.TextSize = 9
    userStatus.TextXAlignment = Enum.TextXAlignment.Center
    userStatus.Parent = profile

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -40, 0, 1)
    sep.Position = UDim2.new(0, 20, 1, 4)
    sep.BackgroundColor3 = theme.Primary
    sep.BackgroundTransparency = 0.85
    sep.BorderSizePixel = 0
    sep.Parent = profile

    -- ========================================================================
    -- Search Bar (Centered, Dark, Red Icon)
    -- ========================================================================
    local searchBarFrame = Instance.new("TextButton")
    searchBarFrame.Name = "SearchBarTrigger"
    searchBarFrame.Size = UDim2.new(1, -24, 0, 34)
    searchBarFrame.Position = UDim2.new(0, 12, 0, 105)
    searchBarFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05) -- Very Dark background
    searchBarFrame.BackgroundTransparency = 0.2
    searchBarFrame.AutoButtonColor = false
    searchBarFrame.Text = ""
    searchBarFrame.Parent = sidebar
    Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(1, 0)
    
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = theme.Primary
    searchStroke.Transparency = 1 -- Hidden by default
    searchStroke.Thickness = 1
    searchStroke.Parent = searchBarFrame

    local searchIconImg = Instance.new("ImageLabel")
    searchIconImg.Size = UDim2.new(0, 14, 0, 14)
    searchIconImg.Position = UDim2.new(0, 14, 0.5, -7)
    searchIconImg.BackgroundTransparency = 1
    
    local resolvedSearch = resolveIcon(assets.Icons.Search)
    if type(resolvedSearch) == "table" then
        searchIconImg.Image = resolvedSearch.Image or ""
        searchIconImg.ImageRectOffset = resolvedSearch.ImageRectOffset or Vector2.new(0,0)
        searchIconImg.ImageRectSize = resolvedSearch.ImageRectSize or Vector2.new(0,0)
    else
        searchIconImg.Image = resolvedSearch or ""
    end
    searchIconImg.ImageColor3 = theme.Primary
    searchIconImg.ZIndex = 3
    searchIconImg.Parent = searchBarFrame

    local searchFakeText = Instance.new("TextLabel")
    searchFakeText.Size = UDim2.new(1, -44, 1, 0)
    searchFakeText.Position = UDim2.new(0, 36, 0, 0)
    searchFakeText.BackgroundTransparency = 1
    searchFakeText.Text = langData.searchFeatures
    searchFakeText.TextColor3 = theme.MutedText
    searchFakeText.Font = Enum.Font.Gotham
    searchFakeText.TextSize = 10
    searchFakeText.TextXAlignment = Enum.TextXAlignment.Left
    searchFakeText.Parent = searchBarFrame

    searchBarFrame.MouseEnter:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        TweenService:Create(searchBarFrame, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play()
    end)
    searchBarFrame.MouseLeave:Connect(function()
        TweenService:Create(searchStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(searchBarFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.05, 0.05, 0.05), BackgroundTransparency = 0.2}):Play()
    end)

    -- Navigation (adjusted position to account for search bar and centering)
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -180)
    navScroll.Position = UDim2.new(0, 0, 0, 150)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 2
    navScroll.ScrollBarImageColor3 = theme.Primary
    navScroll.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 4)
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navScroll

    -- ========================================================================
    -- Content Area
    -- ========================================================================
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -240, 1, 0)
    contentArea.Position = UDim2.new(0, 240, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = body
    
    local pageContainer = Instance.new("Frame")
    pageContainer.Size = UDim2.new(1, 0, 1, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.Parent = contentArea

    -- Modificamos "No Results Found" para que pertenezca al modal después, así que lo borramos del contentArea.

    -- Footer
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.Parent = sidebar
    
    local versionLbl = Instance.new("TextLabel")
    versionLbl.Size = UDim2.new(1, -40, 1, 0)
    versionLbl.Position = UDim2.new(0, 14, 0, 0)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = hubType:upper()
    versionLbl.TextColor3 = theme.MutedText
    versionLbl.Font = Enum.Font.GothamBold
    versionLbl.TextSize = 9
    versionLbl.TextXAlignment = Enum.TextXAlignment.Left
    versionLbl.Parent = footer

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 16, 0, 16)
    discordBtn.Position = UDim2.new(1, -26, 0.5, -8)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BackgroundTransparency = 1
    discordBtn.Text = ""
    discordBtn.Parent = footer
    
    local dscIcon = Instance.new("ImageLabel")
    dscIcon.Size = UDim2.new(1, 0, 1, 0)
    dscIcon.BackgroundTransparency = 1
    local dIcon = resolveIcon(options.DiscordIcon or "lucide:message-square")
    if type(dIcon) == "table" then
        dscIcon.Image = dIcon.Image or ""
        dscIcon.ImageRectOffset = dIcon.ImageRectOffset or Vector2.new(0,0)
        dscIcon.ImageRectSize = dIcon.ImageRectSize or Vector2.new(0,0)
    else
        dscIcon.Image = dIcon
    end
    dscIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    dscIcon.Parent = discordBtn
    
    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard and options.DiscordLink then
            setclipboard(options.DiscordLink)
            if WindowObj.Notify then
                WindowObj:Notify({Title = "Discord", Text = "Link copied to clipboard!", Duration = 3})
            end
        end
    end)
    discordBtn.MouseEnter:Connect(function() TweenService:Create(dscIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(88, 101, 242)}):Play() end)
    discordBtn.MouseLeave:Connect(function() TweenService:Create(dscIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)

    -- ========================================================================
    -- Window Object
    -- ========================================================================
    WindowObj = {
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

    -- ========================================================================
    -- Search Modal (Interactive Spotlight)
    -- ========================================================================
    local searchModal = Instance.new("Frame")
    searchModal.Name = "SearchModal"
    searchModal.Size = UDim2.new(1, 0, 1, 0)
    searchModal.BackgroundColor3 = Color3.new(0, 0, 0)
    searchModal.BackgroundTransparency = 1
    searchModal.ZIndex = 100
    searchModal.Visible = false
    searchModal.Active = true
    searchModal.Parent = mainFrame -- Fijo a la ventana para que se mueva con ella
    
    local modalContainer = Instance.new("Frame")
    modalContainer.Size = UDim2.new(0, 340, 0, 260)
    modalContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    modalContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    modalContainer.BackgroundColor3 = theme.Background
    modalContainer.BackgroundTransparency = 1
    modalContainer.ZIndex = 101
    modalContainer.ClipsDescendants = true
    modalContainer.Parent = searchModal
    Instance.new("UICorner", modalContainer).CornerRadius = UDim.new(0, 16)
    
    local modalStroke = Instance.new("UIStroke")
    modalStroke.Color = theme.Primary
    modalStroke.Transparency = 1
    modalStroke.Thickness = 1
    modalStroke.Parent = modalContainer
    
    local modalInputFrame = Instance.new("Frame")
    modalInputFrame.Size = UDim2.new(1, -20, 0, 40)
    modalInputFrame.Position = UDim2.new(0, 10, 0, 10)
    modalInputFrame.BackgroundColor3 = theme.Surface
    modalInputFrame.BackgroundTransparency = 0.2
    modalInputFrame.ZIndex = 102
    modalInputFrame.Parent = modalContainer
    Instance.new("UICorner", modalInputFrame).CornerRadius = UDim.new(0, 8)
    
    local modalSearchIcon = Instance.new("ImageLabel")
    modalSearchIcon.Size = UDim2.new(0, 16, 0, 16)
    modalSearchIcon.Position = UDim2.new(0, 12, 0.5, -8)
    modalSearchIcon.BackgroundTransparency = 1
    
    local resolvedModalSearch = resolveIcon(assets.Icons.Search)
    if type(resolvedModalSearch) == "table" then
        modalSearchIcon.Image = resolvedModalSearch.Image or ""
        modalSearchIcon.ImageRectOffset = resolvedModalSearch.ImageRectOffset or Vector2.new(0,0)
        modalSearchIcon.ImageRectSize = resolvedModalSearch.ImageRectSize or Vector2.new(0,0)
    else
        modalSearchIcon.Image = resolvedModalSearch or ""
    end
    modalSearchIcon.ImageColor3 = theme.Primary
    modalSearchIcon.ZIndex = 103
    modalSearchIcon.Parent = modalInputFrame
    
    local modalInput = Instance.new("TextBox")
    modalInput.Size = UDim2.new(1, -44, 1, 0)
    modalInput.Position = UDim2.new(0, 36, 0, 0)
    modalInput.BackgroundTransparency = 1
    modalInput.Text = ""
    modalInput.PlaceholderText = langData.searchFeatures
    modalInput.PlaceholderColor3 = theme.MutedText
    modalInput.TextColor3 = theme.Text
    modalInput.Font = Enum.Font.Gotham
    modalInput.TextSize = 12
    modalInput.TextXAlignment = Enum.TextXAlignment.Left
    modalInput.ClearTextOnFocus = false
    modalInput.ZIndex = 103
    modalInput.Parent = modalInputFrame
    
    local resultsScroll = Instance.new("ScrollingFrame")
    resultsScroll.Size = UDim2.new(1, -20, 1, -66)
    resultsScroll.Position = UDim2.new(0, 10, 0, 56)
    resultsScroll.BackgroundTransparency = 1
    resultsScroll.BorderSizePixel = 0
    resultsScroll.ScrollBarThickness = 2
    resultsScroll.ScrollBarImageColor3 = theme.Primary
    resultsScroll.ZIndex = 102
    resultsScroll.Parent = modalContainer
    
    local resultsLayout = Instance.new("UIListLayout")
    resultsLayout.Padding = UDim.new(0, 6)
    resultsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    resultsLayout.Parent = resultsScroll
    
    local mNoResults = Instance.new("TextLabel")
    mNoResults.Size = UDim2.new(1, 0, 1, 0)
    mNoResults.BackgroundTransparency = 1
    mNoResults.Text = langData.noFeatures
    mNoResults.TextColor3 = theme.MutedText
    mNoResults.Font = Enum.Font.GothamBold
    mNoResults.TextSize = 13
    mNoResults.ZIndex = 102
    mNoResults.Visible = false
    mNoResults.Parent = resultsScroll
    
    local function openSearchModal()
        searchModal.Visible = true
        modalInput.Text = ""
        for _, child in pairs(resultsScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        mNoResults.Visible = false
        modalInput:CaptureFocus()
        TweenService:Create(searchModal, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(modalContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(modalStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end
    
    local function closeSearchModal()
        TweenService:Create(searchModal, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        local t = TweenService:Create(modalContainer, TweenInfo.new(0.2), {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.45, 0)})
        TweenService:Create(modalStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        t:Play()
        t.Completed:Connect(function()
            if modalContainer.BackgroundTransparency >= 0.95 then
                searchModal.Visible = false
            end
        end)
    end
    
    searchBarFrame.MouseButton1Click:Connect(openSearchModal)
    
    local bgButton = Instance.new("TextButton")
    bgButton.Size = UDim2.new(1, 0, 1, 0)
    bgButton.BackgroundTransparency = 1
    bgButton.Text = ""
    bgButton.ZIndex = 99
    bgButton.Parent = searchModal
    bgButton.MouseButton1Click:Connect(closeSearchModal)
    
    local function createResultItem(name, parentName, targetTab, isSection)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = theme.Surface
        btn.BackgroundTransparency = 0.5
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 103
        btn.Parent = resultsScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.new(1,1,1)
        btnStroke.Transparency = 0.95
        btnStroke.Thickness = 1
        btnStroke.Parent = btn
        
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 12, 0.5, -8)
        icon.BackgroundTransparency = 1
        
        local resIcon = isSection and resolveIcon(assets.Icons.Folder) or resolveIcon(assets.Icons.SubTab)
        if type(resIcon) == "table" then
            icon.Image = resIcon.Image or ""
            icon.ImageRectOffset = resIcon.ImageRectOffset or Vector2.new(0,0)
            icon.ImageRectSize = resIcon.ImageRectSize or Vector2.new(0,0)
        else
            icon.Image = resIcon or ""
        end
        icon.ImageColor3 = theme.SecondaryText
        icon.ZIndex = 103
        icon.Parent = btn
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 0, 14)
        title.Position = UDim2.new(0, 36, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = theme.Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 103
        title.Parent = btn
        
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -40, 0, 12)
        sub.Position = UDim2.new(0, 36, 0, 22)
        sub.BackgroundTransparency = 1
        sub.Text = langData.inText .. " " .. parentName
        sub.TextColor3 = theme.Primary
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 9
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 103
        sub.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = theme.Primary}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = theme.Primary, Transparency = 0.7}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.5}):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = theme.SecondaryText}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.new(1,1,1), Transparency = 0.95}):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            closeSearchModal()
            if targetTab and targetTab.Select then
                targetTab:Select()
            end
        end)
    end
    
    local function performSearch(query)
        for _, child in pairs(resultsScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        mNoResults.Visible = false
        
        query = string.lower(query)
        if query == "" then return end
        
        local foundCount = 0
        
        for _, tab in pairs(WindowObj.Tabs) do
            local tabName = tab.Label.Text
            if string.find(string.lower(tabName), query, 1, true) then
                createResultItem(tabName, "Sidebar / Tabs", tab, true)
                foundCount = foundCount + 1
            end
            
            for _, child in pairs(tab.Page:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    if child.Name:match("_Section$") then
                        local sNameLbl = child:FindFirstChild("Header") and child.Header:FindFirstChild("Title")
                        local sName = sNameLbl and sNameLbl.Text or child.Name:gsub("_Section", "")
                        
                        if string.find(string.lower(sName), query, 1, true) then
                            createResultItem(sName, tabName, tab, true)
                            foundCount = foundCount + 1
                        end
                        
                        local sContent = child:FindFirstChild("Content") or child:FindFirstChild("Container")
                        if sContent then
                            for _, sc in pairs(sContent:GetChildren()) do
                                if sc:IsA("Frame") or sc:IsA("TextButton") then
                                    local scNameLbl = sc:FindFirstChild("TextLabel") or sc:FindFirstChild("Title") or sc:FindFirstChild("TitleLbl")
                                    local eName = scNameLbl and scNameLbl.Text or sc.Name:gsub("Frame", "")
                                    
                                    if string.find(string.lower(eName), query, 1, true) then
                                        createResultItem(eName, tabName .. " > " .. sName, tab, false)
                                        foundCount = foundCount + 1
                                    end
                                end
                            end
                        end
                    else
                        local cNameLbl = child:FindFirstChild("TextLabel") or child:FindFirstChild("Title")
                        local cName = cNameLbl and cNameLbl.Text or child.Name
                        if string.find(string.lower(cName), query, 1, true) then
                            createResultItem(cName, tabName, tab, false)
                            foundCount = foundCount + 1
                        end
                    end
                end
            end
        end
        
        resultsScroll.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
        if foundCount == 0 then
            mNoResults.Visible = true
        end
    end
    
    modalInput:GetPropertyChangedSignal("Text"):Connect(function()
        performSearch(modalInput.Text)
    end)
    resultsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        resultsScroll.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
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
    
    local viewSizeX = workspace.CurrentCamera.ViewportSize.X
    local viewSizeY = workspace.CurrentCamera.ViewportSize.Y
    library.Utilities:MakeResizable(resizeHandle, mainFrame, Vector2.new(600, 400), Vector2.new(math.min(viewSizeX - 40, 1100), math.min(viewSizeY - 40, 750)))

    function WindowObj:MakeTab(tabOptions)
        return library.Tab:New(tabOptions, self)
    end

    function WindowObj:AddFolder(folderOptions)
        return library.Folder:New(folderOptions, self)
    end
    
    function WindowObj:AddFile(options)
        options.IsFile = true
        return library.Tab:New(options, self)
    end
    
    WindowObj.OrderCounter = 10
    
    function WindowObj:AddDivider()
        local div = Instance.new("Frame")
        div.Size = UDim2.new(1, -24, 0, 2)
        div.Position = UDim2.new(0, 12, 0, 0)
        div.BackgroundColor3 = theme.Primary
        div.BackgroundTransparency = 0.6
        div.BorderSizePixel = 0
        div.LayoutOrder = 5 -- Between Pinned and Normal items
        div.Parent = navScroll
    end
    
    -- Auto Update Canvas Size & Layout Adjustments
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

    mainFrame:GetPropertyChangedSignal("Size"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

    -- Toggle Hotkey
    WindowObj.ToggleKey = options.Keybind or Enum.KeyCode.RightControl
    
    local toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == WindowObj.ToggleKey then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    table.insert(_G.RoseUI_Connections, toggleConn)

    function WindowObj:ShowDialog(config)
        local title = config.Title or "Dialog"
        local message = config.Message or "Are you sure?"
        local confirmText = config.ConfirmText or langData.dialogConfirm
        local cancelText = config.CancelText or langData.dialogCancel

        local overlay = Instance.new("TextButton")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.new(0,0,0)
        overlay.BackgroundTransparency = 1
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 200
        overlay.Parent = screenGui

        local dBox = Instance.new("Frame")
        dBox.Size = UDim2.new(0, 320, 0, 160)
        dBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        dBox.AnchorPoint = Vector2.new(0.5, 0.5)
        dBox.BackgroundColor3 = theme.Background
        dBox.BackgroundTransparency = 1
        dBox.ZIndex = 201
        dBox.Parent = overlay
        Instance.new("UICorner", dBox).CornerRadius = UDim.new(0, 12)

        local dStroke = Instance.new("UIStroke")
        dStroke.Color = theme.Primary
        dStroke.Transparency = 1
        dStroke.Thickness = 1
        dStroke.Parent = dBox

        local dTitle = Instance.new("TextLabel")
        dTitle.Size = UDim2.new(1, -40, 0, 40)
        dTitle.Position = UDim2.new(0, 20, 0, 10)
        dTitle.BackgroundTransparency = 1
        dTitle.Text = title
        dTitle.TextColor3 = theme.Text
        dTitle.Font = Enum.Font.GothamBold
        dTitle.TextSize = 14
        dTitle.TextXAlignment = Enum.TextXAlignment.Left
        dTitle.TextTransparency = 1
        dTitle.ZIndex = 202
        dTitle.Parent = dBox

        local dMessage = Instance.new("TextLabel")
        dMessage.Size = UDim2.new(1, -40, 0, 50)
        dMessage.Position = UDim2.new(0, 20, 0, 45)
        dMessage.BackgroundTransparency = 1
        dMessage.Text = message
        dMessage.TextColor3 = theme.SecondaryText
        dMessage.Font = Enum.Font.Gotham
        dMessage.TextSize = 12
        dMessage.TextXAlignment = Enum.TextXAlignment.Left
        dMessage.TextWrapped = true
        dMessage.TextTransparency = 1
        dMessage.ZIndex = 202
        dMessage.Parent = dBox

        -- Cancel (Encendido/Rojo como pidió el usuario)
        local btnCancel = Instance.new("TextButton")
        btnCancel.Size = UDim2.new(0, 120, 0, 32)
        btnCancel.Position = UDim2.new(1, -140, 1, -45)
        btnCancel.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        btnCancel.BackgroundTransparency = 1
        btnCancel.Text = cancelText
        btnCancel.TextColor3 = Color3.new(1,1,1)
        btnCancel.Font = Enum.Font.GothamBold
        btnCancel.TextSize = 12
        btnCancel.TextTransparency = 1
        btnCancel.ZIndex = 202
        btnCancel.Parent = dBox
        Instance.new("UICorner", btnCancel).CornerRadius = UDim.new(0, 6)

        -- Confirm (Apagado como pidió el usuario)
        local btnConfirm = Instance.new("TextButton")
        btnConfirm.Size = UDim2.new(0, 120, 0, 32)
        btnConfirm.Position = UDim2.new(1, -270, 1, -45)
        btnConfirm.BackgroundColor3 = theme.Surface
        btnConfirm.BackgroundTransparency = 1
        btnConfirm.Text = confirmText
        btnConfirm.TextColor3 = theme.Text
        btnConfirm.Font = Enum.Font.GothamBold
        btnConfirm.TextSize = 12
        btnConfirm.TextTransparency = 1
        btnConfirm.ZIndex = 202
        btnConfirm.Parent = dBox
        Instance.new("UICorner", btnConfirm).CornerRadius = UDim.new(0, 6)

        local btnConfirmStroke = Instance.new("UIStroke")
        btnConfirmStroke.Color = theme.Primary
        btnConfirmStroke.Transparency = 1
        btnConfirmStroke.Thickness = 1
        btnConfirmStroke.Parent = btnConfirm

        local function closeDialog()
            TweenService:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(dBox, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(dStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(dTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            TweenService:Create(dMessage, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            TweenService:Create(btnCancel, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(btnConfirm, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            local t = TweenService:Create(btnConfirmStroke, TweenInfo.new(0.2), {Transparency = 1})
            t:Play()
            t.Completed:Connect(function()
                overlay:Destroy()
            end)
        end

        btnCancel.MouseButton1Click:Connect(function()
            closeDialog()
            if config.OnCancel then config.OnCancel() end
        end)

        btnConfirm.MouseButton1Click:Connect(function()
            closeDialog()
            if config.OnConfirm then config.OnConfirm() end
        end)

        TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(dBox, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(dStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        TweenService:Create(dTitle, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(dMessage, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(btnCancel, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TweenService:Create(btnConfirm, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
        TweenService:Create(btnConfirmStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end

    return WindowObj
end

return Window
