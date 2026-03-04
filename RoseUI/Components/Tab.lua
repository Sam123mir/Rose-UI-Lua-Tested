local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService

local Tab = {}

function Tab:New(tabOptions, window)
    local tabName = tabOptions.Name or "Tab"
    local tabIcon = tabOptions.Icon or ""
    local library = window.Library
    local theme = window.Theme

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundTransparency = 1 
    tabBtn.Text = ""
    tabBtn.Parent = window.Instance.Main.Body.Sidebar.ScrollingFrame -- Adjusted path

    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -35, 1, 0)
    tabLabel.Position = UDim2.new(0, 32, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = tabName
    tabLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    tabLabel.Font = Enum.Font.GothamSemibold
    tabLabel.TextSize = 13
    tabLabel.Parent = tabBtn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = window.PageContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
    end)

    local TabObj = {
        Window = window,
        Page = page,
        Btn = tabBtn,
        Label = tabLabel
    }

    tabBtn.MouseButton1Click:Connect(function()
        if window.CurrentTab == TabObj then return end
        
        if window.CurrentTab then
            window.CurrentTab.Page.Visible = false
            TweenService:Create(window.CurrentTab.Label, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(140, 140, 140)}):Play()
        end

        window.CurrentTab = TabObj
        page.Visible = true
        TweenService:Create(tabLabel, TweenInfo.new(0.3), {TextColor3 = theme.Text}):Play()
    end)

    -- Auto select first tab
    if #window.Tabs == 0 then
        window.CurrentTab = TabObj
        page.Visible = true
        tabLabel.TextColor3 = theme.Text
    end

    table.insert(window.Tabs, TabObj)

    function TabObj:AddSection(sName)
        return library.Section:New(sName, self)
    end

    return TabObj
end

return Tab
