local import = ... 
local Constants = import("Core/Constants")
local Services = Constants.Services
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local RunService = Services.RunService

local Utilities = {}

function Utilities:Tween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Utilities:SafeNewCClosure(fn)
    if newcclosure then return newcclosure(fn) end
    return fn
end

Utilities.HasDrawing = pcall(function() return Drawing.new("Circle") end)

function Utilities:MakeDraggable(dragFrame, parentFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local relativeY = input.Position.Y - dragFrame.AbsolutePosition.Y
            if relativeY <= 45 then -- Header area
                dragging = true
                dragStart = input.Position
                startPos = parentFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local dragCon = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(parentFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    
    return dragCon
end

function Utilities:MakeResizable(resizeBtn, parentFrame, minSize, maxSize)
    local minSize = minSize or Vector2.new(600, 400)
    local dragging, dragInput, dragStart, startSize
    
    resizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = parentFrame.AbsoluteSize
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    resizeBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local resizeCon = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newSizeX = math.max(minSize.X, startSize.X + delta.X)
            local newSizeY = math.max(minSize.Y, startSize.Y + delta.Y)
            
            if maxSize then
                newSizeX = math.min(maxSize.X, newSizeX)
                newSizeY = math.min(maxSize.Y, newSizeY)
            end
            
            parentFrame.Size = UDim2.new(0, newSizeX, 0, newSizeY)
        end
    end)
    
    return resizeCon
end

function Utilities:GetExternalAsset(url)
    if not isfile or not writefile or not getcustomasset then return url end
    
    local fileName = "RoseUI_" .. game:GetService("HttpService"):GenerateGUID(false):sub(1,8) .. ".png"
    if url:find("ibb.co") and not url:find("i.ibb.co") then
        -- This is a partial fix, ideally we'd need a direct link, but let's assume the user provides a direct-ish link or handled it.
        -- We'll try to fetch it if it's a URL.
    end

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        local filePath = "RoseUI/Cache/" .. fileName
        if not isfolder("RoseUI") then makefolder("RoseUI") end
        if not isfolder("RoseUI/Cache") then makefolder("RoseUI/Cache") end
        
        writefile(filePath, response)
        return getcustomasset(filePath)
    end

    return url
end

return Utilities
