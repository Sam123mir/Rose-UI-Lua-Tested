local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local SearchDropdown = {}

function SearchDropdown:Add(parent, options, library)
    local dName = options.Name or "Search Dropdown"
    local optionsList = options.Options or {}
    local selectedItems = options.Default or {}
    if type(selectedItems) ~= "table" then selectedItems = {selectedItems} end
    local cb = options.Callback or function() end
    local theme = library.CurrentTheme or {
        Header = Color3.fromRGB(255, 100, 130),
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20)
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
    dropBtn.Text = "  " .. (#selectedItems > 0 and table.concat(selectedItems, ", ") or "None")
    dropBtn.TextColor3 = Color3.fromRGB(200, 180, 190)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 11
    dropBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropBtn.ZIndex = currentZ + 1
    dropBtn.Parent = dropFrame
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 4)

    local dropMenuBg = Instance.new("Frame")
    dropMenuBg.Size = UDim2.new(0, 0, 0, 0)
    dropMenuBg.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
    dropMenuBg.ZIndex = currentZ + 50
    dropMenuBg.ClipsDescendants = true
    dropMenuBg.Visible = false
    dropMenuBg.Parent = dropFrame:FindFirstAncestor("Main") or parent
    Instance.new("UICorner", dropMenuBg).CornerRadius = UDim.new(0, 4)

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -10, 0, 25)
    searchBox.Position = UDim2.new(0, 5, 0, 5)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
    searchBox.PlaceholderText = "Search..."
    searchBox.Text = ""
    searchBox.TextColor3 = theme.Text
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.ZIndex = currentZ + 51
    searchBox.Parent = dropMenuBg
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)

    local dropMenu = Instance.new("ScrollingFrame")
    dropMenu.Size = UDim2.new(1, -4, 1, -35)
    dropMenu.Position = UDim2.new(0, 2, 0, 32)
    dropMenu.BackgroundTransparency = 1
    dropMenu.BorderSizePixel = 0
    dropMenu.ScrollBarThickness = 3
    dropMenu.ZIndex = currentZ + 51
    dropMenu.Parent = dropMenuBg
    
    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Parent = dropMenu
    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder

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
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -6, 0, 25)
                optBtn.BackgroundColor3 = table.find(SearchObj.Value, opt) and theme.Header or Color3.fromRGB(40, 25, 30)
                optBtn.Text = "  " .. opt
                optBtn.TextColor3 = theme.Text
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.ZIndex = currentZ + 52
                optBtn.Parent = dropMenu
                
                optBtn.MouseButton1Click:Connect(function()
                    local idx = table.find(SearchObj.Value, opt)
                    if idx then table.remove(SearchObj.Value, idx) else table.insert(SearchObj.Value, opt) end
                    dropBtn.Text = "  " .. (#SearchObj.Value > 0 and table.concat(SearchObj.Value, ", ") or "None")
                    cb(SearchObj.Value)
                    SearchObj:Refresh(searchBox.Text)
                end)
            end
        end
        dropMenu.CanvasSize = UDim2.new(0, 0, 0, count * 25)
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
            TweenService:Create(dropMenuBg, TweenInfo.new(0.3), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 150)}):Play()
            SearchObj:Refresh("")
        else
            local t = TweenService:Create(dropMenuBg, TweenInfo.new(0.2), {Size = UDim2.new(0, dropBtn.AbsoluteSize.X, 0, 0)})
            t:Play()
            t.Completed:Wait()
            if not SearchObj.IsOpen then dropMenuBg.Visible = false end
        end
    end)

    return SearchObj
end

return SearchDropdown
