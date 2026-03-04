local Constants = ...
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService

local ColorPicker = {}

function ColorPicker:Add(parent, options, library)
    local cpName = options.Name or "Color Picker"
    local default = options.Default or Color3.fromRGB(255, 255, 255)
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

    local cpFrame = Instance.new("Frame")
    cpFrame.Size = UDim2.new(1, -10, 0, 42)
    cpFrame.BackgroundColor3 = theme.Card
    cpFrame.ZIndex = currentZ
    cpFrame.Parent = parent
    Instance.new("UICorner", cpFrame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = cpName
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = currentZ + 1
    label.Parent = cpFrame

    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 24)
    colorBtn.Position = UDim2.new(1, -55, 0.5, -12)
    colorBtn.BackgroundColor3 = default
    colorBtn.Text = ""
    colorBtn.ZIndex = currentZ + 1
    colorBtn.Parent = cpFrame
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    
    local expandBg = Instance.new("Frame")
    expandBg.Size = UDim2.new(1, 0, 0, 0) 
    expandBg.Position = UDim2.new(0, 0, 1, 5)
    expandBg.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    expandBg.ClipsDescendants = true
    expandBg.Visible = false
    expandBg.ZIndex = currentZ + 3
    expandBg.Parent = cpFrame
    Instance.new("UICorner", expandBg).CornerRadius = UDim.new(0, 6)

    local h, s, v = default:ToHSV()
    local currentColor = default

    local colorMap = Instance.new("TextButton")
    colorMap.Size = UDim2.new(0, 100, 0, 100)
    colorMap.Position = UDim2.new(0, 15, 0, 15)
    colorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorMap.Text = ""
    colorMap.AutoButtonColor = false
    colorMap.ZIndex = currentZ + 4
    colorMap.Parent = expandBg
    
    local hsvGrad = Instance.new("UIGradient")
    hsvGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.500, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.666, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
    })
    hsvGrad.Parent = colorMap

    local pickerRing = Instance.new("Frame")
    pickerRing.Size = UDim2.new(0, 10, 0, 10)
    pickerRing.AnchorPoint = Vector2.new(0.5, 0.5)
    pickerRing.Position = UDim2.new(h, 0, 1 - s, 0)
    pickerRing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pickerRing.ZIndex = currentZ + 7
    pickerRing.Parent = colorMap
    Instance.new("UICorner", pickerRing).CornerRadius = UDim.new(1, 0)

    local ColorObj = {
        Type = "ColorPicker",
        Value = default,
        Flag = flag,
        IsOpen = false
    }

    function ColorObj:Set(nc)
        h, s, v = nc:ToHSV()
        ColorObj.Value = nc
        colorBtn.BackgroundColor3 = nc
        pickerRing.Position = UDim2.new(h, 0, 1 - s, 0)
        if library.Flags then library.Flags[flag] = nc end
        cb(nc)
    end

    colorBtn.MouseButton1Click:Connect(function()
        ColorObj.IsOpen = not ColorObj.IsOpen
        if ColorObj.IsOpen then
            expandBg.Visible = true
            TweenService:Create(expandBg, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 130)}):Play()
            cpFrame.Size = UDim2.new(1, -10, 0, 180)
        else
            local t = TweenService:Create(expandBg, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)})
            t:Play()
            t.Completed:Wait()
            if not ColorObj.IsOpen then 
                expandBg.Visible = false 
                cpFrame.Size = UDim2.new(1, -10, 0, 42)
            end
        end
    end)

    if library.Flags then library.Flags[flag] = default end
    table.insert(library.Elements, ColorObj)

    return ColorObj
end

return ColorPicker
