--[[
    RoseUI v2.5.0
    Created by RoseUI Team
    Build Date: 4/3/2026, 11:08:47 p. m.
    
    This is a unified distribution file. 
]]

local __DARKLUA_BUNDLE_MODULES={cache={}::any}do do local function __modImpl()local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local Constants = {
    Services = {
        UserInputService = UserInputService,
        TweenService = TweenService,
        HttpService = HttpService,
        RunService = RunService,
        CoreGui = CoreGui,
        Players = Players,
        GuiService = GuiService,
        Lighting = Lighting,
        Camera = Camera,
        Stats = Stats
    },
    DefaultSize = UDim2.new(0, 650, 0, 520),
    MinSize = {
        Width = 450,
        Height = 300
    },
    Padding = 40,
    HeaderHeight = 45,
    SidebarWidth = 160
}

return Constants
end function __DARKLUA_BUNDLE_MODULES.a():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.a if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.a=v end return v.c end end do local function __modImpl()
local Themes = {
    ["Rose v2 (Premium)"] = {
        Primary = Color3.fromRGB(242, 13, 13),      
        Background = Color3.fromRGB(10, 5, 5),      
        Surface = Color3.fromRGB(18, 8, 8),        
        Accent = Color3.fromRGB(26, 11, 11),       
        DeepAccent = Color3.fromRGB(15, 6, 6),     
        Border = Color3.fromRGB(242, 13, 13),      
        Text = Color3.fromRGB(241, 245, 249),      
        SecondaryText = Color3.fromRGB(100, 116, 139), 
        MutedText = Color3.fromRGB(71, 85, 105),    
        Header = Color3.fromRGB(26, 11, 11),
        Sidebar = Color3.fromRGB(26, 11, 11),
        Content = Color3.fromRGB(10, 5, 5),
        Card = Color3.fromRGB(0, 0, 0)
    },
    ["Dark Rose"] = {
        Primary = Color3.fromRGB(240, 50, 70),
        Background = Color3.fromRGB(15, 10, 12),
        Surface = Color3.fromRGB(22, 15, 18),
        Accent = Color3.fromRGB(30, 20, 24),
        DeepAccent = Color3.fromRGB(15, 10, 12),
        Border = Color3.fromRGB(240, 50, 70),
        Text = Color3.fromRGB(250, 230, 235),
        SecondaryText = Color3.fromRGB(180, 160, 165),
        MutedText = Color3.fromRGB(120, 100, 105),
        Header = Color3.fromRGB(30, 20, 24),
        Sidebar = Color3.fromRGB(22, 15, 18),
        Content = Color3.fromRGB(15, 10, 12),
        Card = Color3.fromRGB(22, 15, 18)
    }
}

return Themes
end function __DARKLUA_BUNDLE_MODULES.b():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.b if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.b=v end return v.c end end do local function __modImpl()
local Assets = {
    Icons = {
        
        Logo = "lucide:flower",
        
        
        Dashboard = "lucide:layout-grid",
        Combat = "lucide:zap",
        Visuals = "lucide:eye", 
        Movement = "lucide:wind",
        Settings = "lucide:settings",
        SubTab = "lucide:chevron-right",
        
        
        Zap = "lucide:zap",
        Crosshair = "lucide:crosshair",
        Target = "lucide:target",
        Eye = "lucide:eye",
        Globe = "lucide:globe",
        Sliders = "lucide:sliders-horizontal",
        Folder = "lucide:folder",
        File = "lucide:file",
        
        
        Game = "lucide:gamepad-2",
        FPS = "lucide:gauge",
        RAM = "lucide:cpu",
        Ping = "lucide:wifi",
        Time = "lucide:clock",
        
        
        User = "lucide:user",
        
        
        Close = "lucide:x",
        Minimize = "lucide:minus",
        Maximize = "lucide:square",
        Restore = "lucide:copy",
        
        
        Save = "lucide:save",
        Expand = "lucide:chevron-down",
        Check = "lucide:check",
        Search = "lucide:search",
    }
}

return Assets
end function __DARKLUA_BUNDLE_MODULES.c():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.c if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.c=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService

local Utilities = {}

function Utilities:Tween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Utilities:MakeDraggable(dragFrame, parentFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local relativeY = input.Position.Y - dragFrame.AbsolutePosition.Y
            if relativeY <= 45 then 
                dragging = true
                dragStart = input.Position
                startPos = parentFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local dragCon = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(parentFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    
    return dragCon
end

function Utilities:MakeResizable(resizeBtn, parentFrame, minSize, maxSize)
    local minSize = minSize or Vector2.new(600, 400)
    local dragging, dragInput, dragStart, startSize
    
    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = parentFrame.AbsoluteSize
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    resizeBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local resizeCon = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newSizeX = math.max(minSize.X, startSize.X + delta.X)
            local newSizeY = math.max(minSize.Y, startSize.Y + delta.Y)
            
            if maxSize then
                newSizeX = math.min(maxSize.X, newSizeX)
                newSizeY = math.min(maxSize.Y, newSizeY)
            end
            
            parentFrame.Size = UDim2.new(0, newSizeX, 0, newSizeY)
        end
    end)
    
    return resizeCon
end

return Utilities
end function __DARKLUA_BUNDLE_MODULES.d():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.d if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.d=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local CoreGui = Services.CoreGui
local TweenService = Services.TweenService
local RunService = Services.RunService
local GuiService = Services.GuiService
local Lighting = Services.Lighting

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
end function __DARKLUA_BUNDLE_MODULES.e():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.e if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.e=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
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
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]
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
    
    local WindowObj = {} 

    
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
    
    local minSizeConstraint = Instance.new("UISizeConstraint")
    minSizeConstraint.MinSize = Vector2.new(finalWidth, finalHeight)
    minSizeConstraint.Parent = mainFrame

    
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
    
    

    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0, 420, 1, 0)
    statsFrame.Position = UDim2.new(0.5, 40, 0, 0)
    statsFrame.AnchorPoint = Vector2.new(0.5, 0)
    statsFrame.BackgroundTransparency = 1
    statsFrame.Parent = header

    
    local bottomGlow = Instance.new("ImageLabel")
    bottomGlow.Name = "BottomGlow"
    bottomGlow.Size = UDim2.new(1.2, 0, 0, 150)
    bottomGlow.Position = UDim2.new(0.5, 0, 1, 0)
    bottomGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    bottomGlow.BackgroundTransparency = 1
    bottomGlow.Image = "rbxassetid://6015667101" 
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

    
    local lastUpdate = tick()
    local frames = 0
    local statsUpdateConn = RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        local now = tick()
        
        if now - lastUpdate >= 1 then
            
            fpsStat.Text = tostring(frames)
            frames = 0
            lastUpdate = now
            
            
            local totalMem = Services.Stats:GetTotalMemoryUsageMb()
            ramStat.Text = string.format("%.0f MB", totalMem)
            
            
            local ping = math.floor(Services.Players.LocalPlayer:GetNetworkPing() * 1000)
            pingStat.Text = ping .. "ms"
            
            
            timeStat.Text = os.date("%H:%M:%S")
        end
    end)
    table.insert(_G.RoseUI_Connections, statsUpdateConn)

    
    
    
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
    
    
    local minGripHitbox = Instance.new("Frame")
    minGripHitbox.Size = UDim2.new(0, 40, 1, 0)
    minGripHitbox.Active = true 
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

    
    
    
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -40)
    body.Position = UDim2.new(0, 0, 0, 40)
    body.BackgroundTransparency = 1
    body.Parent = mainFrame

    
    
    
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 240, 1, 0)
    sidebar.BackgroundColor3 = theme.Accent
    sidebar.BackgroundTransparency = 0.4
    sidebar.BorderSizePixel = 0
    sidebar.Parent = body
    
    
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
    userStatus.TextColor3 = Color3.fromRGB(0, 255, 128) 
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

    
    
    
    local searchBarFrame = Instance.new("TextButton")
    searchBarFrame.Name = "SearchBarTrigger"
    searchBarFrame.Size = UDim2.new(1, -24, 0, 34)
    searchBarFrame.Position = UDim2.new(0, 12, 0, 105)
    searchBarFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05) 
    searchBarFrame.BackgroundTransparency = 0.2
    searchBarFrame.AutoButtonColor = false
    searchBarFrame.Text = ""
    searchBarFrame.Parent = sidebar
    Instance.new("UICorner", searchBarFrame).CornerRadius = UDim.new(1, 0)
    
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = theme.Primary
    searchStroke.Transparency = 1 
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
    local dIcon = resolveIcon("lucide:discord") 
    if not dIcon or dIcon == "" then
        dIcon = "rbxassetid://10723374482" 
    end
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
            library:Notify({Title = "Discord", Text = "Link copied to clipboard!", Duration = 3})
        end
    end)
    discordBtn.MouseEnter:Connect(function() TweenService:Create(dscIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(88, 101, 242)}):Play() end)
    discordBtn.MouseLeave:Connect(function() TweenService:Create(dscIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)

    
    
    
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

    
    
    
    local searchModal = Instance.new("Frame")
    searchModal.Name = "SearchModal"
    searchModal.Size = UDim2.new(1, 0, 1, 0)
    searchModal.BackgroundColor3 = Color3.new(0, 0, 0)
    searchModal.BackgroundTransparency = 1
    searchModal.ZIndex = 100
    searchModal.Visible = false
    searchModal.Active = true
    searchModal.Parent = mainFrame 
    
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

    
    local resizeHandle = Instance.new("ImageButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Image = "rbxassetid://10723415903" 
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
        div.LayoutOrder = 5 
        div.Parent = navScroll
    end
    
    
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

    mainFrame:GetPropertyChangedSignal("Size"):Connect(function()
        navScroll.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y)
    end)

    
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
end function __DARKLUA_BUNDLE_MODULES.f():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.f if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.f=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Folder = {}

function Folder:New(options, window)
    local name = options.Name or "Folder"
    local icon = options.Icon or "Folder"
    local assets = window.Library.Assets
    local theme = window.Theme
    
    local folderFrame = Instance.new("Frame")
    folderFrame.Name = name .. "_Folder"
    folderFrame.Size = UDim2.new(1, 0, 0, 44)
    folderFrame.BackgroundTransparency = 1
    folderFrame.ClipsDescendants = true
    folderFrame.Parent = window.NavScroll
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = folderFrame
    
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -16, 0, 36)
    content.Position = UDim2.new(0, 8, 0, 4)
    content.BackgroundColor3 = theme.Surface
    content.BackgroundTransparency = 0.5
    content.Parent = folderFrame
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.new(1,1,1)
    contentStroke.Transparency = 0.92
    contentStroke.Thickness = 1
    contentStroke.Parent = content
    
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 0, 18)
    accentBar.Position = UDim2.new(0, 6, 0.5, -9)
    accentBar.BackgroundColor3 = theme.Primary
    accentBar.BackgroundTransparency = 0.3
    accentBar.BorderSizePixel = 0
    accentBar.Parent = content
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 16, 0, 16)
    iconImg.Position = UDim2.new(0, 16, 0.5, -8)
    iconImg.BackgroundTransparency = 1
    iconImg.ImageColor3 = theme.SecondaryText
    iconImg.Parent = content

    local folderIcon = options.Icon or "Folder"
    
    if type(folderIcon) == "string" then
        if tonumber(folderIcon) or string.find(tostring(folderIcon), "rbxassetid://") then
            folderIcon = string.find(tostring(folderIcon), "rbxassetid://") and folderIcon or "rbxassetid://" .. folderIcon
        else
            folderIcon = assets.Icons[folderIcon] or assets.Icons.Folder
        end
    end
    
    if type(folderIcon) == "table" then
        iconImg.Image = folderIcon.Image or ""
        iconImg.ImageRectOffset = folderIcon.ImageRectOffset or Vector2.new(0,0)
        iconImg.ImageRectSize = folderIcon.ImageRectSize or Vector2.new(0,0)
    else
        iconImg.Image = folderIcon
    end
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 38, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = theme.SecondaryText
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    
    
    local spacedText = ""
    for i = 1, #name do
        spacedText = spacedText .. name:sub(i,i):upper()
        if i < #name then spacedText = spacedText .. " " end
    end
    label.Text = spacedText

    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 12, 0, 12)
    arrow.Position = UDim2.new(1, -22, 0.5, -6)
    arrow.BackgroundTransparency = 1
    arrow.Image = assets.Icons.Expand
    arrow.ImageColor3 = theme.MutedText
    arrow.Parent = content
    
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(content, TweenInfo.new(0.2), {BackgroundTransparency = 0.3, BackgroundColor3 = theme.Accent}):Play()
        TweenService:Create(contentStroke, TweenInfo.new(0.2), {Transparency = 0.8, Color = theme.Primary}):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = theme.Text}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(content, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, BackgroundColor3 = theme.Surface}):Play()
        TweenService:Create(contentStroke, TweenInfo.new(0.2), {Transparency = 0.92, Color = Color3.new(1,1,1)}):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = theme.SecondaryText}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    local fileContainer = Instance.new("Frame")
    fileContainer.Name = "Files"
    fileContainer.Size = UDim2.new(1, 0, 0, 0)
    fileContainer.Position = UDim2.new(0, 0, 0, 44)
    fileContainer.BackgroundTransparency = 1
    fileContainer.Parent = folderFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = fileContainer
    
    local FolderObj = {
        Window = window,
        Container = fileContainer,
        Opened = false,
        Files = {}
    }
    
    local function toggle(state)
        FolderObj.Opened = state
        local targetSize = state and (layout.AbsoluteContentSize.Y + 44) or 44
        TweenService:Create(folderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Rotation = state and 180 or 0}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.3), {BackgroundColor3 = state and theme.Primary or theme.Primary, BackgroundTransparency = state and 0 or 0.3}):Play()
        
        
        delay(0.35, function()
            window.NavScroll.CanvasSize = UDim2.new(0, 0, 0, window.NavScroll.UIListLayout.AbsoluteContentSize.Y)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        toggle(not FolderObj.Opened)
    end)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if FolderObj.Opened then
            folderFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 44)
        end
    end)

    function FolderObj:AddFile(fOptions)
        fOptions.IsFile = true
        fOptions.ParentOverride = self.Container
        return window.Library.Tab:New(fOptions, self.Window)
    end
    
    return FolderObj
end

return Folder
end function __DARKLUA_BUNDLE_MODULES.g():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.g if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.g=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Tab = {}

function Tab:New(tabOptions, window)
    local tabName = tabOptions.Name or "Tab"
    local library = window.Library
    local theme = window.Theme
    local assets = library.Assets

    local tabIcon = tabOptions.Icon or (tabOptions.IsFile and "File" or "Dashboard")
    
    if type(tabIcon) == "string" then
        if tonumber(tabIcon) or string.find(tabIcon, "rbxassetid://") then
            tabIcon = string.find(tabIcon, "rbxassetid://") and tabIcon or "rbxassetid://" .. tabIcon
        else
            tabIcon = assets.Icons[tabIcon] or assets.Icons.File
        end
    end

    local isSubTab = tabOptions.IsSubTab or tabOptions.IsFile or false
    local isFile = tabOptions.IsFile or false
    local isPinned = tabOptions.Pinned or false
    local parentOverride = tabOptions.ParentOverride

    local tabBtn = Instance.new("Frame")
    tabBtn.Name = tabName .. (isFile and "_File" or (isSubTab and "_Sub" or "_Main"))
    tabBtn.Size = UDim2.new(1, 0, 0, (isFile or isSubTab) and 34 or 42)
    tabBtn.BackgroundTransparency = 1
    
    if isPinned then
        tabBtn.LayoutOrder = 1
    else
        window.OrderCounter = (window.OrderCounter or 10) + 1
        tabBtn.LayoutOrder = window.OrderCounter
    end
    
    tabBtn.Parent = parentOverride or window.NavScroll

    local btnTrigger = Instance.new("TextButton")
    btnTrigger.Size = UDim2.new(1, 0, 1, 0)
    btnTrigger.BackgroundTransparency = 1
    btnTrigger.Text = ""
    btnTrigger.Parent = tabBtn

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, isFile and -36 or (isSubTab and -26 or -16), 1, -4)
    contentFrame.Position = UDim2.new(0, isFile and 28 or (isSubTab and 22 or 8), 0, 2)
    contentFrame.BackgroundColor3 = theme.Primary
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = tabBtn
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = theme.Primary
    contentStroke.Transparency = 1
    contentStroke.Thickness = 1
    contentStroke.Parent = contentFrame

    
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Size = UDim2.new(0, 3, 0, 0)
    activeIndicator.Position = UDim2.new(0, 0, 0.5, 0)
    activeIndicator.AnchorPoint = Vector2.new(0, 0.5)
    activeIndicator.BackgroundColor3 = theme.Primary
    activeIndicator.BackgroundTransparency = 1
    activeIndicator.BorderSizePixel = 0
    activeIndicator.Parent = contentFrame
    Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(0, 2)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 12, 0.5, -8)
    icon.BackgroundTransparency = 1
    
    if type(tabIcon) == "table" then
        icon.Image = tabIcon.Image or ""
        icon.ImageRectOffset = tabIcon.ImageRectOffset or Vector2.new(0,0)
        icon.ImageRectSize = tabIcon.ImageRectSize or Vector2.new(0,0)
    else
        icon.Image = tabIcon
    end
    
    icon.ImageColor3 = theme.SecondaryText
    icon.Parent = contentFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, isSubTab and -34 or -38, 1, 0)
    label.Position = UDim2.new(0, isSubTab and 32 or 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = tabName
    label.TextColor3 = theme.SecondaryText
    label.Font = isSubTab and Enum.Font.GothamSemibold or Enum.Font.GothamBold
    label.TextSize = isSubTab and 10 or 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    
    if isSubTab or isFile then
        local subLine = Instance.new("Frame")
        subLine.Size = UDim2.new(0, 1, 1, 0)
        subLine.Position = UDim2.new(0, isFile and -14 or -8, 0, 0)
        subLine.BackgroundColor3 = theme.Primary
        subLine.BackgroundTransparency = 0.85
        subLine.BorderSizePixel = 0
        subLine.Parent = contentFrame
    end

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = theme.Primary
    page.Visible = false
    page.Parent = window.PageContainer

    local leftCol = Instance.new("Frame")
    leftCol.Name = "LeftColumn"
    leftCol.Size = UDim2.new(0.5, -8, 0, 0)
    leftCol.Position = UDim2.new(0, 0, 0, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.AutomaticSize = Enum.AutomaticSize.Y
    leftCol.LayoutOrder = 1
    leftCol.Parent = page
    
    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, 12)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    leftLayout.Parent = leftCol

    local rightCol = Instance.new("Frame")
    rightCol.Name = "RightColumn"
    rightCol.Size = UDim2.new(0.5, -8, 0, 0)
    rightCol.Position = UDim2.new(0.5, 8, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.AutomaticSize = Enum.AutomaticSize.Y
    rightCol.LayoutOrder = 2
    rightCol.Parent = page
    
    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, 12)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Parent = rightCol

    local function updateCanvas()
        local leftH = leftLayout.AbsoluteContentSize.Y
        local rightH = rightLayout.AbsoluteContentSize.Y
        local maxH = math.max(leftH, rightH)
        page.CanvasSize = UDim2.new(0, 0, 0, maxH + 40)
    end

    leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local TabObj = {
        Window = window,
        Page = page,
        LeftColumn = leftCol,
        RightColumn = rightCol,
        CurrentSide = "Left",
        Btn = tabBtn,
        Content = contentFrame,
        Label = label,
        Icon = icon,
        IsSubTab = isSubTab,
        Active = false
    }

    local function setActive(state)
        TabObj.Active = state
        if state then
            TweenService:Create(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.1, BackgroundColor3 = theme.Primary}):Play()
            TweenService:Create(contentStroke, TweenInfo.new(0.3), {Transparency = 0.6, Color = theme.Primary}):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1)}):Play()
            TweenService:Create(activeIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 3, 0, 16), BackgroundTransparency = 0}):Play()
            page.Visible = true
        else
            TweenService:Create(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
            TweenService:Create(contentStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextColor3 = theme.SecondaryText}):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {ImageColor3 = theme.SecondaryText}):Play()
            TweenService:Create(activeIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1}):Play()
            page.Visible = false
        end
    end

    btnTrigger.MouseButton1Click:Connect(function()
        if window.CurrentTab == TabObj then return end
        
        if window.CurrentTab then
            window.CurrentTab:Deactivate()
        end
 
        window.CurrentTab = TabObj
        setActive(true)
        
        
        for _, el in pairs(library.Elements) do
            if (el.Type == "Dropdown" or el.Type == "SearchDropdown") and el.IsOpen then
                if type(el.Close) == "function" then
                    el:Close()
                end
            end
        end
    end)

    btnTrigger.MouseEnter:Connect(function()
        if not TabObj.Active then
            TweenService:Create(contentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, BackgroundColor3 = theme.Accent}):Play()
            TweenService:Create(contentStroke, TweenInfo.new(0.2), {Transparency = 0.85, Color = theme.Primary}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = theme.Text}):Play()
        end
    end)

    btnTrigger.MouseLeave:Connect(function()
        if not TabObj.Active then
            TweenService:Create(contentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(contentStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = theme.SecondaryText}):Play()
        end
    end)

    function TabObj:Deactivate()
        setActive(false)
    end

    function TabObj:Select()
        if window.CurrentTab == TabObj then return end
        if window.CurrentTab then window.CurrentTab:Deactivate() end
        window.CurrentTab = TabObj
        setActive(true)
    end

    
    if #window.Tabs == 0 then
        window.CurrentTab = TabObj
        setActive(true)
    end

    table.insert(window.Tabs, TabObj)

    function TabObj:AddSubTab(subOptions)
        subOptions.IsSubTab = true
        return Tab:New(subOptions, self.Window)
    end
    
    local function getNextCol()
        if not TabObj.LeftColumn then return TabObj.Page end
        local parentCol = TabObj.CurrentSide == "Left" and TabObj.LeftColumn or TabObj.RightColumn
        TabObj.CurrentSide = TabObj.CurrentSide == "Left" and "Right" or "Left"
        return parentCol
    end

    function TabObj:AddSection(sName)
        return library.Section:New(sName, self)
    end

    function TabObj:AddParagraph(options)
        return library.Elements.Paragraph:Add(getNextCol(), options, library)
    end

    function TabObj:AddDocTitle(options)
        return library.Elements.Documentation:AddTitle(getNextCol(), options, library)
    end
    
    function TabObj:AddDocDescription(options)
        return library.Elements.Documentation:AddDescription(getNextCol(), options, library)
    end
    
    function TabObj:AddCard(options)
        return library.Elements.Documentation:AddCard(getNextCol(), options, library)
    end
    
    function TabObj:AddVersionCard(options)
        return library.Elements.Documentation:AddVersionCard(getNextCol(), options, library)
    end

    function TabObj:AddColorPicker(options)
        return library.Elements.ColorPicker:Add(getNextCol(), options, library)
    end

    return TabObj
end

return Tab
end function __DARKLUA_BUNDLE_MODULES.h():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.h if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.h=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services

local Section = {}

function Section:New(sName, tab)
    local window = tab.Window
    local library = window.Library
    local theme = window.Theme

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = sName .. "_Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundTransparency = 1
    
    local parentCol = tab.Page
    if tab.LeftColumn and tab.RightColumn then
        parentCol = tab.CurrentSide == "Left" and tab.LeftColumn or tab.RightColumn
        tab.CurrentSide = tab.CurrentSide == "Left" and "Right" or "Left"
    end
    
    sectionFrame.Parent = parentCol
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 15)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = sectionFrame
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, 0)
    accentBar.BackgroundColor3 = theme.Primary
    accentBar.BorderSizePixel = 0
    accentBar.Parent = titleFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 8, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = sName:upper()
    sectionLabel.TextColor3 = theme.Primary
    sectionLabel.TextSize = 10
    sectionLabel.Font = Enum.Font.GothamBlack
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = titleFrame
    
    
    sectionLabel.Text = ""
    for i = 1, #sName do
        sectionLabel.Text = sectionLabel.Text .. sName:sub(i,i):upper() .. " "
    end
    
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Name = "Container"
    sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    local secLayout = Instance.new("UIListLayout")
    secLayout.Padding = UDim.new(0, 10)
    secLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    secLayout.Parent = sectionContainer
    
    sectionContainer.Position = UDim2.new(0, 0, 0, 28)
    
    secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y)
        sectionFrame.Size = UDim2.new(1, 0, 0, 35 + secLayout.AbsoluteContentSize.Y)
    end)
    
    local SectionObj = {
        Container = sectionContainer,
        Tab = tab
    }

    
    function SectionObj:AddButton(options)
        return library.Elements.Button:Add(self.Container, options, library)
    end

    function SectionObj:AddToggle(options)
        return library.Elements.Toggle:Add(self.Container, options, library)
    end

    function SectionObj:AddSlider(options)
        return library.Elements.Slider:Add(self.Container, options, library)
    end

    function SectionObj:AddDropdown(options)
        return library.Elements.Dropdown:Add(self.Container, options, library)
    end

    function SectionObj:AddSearchDropdown(options)
        return library.Elements.SearchDropdown:Add(self.Container, options, library)
    end

    function SectionObj:AddColorPicker(options)
        return library.Elements.ColorPicker:Add(self.Container, options, library)
    end

    function SectionObj:AddKeybind(options)
        return library.Elements.Keybind:Add(self.Container, options, library)
    end

    function SectionObj:AddTextbox(options)
        return library.Elements.Textbox:Add(self.Container, options, library)
    end

    function SectionObj:AddLabel(options)
        return library.Elements.Label:Add(self.Container, options, library)
    end

    function SectionObj:AddParagraph(options)
        return library.Elements.Paragraph:Add(self.Container, options, library)
    end

    function SectionObj:AddTargetList(options)
        return library.Elements.TargetList:Add(self.Container, options, library)
    end

    function SectionObj:AddInventoryGrid(options)
        return library.Elements.InventoryGrid:Add(self.Container, options, library)
    end

    function SectionObj:AddPlotGrid(options)
        return library.Elements.PlotGrid:Add(self.Container, options, library)
    end

    return SectionObj
end

return Section
end function __DARKLUA_BUNDLE_MODULES.i():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.i if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.i=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Button = {}

function Button:Add(parent, options, library)
    local bName = options.Name or "Button"
    local bDesc = options.Description or nil
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]
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
end function __DARKLUA_BUNDLE_MODULES.j():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.j if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.j=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Toggle = {}

function Toggle:Add(parent, options, library)
    local tName = options.Name or "Toggle"
    local tDesc = options.Description or nil
    local cb = options.Callback or options.OnToggle or function() end
    local default = options.Default or false
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]

    local isToggled = default
    local h = tDesc and 45 or 38
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = tName .. "_Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, h)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = toggleFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, tDesc and 24 or h)
    label.Position = UDim2.new(0, 12, 0, tDesc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = tName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    if tDesc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -60, 0, 14)
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = tDesc
        descLabel.TextColor3 = theme.SecondaryText
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 9
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = bg
    end

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and theme.Primary or theme.Background
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = bg
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, default and 19 or 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local ToggleObj = {
        Type = "Toggle",
        Value = default,
        Flag = flag,
        Instance = toggleFrame
    }

    function ToggleObj:Set(state)
        isToggled = state
        ToggleObj.Value = state
        if library.Flags then library.Flags[flag] = state end
        
        local colorGoal = isToggled and theme.Primary or theme.Background
        local posGoal = isToggled and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = colorGoal}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = posGoal}):Play()
        
        cb(isToggled)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        ToggleObj:Set(not isToggled)
    end)
    
    
    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, -50, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg
    trigger.MouseButton1Click:Connect(function()
        ToggleObj:Set(not isToggled)
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, ToggleObj)

    return ToggleObj
end

return Toggle
end function __DARKLUA_BUNDLE_MODULES.k():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.k if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.k=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local Slider = {}

function Slider:Add(parent, options, library)
    local sName = options.Name or "Slider"
    local sDesc = options.Description or nil
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or 50
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]

    local h = sDesc and 60 or 52
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sName .. "_Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, h)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = sliderFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, sDesc and 24 or 30)
    label.Position = UDim2.new(0, 12, 0, sDesc and 4 or 0)
    label.BackgroundTransparency = 1
    label.Text = sName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    if sDesc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -60, 0, 14)
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = sDesc
        descLabel.TextColor3 = theme.SecondaryText
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 9
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = bg
    end

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -52, 0, sDesc and 6 or 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = theme.Primary
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.Code
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = bg

    local slideBg = Instance.new("Frame")
    slideBg.Size = UDim2.new(1, -24, 0, 6)
    slideBg.Position = UDim2.new(0, 12, 1, -14)
    slideBg.BackgroundColor3 = theme.Background
    slideBg.Parent = bg
    Instance.new("UICorner", slideBg).CornerRadius = UDim.new(1, 0)

    local slideInner = Instance.new("Frame")
    slideInner.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    slideInner.BackgroundColor3 = theme.Primary
    slideInner.Parent = slideBg
    Instance.new("UICorner", slideInner).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 6, 0, 14)
    knob.Position = UDim2.new(1, -3, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = slideInner
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = theme.Primary
    knobStroke.Transparency = 0.5
    knobStroke.Thickness = 1
    knobStroke.Parent = knob

    local SliderObj = {
        Type = "Slider",
        Value = default,
        Flag = flag,
        Instance = sliderFrame,
        Dragging = false
    }

    function SliderObj:Set(val)
        local clamped = math.clamp(val, min, max)
        SliderObj.Value = clamped
        valueLabel.Text = tostring(clamped)
        local percentage = (clamped - min) / (max - min)
        TweenService:Create(slideInner, TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        if library.Flags then library.Flags[flag] = clamped end
        cb(clamped)
    end

    local function updateSlider(input)
        local relativeX = math.clamp(input.Position.X - slideBg.AbsolutePosition.X, 0, slideBg.AbsoluteSize.X)
        local percentage = relativeX / slideBg.AbsoluteSize.X
        local value = math.floor(min + (max - min) * percentage)
        SliderObj:Set(value)
    end

    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, 0, 0, 20)
    trigger.Position = UDim2.new(0, 0, 1, -20)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderObj.Dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderObj.Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if SliderObj.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, SliderObj)

    return SliderObj
end

return Slider
end function __DARKLUA_BUNDLE_MODULES.l():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.l if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.l=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Dropdown = {}

function Dropdown:Add(parent, options, library)
    local dName = options.Name or "Dropdown"
    local optionsList = options.Options or {"Option 1", "Option 2"}
    local default = options.Default or optionsList[1]
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]
    local assets = library.Assets

    local h = 42
    
    local dropFrame = Instance.new("Frame")
    dropFrame.Name = dName .. "_Dropdown"
    dropFrame.Size = UDim2.new(1, 0, 0, h)
    dropFrame.BackgroundTransparency = 1
    dropFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = dropFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.5, -12, 0, 26)
    dropBtn.Position = UDim2.new(0.5, 0, 0.5, -13)
    dropBtn.BackgroundColor3 = theme.Background
    dropBtn.BackgroundTransparency = 0.5
    dropBtn.Text = tostring(default)
    dropBtn.TextColor3 = theme.SecondaryText
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 10
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.Parent = bg
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", dropBtn).PaddingLeft = UDim.new(0, 10)
    
    local dropBtnStroke = Instance.new("UIStroke")
    dropBtnStroke.Color = Color3.new(1,1,1)
    dropBtnStroke.Transparency = 0.92
    dropBtnStroke.Thickness = 1
    dropBtnStroke.Parent = dropBtn
    
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.Position = UDim2.new(1, -22, 0.5, -7)
    arrow.BackgroundTransparency = 1
    arrow.Image = assets.Icons.Expand or ""
    arrow.ImageColor3 = theme.SecondaryText
    arrow.Parent = dropBtn

    
    local dropMenuBg = Instance.new("Frame")
    dropMenuBg.Size = UDim2.new(0, 0, 0, 0)
    dropMenuBg.BackgroundColor3 = theme.Surface
    dropMenuBg.BackgroundTransparency = 0.02
    dropMenuBg.ZIndex = 500
    dropMenuBg.Visible = false
    dropMenuBg.ClipsDescendants = true
    dropMenuBg.Parent = dropFrame:FindFirstAncestor("Main") or parent
    Instance.new("UICorner", dropMenuBg).CornerRadius = UDim.new(0, 10)
    
    local dropMenuStroke = Instance.new("UIStroke")
    dropMenuStroke.Color = theme.Primary
    dropMenuStroke.Transparency = 0.4
    dropMenuStroke.Thickness = 1
    dropMenuStroke.Parent = dropMenuBg

    
    local menuPadding = Instance.new("UIPadding")
    menuPadding.PaddingTop = UDim.new(0, 4)
    menuPadding.PaddingBottom = UDim.new(0, 4)
    menuPadding.PaddingLeft = UDim.new(0, 4)
    menuPadding.PaddingRight = UDim.new(0, 4)
    menuPadding.Parent = dropMenuBg

    local dropMenu = Instance.new("ScrollingFrame")
    dropMenu.Size = UDim2.new(1, 0, 1, 0)
    dropMenu.Position = UDim2.new(0, 0, 0, 0)
    dropMenu.BackgroundTransparency = 1
    dropMenu.BorderSizePixel = 0
    dropMenu.ScrollBarThickness = 2
    dropMenu.ScrollBarImageColor3 = theme.Primary
    dropMenu.ZIndex = 501
    dropMenu.Parent = dropMenuBg
    
    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Padding = UDim.new(0, 2)
    dropLayout.Parent = dropMenu

    local DropdownObj = {
        Type = "Dropdown",
        Value = default,
        Flag = flag,
        Options = optionsList,
        IsOpen = false
    }

    function DropdownObj:Set(val)
        DropdownObj.Value = val
        dropBtn.Text = tostring(val)
        if library.Flags then library.Flags[flag] = val end
        cb(val)
        
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then
                local isSelected = child.Text == tostring(val)
                
                if isSelected then
                    child.BackgroundTransparency = 0.6
                    child.BackgroundColor3 = theme.Primary
                    child.TextColor3 = Color3.new(1,1,1)
                    
                    local checkLabel = child:FindFirstChild("CheckIndicator")
                    if checkLabel then checkLabel.Visible = true end
                else
                    child.BackgroundTransparency = 1
                    child.TextColor3 = theme.Text
                    local checkLabel = child:FindFirstChild("CheckIndicator")
                    if checkLabel then checkLabel.Visible = false end
                end
            end
        end
    end

    function DropdownObj:Toggle()
        DropdownObj.IsOpen = not DropdownObj.IsOpen
        if DropdownObj.IsOpen then
            dropMenuBg.Visible = true
            local listHeight = math.min(#DropdownObj.Options * 30 + 12, 160)
            
            local absolutePos = dropBtn.AbsolutePosition
            local containerPos = dropMenuBg.Parent.AbsolutePosition
            dropMenuBg.Position = UDim2.new(0, absolutePos.X - containerPos.X, 0, absolutePos.Y - containerPos.Y + dropBtn.AbsoluteSize.Y + 6)
            dropMenuBg.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
            
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Rotation = 180}):Play()
            TweenService:Create(dropMenuBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, listHeight)}):Play()
            TweenService:Create(dropBtnStroke, TweenInfo.new(0.2), {Color = theme.Primary, Transparency = 0.5}):Play()
        else
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Rotation = 0}):Play()
            TweenService:Create(dropBtnStroke, TweenInfo.new(0.2), {Color = Color3.new(1,1,1), Transparency = 0.92}):Play()
            local tween = TweenService:Create(dropMenuBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                if not DropdownObj.IsOpen then dropMenuBg.Visible = false end
            end)
        end
    end

    function DropdownObj:Close()
        if DropdownObj.IsOpen then
            DropdownObj:Toggle()
        end
    end

    function DropdownObj:Refresh(newList)
        DropdownObj.Options = newList
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in pairs(newList) do
            local isSelected = tostring(opt) == tostring(DropdownObj.Value)
            
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundTransparency = isSelected and 0.6 or 1
            optBtn.BackgroundColor3 = isSelected and theme.Primary or theme.Surface
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = isSelected and Color3.new(1,1,1) or theme.Text
            optBtn.Font = Enum.Font.GothamSemibold
            optBtn.TextSize = 10
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.AutoButtonColor = false
            optBtn.ZIndex = 502
            optBtn.Parent = dropMenu
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)
            Instance.new("UIPadding", optBtn).PaddingLeft = UDim.new(0, 10)
            
            
            local checkIndicator = Instance.new("TextLabel")
            checkIndicator.Name = "CheckIndicator"
            checkIndicator.Size = UDim2.new(0, 16, 0, 16)
            checkIndicator.Position = UDim2.new(1, -22, 0.5, -8)
            checkIndicator.BackgroundTransparency = 1
            checkIndicator.Text = "✓"
            checkIndicator.TextColor3 = Color3.new(1,1,1)
            checkIndicator.Font = Enum.Font.GothamBold
            checkIndicator.TextSize = 12
            checkIndicator.ZIndex = 503
            checkIndicator.Visible = isSelected
            checkIndicator.Parent = optBtn
            
            optBtn.MouseEnter:Connect(function()
                if tostring(opt) ~= tostring(DropdownObj.Value) then
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.75, BackgroundColor3 = theme.Primary}):Play()
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {TextColor3 = Color3.new(1,1,1)}):Play()
                end
            end)
            optBtn.MouseLeave:Connect(function()
                if tostring(opt) ~= tostring(DropdownObj.Value) then
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1, BackgroundColor3 = theme.Surface}):Play()
                    TweenService:Create(optBtn, TweenInfo.new(0.15), {TextColor3 = theme.Text}):Play()
                end
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                DropdownObj:Set(opt)
                DropdownObj:Toggle() 
            end)
        end
        dropMenu.CanvasSize = UDim2.new(0, 0, 0, #newList * 30)
    end

    dropBtn.MouseButton1Click:Connect(function()
        DropdownObj:Toggle()
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    DropdownObj:Refresh(optionsList)
    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, DropdownObj)

    return DropdownObj
end

return Dropdown
end function __DARKLUA_BUNDLE_MODULES.m():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.m if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.m=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local SearchDropdown = {}

function SearchDropdown:Add(parent, options, library)
    local dName = options.Name or "Search Dropdown"
    local optionsList = options.Options or {}
    local selectedItems = options.Default or {}
    if type(selectedItems) ~= "table" then selectedItems = {selectedItems} end
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]
    local assets = library.Assets

    local h = 42
    
    local dropFrame = Instance.new("Frame")
    dropFrame.Name = dName .. "_SearchDropdown"
    dropFrame.Size = UDim2.new(1, 0, 0, h)
    dropFrame.BackgroundTransparency = 1
    dropFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = dropFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.5, -12, 0, 26)
    dropBtn.Position = UDim2.new(0.5, 0, 0.5, -13)
    dropBtn.BackgroundColor3 = theme.Background
    dropBtn.BackgroundTransparency = 0.5
    dropBtn.Text = #selectedItems > 0 and table.concat(selectedItems, ", ") or "None"
    dropBtn.TextColor3 = theme.SecondaryText
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 10
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.Parent = bg
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIPadding", dropBtn).PaddingLeft = UDim.new(0, 10)
    
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.Position = UDim2.new(1, -22, 0.5, -7)
    arrow.BackgroundTransparency = 1
    arrow.Image = assets.Icons.Expand or ""
    arrow.ImageColor3 = theme.SecondaryText
    arrow.Parent = dropBtn

    local dropMenuBg = Instance.new("Frame")
    dropMenuBg.Size = UDim2.new(0, 0, 0, 0)
    dropMenuBg.BackgroundColor3 = theme.Surface
    dropMenuBg.BackgroundTransparency = 0.05
    dropMenuBg.ZIndex = 500
    dropMenuBg.Visible = false
    dropMenuBg.ClipsDescendants = true
    dropMenuBg.Parent = dropFrame:FindFirstAncestor("Main") or parent
    Instance.new("UICorner", dropMenuBg).CornerRadius = UDim.new(0, 8)
    
    local dropMenuStroke = Instance.new("UIStroke")
    dropMenuStroke.Color = theme.Primary
    dropMenuStroke.Transparency = 0.5
    dropMenuStroke.Thickness = 1
    dropMenuStroke.Parent = dropMenuBg

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -12, 0, 24)
    searchBox.Position = UDim2.new(0, 6, 0, 6)
    searchBox.BackgroundColor3 = theme.Background
    searchBox.PlaceholderText = "SEARCH..."
    searchBox.Text = ""
    searchBox.TextColor3 = theme.Text
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 10
    searchBox.ZIndex = 501
    searchBox.Parent = dropMenuBg
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

    local dropMenu = Instance.new("ScrollingFrame")
    dropMenu.Size = UDim2.new(1, -4, 1, -40)
    dropMenu.Position = UDim2.new(0, 2, 0, 36)
    dropMenu.BackgroundTransparency = 1
    dropMenu.BorderSizePixel = 0
    dropMenu.ScrollBarThickness = 2
    dropMenu.ScrollBarImageColor3 = theme.Primary
    dropMenu.ZIndex = 501
    dropMenu.Parent = dropMenuBg
    
    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Padding = UDim.new(0, 2)
    dropLayout.Parent = dropMenu

    local SearchObj = {
        Type = "SearchDropdown",
        Value = selectedItems,
        Options = optionsList,
        IsOpen = false
    }

    function SearchObj:Refresh(filter)
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local count = 0
        for _, opt in pairs(SearchObj.Options) do
            if filter == "" or string.find(string.lower(opt), string.lower(filter)) then
                count = count + 1
                local isSelected = table.find(SearchObj.Value, opt)
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 26)
                optBtn.BackgroundTransparency = isSelected and 0.9 or 1
                optBtn.BackgroundColor3 = isSelected and theme.Primary or Color3.new(1,1,1)
                optBtn.Text = tostring(opt)
                optBtn.TextColor3 = isSelected and theme.Primary or theme.Text
                optBtn.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                optBtn.TextSize = 10
                optBtn.ZIndex = 502
                optBtn.Parent = dropMenu
                
                optBtn.MouseButton1Click:Connect(function()
                    local idx = table.find(SearchObj.Value, opt)
                    if idx then table.remove(SearchObj.Value, idx) else table.insert(SearchObj.Value, opt) end
                    dropBtn.Text = #SearchObj.Value > 0 and table.concat(SearchObj.Value, ", ") or "None"
                    cb(SearchObj.Value)
                    SearchObj:Refresh(searchBox.Text)
                end)
            end
        end
        dropMenu.CanvasSize = UDim2.new(0, 0, 0, count * 28)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        SearchObj:Refresh(searchBox.Text)
    end)

    dropBtn.MouseButton1Click:Connect(function()
        SearchObj.IsOpen = not SearchObj.IsOpen
        if SearchObj.IsOpen then
            dropMenuBg.Visible = true
            local absolutePos = dropBtn.AbsolutePosition
            local containerPos = dropMenuBg.Parent.AbsolutePosition
            dropMenuBg.Position = UDim2.new(0, absolutePos.X - containerPos.X, 0, absolutePos.Y - containerPos.Y + dropBtn.AbsoluteSize.Y + 4)
            dropMenuBg.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
            
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            TweenService:Create(dropMenuBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 180)}):Play()
            SearchObj:Refresh("")
        else
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            local t = TweenService:Create(dropMenuBg, TweenInfo.new(0.2), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                if not SearchObj.IsOpen then dropMenuBg.Visible = false end
            end)
        end
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    function SearchObj:Close()
        if SearchObj.IsOpen then
            SearchObj.IsOpen = false
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            local t = TweenService:Create(dropMenuBg, TweenInfo.new(0.2), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                if not SearchObj.IsOpen then dropMenuBg.Visible = false end
            end)
        end
    end

    table.insert(library.Elements, SearchObj)

    return SearchObj
end

return SearchDropdown
end function __DARKLUA_BUNDLE_MODULES.n():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.n if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.n=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService

local Textbox = {}

function Textbox:Add(parent, options, library)
    local tName = options.Name or "Textbox"
    local default = options.Default or ""
    local placeholder = options.Placeholder or "TYPE HERE..."
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]

    local h = 42
    
    local txtFrame = Instance.new("Frame")
    txtFrame.Name = tName .. "_Textbox"
    txtFrame.Size = UDim2.new(1, 0, 0, h)
    txtFrame.BackgroundTransparency = 1
    txtFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = txtFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = tName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local boxBg = Instance.new("Frame")
    boxBg.Size = UDim2.new(0.5, -12, 0, 26)
    boxBg.Position = UDim2.new(0.5, 0, 0.5, -13)
    boxBg.BackgroundColor3 = theme.Background
    boxBg.BackgroundTransparency = 0.5
    boxBg.Parent = bg
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.new(0, 10, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = default
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = theme.SecondaryText
    box.TextColor3 = theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 10
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = boxBg

    local boxObj = {
        Type = "Textbox",
        Value = default
    }

    box.FocusLost:Connect(function(enter)
        boxObj.Value = box.Text
        cb(box.Text)
        
        if options.NotifyOnChange and library.Window then
            library.Window:Notify({
                Title = tName,
                Text = "Value changed to: " .. box.Text,
                Duration = 2
            })
        end
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    return boxObj
end

return Textbox
end function __DARKLUA_BUNDLE_MODULES.o():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.o if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.o=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService

local Keybind = {}

function Keybind:Add(parent, options, library)
    local kbName = options.Name or "Keybind"
    local default = options.Default or Enum.KeyCode.F
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]

    local currentKey = default
    local isWaiting = false
    local h = 42
    
    local kbFrame = Instance.new("Frame")
    kbFrame.Name = kbName .. "_Keybind"
    kbFrame.Size = UDim2.new(1, 0, 0, h)
    kbFrame.BackgroundTransparency = 1
    kbFrame.Parent = parent
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = kbFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = kbName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 60, 0, 22)
    bindBtn.Position = UDim2.new(1, -72, 0.5, -11)
    bindBtn.BackgroundColor3 = theme.Background
    bindBtn.BackgroundTransparency = 0.5
    bindBtn.Text = currentKey.Name:upper()
    bindBtn.TextColor3 = theme.Primary
    bindBtn.Font = Enum.Font.Code
    bindBtn.TextSize = 10
    bindBtn.Parent = bg
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)
    local bindStroke = Instance.new("UIStroke", bindBtn)
    bindStroke.Color = theme.Primary
    bindStroke.Transparency = 0.5

    local KeybindObj = {
        Type = "Keybind",
        Value = default,
        Flag = flag
    }

    bindBtn.MouseButton1Click:Connect(function()
        isWaiting = true
        bindBtn.Text = "..."
        TweenService:Create(bindStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, proc)
        if isWaiting and input.UserInputType == Enum.UserInputType.Keyboard then
            isWaiting = false
            currentKey = input.KeyCode
            bindBtn.Text = currentKey.Name:upper()
            KeybindObj.Value = currentKey
            if library.Flags then library.Flags[flag] = currentKey end
            TweenService:Create(bindStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            cb(currentKey)
        end
    end)

    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    if library.Flags then library.Flags[flag] = default end
    return KeybindObj
end

return Keybind
end function __DARKLUA_BUNDLE_MODULES.p():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.p if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.p=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local ColorPicker = {}

function ColorPicker:Add(parent, options, library)
    local cpName = options.Name or "Color Picker"
    local default = options.Default or Color3.fromRGB(242, 13, 13)
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or __DARKLUA_BUNDLE_MODULES.b()
["Rose v2 (Premium)"]

    local h, s, v = default:ToHSV()
    local currentColor = default

    
    local cpFrame = Instance.new("Frame")
    cpFrame.Name = cpName .. "_ColorPicker"
    cpFrame.Size = UDim2.new(1, 0, 0, 260) 
    cpFrame.BackgroundTransparency = 1
    cpFrame.Parent = parent

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = theme.Surface
    bg.BackgroundTransparency = 0.3
    bg.Parent = cpFrame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)

    local bgStroke = Instance.new("UIStroke")
    bgStroke.Color = Color3.new(1,1,1)
    bgStroke.Transparency = 0.95
    bgStroke.Thickness = 1
    bgStroke.Parent = bg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = cpName:upper()
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = bg

    
    local previewContainer = Instance.new("Frame")
    previewContainer.Size = UDim2.new(0, 60, 0, 20)
    previewContainer.Position = UDim2.new(1, -72, 0, 8)
    previewContainer.BackgroundTransparency = 1
    previewContainer.Parent = bg

    local previewColor = Instance.new("Frame")
    previewColor.Size = UDim2.new(0, 16, 0, 16)
    previewColor.Position = UDim2.new(0, 0, 0.5, -8)
    previewColor.BackgroundColor3 = currentColor
    previewColor.Parent = previewContainer
    Instance.new("UICorner", previewColor).CornerRadius = UDim.new(1, 0)
    local prevStroke = Instance.new("UIStroke", previewColor)
    prevStroke.Thickness = 2
    prevStroke.Transparency = 0.2
    prevStroke.Color = currentColor

    local activeLbl = Instance.new("TextLabel")
    activeLbl.Size = UDim2.new(1, -20, 1, 0)
    activeLbl.Position = UDim2.new(0, 22, 0, 0)
    activeLbl.BackgroundTransparency = 1
    activeLbl.Text = "ACTIVO"
    activeLbl.TextColor3 = theme.MutedText
    activeLbl.Font = Enum.Font.GothamBold
    activeLbl.TextSize = 9
    activeLbl.TextXAlignment = Enum.TextXAlignment.Left
    activeLbl.Parent = previewContainer

    
    local satMap = Instance.new("ImageButton")
    satMap.Size = UDim2.new(1, -24, 0, 110)
    satMap.Position = UDim2.new(0, 12, 0, 36)
    satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    satMap.Image = "rbxassetid://6980062489"
    satMap.AutoButtonColor = false
    satMap.Parent = bg
    Instance.new("UICorner", satMap).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", satMap).Transparency = 0.82

    local mapCursor = Instance.new("Frame")
    mapCursor.Size = UDim2.new(0, 12, 0, 12)
    mapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
    mapCursor.BackgroundColor3 = Color3.new(1,1,1)
    mapCursor.ZIndex = 2
    mapCursor.Parent = satMap
    Instance.new("UICorner", mapCursor).CornerRadius = UDim.new(1, 0)
    local mapCursorStroke = Instance.new("UIStroke", mapCursor)
    mapCursorStroke.Thickness = 1.5
    mapCursorStroke.Color = Color3.new(0,0,0)

    
    local hueFrame = Instance.new("TextButton")
    hueFrame.Size = UDim2.new(1, -24, 0, 22) 
    hueFrame.Position = UDim2.new(0, 12, 0, 154)
    hueFrame.AutoButtonColor = false
    hueFrame.Text = ""
    hueFrame.Parent = bg
    Instance.new("UICorner", hueFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", hueFrame).Transparency = 0.8
    Instance.new("UIStroke", hueFrame).Color = Color3.new(1,1,1)

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueFrame

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(0, 4, 1, 4)
    hueCursor.Position = UDim2.new(1-h, -2, 0, -2)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.Parent = hueFrame
    Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", hueCursor).Thickness = 1
    Instance.new("UIStroke", hueCursor).Color = Color3.new(0,0,0)

    
    local valFrame = Instance.new("TextButton")
    valFrame.Size = UDim2.new(1, -24, 0, 12)
    valFrame.Position = UDim2.new(0, 12, 0, 184)
    valFrame.AutoButtonColor = false
    valFrame.Text = ""
    valFrame.Parent = bg
    Instance.new("UICorner", valFrame).CornerRadius = UDim.new(0, 4)
    
    local valGradient = Instance.new("UIGradient")
    local function updateValGradient()
        valGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1))
        })
    end
    valGradient.Parent = valFrame
    updateValGradient()

    local valCursor = Instance.new("Frame")
    valCursor.Size = UDim2.new(0, 4, 1, 2)
    valCursor.Position = UDim2.new(v, -2, 0, -1)
    valCursor.BackgroundColor3 = Color3.new(1,1,1)
    valCursor.Parent = valFrame
    Instance.new("UICorner", valCursor).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", valCursor).Color = Color3.new(0,0,0)

    
    local hexBg = Instance.new("Frame")
    hexBg.Size = UDim2.new(1, -24, 0, 32)
    hexBg.Position = UDim2.new(0, 12, 0, 212)
    hexBg.BackgroundColor3 = theme.Background
    hexBg.BackgroundTransparency = 0.4
    hexBg.Parent = bg
    Instance.new("UICorner", hexBg).CornerRadius = UDim.new(0, 8)
    local hexStroke = Instance.new("UIStroke", hexBg)
    hexStroke.Transparency = 0.85
    hexStroke.Color = Color3.new(1,1,1)
    
    local hexLbl = Instance.new("TextLabel")
    hexLbl.Size = UDim2.new(0, 40, 1, 0)
    hexLbl.Position = UDim2.new(0, 12, 0, 0)
    hexLbl.BackgroundTransparency = 1
    hexLbl.Text = "HEX"
    hexLbl.TextColor3 = theme.MutedText
    hexLbl.Font = Enum.Font.GothamBold
    hexLbl.TextSize = 10
    hexLbl.TextXAlignment = Enum.TextXAlignment.Left
    hexLbl.Parent = hexBg

    local hexInput = Instance.new("TextBox")
    hexInput.Size = UDim2.new(1, -64, 1, 0)
    hexInput.Position = UDim2.new(0, 52, 0, 0)
    hexInput.BackgroundTransparency = 1
    hexInput.Text = "#" .. currentColor:ToHex():upper()
    hexInput.TextColor3 = theme.Text
    hexInput.Font = Enum.Font.Code
    hexInput.TextSize = 12
    hexInput.TextXAlignment = Enum.TextXAlignment.Left
    hexInput.ClearTextOnFocus = false
    hexInput.Parent = hexBg

    local function updateColors(ignoreHex)
        currentColor = Color3.fromHSV(h, s, v)
        satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        previewColor.BackgroundColor3 = currentColor
        prevStroke.Color = currentColor
        updateValGradient()
        
        if not ignoreHex then
            hexInput.Text = "#" .. currentColor:ToHex():upper()
        end
        
        if library.Flags then library.Flags[flag] = currentColor end
        cb(currentColor)
    end

    local isDraggingSat = false
    local isDraggingHue = false
    local isDraggingVal = false

    satMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSat = true
            local posX = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
            local posY = math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
            s = posX
            v = 1 - posY
            mapCursor.Position = UDim2.new(posX, 0, posY, 0)
            valCursor.Position = UDim2.new(v, -2, 0, -1)
            updateColors()
        end
    end)

    hueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingHue = true
            local posX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
            h = 1 - posX
            hueCursor.Position = UDim2.new(posX, -2, 0, -2)
            updateColors()
        end
    end)

    valFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingVal = true
            local posX = math.clamp((input.Position.X - valFrame.AbsolutePosition.X) / valFrame.AbsoluteSize.X, 0, 1)
            v = posX
            valCursor.Position = UDim2.new(posX, -2, 0, -1)
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            updateColors()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDraggingSat then
                local posX = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
                local posY = math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
                s = posX
                v = 1 - posY
                mapCursor.Position = UDim2.new(posX, 0, posY, 0)
                valCursor.Position = UDim2.new(v, -2, 0, -1)
                updateColors()
            elseif isDraggingHue then
                local posX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                h = 1 - posX
                hueCursor.Position = UDim2.new(posX, -2, 0, -2)
                updateColors()
            elseif isDraggingVal then
                local posX = math.clamp((input.Position.X - valFrame.AbsolutePosition.X) / valFrame.AbsoluteSize.X, 0, 1)
                v = posX
                valCursor.Position = UDim2.new(posX, -2, 0, -1)
                mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
                updateColors()
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSat = false
            isDraggingHue = false
            isDraggingVal = false
        end
    end)

    
    local function setFromHex(hexStr)
        local hex = hexStr:gsub("#", "")
        
        if #hex == 3 then
            hex = hex:sub(1,1):rep(2) .. hex:sub(2,2):rep(2) .. hex:sub(3,3):rep(2)
        elseif #hex == 1 then
            hex = hex:rep(6)
        end
        
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16)
            local g = tonumber(hex:sub(3,4), 16)
            local b = tonumber(hex:sub(5,6), 16)
            
            if r and g and b then
                currentColor = Color3.fromRGB(r, g, b)
                h, s, v = currentColor:ToHSV()
                mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
                hueCursor.Position = UDim2.new(1-h, -2, 0, -2)
                valCursor.Position = UDim2.new(v, -2, 0, -1)
                updateColors(true)
            end
        end
    end

    hexInput:GetPropertyChangedSignal("Text"):Connect(function()
        if not hexInput:IsFocused() then return end
        setFromHex(hexInput.Text)
    end)

    hexInput.FocusLost:Connect(function(enterPressed)
        TweenService:Create(hexStroke, TweenInfo.new(0.15), {Color = Color3.new(1,1,1), Transparency = 0.85}):Play()
        setFromHex(hexInput.Text)
        hexInput.Text = "#" .. currentColor:ToHex():upper()
    end)

    if library.Flags then library.Flags[flag] = default end

    return {
        Frame = cpFrame,
        Set = function(self, color)
            currentColor = color
            h, s, v = currentColor:ToHSV()
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            hueCursor.Position = UDim2.new(1-h, -2, 0, -2)
            valCursor.Position = UDim2.new(v, -2, 0, -1)
            updateColors()
        end
    }
end

return ColorPicker

end function __DARKLUA_BUNDLE_MODULES.q():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.q if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.q=v end return v.c end end do local function __modImpl()
local Constants = __DARKLUA_BUNDLE_MODULES.a()

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
end function __DARKLUA_BUNDLE_MODULES.r():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.r if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.r=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
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
end function __DARKLUA_BUNDLE_MODULES.s():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.s if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.s=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services

local InventoryGrid = {}

function InventoryGrid:Add(parent, options, library)
    local iName = options.Name or "Inventory"
    local cb = options.OnSell or function() end
    local theme = library.CurrentTheme or {
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20),
        Header = Color3.fromRGB(255, 100, 130)
    }

    local gridContainer = Instance.new("Frame")
    gridContainer.Size = UDim2.new(1, -10, 0, 30)
    gridContainer.BackgroundColor3 = theme.Card
    gridContainer.Parent = parent
    Instance.new("UICorner", gridContainer).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = gridContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = Instance.new("UIPadding")
    padding.Parent = gridContainer
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    
    local InvObj = {
        Type = "InventoryGrid",
        FrameCache = {},
        CurrentList = {}
    }
    
    function InvObj:Refresh(newList)
        InvObj.CurrentList = newList
        local count = 0
        for i, itemData in ipairs(newList) do
            count = count + 1
            local itemFrame = InvObj.FrameCache[i]
            if not itemFrame then
                itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(1, -10, 0, 30)
                itemFrame.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
                itemFrame.Parent = gridContainer
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
                
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "NameLbl"
                nameLbl.Size = UDim2.new(0.4, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.TextColor3 = theme.Text
                nameLbl.Font = Enum.Font.GothamSemibold
                nameLbl.TextSize = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = itemFrame
                
                local sellBtn = Instance.new("TextButton")
                sellBtn.Name = "SellBtn"
                sellBtn.Size = UDim2.new(0, 50, 0, 22)
                sellBtn.Position = UDim2.new(1, -55, 0.5, -11)
                sellBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
                sellBtn.Text = "Sell"
                sellBtn.TextColor3 = Color3.new(1,1,1)
                sellBtn.Font = Enum.Font.GothamBold
                sellBtn.TextSize = 11
                sellBtn.Parent = itemFrame
                Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 4)
                
                sellBtn.MouseButton1Click:Connect(function()
                    if cb and InvObj.CurrentList[i] then
                        cb(InvObj.CurrentList[i])
                    end
                end)
                
                InvObj.FrameCache[i] = itemFrame
            end
            
            itemFrame.Visible = true
            itemFrame.NameLbl.Text = itemData.Name or "Unknown"
        end
        
        for i = count + 1, #InvObj.FrameCache do
            InvObj.FrameCache[i].Visible = false
        end
        
        gridContainer.Size = UDim2.new(1, -10, 0, (count * 34) + 10)
    end
    
    return InvObj
end

return InventoryGrid
end function __DARKLUA_BUNDLE_MODULES.t():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.t if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.t=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()
local Services = Constants.Services

local PlotGrid = {}

function PlotGrid:Add(parent, options, library)
    local iName = options.Name or "Plot Grid"
    local onPickup = options.OnPickup or function() end
    local onUpgrade = options.OnUpgrade or function() end
    local theme = library.CurrentTheme or {
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20),
        Header = Color3.fromRGB(255, 100, 130)
    }

    local gridContainer = Instance.new("Frame")
    gridContainer.Size = UDim2.new(1, -10, 0, 30)
    gridContainer.BackgroundColor3 = theme.Card
    gridContainer.Parent = parent
    Instance.new("UICorner", gridContainer).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = gridContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = Instance.new("UIPadding")
    padding.Parent = gridContainer
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    
    local PlotObj = {
        Type = "PlotGrid",
        FrameCache = {},
        CurrentList = {}
    }
    
    function PlotObj:Refresh(newList)
        PlotObj.CurrentList = newList
        local count = 0
        for i, itemData in ipairs(newList) do
            count = count + 1
            local itemFrame = PlotObj.FrameCache[i]
            if not itemFrame then
                itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(1, -10, 0, 30)
                itemFrame.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
                itemFrame.Parent = gridContainer
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
                
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "NameLbl"
                nameLbl.Size = UDim2.new(0.4, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.TextColor3 = theme.Text
                nameLbl.Font = Enum.Font.GothamSemibold
                nameLbl.TextSize = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = itemFrame
                
                local actionsFrame = Instance.new("Frame")
                actionsFrame.Size = UDim2.new(0, 100, 1, 0)
                actionsFrame.Position = UDim2.new(1, -105, 0, 0)
                actionsFrame.BackgroundTransparency = 1
                actionsFrame.Parent = itemFrame
                
                local pickupBtn = Instance.new("TextButton")
                pickupBtn.Size = UDim2.new(0, 45, 0, 22)
                pickupBtn.Position = UDim2.new(0, 0, 0.5, -11)
                pickupBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
                pickupBtn.Text = "⬆"
                pickupBtn.TextColor3 = Color3.new(1,1,1)
                pickupBtn.Parent = actionsFrame
                
                pickupBtn.MouseButton1Click:Connect(function()
                    if onPickup and PlotObj.CurrentList[i] then onPickup(PlotObj.CurrentList[i]) end
                end)
                
                PlotObj.FrameCache[i] = itemFrame
            end
            
            itemFrame.Visible = true
            itemFrame.NameLbl.Text = itemData.Name or "Unknown"
        end
        
        for i = count + 1, #PlotObj.FrameCache do
            PlotObj.FrameCache[i].Visible = false
        end
        
        gridContainer.Size = UDim2.new(1, -10, 0, (count * 34) + 10)
    end
    
    return PlotObj
end

return PlotGrid
end function __DARKLUA_BUNDLE_MODULES.u():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.u if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.u=v end return v.c end end do local function __modImpl()

local Constants = __DARKLUA_BUNDLE_MODULES.a()

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
end function __DARKLUA_BUNDLE_MODULES.v():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.v if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.v=v end return v.c end end do local function __modImpl()
local Documentation = {}

function Documentation:AddTitle(parent, options, library)
    local text = options.Title or options.Text or "DOCUMENTATION TITLE"
    local theme = library.CurrentTheme or library.Theme
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 30)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = parent
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0, 16)
    accentBar.Position = UDim2.new(0, 4, 0.5, -8)
    accentBar.BackgroundColor3 = theme.Primary
    accentBar.BorderSizePixel = 0
    accentBar.Parent = titleFrame
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text:upper()
    label.TextColor3 = theme.Primary
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = titleFrame
    
    
    local spacedText = ""
    for i = 1, #text do
        spacedText = spacedText .. text:sub(i,i):upper() .. " "
    end
    label.Text = spacedText
    
    return titleFrame
end

function Documentation:AddDescription(parent, options, library)
    local text = options.Text or options.Description or "Description text..."
    local theme = library.CurrentTheme or library.Theme
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -8, 0, 20) 
    descLabel.BackgroundTransparency = 1
    descLabel.Text = text
    descLabel.TextColor3 = theme.SecondaryText
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.Parent = parent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 4)
    padding.Parent = descLabel
    
    local textBounds = descLabel.TextBounds
    descLabel.Size = UDim2.new(1, -8, 0, textBounds.Y + 10)
    
    descLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        descLabel.Size = UDim2.new(1, -8, 0, descLabel.TextBounds.Y + 10)
    end)
    
    return descLabel
end

function Documentation:AddCard(parent, options, library)
    local title = options.Title or "Card Title"
    local desc = options.Description or options.Text or "Card description goes here."
    local theme = library.CurrentTheme or library.Theme
    
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, 60)
    cardFrame.BackgroundColor3 = theme.Surface
    cardFrame.BackgroundTransparency = 0.5
    cardFrame.Parent = parent
    Instance.new("UICorner", cardFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Primary
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = cardFrame
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 16)
    titleLbl.Position = UDim2.new(0, 12, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = cardFrame
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -24, 0, 20)
    descLbl.Position = UDim2.new(0, 12, 0, 26)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = theme.SecondaryText
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.Parent = cardFrame
    
    
    local frameHeight = 10 + 16 + descLbl.TextBounds.Y + 10
    cardFrame.Size = UDim2.new(1, 0, 0, math.max(60, frameHeight))
    
    return cardFrame
end

function Documentation:AddVersionCard(parent, options, library)
    local version = options.Version or "v1.0.0"
    local title = options.Title or "Added new features"
    local description = options.Description or options.Text or "- Updated xyz\n- Fixed abc"
    local theme = library.CurrentTheme or library.Theme
    
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, 80)
    cardFrame.BackgroundColor3 = theme.Background
    cardFrame.BackgroundTransparency = 0.1
    cardFrame.Parent = parent
    Instance.new("UICorner", cardFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Primary
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.Parent = cardFrame
    
    local statusBadge = Instance.new("Frame")
    statusBadge.Size = UDim2.new(0, 48, 0, 18)
    statusBadge.Position = UDim2.new(0, 12, 0, 12)
    statusBadge.BackgroundColor3 = theme.Primary
    statusBadge.BackgroundTransparency = 0.8
    statusBadge.Parent = cardFrame
    Instance.new("UICorner", statusBadge).CornerRadius = UDim.new(0, 4)
    
    local versionLbl = Instance.new("TextLabel")
    versionLbl.Size = UDim2.new(1, 0, 1, 0)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = version
    versionLbl.TextColor3 = theme.Text
    versionLbl.Font = Enum.Font.GothamBold
    versionLbl.TextSize = 10
    versionLbl.Parent = statusBadge
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -76, 0, 18)
    titleLbl.Position = UDim2.new(0, 68, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = cardFrame
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -24, 0, 30)
    descLbl.Position = UDim2.new(0, 12, 0, 38)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = theme.SecondaryText
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.Parent = cardFrame
    
    
    local frameHeight = 38 + descLbl.TextBounds.Y + 12
    cardFrame.Size = UDim2.new(1, 0, 0, math.max(60, frameHeight))
    
    return cardFrame
end

return Documentation
end function __DARKLUA_BUNDLE_MODULES.w():typeof(__modImpl())local v=__DARKLUA_BUNDLE_MODULES.cache.w if not v then v={c=__modImpl()}__DARKLUA_BUNDLE_MODULES.cache.w=v end return v.c end end end


local RoseUI = {
    Flags = {},
    Elements = {},
    CurrentTheme = nil
}


RoseUI.Constants = __DARKLUA_BUNDLE_MODULES.a()
RoseUI.Themes = __DARKLUA_BUNDLE_MODULES.b()
RoseUI.Assets = __DARKLUA_BUNDLE_MODULES.c()
RoseUI.Utilities = __DARKLUA_BUNDLE_MODULES.d()


RoseUI.CurrentTheme = RoseUI.Themes["Rose v2 (Premium)"]


RoseUI.Notification = __DARKLUA_BUNDLE_MODULES.e()
RoseUI.Window = __DARKLUA_BUNDLE_MODULES.f()
RoseUI.Folder = __DARKLUA_BUNDLE_MODULES.g()
RoseUI.Tab = __DARKLUA_BUNDLE_MODULES.h()
RoseUI.Section = __DARKLUA_BUNDLE_MODULES.i()


RoseUI.Elements.Button = __DARKLUA_BUNDLE_MODULES.j()
RoseUI.Elements.Toggle = __DARKLUA_BUNDLE_MODULES.k()
RoseUI.Elements.Slider = __DARKLUA_BUNDLE_MODULES.l()
RoseUI.Elements.Dropdown = __DARKLUA_BUNDLE_MODULES.m()
RoseUI.Elements.SearchDropdown = __DARKLUA_BUNDLE_MODULES.n()
RoseUI.Elements.Textbox = __DARKLUA_BUNDLE_MODULES.o()
RoseUI.Elements.Keybind = __DARKLUA_BUNDLE_MODULES.p()
RoseUI.Elements.ColorPicker = __DARKLUA_BUNDLE_MODULES.q()
RoseUI.Elements.Label = __DARKLUA_BUNDLE_MODULES.r()
RoseUI.Elements.TargetList = __DARKLUA_BUNDLE_MODULES.s()
RoseUI.Elements.InventoryGrid = __DARKLUA_BUNDLE_MODULES.t()
RoseUI.Elements.PlotGrid = __DARKLUA_BUNDLE_MODULES.u()
RoseUI.Elements.Paragraph = __DARKLUA_BUNDLE_MODULES.v()
RoseUI.Elements.Documentation = __DARKLUA_BUNDLE_MODULES.w()


function RoseUI:Notify(options)
    return self.Notification:New(options, self)
end

function RoseUI:CreateWindow(options)
    return self.Window:New(options, self)
end

return RoseUI
