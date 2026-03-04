local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

local Constants = {
    Services = {
        UserInputService = UserInputService,
        TweenService = TweenService,
        HttpService = HttpService,
        RunService = RunService,
        CoreGui = CoreGui,
        Players = Players,
        GuiService = GuiService,
        Lighting = Lighting,
        Camera = Camera
    },
    DefaultSize = UDim2.new(0, 650, 0, 520),
    MinSize = {
        Width = 450,
        Height = 300
    },
    Padding = 40,
    HeaderHeight = 45,
    SidebarWidth = 160
}

return Constants
