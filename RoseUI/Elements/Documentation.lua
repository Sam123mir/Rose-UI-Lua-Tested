local Documentation = {}

function Documentation:AddTitle(parent, options, library)
    local text = options.Title or options.Text or "DOCUMENTATION TITLE"
    local theme = library.CurrentTheme or library.Theme
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 30)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = parent
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0, 16)
    accentBar.Position = UDim2.new(0, 4, 0.5, -8)
    accentBar.BackgroundColor3 = theme.Primary
    accentBar.BorderSizePixel = 0
    accentBar.Parent = titleFrame
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text:upper()
    label.TextColor3 = theme.Primary
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = titleFrame
    
    -- Letter spacing simulation
    local spacedText = ""
    for i = 1, #text do
        spacedText = spacedText .. text:sub(i,i):upper() .. " "
    end
    label.Text = spacedText
    
    return titleFrame
end

function Documentation:AddDescription(parent, options, library)
    local text = options.Text or options.Description or "Description text..."
    local theme = library.CurrentTheme or library.Theme
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -8, 0, 20) -- Will auto-adjust
    descLabel.BackgroundTransparency = 1
    descLabel.Text = text
    descLabel.TextColor3 = theme.SecondaryText
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextXAlignment.Top
    descLabel.TextWrapped = true
    descLabel.Parent = parent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 4)
    padding.Parent = descLabel
    
    local textBounds = descLabel.TextBounds
    descLabel.Size = UDim2.new(1, -8, 0, textBounds.Y + 10)
    
    descLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        descLabel.Size = UDim2.new(1, -8, 0, descLabel.TextBounds.Y + 10)
    end)
    
    return descLabel
end

function Documentation:AddCard(parent, options, library)
    local title = options.Title or "Card Title"
    local desc = options.Description or options.Text or "Card description goes here."
    local theme = library.CurrentTheme or library.Theme
    
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, 60)
    cardFrame.BackgroundColor3 = theme.Surface
    cardFrame.BackgroundTransparency = 0.5
    cardFrame.Parent = parent
    Instance.new("UICorner", cardFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Primary
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = cardFrame
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 16)
    titleLbl.Position = UDim2.new(0, 12, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = cardFrame
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -24, 0, 20)
    descLbl.Position = UDim2.new(0, 12, 0, 26)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = desc
    descLbl.TextColor3 = theme.SecondaryText
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextXAlignment.Top
    descLbl.TextWrapped = true
    descLbl.Parent = cardFrame
    
    -- Auto height based on description
    local frameHeight = 10 + 16 + descLbl.TextBounds.Y + 10
    cardFrame.Size = UDim2.new(1, 0, 0, math.max(60, frameHeight))
    
    return cardFrame
end

function Documentation:AddVersionCard(parent, options, library)
    local version = options.Version or "v1.0.0"
    local title = options.Title or "Added new features"
    local description = options.Description or options.Text or "- Updated xyz\n- Fixed abc"
    local theme = library.CurrentTheme or library.Theme
    
    local cardFrame = Instance.new("Frame")
    cardFrame.Size = UDim2.new(1, 0, 0, 80)
    cardFrame.BackgroundColor3 = theme.Background
    cardFrame.BackgroundTransparency = 0.1
    cardFrame.Parent = parent
    Instance.new("UICorner", cardFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Primary
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.Parent = cardFrame
    
    local statusBadge = Instance.new("Frame")
    statusBadge.Size = UDim2.new(0, 48, 0, 18)
    statusBadge.Position = UDim2.new(0, 12, 0, 12)
    statusBadge.BackgroundColor3 = theme.Primary
    statusBadge.BackgroundTransparency = 0.8
    statusBadge.Parent = cardFrame
    Instance.new("UICorner", statusBadge).CornerRadius = UDim.new(0, 4)
    
    local versionLbl = Instance.new("TextLabel")
    versionLbl.Size = UDim2.new(1, 0, 1, 0)
    versionLbl.BackgroundTransparency = 1
    versionLbl.Text = version
    versionLbl.TextColor3 = theme.Text
    versionLbl.Font = Enum.Font.GothamBold
    versionLbl.TextSize = 10
    versionLbl.Parent = statusBadge
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -76, 0, 18)
    titleLbl.Position = UDim2.new(0, 68, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = cardFrame
    
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -24, 0, 30)
    descLbl.Position = UDim2.new(0, 12, 0, 38)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = theme.SecondaryText
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextXAlignment.Top
    descLbl.TextWrapped = true
    descLbl.Parent = cardFrame
    
    -- Auto height based on description
    local frameHeight = 38 + descLbl.TextBounds.Y + 12
    cardFrame.Size = UDim2.new(1, 0, 0, math.max(60, frameHeight))
    
    return cardFrame
end

return Documentation
