local function getAsset(path, url)
    local getasset = select(2, pcall(function() return getcustomasset and getcustomasset or (getgenv and getgenv().getcustomasset) end))
    if not getasset or type(getasset) ~= "function" then return "" end

    if not isfolder("RoseHub") then makefolder("RoseHub") end
    if not isfolder("RoseHub/assets") then makefolder("RoseHub/assets") end

    local fullPath = "RoseHub/assets/" .. path
    if not isfile(fullPath) then
        local success, data = pcall(function() return game:HttpGet(url) end)
        if success and data then
            writefile(fullPath, data)
        end
    end

    if isfile(fullPath) then
        return getasset(fullPath)
    end
    return ""
end

local Assets = {
    GetAsset = getAsset,
    Icons = {
        Logo = "https://raw.githubusercontent.com/rosehublua/rosehubimages/main/roselogo.png",
        Discord = "https://raw.githubusercontent.com/rosehublua/rosehubimages/main/discordlogo.png",
        TabOut = "https://raw.githubusercontent.com/rosehublua/rosehubimages/main/white/tabout.png",
        Cross = "https://raw.githubusercontent.com/rosehublua/rosehubimages/main/white/cross.png"
    }
}

return Assets
