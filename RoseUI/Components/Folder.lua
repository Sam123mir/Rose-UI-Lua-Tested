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
    folderFrame.Size = UDim2.new(1, 0, 0, 40)
    folderFrame.BackgroundTransparency = 1
    folderFrame.ClipsDescendants = true
    folderFrame.Parent = window.NavScroll
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = folderFrame
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 0, 32)
    content.Position = UDim2.new(0, 10, 0, 4)
    content.BackgroundColor3 = theme.Accent
    content.BackgroundTransparency = 0.5
    content.Parent = folderFrame
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 18, 0, 18)
    iconImg.Position = UDim2.new(0, 10, 0.5, -9)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = assets.Icons[icon] or assets.Icons.Folder
    iconImg.ImageColor3 = theme.SecondaryText
    iconImg.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = theme.SecondaryText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
    
    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.Position = UDim2.new(1, -24, 0.5, -7)
    arrow.BackgroundTransparency = 1
    arrow.Image = assets.Icons.Expand
    arrow.ImageColor3 = theme.SecondaryText
    arrow.Parent = content
    
    local fileContainer = Instance.new("Frame")
    fileContainer.Name = "Files"
    fileContainer.Size = UDim2.new(1, 0, 0, 0)
    fileContainer.Position = UDim2.new(0, 0, 0, 40)
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
        local targetSize = state and (layout.AbsoluteContentSize.Y + 40) or 40
        TweenService:Create(folderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = state and 180 or 0}):Play()
        
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
            folderFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 40)
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
