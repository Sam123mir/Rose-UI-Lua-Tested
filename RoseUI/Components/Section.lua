local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services

local Section = {}

function Section:New(sName, tab)
    local window = tab.Window
    local library = window.Library
    local theme = window.Theme

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = sName .. "_Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = tab.Page
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 15)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = sectionFrame
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 1, 0)
    accentBar.BackgroundColor3 = theme.Primary
    accentBar.BorderSizePixel = 0
    accentBar.Parent = titleFrame
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 8, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = sName:upper()
    sectionLabel.TextColor3 = theme.Primary
    sectionLabel.TextSize = 10
    sectionLabel.Font = Enum.Font.GothamBlack
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = titleFrame
    
    -- Custom tracking simulation (Letter spacing)
    sectionLabel.Text = ""
    for i = 1, #sName do
        sectionLabel.Text = sectionLabel.Text .. sName:sub(i,i):upper() .. " "
    end
    
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Name = "Container"
    sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    sectionContainer.Position = UDim2.new(0, 0, 0, 25)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Parent = sectionFrame
    
    local secLayout = Instance.new("UIListLayout")
    secLayout.Padding = UDim.new(0, 8)
    secLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    secLayout.Parent = sectionContainer
    
    secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y)
        sectionFrame.Size = UDim2.new(1, 0, 0, 35 + secLayout.AbsoluteContentSize.Y)
    end)
    
    local SectionObj = {
        Container = sectionContainer,
        Tab = tab
    }

    -- Element Proxies
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
