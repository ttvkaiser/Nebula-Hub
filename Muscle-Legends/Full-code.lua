local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Nebula Hub | Game: Muscle Legends | Version [v.beta]`,
    SubTitle = "by Actual Master Oogway",
    TabWidth = 160,
    Size = UDim2.fromOffset(1087, 690.5),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}

-- Fluent Renewed provides ALL 1544 Lucide 0.469.0 https://lucide.dev/icons/ Icons and ALL 9072 Phosphor 2.1.0 https://phosphoricons.com/ Icons for the tabs, icons are optional
local Tabs = {
  Home = Window:CreateTab{
    	Title = "Home",
    	Icon = "house"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "phosphor-users-bold"
    },
  	Rocks = Window:CreateTab{
        Title = "Rocks",
        Icon = "mountain"
    },
	  Rebirth = Window:CreateTab{
        Title = "Auto Rebirths",
        Icon = "biceps-flexed"
    },
  	Kills = Window:CreateTab{
        Title = "Auto Kill",
        Icon = "skull"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

Library:Notify{
    Title = "Welcome to Nebula Hub",
    Content = "Nebula Hub supports 6 games!",
    SubContent = "This game is muscle legends and currently in beta!", -- Optional
    Duration = 13 -- Set to nil to make the notification not disappear
}

Tabs.Home:AddSection("Discord Server Link")

Tabs.Home:CreateButton({
    Title = "Click to Copy Link",
    Description = "This allows you to join our Discord server and get update pings and more.",
    Callback = function()
        Window:Dialog({
            Title = "Join Our Discord",
            Content = "Would you like to copy the invite link to our Discord server?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local link = "https://discord.gg/YOUR_INVITE"
                        setclipboard(link)
                        print("Copied Discord link to clipboard.")
                    end
                }
            }
        })
    end
})

Tabs.Home:AddSection("Local Player Configurations")

local speed = 16 -- default speed

-- input speed
local Input = Tabs.Home:AddInput("Input", {
    Title = "Speed Input",
    Default = tostring(speed),
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            speed = num
            print("Speed set to:", speed)
            if Options.MyToggle.Value then
                applySpeed()
            end
        end
    end
})

-- enable speed toggle
local Toggle = Tabs.Home:AddToggle("MyToggle", {
    Title = "Enable Speed",
    Default = false
})

-- utilty to apply speed
local function applySpeed()
    local player = game.Players.LocalPlayer
    if not player then return end

    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Options.MyToggle.Value and speed or 16
        end
    end
end

-- toggle handlee
Toggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
    applySpeed()
end)

-- reaply speed when reseted
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid") -- Ensure humanoid exists
    if Options.MyToggle.Value then
        task.wait(0.1) -- slight delay to ensure stability
        applySpeed()
    end
end)

-- indinre jump togllw
local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Infinite Jump", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        -- connecttion on ro jumps
        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Options.Toggle_InfiniteJump.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("Infinite Jump enabled")
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end)

-- no xlip togle
local ToggleNoClip = Tabs.Home:AddToggle("Toggle_NoClip", {Title = "No Clip", Default = false})
ToggleNoClip:OnChanged(function()
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    if Options.Toggle_NoClip.Value then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("No Clip enabled")
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        print("No Clip disabled")
    end
end)

Tabs.Rocks:AddSection("Auto Punch Rocks")

local selectrock = ""

local function punchRock(requiredDurability, rockName)
    getgenv().autoFarm = true
    while getgenv().autoFarm and selectrock == rockName do
        task.wait()
        local player = game.Players.LocalPlayer
        if player.Durability.Value >= requiredDurability then
            for _, v in pairs(game.Workspace.machinesFolder:GetDescendants()) do
                if v.Name == "neededDurability" and v.Value == requiredDurability and player.Character:FindFirstChild("LeftHand") and player.Character:FindFirstChild("RightHand") then
                    firetouchinterest(v.Parent.Rock, player.Character.RightHand, 0)
                    firetouchinterest(v.Parent.Rock, player.Character.RightHand, 1)
                    firetouchinterest(v.Parent.Rock, player.Character.LeftHand, 0)
                    firetouchinterest(v.Parent.Rock, player.Character.LeftHand, 1)
                    gettool()
                end
            end
        end
    end
end

-- jungle Rock
local jungleToggle = Tabs.Rocks:CreateToggle("JungleRock", {Title = "Auto Punch Jungle Rock (10M)", Default = false})
jungleToggle:OnChanged(function()
    selectrock = "Ancient Jungle Rock"
    getgenv().autoFarm = Options.JungleRock.Value
    if Options.JungleRock.Value then punchRock(10000000, selectrock) end
end)

-- muscle king Rock
local kingToggle = Tabs.Rocks:CreateToggle("KingRock", {Title = "Auto Punch Muscle King Rock (5M)", Default = false})
kingToggle:OnChanged(function()
    selectrock = "Muscle King Gym Rock"
    getgenv().autoFarm = Options.KingRock.Value
    if Options.KingRock.Value then punchRock(5000000, selectrock) end
end)

-- Legend Rock
local legendToggle = Tabs.Rocks:CreateToggle("LegendRock", {Title = "Auto Punch Legend Rock (1M)", Default = false})
legendToggle:OnChanged(function()
    selectrock = "Legend Gym Rock"
    getgenv().autoFarm = Options.LegendRock.Value
    if Options.LegendRock.Value then punchRock(1000000, selectrock) end
end)

-- Inferno Rock
local infernoToggle = Tabs.Rocks:CreateToggle("InfernoRock", {Title = "Auto Punch Inferno Rock (750K)", Default = false})
infernoToggle:OnChanged(function()
    selectrock = "Eternal Gym Rock"
    getgenv().autoFarm = Options.InfernoRock.Value
    if Options.InfernoRock.Value then punchRock(750000, selectrock) end
end)

-- Mythical Rock
local mythToggle = Tabs.Rocks:CreateToggle("MythRock", {Title = "Auto Punch Mythical Rock (400K)", Default = false})
mythToggle:OnChanged(function()
    selectrock = "Mythical Gym Rock"
    getgenv().autoFarm = Options.MythRock.Value
    if Options.MythRock.Value then punchRock(400000, selectrock) end
end)

-- Frost Rock
local frostToggle = Tabs.Rocks:CreateToggle("FrostRock", {Title = "Auto Punch Frost Rock (150K)", Default = false})
frostToggle:OnChanged(function()
    selectrock = "Frost Gym Rock"
    getgenv().autoFarm = Options.FrostRock.Value
    if Options.FrostRock.Value then punchRock(150000, selectrock) end
end)

-- Tiny Rock
local tinyToggle = Tabs.Rocks:CreateToggle("TinyRock", {Title = "Auto Punch Tiny Rock (0)", Default = false})
tinyToggle:OnChanged(function()
    selectrock = "Tiny Island Rock"
    getgenv().autoFarm = Options.TinyRock.Value
    if Options.TinyRock.Value then punchRock(0, selectrock) end
end)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Nebula Hub",
    Content = "The script has been loaded.",
    Duration = 1
}

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
