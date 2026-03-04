local Themes = {
    ["Rose v2 (Premium)"] = {
        Primary = Color3.fromRGB(242, 13, 13),      -- #f20d0d
        Background = Color3.fromRGB(10, 5, 5),      -- #0a0505
        Surface = Color3.fromRGB(18, 8, 8),        -- #120808
        Accent = Color3.fromRGB(26, 11, 11),       -- #1a0b0b
        Border = Color3.fromRGB(242, 13, 13),      -- #f20d0d (Transparente en UI)
        Text = Color3.fromRGB(241, 245, 249),      -- text-slate-100
        SecondaryText = Color3.fromRGB(100, 116, 139), -- text-slate-500
        MutedText = Color3.fromRGB(71, 85, 105),    -- text-slate-600
        Header = Color3.fromRGB(26, 11, 11),
        Sidebar = Color3.fromRGB(26, 11, 11),
        Content = Color3.fromRGB(10, 5, 5),
        Card = Color3.fromRGB(0, 0, 0) -- Usado como overlay con transparencia
    },
    ["Dark Rose"] = {
        Header = Color3.fromRGB(240, 50, 70),
        Sidebar = Color3.fromRGB(15, 10, 12),
        Content = Color3.fromRGB(15, 10, 12),
        Card = Color3.fromRGB(22, 15, 18),
        Text = Color3.fromRGB(250, 230, 235),
        Accent = Color3.fromRGB(255, 60, 90)
    }
}

return Themes
