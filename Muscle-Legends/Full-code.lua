local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "Nebula Hub | Game: Muscle Legends | Version [v.beta]",
    SubTitle = "by ttvkaiser",
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
  	Killing = Window:CreateTab{
        Title = "Auto Kill",
        Icon = "skull"
    },
	Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "tree-palm"
    },
	Status = Window:CreateTab{
        Title = "Status",
        Icon = "circle-plus"
    },
	Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "command"
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

Tabs.Main:AddSection("Auto Farm")

local Toggle = Tabs.Main:CreateToggle("AutoRep", {Title = "Auto Lift", Default = false})
Toggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while Toggle.Value do
                game:GetService("Players").LocalPlayer:WaitForChild("muscleEvent"):FireServer("rep")
                task.wait(0.1)
            end
        end)
    end
end)

Tabs.Main:AddSection("Auto Jungle")

local jungleBenchToggle = Tabs.Main:CreateToggle("JungleBench", {Title = "Auto Jungle Bench", Default = false})
jungleBenchToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while jungleBenchToggle.Value do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8629.88086, 64.8842468, 1855.03467))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Bench"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local jungleBarToggle = Tabs.Main:CreateToggle("JungleBar", {Title = "Auto Jungle Bar Lift", Default = false})
jungleBarToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while jungleBarToggle.Value do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8678.05566, 14.5030098, 2089.25977))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Bar Lift"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

local jungleSquatToggle = Tabs.Main:CreateToggle("JungleSquat", {Title = "Auto Jungle Squat", Default = false})
jungleSquatToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while jungleSquatToggle.Value do
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(-8374.25586, 34.5933418, 2932.44995))
                game:GetService("ReplicatedStorage").rEvents.machineInteractRemote:InvokeServer("useMachine", workspace.machinesFolder["Jungle Squat"].interactSeat)
                task.wait(0.1)
            end
        end)
    end
end)

Tabs.Main:AddSection("Auto Equip")

local equipWeightToggle = Tabs.Main:CreateToggle("EquipWeight", {Title = "Auto Equip Weight", Default = false})
equipWeightToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipWeightToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipPushupToggle = Tabs.Main:CreateToggle("EquipPushups", {Title = "Auto Equip Pushups", Default = false})
equipPushupToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipPushupToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Pushups")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipSitupToggle = Tabs.Main:CreateToggle("EquipSitups", {Title = "Auto Equip Situps", Default = false})
equipSitupToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipSitupToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Situps")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

local equipHandstandToggle = Tabs.Main:CreateToggle("EquipHandstands", {Title = "Auto Equip Handstands", Default = false})
equipHandstandToggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while equipHandstandToggle.Value do
                local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Handstand")
                if tool then tool.Parent = game.Players.LocalPlayer.Character end
                task.wait(0.1)
            end
        end)
    end
end)

-- Auto Rebirth (Normal)
local autoRebirthToggle = Tabs.Rebirth:CreateToggle("AutoRebirth", {Title = "Auto Rebirth (Normal)", Default = false})
autoRebirthToggle:OnChanged(function(State)
	if State then
		task.spawn(function()
			while autoRebirthToggle.Value do
				game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthRemote"):InvokeServer("rebirthRequest")
				task.wait(0.1)
			end
		end)
	end
end)

-- Auto Size 2
local autoSize2Toggle = Tabs.Rebirth:CreateToggle("AutoSize2", {Title = "Auto Size 2", Default = false})
autoSize2Toggle:OnChanged(function(State)
	if State then
		autoSizeLoop = task.spawn(function()
			while autoSize2Toggle.Value do
				game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
				task.wait()
			end
		end)
	else
		if autoSizeLoop then
			task.cancel(autoSizeLoop)
			autoSizeLoop = nil
		end
	end
end)

-- Hide All Frames
local hideFramesToggle = Tabs.Rebirth:CreateToggle("HideAllFrames", {Title = "Hide All Frames", Default = false})
hideFramesToggle:OnChanged(function(State)
	local rSto = game:GetService("ReplicatedStorage")
	for _, obj in pairs(rSto:GetChildren()) do
		if obj:IsA("Instance") and obj.Name:match("Frame$") then
			obj.Visible = not State
		end
	end
end)

-- Label
Tabs.Rebirth:AddSection("OP Stuff")

-- Fast Rebirths
local fastRebirthsToggle = Tabs.Rebirth:CreateToggle("FastRebirths", {Title = "Fast Rebirths", Default = false})
fastRebirthsToggle:OnChanged(function(State)
	if State then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/0o0o0o0o0o0o0o0o0o0o0o0o/0o0o0o0o/refs/heads/main/Kk"))()
	end
end)

-- Speed Grind (No Rebirth)
local speedGrindToggle = Tabs.Rebirth:CreateToggle("SpeedGrind", {Title = "Fast Grind (No Rebirth)", Default = false})
speedGrindToggle:OnChanged(function(State)
	if State then
		for i = 1, 12 do
			task.spawn(function()
				while speedGrindToggle.Value do
					game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
					task.wait(0.083)
				end
			end)
		end
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

-- Auto Punch Toggle (No Animation)
local Toggle = Tabs.Killing:CreateToggle("AutoPunchNoAnim", {Title = "Auto Punch (No Anim)", Default = false})
Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer
        local char = game.Workspace:FindFirstChild(player.Name)
        local punchTool = player.Backpack:FindFirstChild("Punch") or (char and char:FindFirstChild("Punch"))

        if punchTool then
            if punchTool.Parent ~= char then
                punchTool.Parent = char -- Equip
            end

            player.muscleEvent:FireServer("punch", "rightHand")
            player.muscleEvent:FireServer("punch", "leftHand")
        else
            warn("Punch tool not found")
            Toggle:SetValue(false) -- Stop if tool not found
        end
        task.wait()
    end
end)

-- Speed Punch Button
Tabs.Killing:CreateButton({
    Title = "Fast Punch",
    Callback = function()
        local player = game.Players.LocalPlayer
        local punch = player.Backpack:FindFirstChild("Punch") or (game.Workspace:FindFirstChild(player.Name) and game.Workspace[player.Name]:FindFirstChild("Punch"))
        if punch and punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0
        end
    end
})

-- Normal Punch Button
Tabs.Killing:CreateButton({
    Title = "Normal Punch",
    Callback = function()
        local player = game.Players.LocalPlayer
        local punch = player.Backpack:FindFirstChild("Punch") or (game.Workspace:FindFirstChild(player.Name) and game.Workspace[player.Name]:FindFirstChild("Punch"))
        if punch and punch:FindFirstChild("attackTime") then
            punch.attackTime.Value = 0.35
        end
    end
})

-- Whitelist Table
local whitelist = {}

Tabs.Killing:CreateInput("WhitelistBox", {
    Title = "Whitelist Player",
    Default = "",
    Placeholder = "Enter username...",
    Numeric = false,
    Callback = function(text)
        local target = game.Players:FindFirstChild(text)
        if target then
            whitelist[target.Name] = true
        end
    end
})

-- Auto Kill Toggle
local Toggle = Tabs.Killing:CreateToggle("AutoKill", {Title = "Auto Kill", Default = false})
Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target ~= player and not whitelist[target.Name] then
                local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local rHand = player.Character and player.Character:FindFirstChild("RightHand")
                local lHand = player.Character and player.Character:FindFirstChild("LeftHand")

                if root and rHand and lHand then
                    firetouchinterest(rHand, root, 1)
                    firetouchinterest(lHand, root, 1)
                    firetouchinterest(rHand, root, 0)
                    firetouchinterest(lHand, root, 0)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Target Kill
local targetPlayerName = nil
Tabs.Killing:CreateInput("TargetPlayerBox", {
    Title = "Player Username",
    Default = "",
    Placeholder = "Enter exact username...",
    Callback = function(text)
        targetPlayerName = text
    end
})

local Toggle = Tabs.Killing:CreateToggle("AutoKillTarget", {Title = "Auto Kill Player", Default = false})
Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer
        local target = game.Players:FindFirstChild(targetPlayerName)

        if target and target ~= player then
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local rHand = player.Character and player.Character:FindFirstChild("RightHand")
            local lHand = player.Character and player.Character:FindFirstChild("LeftHand")

            if root and rHand and lHand then
                firetouchinterest(rHand, root, 1)
                firetouchinterest(lHand, root, 1)
                firetouchinterest(rHand, root, 0)
                firetouchinterest(lHand, root, 0)
            end
        end
        task.wait(0.1)
    end
end)

Tabs.Status:AddSection("Stats Gained")

local function abbreviateNumber(value)
    if value >= 1e15 then
        return string.format("%.1fQa", value / 1e15)
    elseif value >= 1e12 then
        return string.format("%.1fT", value / 1e12)
    elseif value >= 1e9 then
        return string.format("%.1fB", value / 1e9)
    elseif value >= 1e6 then
        return string.format("%.1fM", value / 1e6)
    elseif value >= 1e3 then
        return string.format("%.1fK", value / 1e3)
    else
        return tostring(value)
    end
end

-- Paragraph containers
local paragraphs = {
    TimeSpent = Tabs.Status:CreateParagraph("TimeSpent", {
        Title = "Time Spent",
        Content = "Time spent in this server: 00:00",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    StrengthGained = Tabs.Status:CreateParagraph("StrengthGained", {
        Title = "Strength",
        Content = "Strength gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    DurabilityGained = Tabs.Status:CreateParagraph("DurabilityGained", {
        Title = "Durability",
        Content = "Durability gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    AgilityGained = Tabs.Status:CreateParagraph("AgilityGained", {
        Title = "Agility",
        Content = "Agility gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    KillsGained = Tabs.Status:CreateParagraph("KillsGained", {
        Title = "Kills",
        Content = "Kills gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    EvilKarmaGained = Tabs.Status:CreateParagraph("EvilKarmaGained", {
        Title = "Evil Karma",
        Content = "Evil Karma gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    }),
    GoodKarmaGained = Tabs.Status:CreateParagraph("GoodKarmaGained", {
        Title = "Good Karma",
        Content = "Good Karma gained: 0",
        TitleAlignment = "Middle",
        ContentAlignment = Enum.TextXAlignment.Center
    })
}

local function createMyParagraphStats()
    local player = game.Players.LocalPlayer
    if not player then return end

    local leaderstats = player:WaitForChild("leaderstats")
    local strengthStat = leaderstats:WaitForChild("Strength")
    local durabilityStat = player:WaitForChild("Durability")
    local agilityStat = player:WaitForChild("Agility")
    local killsStat = leaderstats:WaitForChild("Kills")
    local evilKarmaStat = player:WaitForChild("evilKarma")
    local goodKarmaStat = player:WaitForChild("goodKarma")

    local initialStrength = strengthStat.Value
    local initialDurability = durabilityStat.Value
    local initialAgility = agilityStat.Value
    local initialKills = killsStat.Value
    local initialEvilKarma = evilKarmaStat.Value
    local initialGoodKarma = goodKarmaStat.Value

    local startTime = tick()

    local function updateParagraphs()
        paragraphs.StrengthGained:SetContent("Strength gained: " .. abbreviateNumber(strengthStat.Value - initialStrength))
        paragraphs.DurabilityGained:SetContent("Durability gained: " .. abbreviateNumber(durabilityStat.Value - initialDurability))
        paragraphs.AgilityGained:SetContent("Agility gained: " .. abbreviateNumber(agilityStat.Value - initialAgility))
        paragraphs.KillsGained:SetContent("Kills gained: " .. abbreviateNumber(killsStat.Value - initialKills))
        paragraphs.EvilKarmaGained:SetContent("Evil Karma gained: " .. abbreviateNumber(evilKarmaStat.Value - initialEvilKarma))
        paragraphs.GoodKarmaGained:SetContent("Good Karma gained: " .. abbreviateNumber(goodKarmaStat.Value - initialGoodKarma))
    end

    local function updateTimeSpent()
        local timeSpent = tick() - startTime
        local minutes = math.floor(timeSpent / 60)
        local seconds = math.floor(timeSpent % 60)
        paragraphs.TimeSpent:SetContent(string.format("Time spent in this server: %02d:%02d", minutes, seconds))
    end

    -- Connect stat changes to updates
    strengthStat.Changed:Connect(updateParagraphs)
    durabilityStat.Changed:Connect(updateParagraphs)
    agilityStat.Changed:Connect(updateParagraphs)
    killsStat.Changed:Connect(updateParagraphs)
    evilKarmaStat.Changed:Connect(updateParagraphs)
    goodKarmaStat.Changed:Connect(updateParagraphs)

    -- Update loop for time
    game:GetService("RunService").Heartbeat:Connect(updateTimeSpent)

    -- Initial refresh
    updateParagraphs()
end

createMyParagraphStats()

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
