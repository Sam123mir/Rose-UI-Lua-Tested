local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Dropdown = {}

function Dropdown:Add(parent, options, library)
    local dName = options.Name or "Dropdown"
    local optionsList = options.Options or {"Option 1", "Option 2"}
    local default = options.Default or optionsList[1]
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]
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
    Instance.new("UICorner", dropMenuBg).CornerRadius = UDim.new(0, 10)
    
    local dropMenuStroke = Instance.new("UIStroke")
    dropMenuStroke.Color = theme.Primary
    dropMenuStroke.Transparency = 0.5
    dropMenuStroke.Thickness = 1
    dropMenuStroke.Parent = dropMenuBg

    local dropMenu = Instance.new("ScrollingFrame")
    dropMenu.Size = UDim2.new(1, -4, 1, -4)
    dropMenu.Position = UDim2.new(0, 2, 0, 2)
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
    end

    function DropdownObj:Toggle()
        DropdownObj.IsOpen = not DropdownObj.IsOpen
        if DropdownObj.IsOpen then
            dropMenuBg.Visible = true
            local listHeight = math.min(#DropdownObj.Options * 28 + 4, 150)
            
            local absolutePos = dropBtn.AbsolutePosition
            local containerPos = dropMenuBg.Parent.AbsolutePosition
            dropMenuBg.Position = UDim2.new(0, absolutePos.X - containerPos.X, 0, absolutePos.Y - containerPos.Y + dropBtn.AbsoluteSize.Y + 4)
            dropMenuBg.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
            
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            TweenService:Create(dropMenuBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, listHeight)}):Play()
        else
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            local tween = TweenService:Create(dropMenuBg, TweenInfo.new(0.2), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                if not DropdownObj.IsOpen then dropMenuBg.Visible = false end
            end)
        end
    end

    function DropdownObj:Refresh(newList)
        DropdownObj.Options = newList
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in pairs(newList) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = tostring(opt)
            optBtn.TextColor3 = theme.Text
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 10
            optBtn.ZIndex = 502
            optBtn.Parent = dropMenu
            
            optBtn.MouseEnter:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = theme.Primary}):Play()
            end)
            optBtn.MouseLeave:Connect(function()
                TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                DropdownObj:Set(opt)
                DropdownObj:Toggle() -- Close automatically
            end)
        end
        dropMenu.CanvasSize = UDim2.new(0, 0, 0, #newList * 26)
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
