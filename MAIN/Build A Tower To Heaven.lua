local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Nebula Hub | Game: Build a Tower to Heaven | Version [v2.0.5]`,
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
        Icon = "align-justify"
    },
    Teleport = Window:CreateTab{
        Title = "Teleport",
        Icon = "tree-palm"
    },
    Misc = Window:CreateTab{
        Title = "Miscellaneous",
        Icon = "command"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    },
}

local Options = Library.Options

Library:Notify{
    Title = "Notification",
    Content = "This is a notification",
    SubContent = "SubContent", -- Optional
    Duration = 5 -- Set to nil to make the notification not disappear
}

Tabs.Home:CreateParagraph("Aligned Paragraph", {
    Title = "---DISCORD SERVER---",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Home:AddButton({
    Title = "Copy Discord Invite",
    Description = "Click to copy our Discord invite link",
    Callback = function()
        -- Copy to clipboard
        setclipboard("Nothing to see here...")

        -- Show dialog confirmation
        Window:Dialog({
            Title = "Copied!",
            Content = "Discord invite has been copied to your clipboard.",
            Buttons = {
                {
                    Title = "OK",
                    Callback = function()
                        print("User acknowledged copy.")
                    end
                }
            }
        })
    end
})

Tabs.Home:CreateParagraph("Aligned Paragraph", {
    Title = "---LOCAL PLAYER CONFIGURATION---",
    Content = "	",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local speed = 16 -- Default speed

-- Input field
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

-- Toggle
local Toggle = Tabs.Home:AddToggle("MyToggle", {
    Title = "Enable Speed",
    Default = false
})

-- Utility to apply speed
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

-- Toggle handler
Toggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
    applySpeed()
end)

-- Reapply speed on respawn
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid") -- Ensure humanoid exists
    if Options.MyToggle.Value then
        task.wait(0.1) -- slight delay to ensure stability
        applySpeed()
    end
end)

-- Infinite Jump Toggle
local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Infinite Jump", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        -- Connection to jump input
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

-- No Clip Toggle
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

Tabs.Main:CreateParagraph("Aligned Paragraph", {
    Title = "More will come soon...",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "INFO ABOUT TOWERS",
    Content = "Go to the miscellaneous tab, there will be an tower esp, use it and then use the teleport buttons!",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 1",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateButton{
    Title = "Teleport to 500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(127.6, 503.4, -114.2) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(127.6, 1003.4, -114.2) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(127.6, 1503.4, -114.2) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to 2000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 2000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(127.6, 2003.4, -114.2) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 2",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateButton{
    Title = "Teleport to 500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-126, 503.4, 113.9) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-126, 1003.4, 0.-113.9) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-126, 1503.4, -113.9) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to 2000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 2000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-126, 2003.4, -133.9) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 3",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 4",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateButton{
    Title = "Teleport to 500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-125.9, 503.4, 0.143) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-125.9, 1003.4, 0.143) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to 1500m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 1500m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-125.9, 1503.4, 0.143) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateButton{
    Title = "Teleport to 2000m mark",
    Description = "Just teleport you there",
    Callback = function()
        Window:Dialog{
            Title = "Teleport?",
            Content = "Are you sure you want to teleport to the 2000m mark?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        local rootPart = character:WaitForChild("HumanoidRootPart")
                        
                        -- Set the teleport destination (adjust to your map)
                        rootPart.CFrame = CFrame.new(-125.9, 2003.4, 0.143) -- X, Y, Z
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}	

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 5",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Teleport:CreateParagraph("Aligned Paragraph", {
    Title = "Tower 6",
    Content = "",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local espParts = {}

local Toggle = Tabs.Misc:CreateToggle("MyToggle", {Title = "Tower ESP (HELPS WITH TELEPORT!!!)", Default = false })

local targetPositions = {
    Vector3.new(69.3, 4.9, -112.3),
    Vector3.new(-69.8, 4.9, -114.3),
    Vector3.new(71.0, 4.9, 0.139),
    Vector3.new(-71, 4.9, -0.738),
    Vector3.new(73.6, 4.9, 114.1),
    Vector3.new(-69, 4.9, 114.2),
}

Toggle:OnChanged(function()
    if Toggle.Value then
        for i, pos in ipairs(targetPositions) do
            local espPart = Instance.new("Part")
            espPart.Size = Vector3.new(3, 3, 3)
            espPart.Anchored = true
            espPart.CanCollide = false
            espPart.Transparency = 0.5
            espPart.BrickColor = BrickColor.new("Bright yellow")
            espPart.Position = pos
            espPart.Name = "TowerCoordinateESP_" .. i
            espPart.Parent = workspace

            local billboard = Instance.new("BillboardGui", espPart)
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.Adornee = espPart

            local textLabel = Instance.new("TextLabel", billboard)
            textLabel.Text = "Tower " .. i
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 0)
            textLabel.TextScaled = true

            table.insert(espParts, espPart)
        end
    else
        for _, part in ipairs(espParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        espParts = {}
    end
end)

Options.MyToggle:SetValue(false)

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
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
}

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
