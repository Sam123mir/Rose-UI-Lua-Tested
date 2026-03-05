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
    label.TextSize = 12
    label.Font = Enum.Font.Inter
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(1, -24, 0, 32)
    dropBtn.Position = UDim2.new(0, 12, 0, options.Description and 42 or 28)
    dropBtn.BackgroundColor3 = theme.Surface
    dropBtn.BackgroundTransparency = 0.5
    dropBtn.Text = "Select Option..."
    dropBtn.TextColor3 = theme.MutedText
    dropBtn.Font = Enum.Font.Inter
    dropBtn.TextSize = 11
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

    -- Dropdown Menu Container
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

    -- Inner padding for the menu
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
        -- Update visual selection state
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then
                local isSelected = child.Text == tostring(val)
                -- Update the background highlight for the selected item
                if isSelected then
                    child.BackgroundTransparency = 0.6
                    child.BackgroundColor3 = theme.Primary
                    child.TextColor3 = Color3.new(1,1,1)
                    -- Show the check indicator
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
            
            -- Check indicator for selected item
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
                DropdownObj:Toggle() -- Close automatically
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
