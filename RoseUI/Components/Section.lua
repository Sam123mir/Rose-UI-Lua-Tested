local Constants = ...
local Services = Constants.Services

local Section = {}

function Section:New(sName, tab)
    local window = tab.Window
    local library = window.Library
    local theme = window.Theme

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, -10, 0, 30)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
    sectionFrame.BackgroundTransparency = 0.5
    sectionFrame.Parent = tab.Page
    Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 6)
    
    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Color = theme.Header
    sectionStroke.Transparency = 0.7
    sectionStroke.Thickness = 1
    sectionStroke.Parent = sectionFrame

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -30, 0, 30)
    sectionLabel.Position = UDim2.new(0, 15, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = sName
    sectionLabel.TextColor3 = theme.Header
    sectionLabel.TextSize = 13
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    sectionContainer.Position = UDim2.new(0, 0, 0, 35)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Parent = sectionFrame
    
    local secLayout = Instance.new("UIListLayout")
    secLayout.Padding = UDim.new(0, 8)
    secLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    secLayout.Parent = sectionContainer
    
    secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y)
        sectionFrame.Size = UDim2.new(1, -10, 0, 45 + secLayout.AbsoluteContentSize.Y)
    end)
    
    local SectionObj = {
        Container = sectionContainer,
        Tab = tab
    }

    -- Proxies para Elementos
    function SectionObj:AddButton(options)
        return library.Elements.Button:Add(self.Container, options, library)
    end

    function SectionObj:AddToggle(options)
        return library.Elements.Toggle:Add(self.Container, options, library)
    end

    function SectionObj:AddSlider(options)
        return library.Elements.Slider:Add(self.Container, options, library)
    end

    function SectionObj:AddDropdown(options)
        return library.Elements.Dropdown:Add(self.Container, options, library)
    end

    function SectionObj:AddSearchDropdown(options)
        return library.Elements.SearchDropdown:Add(self.Container, options, library)
    end

    function SectionObj:AddColorPicker(options)
        return library.Elements.ColorPicker:Add(self.Container, options, library)
    end

    function SectionObj:AddKeybind(options)
        return library.Elements.Keybind:Add(self.Container, options, library)
    end

    function SectionObj:AddTextbox(options)
        return library.Elements.Textbox:Add(self.Container, options, library)
    end

    function SectionObj:AddLabel(options)
        return library.Elements.Label:Add(self.Container, options, library)
    end

    function SectionObj:AddTargetList(options)
        return library.Elements.TargetList:Add(self.Container, options, library)
    end

    function SectionObj:AddInventoryGrid(options)
        return library.Elements.InventoryGrid:Add(self.Container, options, library)
    end

    function SectionObj:AddPlotGrid(options)
        return library.Elements.PlotGrid:Add(self.Container, options, library)
    end

    return SectionObj
end

return Section
