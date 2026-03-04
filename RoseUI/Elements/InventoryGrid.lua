local Constants = ...
local Services = Constants.Services

local InventoryGrid = {}

function InventoryGrid:Add(parent, options, library)
    local iName = options.Name or "Inventory"
    local cb = options.OnSell or function() end
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
    
    local InvObj = {
        Type = "InventoryGrid",
        FrameCache = {},
        CurrentList = {}
    }
    
    function InvObj:Refresh(newList)
        InvObj.CurrentList = newList
        local count = 0
        for i, itemData in ipairs(newList) do
            count = count + 1
            local itemFrame = InvObj.FrameCache[i]
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
                
                local sellBtn = Instance.new("TextButton")
                sellBtn.Name = "SellBtn"
                sellBtn.Size = UDim2.new(0, 50, 0, 22)
                sellBtn.Position = UDim2.new(1, -55, 0.5, -11)
                sellBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 70)
                sellBtn.Text = "Sell"
                sellBtn.TextColor3 = Color3.new(1,1,1)
                sellBtn.Font = Enum.Font.GothamBold
                sellBtn.TextSize = 11
                sellBtn.Parent = itemFrame
                Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 4)
                
                sellBtn.MouseButton1Click:Connect(function()
                    if cb and InvObj.CurrentList[i] then
                        cb(InvObj.CurrentList[i])
                    end
                end)
                
                InvObj.FrameCache[i] = itemFrame
            end
            
            itemFrame.Visible = true
            itemFrame.NameLbl.Text = itemData.Name or "Unknown"
        end
        
        for i = count + 1, #InvObj.FrameCache do
            InvObj.FrameCache[i].Visible = false
        end
        
        gridContainer.Size = UDim2.new(1, -10, 0, (count * 34) + 10)
    end
    
    return InvObj
end

return InventoryGrid
