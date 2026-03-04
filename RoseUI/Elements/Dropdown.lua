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
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Sidebar = Color3.fromRGB(12, 18, 14),
        Content = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(18, 26, 20),
        Text = Color3.fromRGB(240, 255, 240)
    }

    _G.RoseUI_ZIndex = (_G.RoseUI_ZIndex or 100) + 10
    local currentZ = _G.RoseUI_ZIndex

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, -10, 0, 42)
    dropFrame.BackgroundColor3 = theme.Card
    dropFrame.ZIndex = currentZ
    dropFrame.Parent = parent
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dName
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = currentZ + 1
    label.Parent = dropFrame

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.5, -15, 0, 30)
    dropBtn.Position = UDim2.new(0.5, 5, 0.5, -15)
    dropBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    dropBtn.Text = "  " .. default
    dropBtn.TextColor3 = Color3.fromRGB(200, 180, 190)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 12
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.ZIndex = currentZ + 1
    dropBtn.Parent = dropFrame
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 120, 130)
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = currentZ + 2
    arrow.Parent = dropBtn

    local dropMenuBg = Instance.new("Frame")
    dropMenuBg.Size = UDim2.new(0, 0, 0, 0)
    dropMenuBg.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
    dropMenuBg.ZIndex = currentZ + 50
    dropMenuBg.ClipsDescendants = true
    dropMenuBg.Visible = false
    -- Simplified parent logic for the modular version
    dropMenuBg.Parent = dropFrame:FindFirstAncestor("Main") or parent
    Instance.new("UICorner", dropMenuBg).CornerRadius = UDim.new(0, 4)
    
    local dropMenuStroke = Instance.new("UIStroke")
    dropMenuStroke.Color = theme.Header
    dropMenuStroke.Transparency = 0.5
    dropMenuStroke.Thickness = 1
    dropMenuStroke.Parent = dropMenuBg

    local dropMenu = Instance.new("ScrollingFrame")
    dropMenu.Size = UDim2.new(1, -4, 1, -4)
    dropMenu.Position = UDim2.new(0, 2, 0, 2)
    dropMenu.BackgroundTransparency = 1
    dropMenu.BorderSizePixel = 0
    dropMenu.ScrollBarThickness = 3
    dropMenu.ScrollBarImageColor3 = theme.Header
    dropMenu.ZIndex = currentZ + 51
    dropMenu.Parent = dropMenuBg
    
    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Parent = dropMenu
    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local DropdownObj = {
        Type = "Dropdown",
        Value = default,
        Flag = flag,
        Options = optionsList,
        IsOpen = false
    }

    function DropdownObj:Set(val)
        DropdownObj.Value = val
        dropBtn.Text = "  " .. tostring(val)
        if library.Flags then library.Flags[flag] = val end
        cb(val)
    end

    function DropdownObj:Toggle()
        DropdownObj.IsOpen = not DropdownObj.IsOpen
        if DropdownObj.IsOpen then
            dropMenuBg.Visible = true
            local listHeight = #DropdownObj.Options * 25
            dropMenuBg.Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)
            
            -- Absolute positioning logic
            local absolutePos = dropBtn.AbsolutePosition
            local containerPos = dropMenuBg.Parent.AbsolutePosition
            dropMenuBg.Position = UDim2.new(0, absolutePos.X - containerPos.X, 0, absolutePos.Y - containerPos.Y + dropBtn.AbsoluteSize.Y + 4)
            
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            TweenService:Create(dropMenuBg, TweenInfo.new(0.3), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, math.clamp(listHeight, 10, 150))}):Play()
        else
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            local tween = TweenService:Create(dropMenuBg, TweenInfo.new(0.2), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            tween:Play()
            tween.Completed:Wait()
            if not DropdownObj.IsOpen then dropMenuBg.Visible = false end
        end
    end

    function DropdownObj:Refresh(newList)
        DropdownObj.Options = newList
        for _, child in pairs(dropMenu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in pairs(newList) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -6, 0, 25)
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 30)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = "  " .. opt
            optBtn.TextColor3 = theme.Text
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 11
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.ZIndex = currentZ + 52
            optBtn.Parent = dropMenu
            
            optBtn.MouseButton1Click:Connect(function()
                DropdownObj:Set(opt)
                DropdownObj:Toggle()
            end)
        end
    end

    dropBtn.MouseButton1Click:Connect(function()
        DropdownObj:Toggle()
    end)

    DropdownObj:Refresh(optionsList)
    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, DropdownObj)

    return DropdownObj
end

return Dropdown
