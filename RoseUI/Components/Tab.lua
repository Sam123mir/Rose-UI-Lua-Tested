local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService

local Tab = {}

function Tab:New(tabOptions, window)
    local tabName = tabOptions.Name or "Tab"
    local tabIcon = tabOptions.Icon or "Dashboard"
    local isSubTab = tabOptions.IsSubTab or false
    local library = window.Library
    local theme = window.Theme
    local assets = library.Assets

    local tabBtn = Instance.new("Frame")
    tabBtn.Name = tabName .. (isSubTab and "_Sub" or "_Main")
    tabBtn.Size = UDim2.new(1, 0, 0, isSubTab and 30 or 40)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Parent = window.NavScroll

    local btnTrigger = Instance.new("TextButton")
    btnTrigger.Size = UDim2.new(1, 0, 1, 0)
    btnTrigger.BackgroundTransparency = 1
    btnTrigger.Text = ""
    btnTrigger.Parent = tabBtn

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, isSubTab and -30 or -20, 1, -4)
    contentFrame.Position = UDim2.new(0, isSubTab and 25 or 10, 0, 2)
    contentFrame.BackgroundColor3 = theme.Primary
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = tabBtn
    Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 4)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, isSubTab and 14 or 18, 0, isSubTab and 14 or 18)
    icon.Position = UDim2.new(0, 8, 0.5, isSubTab and -7 or -9)
    icon.BackgroundTransparency = 1
    icon.Image = assets.Icons[tabIcon] or ""
    icon.ImageColor3 = theme.SecondaryText
    icon.Parent = contentFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, isSubTab and -32 or -36, 1, 0)
    label.Position = UDim2.new(0, isSubTab and 28 or 34, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = tabName
    label.TextColor3 = theme.SecondaryText
    label.Font = isSubTab and Enum.Font.GothamSemibold or Enum.Font.GothamBold
    label.TextSize = isSubTab and 10 or 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    if isSubTab then
        local subLine = Instance.new("Frame")
        subLine.Size = UDim2.new(0, 1, 1, 0)
        subLine.Position = UDim2.new(0, -10, 0, 0)
        subLine.BackgroundColor3 = theme.Primary
        subLine.BackgroundTransparency = 0.8
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

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    local TabObj = {
        Window = window,
        Page = page,
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
            TweenService:Create(contentFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0, BackgroundColor3 = theme.Primary}):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextColor3 = Color3.new(1,1,1)}):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1,1,1)}):Play()
            page.Visible = true
        else
            TweenService:Create(contentFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextColor3 = theme.SecondaryText}):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {ImageColor3 = theme.SecondaryText}):Play()
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
    end)

    btnTrigger.MouseEnter:Connect(function()
        if not TabObj.Active then
            TweenService:Create(contentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.new(1,1,1)}):Play()
        end
    end)

    btnTrigger.MouseLeave:Connect(function()
        if not TabObj.Active then
            TweenService:Create(contentFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end)

    function TabObj:Deactivate()
        setActive(false)
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

    function TabObj:AddSection(sName)
        return library.Section:New(sName, self)
    end

    return TabObj
end

return Tab
