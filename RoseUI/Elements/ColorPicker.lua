local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local ColorPicker = {}

function ColorPicker:Add(parent, options, library)
    local cpName = options.Name or "Color Picker"
    local default = options.Default or Color3.fromRGB(242, 13, 13)
    local cb = options.Callback or function() end
    local flag = options.Flag or options.Name
    local theme = library.CurrentTheme or import("Core/Themes")["Rose v2 (Premium)"]

    local h, s, v = default:ToHSV()
    local currentColor = default
    local isOpen = false

    local cpFrame = Instance.new("Frame")
    cpFrame.Name = cpName .. "_ColorPicker"
    cpFrame.Size = UDim2.new(1, 0, 0, 42)
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = cpName
    label.TextColor3 = theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg

    -- Color preview swatch
    local colorDisplayContainer = Instance.new("Frame")
    colorDisplayContainer.Size = UDim2.new(0, 40, 0, 20)
    colorDisplayContainer.Position = UDim2.new(1, -50, 0.5, -10)
    colorDisplayContainer.BackgroundColor3 = theme.Background
    colorDisplayContainer.BackgroundTransparency = 0.3
    colorDisplayContainer.Parent = bg
    Instance.new("UICorner", colorDisplayContainer).CornerRadius = UDim.new(0, 6)
    
    local dispStroke = Instance.new("UIStroke", colorDisplayContainer)
    dispStroke.Color = theme.Primary
    dispStroke.Transparency = 0.5
    dispStroke.Thickness = 1
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(1, -4, 1, -4)
    colorDisplay.Position = UDim2.new(0, 2, 0, 2)
    colorDisplay.BackgroundColor3 = default
    colorDisplay.Parent = colorDisplayContainer
    Instance.new("UICorner", colorDisplay).CornerRadius = UDim.new(0, 4)
    
    local trigger = Instance.new("TextButton")
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""
    trigger.Parent = bg

    -- ========================================================================
    -- POPUP PICKER (Enhanced - Adapted from reference)
    -- ========================================================================
    local popupWidth = 240
    local popupHeight = 290

    local pickerPopup = Instance.new("Frame")
    pickerPopup.Name = "ColorPopup"
    pickerPopup.Size = UDim2.new(0, popupWidth, 0, popupHeight)
    pickerPopup.BackgroundColor3 = theme.Surface
    pickerPopup.BackgroundTransparency = 0.02
    pickerPopup.Visible = false
    pickerPopup.ZIndex = 1000
    pickerPopup.Parent = cpFrame:FindFirstAncestor("Main") or parent
    Instance.new("UICorner", pickerPopup).CornerRadius = UDim.new(0, 12)
    
    local pickerStroke = Instance.new("UIStroke", pickerPopup)
    pickerStroke.Color = theme.Primary
    pickerStroke.Transparency = 0.4
    pickerStroke.Thickness = 1

    -- Header with title
    local popupHeader = Instance.new("Frame")
    popupHeader.Size = UDim2.new(1, 0, 0, 32)
    popupHeader.BackgroundTransparency = 1
    popupHeader.ZIndex = 1001
    popupHeader.Parent = pickerPopup

    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, -40, 1, 0)
    popupTitle.Position = UDim2.new(0, 12, 0, 0)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = cpName
    popupTitle.TextColor3 = theme.Text
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.TextSize = 11
    popupTitle.TextXAlignment = Enum.TextXAlignment.Left
    popupTitle.ZIndex = 1001
    popupTitle.Parent = popupHeader

    local closePopup = Instance.new("TextButton")
    closePopup.Size = UDim2.new(0, 24, 0, 24)
    closePopup.Position = UDim2.new(1, -32, 0.5, -12)
    closePopup.BackgroundColor3 = Color3.new(1,1,1)
    closePopup.BackgroundTransparency = 0.95
    closePopup.Text = "×"
    closePopup.TextColor3 = theme.MutedText
    closePopup.Font = Enum.Font.GothamBold
    closePopup.TextSize = 14
    closePopup.AutoButtonColor = false
    closePopup.ZIndex = 1001
    closePopup.Parent = popupHeader
    Instance.new("UICorner", closePopup).CornerRadius = UDim.new(0, 6)

    closePopup.MouseEnter:Connect(function()
        TweenService:Create(closePopup, TweenInfo.new(0.15), {BackgroundTransparency = 0.7, TextColor3 = theme.Text}):Play()
    end)
    closePopup.MouseLeave:Connect(function()
        TweenService:Create(closePopup, TweenInfo.new(0.15), {BackgroundTransparency = 0.95, TextColor3 = theme.MutedText}):Play()
    end)

    -- Divider under header
    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, -20, 0, 1)
    headerDiv.Position = UDim2.new(0, 10, 1, 0)
    headerDiv.BackgroundColor3 = Color3.new(1,1,1)
    headerDiv.BackgroundTransparency = 0.92
    headerDiv.BorderSizePixel = 0
    headerDiv.ZIndex = 1001
    headerDiv.Parent = popupHeader

    -- Saturation/Value Map
    local satMap = Instance.new("ImageButton")
    satMap.Size = UDim2.new(1, -42, 0, 130)
    satMap.Position = UDim2.new(0, 10, 0, 38)
    satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    satMap.Image = "rbxassetid://6980062489"
    satMap.AutoButtonColor = false
    satMap.ZIndex = 1001
    satMap.Parent = pickerPopup
    Instance.new("UICorner", satMap).CornerRadius = UDim.new(0, 8)

    -- Overlay for the saturation map (makes it look better)
    local satMapStroke = Instance.new("UIStroke", satMap)
    satMapStroke.Color = Color3.new(1,1,1)
    satMapStroke.Transparency = 0.9
    satMapStroke.Thickness = 1

    local mapCursor = Instance.new("Frame")
    mapCursor.Size = UDim2.new(0, 14, 0, 14)
    mapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
    mapCursor.BackgroundColor3 = Color3.new(1,1,1)
    mapCursor.BackgroundTransparency = 0.2
    mapCursor.ZIndex = 1002
    mapCursor.Parent = satMap
    Instance.new("UICorner", mapCursor).CornerRadius = UDim.new(1, 0)
    local cursorStroke = Instance.new("UIStroke", mapCursor)
    cursorStroke.Thickness = 2
    cursorStroke.Color = Color3.new(1,1,1)

    -- Inner dot of cursor
    local cursorDot = Instance.new("Frame")
    cursorDot.Size = UDim2.new(0, 4, 0, 4)
    cursorDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    cursorDot.BackgroundColor3 = default
    cursorDot.ZIndex = 1003
    cursorDot.Parent = mapCursor
    Instance.new("UICorner", cursorDot).CornerRadius = UDim.new(1, 0)

    -- Hue Slider (Vertical)
    local hueSlider = Instance.new("TextButton")
    hueSlider.Size = UDim2.new(0, 18, 0, 130)
    hueSlider.Position = UDim2.new(1, -28, 0, 38)
    hueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    hueSlider.Text = ""
    hueSlider.AutoButtonColor = false
    hueSlider.ZIndex = 1001
    hueSlider.Parent = pickerPopup
    Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", hueSlider).Transparency = 0.9

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Rotation = 90
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueSlider

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(1, 6, 0, 6)
    hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.ZIndex = 1002
    hueCursor.Parent = hueSlider
    Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1, 0)
    local hueStroke = Instance.new("UIStroke", hueCursor)
    hueStroke.Thickness = 1
    hueStroke.Color = Color3.fromRGB(200, 200, 200)

    -- ========================================================================
    -- HEX Input Row
    -- ========================================================================
    local hexRow = Instance.new("Frame")
    hexRow.Size = UDim2.new(1, -20, 0, 26)
    hexRow.Position = UDim2.new(0, 10, 0, 176)
    hexRow.BackgroundTransparency = 1
    hexRow.ZIndex = 1001
    hexRow.Parent = pickerPopup

    local hexLabel = Instance.new("TextLabel")
    hexLabel.Size = UDim2.new(0, 30, 1, 0)
    hexLabel.BackgroundTransparency = 1
    hexLabel.Text = "HEX"
    hexLabel.TextColor3 = theme.MutedText
    hexLabel.Font = Enum.Font.GothamBold
    hexLabel.TextSize = 9
    hexLabel.ZIndex = 1001
    hexLabel.Parent = hexRow

    local hexInputBg = Instance.new("Frame")
    hexInputBg.Size = UDim2.new(1, -38, 1, 0)
    hexInputBg.Position = UDim2.new(0, 36, 0, 0)
    hexInputBg.BackgroundColor3 = theme.Background
    hexInputBg.BackgroundTransparency = 0.3
    hexInputBg.ZIndex = 1001
    hexInputBg.Parent = hexRow
    Instance.new("UICorner", hexInputBg).CornerRadius = UDim.new(0, 6)
    
    local hexInputStroke = Instance.new("UIStroke", hexInputBg)
    hexInputStroke.Color = Color3.new(1,1,1)
    hexInputStroke.Transparency = 0.92
    hexInputStroke.Thickness = 1

    local hexInput = Instance.new("TextBox")
    hexInput.Size = UDim2.new(1, -8, 1, 0)
    hexInput.Position = UDim2.new(0, 4, 0, 0)
    hexInput.BackgroundTransparency = 1
    hexInput.Text = "#" .. default:ToHex():upper()
    hexInput.TextColor3 = theme.Text
    hexInput.PlaceholderText = "#FF0000"
    hexInput.PlaceholderColor3 = theme.MutedText
    hexInput.Font = Enum.Font.Code
    hexInput.TextSize = 10
    hexInput.ClearTextOnFocus = false
    hexInput.ZIndex = 1002
    hexInput.Parent = hexInputBg

    hexInput.Focused:Connect(function()
        TweenService:Create(hexInputStroke, TweenInfo.new(0.15), {Color = theme.Primary, Transparency = 0.5}):Play()
    end)
    hexInput.FocusLost:Connect(function(enterPressed)
        TweenService:Create(hexInputStroke, TweenInfo.new(0.15), {Color = Color3.new(1,1,1), Transparency = 0.92}):Play()
        if enterPressed then
            local hex = hexInput.Text:gsub("#", "")
            if #hex == 6 then
                local ok, r, g, b = pcall(function()
                    return tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
                end)
                if ok and r and g and b then
                    currentColor = Color3.fromRGB(r, g, b)
                    h, s, v = currentColor:ToHSV()
                    mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
                    hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
                    satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    colorDisplay.BackgroundColor3 = currentColor
                    cursorDot.BackgroundColor3 = currentColor
                    if library.Flags then library.Flags[flag] = currentColor end
                    cb(currentColor)
                end
            end
        end
    end)

    -- ========================================================================
    -- Color Presets Row
    -- ========================================================================
    local presetsLabel = Instance.new("TextLabel")
    presetsLabel.Size = UDim2.new(1, -20, 0, 14)
    presetsLabel.Position = UDim2.new(0, 10, 0, 208)
    presetsLabel.BackgroundTransparency = 1
    presetsLabel.Text = "PRESETS"
    presetsLabel.TextColor3 = theme.MutedText
    presetsLabel.Font = Enum.Font.GothamBold
    presetsLabel.TextSize = 8
    presetsLabel.TextXAlignment = Enum.TextXAlignment.Left
    presetsLabel.ZIndex = 1001
    presetsLabel.Parent = pickerPopup

    local presetsFrame = Instance.new("Frame")
    presetsFrame.Size = UDim2.new(1, -20, 0, 26)
    presetsFrame.Position = UDim2.new(0, 10, 0, 224)
    presetsFrame.BackgroundTransparency = 1
    presetsFrame.ZIndex = 1001
    presetsFrame.Parent = pickerPopup

    local presetsLayout = Instance.new("UIListLayout")
    presetsLayout.FillDirection = Enum.FillDirection.Horizontal
    presetsLayout.Padding = UDim.new(0, 4)
    presetsLayout.Parent = presetsFrame

    local presetColors = {
        Color3.fromRGB(242, 13, 13),    -- Rose Red
        Color3.fromRGB(239, 68, 68),    -- Red
        Color3.fromRGB(249, 115, 22),   -- Orange
        Color3.fromRGB(234, 179, 8),    -- Yellow
        Color3.fromRGB(34, 197, 94),    -- Green
        Color3.fromRGB(6, 182, 212),    -- Cyan
        Color3.fromRGB(59, 130, 246),   -- Blue
        Color3.fromRGB(139, 92, 246),   -- Violet
        Color3.fromRGB(236, 72, 153),   -- Pink
        Color3.new(1, 1, 1),            -- White
        Color3.fromRGB(148, 163, 184),  -- Gray
        Color3.new(0, 0, 0),            -- Black
    }

    for _, presetColor in pairs(presetColors) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Size = UDim2.new(0, 16, 0, 16)
        presetBtn.BackgroundColor3 = presetColor
        presetBtn.Text = ""
        presetBtn.AutoButtonColor = false
        presetBtn.ZIndex = 1002
        presetBtn.Parent = presetsFrame
        Instance.new("UICorner", presetBtn).CornerRadius = UDim.new(0, 4)
        
        local presetStroke = Instance.new("UIStroke", presetBtn)
        presetStroke.Color = Color3.new(1,1,1)
        presetStroke.Transparency = 0.85
        presetStroke.Thickness = 1

        presetBtn.MouseEnter:Connect(function()
            TweenService:Create(presetBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 18, 0, 18)}):Play()
            TweenService:Create(presetStroke, TweenInfo.new(0.1), {Transparency = 0.3}):Play()
        end)
        presetBtn.MouseLeave:Connect(function()
            TweenService:Create(presetBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play()
            TweenService:Create(presetStroke, TweenInfo.new(0.1), {Transparency = 0.85}):Play()
        end)

        presetBtn.MouseButton1Click:Connect(function()
            currentColor = presetColor
            h, s, v = currentColor:ToHSV()
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
            satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            colorDisplay.BackgroundColor3 = currentColor
            cursorDot.BackgroundColor3 = currentColor
            hexInput.Text = "#" .. currentColor:ToHex():upper()
            if library.Flags then library.Flags[flag] = currentColor end
            cb(currentColor)
        end)
    end

    -- ========================================================================
    -- Action Buttons Row (Cancel / Save)
    -- ========================================================================
    local actionsRow = Instance.new("Frame")
    actionsRow.Size = UDim2.new(1, -20, 0, 28)
    actionsRow.Position = UDim2.new(0, 10, 0, 256)
    actionsRow.BackgroundTransparency = 1
    actionsRow.ZIndex = 1001
    actionsRow.Parent = pickerPopup

    local actionsLayout = Instance.new("UIListLayout")
    actionsLayout.FillDirection = Enum.FillDirection.Horizontal
    actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    actionsLayout.Padding = UDim.new(0, 8)
    actionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    actionsLayout.Parent = actionsRow

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 65, 0, 24)
    cancelBtn.BackgroundColor3 = theme.Accent
    cancelBtn.BackgroundTransparency = 0.3
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = theme.SecondaryText
    cancelBtn.Font = Enum.Font.GothamSemibold
    cancelBtn.TextSize = 9
    cancelBtn.AutoButtonColor = false
    cancelBtn.ZIndex = 1002
    cancelBtn.Parent = actionsRow
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)

    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0, 65, 0, 24)
    saveBtn.BackgroundColor3 = theme.Primary
    saveBtn.BackgroundTransparency = 0.1
    saveBtn.Text = "Save"
    saveBtn.TextColor3 = Color3.new(1,1,1)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 9
    saveBtn.AutoButtonColor = false
    saveBtn.ZIndex = 1002
    saveBtn.Parent = actionsRow
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

    -- Button hover effects
    cancelBtn.MouseEnter:Connect(function()
        TweenService:Create(cancelBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
    end)
    cancelBtn.MouseLeave:Connect(function()
        TweenService:Create(cancelBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
    end)
    saveBtn.MouseEnter:Connect(function()
        TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    saveBtn.MouseLeave:Connect(function()
        TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
    end)

    -- ========================================================================
    -- Color Picker Object & Logic
    -- ========================================================================
    local ColorObj = {
        Type = "ColorPicker",
        Value = default,
        Flag = flag
    }

    local savedColor = default -- Track the "saved" color

    local function updateColor()
        currentColor = Color3.fromHSV(h, s, v)
        colorDisplay.BackgroundColor3 = currentColor
        cursorDot.BackgroundColor3 = currentColor
        satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        hexInput.Text = "#" .. currentColor:ToHex():upper()
        if library.Flags then library.Flags[flag] = currentColor end
        cb(currentColor)
    end

    -- Hue dragging
    local draggingHue = false
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            draggingHue = true 
            h = 1 - math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
            hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
            updateColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            h = 1 - math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
            hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
            updateColor()
        end
    end)

    -- Saturation/Value dragging
    local draggingSat = false
    satMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            draggingSat = true 
            s = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            updateColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSat and input.UserInputType == Enum.UserInputType.MouseMovement then
            s = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            updateColor()
        end
    end)

    -- Open/Close Logic
    local function openPicker()
        isOpen = true
        savedColor = currentColor
        pickerPopup.Visible = true
        local absPos = colorDisplayContainer.AbsolutePosition
        local contPos = pickerPopup.Parent.AbsolutePosition
        pickerPopup.Position = UDim2.new(0, absPos.X - contPos.X - popupWidth + 40, 0, absPos.Y - contPos.Y + 28)
    end

    local function closePicker()
        isOpen = false
        pickerPopup.Visible = false
    end

    trigger.MouseButton1Click:Connect(function()
        if isOpen then
            closePicker()
        else
            openPicker()
        end
    end)

    closePopup.MouseButton1Click:Connect(function()
        closePicker()
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        -- Revert to saved color
        currentColor = savedColor
        h, s, v = currentColor:ToHSV()
        mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
        hueCursor.Position = UDim2.new(0, -3, 1-h, -3)
        satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        colorDisplay.BackgroundColor3 = currentColor
        cursorDot.BackgroundColor3 = currentColor
        hexInput.Text = "#" .. currentColor:ToHex():upper()
        if library.Flags then library.Flags[flag] = currentColor end
        cb(currentColor)
        closePicker()
    end)

    saveBtn.MouseButton1Click:Connect(function()
        savedColor = currentColor
        closePicker()
    end)

    -- Element row hover
    bg.MouseEnter:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.1}):Play()
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = theme.Primary}):Play()
    end)
    bg.MouseLeave:Connect(function() 
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.3}):Play() 
        TweenService:Create(bgStroke, TweenInfo.new(0.2), {Transparency = 0.95, Color = Color3.new(1,1,1)}):Play()
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, ColorObj)

    return ColorObj
end

return ColorPicker
