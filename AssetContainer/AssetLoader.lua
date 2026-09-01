--[[
AssetLoader.luau
]]

local AssetLoader = {};
AssetLoader.__index = AssetLoader;

local Http = game:GetService("HttpService")

local TOKEN = "";

local function GetPath(FileName)
    return string.format("https://raw.githubusercontent.com/kyoukidevs/adonishook/refs/heads/main/AssetContainer/%s", FileName)    
end

local function GetWorkspacePath(FileName)
    return string.format("adonishook/AssetContainer/%s", FileName);
end

function AssetLoader:LoadFont(Name, Parameters)
    local FileName = Name .. ".ttf";
    local RealName = Name .. ".font";
    local Path = GetPath(FileName);
    local TempPath = GetWorkspacePath(FileName);
    local RealPath = GetWorkspacePath(RealName);
    local Request = request({
        Url = Path,
        Method = "GET";
    })
    
    if not isfile(TempPath) then 
        writefile(TempPath, Request.Body);
    end

    local Data = {
        name = Name,
        faces = {{
            weight = Parameters.Weight or 400,
            name = Name,
            style = Parameters.Style or "Regular",
            assetId = getcustomasset(TempPath)
        }}
    }

    writefile(RealPath, Http:JSONEncode(Data));
    return Font.new(
        getcustomasset(RealPath),
        Enum.FontWeight.Regular,
        Enum.FontStyle.Normal
    )
end 

function AssetLoader:LoadImage(Name)
    local FakePath = GetPath(Name .. ".png")
    local RealPath = GetWorkspacePath(Name .. ".png");

    if isfile(RealPath) then 
        return 
    end

    local Request = request({
        Url = FakePath,
        Method = "GET"
    })

    writefile(RealPath, Request.Body);

    return getcustomasset(RealPath)
end

getgenv().AssetLoader = AssetLoader;
return AssetLoader
