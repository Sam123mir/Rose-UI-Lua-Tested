local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Tab = {}

function Tab:New(tabOptions, window)
    local tabName = tabOptions.Name or "Tab"
    local library = window.Library
    local theme = window.Theme
    local assets = library.Assets

    local tabIcon = tabOptions.Icon or (tabOptions.IsFile and "File" or "Dashboard")
    -- Support for custom asset IDs
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

    -- Active indicator bar (left side)
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
        icon.Image = tabIcon or ""
    end
    
    icon.ImageColor3 = theme.SecondaryText
    icon.Parent = contentFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, isSubTab and -34 or -38, 1, 0)
    label.Position = UDim2.new(0, isSubTab and 32 or 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = tabName
    label.TextColor3 = theme.SecondaryText
    label.Font = Enum.Font.Montserrat
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    -- Connector line for sub-items
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
        
        leftCol.Size = UDim2.new(0.5, -8, 0, leftH)
        rightCol.Size = UDim2.new(0.5, -8, 0, rightH)
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
        
        -- Cierra todos los dropdowns abiertos al cambiar de pestaña
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

    -- Auto select first tab
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

    function TabObj:AddKeybind(options)
        return library.Elements.Keybind:Add(getNextCol(), options, library)
    end
    
    function TabObj:AddToggle(options)
        return library.Elements.Toggle:Add(getNextCol(), options, library)
    end
    
    function TabObj:AddSlider(options)
        return library.Elements.Slider:Add(getNextCol(), options, library)
    end
    
    function TabObj:AddDropdown(options)
        return library.Elements.Dropdown:Add(getNextCol(), options, library)
    end
    
    function TabObj:AddButton(options)
        return library.Elements.Button:Add(getNextCol(), options, library)
    end

    return TabObj
end

return Tab
