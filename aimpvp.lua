local UILib = loadstring(game:HttpGet("https://github.com/Catsourehub/Sourecathub/blob/main/CatDiPitien.lua?raw=true"))()
local AimlockModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Dk"))()
local ESPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Gk"))()
local SilentAimModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Bg"))()
local StuffsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Stuf"))()
local OthersStuffsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Mot"))()
local UiSettingsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Vot"))()
local ZSkillModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NgotBand/BloxFruits/refs/heads/main/Beta/Aim/Teku"))()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local PlayerList = {"None"}

-- Detect executor
local executor = "Unknown"
if syn then
    executor = "Synapse X"
elseif KRNL_LOADED then
    executor = "KRNL"
elseif fluxus then
    executor = "Fluxus"
elseif getexecutorname then
    local success, execName = pcall(getexecutorname)
    if success and type(execName) == "string" then
        executor = execName
    end
end

local execStatus = (executor == "Xeno" or executor:lower():find("solara") or executor:lower():find("krnl")) and "Not Working" or "Working"

-- Load Settings
local Settings = OthersStuffsModule.LoadSettings()

-- ════════════════════════════════════════════
--          TOGGLE BUTTON (Copy từ CatTaiHub)
-- ════════════════════════════════════════════

local _TweenService = game:GetService("TweenService")
local _VIM = game:GetService("VirtualInputManager")

local _ScreenGui = Instance.new("ScreenGui")
local _ImageButton = Instance.new("ImageButton")
local _UICorner = Instance.new("UICorner")
local _UIStroke = Instance.new("UIStroke")
local _UIGradient = Instance.new("UIGradient")
_ScreenGui.Parent = game:GetService("CoreGui")
_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_ScreenGui.ResetOnSpawn = false
_ImageButton.Parent = _ScreenGui
_ImageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_ImageButton.BorderSizePixel = 0
_ImageButton.Position = UDim2.new(0.12, 0, 0.095, 0)
_ImageButton.Size = UDim2.new(0, 60, 0, 60)
_ImageButton.Image = "http://www.roblox.com/asset/?id=115377474207871"
_ImageButton.ImageTransparency = 0.1
_ImageButton.Active = true
_ImageButton.Draggable = true
_UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 255))
})
_UIGradient.Parent = _ImageButton
_UIStroke.Color = Color3.fromRGB(255, 255, 255)
_UIStroke.Thickness = 2.5
_UIStroke.Transparency = 0.1
_UIStroke.Parent = _ImageButton
_UICorner.CornerRadius = UDim.new(1, 0)
_UICorner.Parent = _ImageButton
local _Tweens = (function()
    local _s = _ImageButton.Size
    return {
        ["zoomIn"]  = _TweenService:Create(_ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back),   {["Size"] = UDim2.new(0, _s.X.Offset * 0.85, 0, _s.Y.Offset * 0.85)}),
        ["zoomOut"] = _TweenService:Create(_ImageButton, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {["Size"] = _s}),
        ["glowIn"]  = _TweenService:Create(_UIStroke,    TweenInfo.new(0.2), {["Thickness"] = 4, ["Transparency"] = 0}),
        ["glowOut"] = _TweenService:Create(_UIStroke,    TweenInfo.new(0.3), {["Thickness"] = 2.5, ["Transparency"] = 0.1}),
    }
end)()
_ImageButton.MouseButton1Down:Connect(function()
    _Tweens.zoomIn:Play()
    _Tweens.glowIn:Play()
    _VIM:SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)
_ImageButton.MouseButton1Up:Connect(function()
    _Tweens.zoomOut:Play()
    _Tweens.glowOut:Play()
end)
_ImageButton.MouseEnter:Connect(function()
    _TweenService:Create(_ImageButton, TweenInfo.new(0.3), {["BackgroundColor3"] = Color3.fromRGB(40, 40, 40)}):Play()
end)
_ImageButton.MouseLeave:Connect(function()
    _TweenService:Create(_ImageButton, TweenInfo.new(0.3), {["BackgroundColor3"] = Color3.fromRGB(20, 20, 20)}):Play()
end)


UILib:MakeNotify({
    ["Title"] = "Sapi Hub BF PvP",
    ["Description"] = "Welcome!",
    ["Color"] = Color3.fromRGB(255, 0, 255),
    ["Content"] = "Welcome to Sapi Hub BF PvP ˃ᴗ˂",
    ["Time"] = 1,
    ["Delay"] = 10
})

local UIGui = UILib.MakeGui(UILib, {
    ["NameHub"] = "Sapi Hub BF PvP ˃ᴗ˂",
    ["Description"] = "Fix By Dragon Toro",
    ["Color"] = Color3.fromRGB(255, 0, 255),
    ["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. game:GetService("Players").LocalPlayer.UserId .. "&width=420&height=420&format=png",
    ["Name Player"] = tostring(game:GetService("Players").LocalPlayer.Name),
    ["Tab Width"] = 125
})

-- ════════════════════════════════════════════
--          TAB 1: Executor Status
-- ════════════════════════════════════════════

local TabStatus = UIGui:CreateTab({
    ["Name"] = "Status",
    ["Icon"] = "rbxassetid://7733960981"
})

local SectionStatus = TabStatus:AddSection("◈ Information")

SectionStatus:AddParagraph({
    ["Title"] = "Executor",
    ["Content"] = executor
})

SectionStatus:AddParagraph({
    ["Title"] = "Status",
    ["Content"] = execStatus
})

-- ════════════════════════════════════════════
--          TAB 2: ChangesLogs
-- ════════════════════════════════════════════

local TabLogs = UIGui:CreateTab({
    ["Name"] = "Logs",
    ["Icon"] = "rbxassetid://7734053495"
})

local SectionLogs = TabLogs:AddSection("✏ Updated")

SectionLogs:AddParagraph({
    ["Title"] = "Changelogs",
    ["Content"] = "• Fixed Dropdown Save Settings ✔\n• Added Info Of Target (Name/Health) ✔\n• Optimized Script ✔\n• Improved Fps Boost ✔\n• Fixed Soul Guitar M1 in Silent aim ✔\n• Added RTX Graphic (Visual Vibes) ✔\n• Added Custom Global Text ✔\n• Added Dash No CD ✔\n• Added Remove Fog or Lava ✔\n• Added Z Skills Work (Except Godhuman Z) ✔\n• Added Fruit M1 Closet Attack ✔\n• Fixed Buddy Sword X in Silent aim ✔"
})

-- ════════════════════════════════════════════
--          TAB 3: Aimbot
-- ════════════════════════════════════════════

local TabAim = UIGui:CreateTab({
    ["Name"] = "Aimbot",
    ["Icon"] = "rbxassetid://7733960981"
})

local SectionAim = TabAim:AddSection("☘ Settings")

local AimlockPlayersToggle = SectionAim:AddToggle({
    ["Title"] = "Aimlock Players",
    ["Content"] = "Lock onto nearest player",
    ["Default"] = false,
    ["Callback"] = function(state)
        AimlockModule:SetPlayerAimlock(state)
        Settings["AimlockPlayers"] = state
    end
})

local AimlockPlayersMiniTogglePlayersToggle = SectionAim:AddToggle({
    ["Title"] = "Aimlock Mini Toggle Players",
    ["Content"] = "Lock onto nearest player",
    ["Default"] = false,
    ["Callback"] = function(state)
        AimlockModule:SetMiniTogglePlayerAimlock(state)
        Settings["AimlockPlayersMiniTogglePlayers"] = state
    end
})

local AimlockNPCToggle = SectionAim:AddToggle({
    ["Title"] = "Aimlock NPC",
    ["Content"] = "Lock onto nearest NPC/Boss",
    ["Default"] = false,
    ["Callback"] = function(state)
        AimlockModule:SetNpcAimlock(state)
        Settings["AimlockNPC"] = state
    end
})

local AimlockPlayersMiniToggleNPCToggle = SectionAim:AddToggle({
    ["Title"] = "Aimlock Mini Toggle NPC",
    ["Content"] = "Lock onto nearest NPC/Boss",
    ["Default"] = false,
    ["Callback"] = function(state)
        AimlockModule:SetMiniToggleNpcAimlock(state)
        Settings["AimlockPlayersMiniToggleNPC"] = state
    end
})

local PredictionToggle = SectionAim:AddToggle({
    ["Title"] = "Prediction",
    ["Content"] = "Predict enemy movement",
    ["Default"] = false,
    ["Callback"] = function(state)
        AimlockModule:SetPrediction(state)
        Settings["Prediction"] = state
    end
})

local PredictionAimlockAmountDropdown = SectionAim:AddDropdown({
    ["Title"] = "Prediction Amount | Default 0.1s",
    ["Content"] = "Select max Prediction for Aimlock",
    ["Multi"] = false,
    ["Options"] = {"0.2", "0.3", "0.4"},
    ["Default"] = {"0.2"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local num = tonumber(val)
        if num then
            AimlockModule:SetPredictionTime(num)
            Settings["PredictionAmount"] = num
        end
    end
})

-- ════════════════════════════════════════════
--          TAB 4: Silent Aimbot
-- ════════════════════════════════════════════

local TabSilent = UIGui:CreateTab({
    ["Name"] = "Silent Aim",
    ["Icon"] = "rbxassetid://7734053495"
})

local SectionSilent = TabSilent:AddSection("⚓ Settings")

local SilentAimPlayersToggle = SectionSilent:AddToggle({
    ["Title"] = "SilentAim Players",
    ["Content"] = "Lock onto nearest player",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetPlayerSilentAim(state)
        Settings["SilentAimPlayers"] = state
    end
})

local SilentMiniTogglePlayersToggle = SectionSilent:AddToggle({
    ["Title"] = "SilentAim Mini Toggle Players",
    ["Content"] = "Lock onto nearest player",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetMiniTogglePlayerSilentAim(state)
        Settings["SilentMiniTogglePlayers"] = state
    end
})

local SilentAimNPCToggle = SectionSilent:AddToggle({
    ["Title"] = "SilentAim Npcs",
    ["Content"] = "Lock onto nearest npc",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetNPCSilentAim(state)
        Settings["SilentAimNPC"] = state
    end
})

local SilentMiniToggleNPCToggle = SectionSilent:AddToggle({
    ["Title"] = "SilentAim Mini Toggle NPC",
    ["Content"] = "Lock onto nearest NPC/Boss",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetMiniToggleNpcSilentAim(state)
        Settings["SilentMiniToggleNPC"] = state
    end
})

local SilentAimPedictionToggle = SectionSilent:AddToggle({
    ["Title"] = "SilentAim Prediction",
    ["Content"] = "Prediction on target",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetPrediction(state)
        Settings["SilentAimPediction"] = state
    end
})

local PredictionAmountDropdown = SectionSilent:AddDropdown({
    ["Title"] = "Prediction Future | Default 0.1s",
    ["Content"] = "Select max Prediction for Silent Aim",
    ["Multi"] = false,
    ["Options"] = {"0.2", "0.3", "0.4"},
    ["Default"] = {"0.2"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local num = tonumber(val)
        if num then
            SilentAimModule:SetPredictionAmount(num)
            Settings["SilentAimPredictionFuture"] = num
        end
    end
})

local DistanceAmountDropdown = SectionSilent:AddDropdown({
    ["Title"] = "Distance Limit | Default 1000m",
    ["Content"] = "Select max distance for aimbot",
    ["Multi"] = false,
    ["Options"] = {"200", "400", "600"},
    ["Default"] = {"200"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local num = tonumber(val)
        if num then
            SilentAimModule:SetDistanceLimit(num)
            Settings["SilentAimDistanceLimit"] = num
        end
    end
})

-- Player list for dropdown
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= Players.LocalPlayer then
        table.insert(PlayerList, plr.Name)
    end
end

local PlayerDropdown = SectionSilent:AddDropdown({
    ["Title"] = "Select Player Target",
    ["Content"] = "Choose a player to lock onto",
    ["Multi"] = false,
    ["Options"] = PlayerList,
    ["Default"] = {"None"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        if val == "None" then
            SilentAimModule:SetSelectedPlayer(nil)
        else
            SilentAimModule:SetSelectedPlayer(val)
        end
    end
})

local function RefreshPlayerList()
    local newList = {"None"}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            table.insert(newList, plr.Name)
        end
    end
    PlayerDropdown:Refresh(newList, {"None"})
end

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)
RefreshPlayerList()

local ZSkillToggle = SectionSilent:AddToggle({
    ["Title"] = "GodhumanZ Aimlock",
    ["Content"] = "I only set Godhuman",
    ["Default"] = false,
    ["Callback"] = function(state)
        ZSkillModule:SetZSkills(state)
        Settings["ZSkills"] = state
    end
})

local HighlightToggle = SectionSilent:AddToggle({
    ["Title"] = "Main Highlight",
    ["Content"] = "Current Target Highlighted",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetHighlight(state)
        Settings["Highlight"] = state
    end
})

local ZskillMOneToggle = SectionSilent:AddToggle({
    ["Title"] = "Z|M1 Skills (except Godhuman Z)",
    ["Content"] = "Silent Aim That Work Some Skills",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetZSkillorM1(state)
        Settings["Zskillmone"] = state
    end
})

-- ════════════════════════════════════════════
--          TAB 5: Features
-- ════════════════════════════════════════════

local TabFeatures = UIGui:CreateTab({
    ["Name"] = "Features",
    ["Icon"] = "rbxassetid://7733960981"
})

local SectionFeatures = TabFeatures:AddSection("⚜ Settings")

SectionFeatures:AddButton({
    ["Title"] = "Join Discord",
    ["Content"] = "Get Link Discord server",
    ["Icon"] = "rbxassetid://16932740082",
    ["Callback"] = function()
        local link = "https://discord.gg/fKwqmB4C"
        if setclipboard then
            setclipboard(link)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Sapi Hub",
                Text = "Copied Discord Link!",
                Duration = 5
            })
        end
    end
})

local ESPPlayersToggle = SectionFeatures:AddToggle({
    ["Title"] = "ESP Players",
    ["Content"] = "Toggle Player ESP",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetESP(state)
        Settings["ESPPlayers"] = state
    end
})

local V3SkillToggle = SectionFeatures:AddToggle({
    ["Title"] = "V3 Skill",
    ["Content"] = "Auto activate V3 ability",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetV3(state)
        Settings["V3Skill"] = state
    end
})

local BunnyHopToggle = SectionFeatures:AddToggle({
    ["Title"] = "Bunny Hop",
    ["Content"] = "Toggle Bunnyhop",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetBunnyhop(state)
        Settings["BunnyHop"] = state
    end
})

local AuraSkillToggle = SectionFeatures:AddToggle({
    ["Title"] = "Aura Skill",
    ["Content"] = "Auto activate Buso",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetBuso(state)
        Settings["AuraSkill"] = state
    end
})

local FpsOrPingsToggle = SectionFeatures:AddToggle({
    ["Title"] = "Fps Or Pings",
    ["Content"] = "Display Ping or Fps",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetPingsOrFps(state)
        Settings["FpsOrPings"] = state
    end
})

local SpeedInput = SectionFeatures:AddInput({
    ["Title"] = "Speed Hack",
    ["Content"] = "Enter WalkSpeed value",
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num then
            getgenv().WalkSpeedValue = num
            UiSettingsModule:SetWalkSpeed(num)
        end
    end
})

local FpsBoostToggle = SectionFeatures:AddToggle({
    ["Title"] = "Fps Boost",
    ["Content"] = "Increase Fps",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetFpsBoost(state)
        Settings["FpsBoost"] = state
    end
})

local INFEnergyToggle = SectionFeatures:AddToggle({
    ["Title"] = "INF Energy",
    ["Content"] = "Max Energy",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetINFEnergy(state)
        Settings["INFEnergy"] = state
    end
})

local WalkonWaterToggle = SectionFeatures:AddToggle({
    ["Title"] = "Walk on Water",
    ["Content"] = "Travel in Water",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetWalkWater(state)
        Settings["WalkonWater"] = state
    end
})

local FastAttackToggle = SectionFeatures:AddToggle({
    ["Title"] = "Fast Attack",
    ["Content"] = "Fast Attack",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetFastAttack(state)
        Settings["FastAttack"] = state
    end
})

local AntiAFKToggle = SectionFeatures:AddToggle({
    ["Title"] = "AntiAfk",
    ["Content"] = "AntiAfk only on before you off",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetAntiAfk(state)
        Settings["AntiAFK"] = state
    end
})

local JumpInput = SectionFeatures:AddInput({
    ["Title"] = "Jump Power",
    ["Content"] = "Enter JumpPower value",
    ["Callback"] = function(value)
        getgenv().JumpValue = value
        if getgenv().JumpValue then
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = getgenv().JumpValue
        end
    end
})

local V4Toggle = SectionFeatures:AddToggle({
    ["Title"] = "Auto V4",
    ["Content"] = "Auto V4 Transform",
    ["Default"] = false,
    ["Callback"] = function(state)
        UiSettingsModule:SetV4(state)
        Settings["V4"] = state
    end
})

local FruitCheckToggle = SectionFeatures:AddToggle({
    ["Title"] = "Spawned Fruit Check",
    ["Content"] = "Check Fruit Spawned",
    ["Default"] = false,
    ["Callback"] = function(state)
        UiSettingsModule:SetFruitCheck(state)
        Settings["FruitCheck"] = state
    end
})

local TeleportFruitToggle = SectionFeatures:AddToggle({
    ["Title"] = "Bring Fruits",
    ["Content"] = "It take few seconds to bring fruits",
    ["Default"] = false,
    ["Callback"] = function(state)
        UiSettingsModule:SetTeleportFruit(state)
        Settings["TeleportFruit"] = state
    end
})

local AutoKenToggle = SectionFeatures:AddToggle({
    ["Title"] = "Auto Ken",
    ["Content"] = "AutoKen",
    ["Default"] = false,
    ["Callback"] = function(state)
        SilentAimModule:SetAutoKen(state)
        Settings["AutoKen"] = state
    end
})

local LavaToggle = SectionFeatures:AddToggle({
    ["Title"] = "Remove Lava",
    ["Content"] = "Remove Lava",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetLava(state)
        Settings["Lava"] = state
    end
})

local FogToggle = SectionFeatures:AddToggle({
    ["Title"] = "Remove Fog",
    ["Content"] = "Remove Fog",
    ["Default"] = false,
    ["Callback"] = function(state)
        StuffsModule:SetFog(state)
        Settings["Fog"] = state
    end
})

local DodgeToggle = SectionFeatures:AddToggle({
    ["Title"] = "Dodge no cd",
    ["Content"] = "Dodge no cd",
    ["Default"] = false,
    ["Callback"] = function(state)
        ESPModule:SetNoDodgeCD(state)
        Settings["Dodge"] = state
    end
})

local OpponentToggle = SectionFeatures:AddToggle({
    ["Title"] = "Target Info (Name/Health)",
    ["Content"] = "Info Of Target",
    ["Default"] = false,
    ["Callback"] = function(state)
        ZSkillModule:SetInfo(state)
        Settings["Opponent"] = state
    end
})

-- ════════════════════════════════════════════
--          TAB 6: Settings Manager
-- ════════════════════════════════════════════

local TabSettings = UIGui:CreateTab({
    ["Name"] = "Setting",
    ["Icon"] = "rbxassetid://7734053495"
})

local SectionManager = TabSettings:AddSection("💾 Settings Manager")

local JobIdInput = SectionManager:AddInput({
    ["Title"] = "Paste Job Id Here",
    ["Content"] = "Paste JobId and press Enter",
    ["Callback"] = function(jobid)
        if jobid and jobid ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobid, Players.LocalPlayer)
        end
    end
})

SectionManager:AddButton({
    ["Title"] = "Save Current Settings",
    ["Content"] = "Save all current settings",
    ["Icon"] = "rbxassetid://16932740082",
    ["Callback"] = function()
        OthersStuffsModule.SaveSettings(Settings)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sapi Hub",
            Text = "Settings Saved!",
            Duration = 4
        })
    end
})

SectionManager:AddButton({
    ["Title"] = "Reset Settings",
    ["Content"] = "Clear saved settings",
    ["Icon"] = "rbxassetid://16932740082",
    ["Callback"] = function()
        OthersStuffsModule.ResetSettings()
        Settings = {}
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sapi Hub",
            Text = "Settings Reset!",
            Duration = 4
        })
    end
})

SectionManager:AddButton({
    ["Title"] = "Rejoin Server",
    ["Content"] = "Rejoin your server",
    ["Icon"] = "rbxassetid://16932740082",
    ["Callback"] = function()
        StuffsModule:SetRejoinServer()
    end
})

local GlobalTextDropdown = SectionManager:AddDropdown({
    ["Title"] = "Global Text Font",
    ["Content"] = "Change font for all text",
    ["Multi"] = false,
    ["Options"] = {
        "Arcade", "Cartoon", "SciFi", "Fantasy", "Antique",
        "Garamond", "RobotoMono", "FredokaOne", "LuckiestGuy",
        "PermanentMarker", "SpecialElite", "Oswald", "Nunito"
    },
    ["Default"] = {"Arcade"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local fontEnum = Enum.Font[val]
        if fontEnum then
            ESPModule:SetGlobalFont(fontEnum)
            Settings["GlobalFont"] = val
        else
            warn("Font not found:", val)
        end
    end
})

local RTXModeDropdown = SectionManager:AddDropdown({
    ["Title"] = "RTX Graphics Mode",
    ["Content"] = "Choose between Autumn or Summer lighting",
    ["Multi"] = false,
    ["Options"] = {"Autumn", "Summer", "Spring", "Winter"},
    ["Default"] = {"Autumn"},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        ESPModule:SetRTXMode(val)
        Settings["RTXMode"] = val
    end
})

local ThemesDropdown = SectionManager:AddDropdown({
    ["Title"] = "Select Theme",
    ["Content"] = "Choose a color theme",
    ["Multi"] = false,
    ["Options"] = UiSettingsModule:getThemeNames(),
    ["Default"] = {UiSettingsModule:getThemeNames()[1]},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local newColor = UiSettingsModule.themes[val]
        if newColor then
            UiSettingsModule:updateSchemeColor(newColor, UIGui)
            Settings["Themes"] = val
        end
    end
})

local BackgroundThemesDropdown = SectionManager:AddDropdown({
    ["Title"] = "Select Background Theme",
    ["Content"] = "Choose a color background",
    ["Multi"] = false,
    ["Options"] = UiSettingsModule:getBackgroundThemeNames(),
    ["Default"] = {UiSettingsModule:getBackgroundThemeNames()[1]},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local newColor = UiSettingsModule.backgroundThemes[val]
        if newColor then
            UiSettingsModule:updateBackgroundColor(newColor, UIGui)
            Settings["BackgroundThemes"] = val
        end
    end
})

local TextColorDropdown = SectionManager:AddDropdown({
    ["Title"] = "Select TextColor",
    ["Content"] = "Choose a textcolor",
    ["Multi"] = false,
    ["Options"] = UiSettingsModule:getThemeNames(),
    ["Default"] = {UiSettingsModule:getThemeNames()[1]},
    ["Callback"] = function(selected)
        local val = type(selected) == "table" and selected[1] or selected
        local newColor = UiSettingsModule.themes[val]
        if newColor then
            UiSettingsModule:updateTextColor(newColor, UIGui)
            Settings["TextColor"] = val
        end
    end
})

-- ════════════════════════════════════════════
--          APPLY SAVED SETTINGS
-- ════════════════════════════════════════════

Settings = OthersStuffsModule.LoadSettings()

OthersStuffsModule:ApplySettings(Settings, {
    Aimlock = AimlockModule,
    SilentAim = SilentAimModule,
    ESP = ESPModule,
    Stuffs = StuffsModule,
    Ui = UiSettingsModule,
    Zskill = ZSkillModule
}, {
    AimlockPlayers = AimlockPlayersToggle,
    AimlockPlayersMiniTogglePlayers = AimlockPlayersMiniTogglePlayersToggle,
    AimlockNPC = AimlockNPCToggle,
    SilentAimPlayers = SilentAimPlayersToggle,
    SilentAimNPC = SilentAimNPCToggle,
    ESPPlayers = ESPPlayersToggle,
    AntiAFK = AntiAFKToggle,
    FpsOrPings = FpsOrPingsToggle,
    FpsBoost = FpsBoostToggle,
    INFEnergy = INFEnergyToggle,
    FastAttack = FastAttackToggle,
    WalkonWater = WalkonWaterToggle,
    V4 = V4Toggle,
    FruitCheck = FruitCheckToggle,
    TeleportFruit = TeleportFruitToggle,
    AutoKen = AutoKenToggle,
    ZSkills = ZSkillToggle,
    BunnyHop = BunnyHopToggle,
    AuraSkill = AuraSkillToggle,
    V3Skill = V3SkillToggle,
    Highlight = HighlightToggle,
    SilentMiniToggleNPC = SilentMiniToggleNPCToggle,
    SilentMiniTogglePlayers = SilentMiniTogglePlayersToggle,
    Zskillmone = ZskillMOneToggle,
    SilentAimPediction = SilentAimPedictionToggle,
    Dodge = DodgeToggle,
    Lava = LavaToggle,
    Fog = FogToggle,
    PredictionAmount = PredictionAimlockAmountDropdown,
    SilentAimPredictionFuture = PredictionAmountDropdown,
    SilentAimDistanceLimit = DistanceAmountDropdown,
    GlobalFont = GlobalTextDropdown,
    RTXMode = RTXModeDropdown,
    Themes = ThemesDropdown,
    BackgroundThemes = BackgroundThemesDropdown,
    TextColor = TextColorDropdown
})

OthersStuffsModule.StartFruitNotifier()

-- ════════════════════════════════════════════
--          KEYBINDS
-- ════════════════════════════════════════════

-- Phím M: ẩn/hiện button toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        _ImageButton.Visible = not _ImageButton.Visible
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and UserInputService.KeyboardEnabled and input.KeyCode == Enum.KeyCode.G then
        Settings["SilentAimPlayers"] = not Settings["SilentAimPlayers"]
        SilentAimModule:SetPlayerSilentAim(Settings["SilentAimPlayers"])
        if SilentAimPlayersToggle then
            SilentAimPlayersToggle:Set(Settings["SilentAimPlayers"])
        end
    end
end)
