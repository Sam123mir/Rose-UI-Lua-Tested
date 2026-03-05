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

    -- Main Container
    local cpFrame = Instance.new("Frame")
    cpFrame.Name = cpName .. "_ColorPicker"
    cpFrame.Size = UDim2.new(1, 0, 0, 240)
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

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = cpName:upper()
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = bg

    -- COLOR PREVIEW & ACTIVE CIRCLE (Inline Header)
    local previewContainer = Instance.new("Frame")
    previewContainer.Size = UDim2.new(0, 60, 0, 20)
    previewContainer.Position = UDim2.new(1, -72, 0, 8)
    previewContainer.BackgroundTransparency = 1
    previewContainer.Parent = bg

    local previewColor = Instance.new("Frame")
    previewColor.Size = UDim2.new(0, 16, 0, 16)
    previewColor.Position = UDim2.new(0, 0, 0.5, -8)
    previewColor.BackgroundColor3 = currentColor
    previewColor.Parent = previewContainer
    Instance.new("UICorner", previewColor).CornerRadius = UDim.new(1, 0)
    local prevStroke = Instance.new("UIStroke", previewColor)
    prevStroke.Thickness = 2
    prevStroke.Transparency = 0.2
    prevStroke.Color = currentColor

    local activeLbl = Instance.new("TextLabel")
    activeLbl.Size = UDim2.new(1, -20, 1, 0)
    activeLbl.Position = UDim2.new(0, 22, 0, 0)
    activeLbl.BackgroundTransparency = 1
    activeLbl.Text = "ACTIVE"
    activeLbl.TextColor3 = theme.MutedText
    activeLbl.Font = Enum.Font.GothamBold
    activeLbl.TextSize = 9
    activeLbl.TextXAlignment = Enum.TextXAlignment.Left
    activeLbl.Parent = previewContainer

    -- 2D SATURATION/VALUE MAP (Image 3)
    local satMap = Instance.new("ImageButton")
    satMap.Size = UDim2.new(1, -24, 0, 120)
    satMap.Position = UDim2.new(0, 12, 0, 36)
    satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    satMap.Image = "rbxassetid://6980062489"
    satMap.AutoButtonColor = false
    satMap.Parent = bg
    Instance.new("UICorner", satMap).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", satMap).Transparency = 0.8
    Instance.new("UIStroke", satMap).Color = Color3.new(1,1,1)

    local mapCursor = Instance.new("Frame")
    mapCursor.Size = UDim2.new(0, 14, 0, 14)
    mapCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
    mapCursor.BackgroundColor3 = Color3.new(1,1,1)
    mapCursor.BackgroundTransparency = 0.2
    mapCursor.ZIndex = 2
    mapCursor.Parent = satMap
    Instance.new("UICorner", mapCursor).CornerRadius = UDim.new(1, 0)
    local mapCursorStroke = Instance.new("UIStroke", mapCursor)
    mapCursorStroke.Thickness = 2
    mapCursorStroke.Color = Color3.new(1,1,1)

    local cursorDot = Instance.new("Frame")
    cursorDot.Size = UDim2.new(0, 4, 0, 4)
    cursorDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    cursorDot.BackgroundColor3 = currentColor
    cursorDot.ZIndex = 3
    cursorDot.Parent = mapCursor
    Instance.new("UICorner", cursorDot).CornerRadius = UDim.new(1, 0)

    -- HORIZONTAL HUE SLIDER (Image 2 translated horizontally)
    local hueFrame = Instance.new("TextButton")
    hueFrame.Size = UDim2.new(1, -24, 0, 16)
    hueFrame.Position = UDim2.new(0, 12, 0, 166)
    hueFrame.AutoButtonColor = false
    hueFrame.Text = ""
    hueFrame.Parent = bg
    Instance.new("UICorner", hueFrame).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", hueFrame).Transparency = 0.8

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    hueGradient.Parent = hueFrame

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(0, 6, 1, 4)
    hueCursor.Position = UDim2.new(1-h, -3, 0, -2)
    hueCursor.BackgroundColor3 = Color3.new(1,1,1)
    hueCursor.Parent = hueFrame
    Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(0, 2)
    Instance.new("UIStroke", hueCursor).Color = Color3.new(0,0,0)

    -- BOTTOM ROW (HEX)
    local hexBg = Instance.new("Frame")
    hexBg.Size = UDim2.new(1, -24, 0, 32)
    hexBg.Position = UDim2.new(0, 12, 0, 194)
    hexBg.BackgroundColor3 = theme.Background
    hexBg.BackgroundTransparency = 0.4
    hexBg.Parent = bg
    Instance.new("UICorner", hexBg).CornerRadius = UDim.new(0, 6)
    local hexStroke = Instance.new("UIStroke", hexBg)
    hexStroke.Transparency = 0.85
    hexStroke.Color = Color3.new(1,1,1)
    
    local hexLbl = Instance.new("TextLabel")
    hexLbl.Size = UDim2.new(0, 40, 1, 0)
    hexLbl.Position = UDim2.new(0, 12, 0, 0)
    hexLbl.BackgroundTransparency = 1
    hexLbl.Text = "HEX"
    hexLbl.TextColor3 = theme.MutedText
    hexLbl.Font = Enum.Font.GothamBold
    hexLbl.TextSize = 10
    hexLbl.TextXAlignment = Enum.TextXAlignment.Left
    hexLbl.Parent = hexBg

    local hexInput = Instance.new("TextBox")
    hexInput.Size = UDim2.new(1, -64, 1, 0)
    hexInput.Position = UDim2.new(0, 52, 0, 0)
    hexInput.BackgroundTransparency = 1
    hexInput.Text = "#" .. currentColor:ToHex():upper()
    hexInput.TextColor3 = theme.Text
    hexInput.Font = Enum.Font.Code
    hexInput.TextSize = 12
    hexInput.TextXAlignment = Enum.TextXAlignment.Left
    hexInput.ClearTextOnFocus = false
    hexInput.Parent = hexBg

    local function updateColors()
        currentColor = Color3.fromHSV(h, s, v)
        satMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        previewColor.BackgroundColor3 = currentColor
        prevStroke.Color = currentColor
        cursorDot.BackgroundColor3 = currentColor
        hexInput.Text = "#" .. currentColor:ToHex():upper()
        
        if library.Flags then library.Flags[flag] = currentColor end
        cb(currentColor)
    end

    local isDraggingSat = false
    local isDraggingHue = false

    satMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSat = true
            local posX = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
            local posY = math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
            s = posX
            v = 1 - posY
            mapCursor.Position = UDim2.new(posX, 0, posY, 0)
            updateColors()
        end
    end)

    hueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingHue = true
            local posX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
            h = 1 - posX
            hueCursor.Position = UDim2.new(posX, -3, 0, -2)
            updateColors()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDraggingSat then
                local posX = math.clamp((input.Position.X - satMap.AbsolutePosition.X) / satMap.AbsoluteSize.X, 0, 1)
                local posY = math.clamp((input.Position.Y - satMap.AbsolutePosition.Y) / satMap.AbsoluteSize.Y, 0, 1)
                s = posX
                v = 1 - posY
                mapCursor.Position = UDim2.new(posX, 0, posY, 0)
                updateColors()
            elseif isDraggingHue then
                local posX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                h = 1 - posX
                hueCursor.Position = UDim2.new(posX, -3, 0, -2)
                updateColors()
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingSat = false
            isDraggingHue = false
        end
    end)

    hexInput.Focused:Connect(function()
        TweenService:Create(hexStroke, TweenInfo.new(0.15), {Color = theme.Primary, Transparency = 0}):Play()
    end)

    hexInput.FocusLost:Connect(function(enterPressed)
        TweenService:Create(hexStroke, TweenInfo.new(0.15), {Color = Color3.new(1,1,1), Transparency = 0.85}):Play()
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
                    hueCursor.Position = UDim2.new(1-h, -3, 0, -2)
                    updateColors()
                end
            end
        else
            hexInput.Text = "#" .. currentColor:ToHex():upper()
        end
    end)

    if library.Flags then library.Flags[flag] = default end

    return {
        Frame = cpFrame,
        Set = function(self, color)
            currentColor = color
            h, s, v = currentColor:ToHSV()
            mapCursor.Position = UDim2.new(s, 0, 1-v, 0)
            hueCursor.Position = UDim2.new(1-h, -3, 0, -2)
            updateColors()
        end
    }
end

return ColorPicker
