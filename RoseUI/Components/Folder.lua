local import = ...
local Constants = import("Core/Constants")
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
    
    -- Folder header with glassmorphism style
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
    
    -- Category accent bar (left side)
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
    iconImg.Image = assets.Icons[icon] or assets.Icons.Folder
    iconImg.ImageColor3 = theme.SecondaryText
    iconImg.Parent = content
    
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
    
    -- Letter spacing effect
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
    
    -- Hover effects for folder header
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
        
        -- Force update NavScroll CanvasSize
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
