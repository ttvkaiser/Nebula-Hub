-- Services
local TweenService = game:GetService("TweenService")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NebulaHubLoader"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 180)
Frame.Position = UDim2.new(0.5, -200, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0
Frame.Visible = true
Frame.ClipsDescendants = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "NEBULA HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 30
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

local Subtitle = Instance.new("TextLabel", Frame)
Subtitle.Text = "Detecting game..."
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 20
Subtitle.Position = UDim2.new(0, 0, 0, 55)
Subtitle.Size = UDim2.new(1, 0, 0, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)

local GameStatus = Instance.new("TextLabel", Frame)
GameStatus.Text = "Game: Unknown"
GameStatus.Font = Enum.Font.Gotham
GameStatus.TextSize = 18
GameStatus.Position = UDim2.new(0, 0, 0, 90)
GameStatus.Size = UDim2.new(1, 0, 0, 25)
GameStatus.BackgroundTransparency = 1
GameStatus.TextColor3 = Color3.fromRGB(150, 150, 150)

local BarBackground = Instance.new("Frame", Frame)
BarBackground.Size = UDim2.new(0.9, 0, 0, 10)
BarBackground.Position = UDim2.new(0.05, 0, 0.8, 0)
BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
BarBackground.BorderSizePixel = 0
BarBackground.BackgroundTransparency = 0.2
BarBackground.ClipsDescendants = true

local LoadingBar = Instance.new("Frame", BarBackground)
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
LoadingBar.BorderSizePixel = 0

-- Animate loading bar
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(LoadingBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

-- Simulate detection wait
task.wait(2.5)

-- Detect game
local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Configuration/gamelist.lua"))()
local found = false

for PlaceID, Execute in pairs(Games) do
    if tonumber(PlaceID) == game.PlaceId then
        found = true
        GameStatus.Text = "Game: Found"
        Subtitle.Text = "Loading Script..."
        
        task.wait(1)
        ScreenGui:Destroy()
        loadstring(game:HttpGet(Execute))()
        return
    end
end

-- If not found, update UI to show message
GameStatus.Text = "Game: Not Found"
Subtitle.Text = "GAMES WE SUPPORT!"

-- List supported games
local SupportList = Instance.new("TextLabel", Frame)
SupportList.Text = ""
SupportList.Font = Enum.Font.Gotham
SupportList.TextSize = 14
SupportList.Position = UDim2.new(0, 0, 1, -30)
SupportList.Size = UDim2.new(1, 0, 0, 90)
SupportList.BackgroundTransparency = 1
SupportList.TextColor3 = Color3.fromRGB(170, 170, 170)
SupportList.TextWrapped = true
SupportList.TextYAlignment = Enum.TextYAlignment.Top

local list = {}
for PlaceID, _ in pairs(Games) do
    table.insert(list, tostring(PlaceID))
end

SupportList.Text = "Supported PlaceIds:\n" .. table.concat(list, ", ")
