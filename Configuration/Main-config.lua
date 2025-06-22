-- Services
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Load game list
local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Configuration/gamelist.lua"))()

-- Create Detection UI
local function createDetectionUI()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "NebulaHubLoader"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 500, 0, 220)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Frame.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Frame)
    Title.Text = "NEBULA HUB"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 34
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)

    local ExitButton = Instance.new("TextButton", Frame)
    ExitButton.Text = "X"
    ExitButton.Font = Enum.Font.GothamBold
    ExitButton.TextSize = 20
    ExitButton.Size = UDim2.new(0, 40, 0, 40)
    ExitButton.Position = UDim2.new(1, -45, 0, 5)
    ExitButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    ExitButton.TextColor3 = Color3.new(1, 1, 1)
    ExitButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Subtitle = Instance.new("TextLabel", Frame)
    Subtitle.Text = "Detecting game..."
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 22
    Subtitle.Position = UDim2.new(0, 0, 0, 60)
    Subtitle.Size = UDim2.new(1, 0, 0, 30)
    Subtitle.BackgroundTransparency = 1
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)

    local GameStatus = Instance.new("TextLabel", Frame)
    GameStatus.Text = "Game: Unknown"
    GameStatus.Font = Enum.Font.Gotham
    GameStatus.TextSize = 18
    GameStatus.Position = UDim2.new(0, 0, 0, 95)
    GameStatus.Size = UDim2.new(1, 0, 0, 25)
    GameStatus.BackgroundTransparency = 1
    GameStatus.TextColor3 = Color3.fromRGB(150, 150, 150)

    local BarBackground = Instance.new("Frame", Frame)
    BarBackground.Size = UDim2.new(0.9, 0, 0, 10)
    BarBackground.Position = UDim2.new(0.05, 0, 0.7, 0)
    BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    BarBackground.BorderSizePixel = 0
    BarBackground.BackgroundTransparency = 0.2
    BarBackground.ClipsDescendants = true

    local LoadingBar = Instance.new("Frame", BarBackground)
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    LoadingBar.BorderSizePixel = 0

    TweenService:Create(LoadingBar, TweenInfo.new(2.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()

    return ScreenGui, Subtitle, GameStatus
end

-- Create Supported Game UI
local function createSupportUI(gameNames)
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "NebulaHubSupportedGames"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 500, 0, 250)
    frame.Position = UDim2.new(0.5, -250, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Text = "GAMES WE SUPPORT"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.CanvasSize = UDim2.new(0, 0, 0, #gameNames * 30)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6

    for i, name in ipairs(gameNames) do
        local label = Instance.new("TextLabel", scroll)
        label.Size = UDim2.new(1, -10, 0, 25)
        label.Position = UDim2.new(0, 5, 0, (i - 1) * 30)
        label.Text = "• " .. name
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
    end
end

-- Main Detection Flow
local screenGui, subtitle, gameStatus = createDetectionUI()

task.wait(2.5)

local found = false
local placeId = game.PlaceId
local gameName = "Unknown"

for id, url in pairs(Games) do
    if tonumber(id) == placeId then
        found = true
        gameStatus.Text = "Game: Found"
        subtitle.Text = "Loading Script..."
        task.wait(1)
        screenGui:Destroy()
        loadstring(game:HttpGet(url))()
        return
    end
end

-- If not found
gameStatus.Text = "Game: Not Found"
subtitle.Text = "Loading supported games..."
task.wait(1)

-- Get names of supported games
local supportedNames = {}
for id, _ in pairs(Games) do
    local name
    pcall(function()
        name = MarketplaceService:GetProductInfo(tonumber(id)).Name
    end)
    table.insert(supportedNames, name or ("Unknown Game ("..id..")"))
end

screenGui:Destroy()
createSupportUI(supportedNames)
