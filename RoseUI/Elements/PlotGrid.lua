local import = ...
local Constants = import("Core/Constants")
local Services = Constants.Services

local PlotGrid = {}

function PlotGrid:Add(parent, options, library)
    local iName = options.Name or "Plot Grid"
    local onPickup = options.OnPickup or function() end
    local onUpgrade = options.OnUpgrade or function() end
    local theme = library.CurrentTheme or {
        Text = Color3.fromRGB(240, 255, 240),
        Card = Color3.fromRGB(18, 26, 20),
        Header = Color3.fromRGB(255, 100, 130)
    }

    local gridContainer = Instance.new("Frame")
    gridContainer.Size = UDim2.new(1, -10, 0, 30)
    gridContainer.BackgroundColor3 = theme.Card
    gridContainer.Parent = parent
    Instance.new("UICorner", gridContainer).CornerRadius = UDim.new(0, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = gridContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local padding = Instance.new("UIPadding")
    padding.Parent = gridContainer
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    
    local PlotObj = {
        Type = "PlotGrid",
        FrameCache = {},
        CurrentList = {}
    }
    
    function PlotObj:Refresh(newList)
        PlotObj.CurrentList = newList
        local count = 0
        for i, itemData in ipairs(newList) do
            count = count + 1
            local itemFrame = PlotObj.FrameCache[i]
            if not itemFrame then
                itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(1, -10, 0, 30)
                itemFrame.BackgroundColor3 = Color3.fromRGB(45, 25, 35)
                itemFrame.Parent = gridContainer
                Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
                
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Name = "NameLbl"
                nameLbl.Size = UDim2.new(0.4, 0, 1, 0)
                nameLbl.Position = UDim2.new(0, 10, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.TextColor3 = theme.Text
                nameLbl.Font = Enum.Font.GothamSemibold
                nameLbl.TextSize = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = itemFrame
                
                local actionsFrame = Instance.new("Frame")
                actionsFrame.Size = UDim2.new(0, 100, 1, 0)
                actionsFrame.Position = UDim2.new(1, -105, 0, 0)
                actionsFrame.BackgroundTransparency = 1
                actionsFrame.Parent = itemFrame
                
                local pickupBtn = Instance.new("TextButton")
                pickupBtn.Size = UDim2.new(0, 45, 0, 22)
                pickupBtn.Position = UDim2.new(0, 0, 0.5, -11)
                pickupBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
                pickupBtn.Text = "⬆"
                pickupBtn.TextColor3 = Color3.new(1,1,1)
                pickupBtn.Parent = actionsFrame
                
                pickupBtn.MouseButton1Click:Connect(function()
                    if onPickup and PlotObj.CurrentList[i] then onPickup(PlotObj.CurrentList[i]) end
                end)
                
                PlotObj.FrameCache[i] = itemFrame
            end
            
            itemFrame.Visible = true
            itemFrame.NameLbl.Text = itemData.Name or "Unknown"
        end
        
        for i = count + 1, #PlotObj.FrameCache do
            PlotObj.FrameCache[i].Visible = false
        end
        
        gridContainer.Size = UDim2.new(1, -10, 0, (count * 34) + 10)
    end
    
    return PlotObj
end

return PlotGrid
