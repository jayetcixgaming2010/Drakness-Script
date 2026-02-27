local FlurioreFixLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jayetcixgaming2010/UI/refs/heads/main/FlurioreLibFix.lua"))()
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

-- Ensure this runs as a LocalScript (client). Abort early on server scripts.
local player = Players.LocalPlayer
if not player then
    warn("test.lua must run as a LocalScript (client). Aborting GUI creation.")
    return
end

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

local Settings = OthersStuffsModule.LoadSettings()

local _TweenService = game:GetService("TweenService")
local _VIM = game:GetService("VirtualInputManager")

local isUIEnabled = true
local UIEnabled = true -- Biến trạng thái UI

-- Hàm toggle UI: điều khiển ScreenGui do FlurioreFixLib tạo (HirimiGui)
local function toggleUI()
    UIEnabled = not UIEnabled
    local hirimi = nil
    -- Try CoreGui first, then PlayerGui (library may parent to PlayerGui)
    local coreGui = game:GetService("CoreGui")
    hirimi = coreGui:FindFirstChild("HirimiGui")
    if not hirimi and player and player:FindFirstChild("PlayerGui") then
        hirimi = player.PlayerGui:FindFirstChild("HirimiGui")
    end
    if hirimi and hirimi:IsA("ScreenGui") then
        hirimi.Enabled = UIEnabled
        -- Ensure main container is visible if the library previously hid it via Min/Close
        local holder = hirimi:FindFirstChild("DropShadowHolder")
        if holder and holder:IsA("Frame") then
            pcall(function() holder.Visible = UIEnabled end)
        end
    end
    -- cập nhật label trạng thái nếu có
    if StatusLabel then
        if UIEnabled then
            StatusLabel.Text = "UI: ON"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            StatusLabel.Text = "UI: OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

-- Tạo ScreenGui và ImageButton để mở/đóng UI
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "ToggleButtonGui"

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 1 -- Nền trong suốt
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.120833337 - 0.10, 0, 0.0952890813 + 0.01, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Draggable = true
ImageButton.Image = "rbxassetid://101138166721164"
ImageButton.Name = "ToggleButton"

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ImageButton

-- Tạo TextLabel để hiển thị trạng thái (có thể bỏ qua nếu không cần)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = ImageButton
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 0.3, 0)
StatusLabel.Position = UDim2.new(0, 0, 1, 5)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "UI: ON"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.TextSize = 12
StatusLabel.TextStrokeTransparency = 0.5

-- Handle the event when the ImageButton is clicked
ImageButton.MouseButton1Click:Connect(function()
    -- toggle giao diện chính do thư viện tạo
    toggleUI()
    -- Tạo hiệu ứng click (dùng LocalPlayer mouse)
    local ok, m = pcall(function() return player:GetMouse() end)
    if ok and m then
        CircleClick(ImageButton, m.X or 0, m.Y or 0)
    else
        CircleClick(ImageButton, 0, 0)
    end
end)

-- Thêm hiệu ứng hover
ImageButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        ImageButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 55, 0, 55)}
    ):Play()
end)

ImageButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        ImageButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 50, 0, 50)}
    ):Play()
end)

-- Thêm phím tắt để mở/đóng UI (ví dụ: RightControl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        -- Toggle UI directly and show click effect
        toggleUI()
        local ok, m = pcall(function() return player:GetMouse() end)
        if ok and m then
            CircleClick(ImageButton, m.X or 0, m.Y or 0)
        else
            CircleClick(ImageButton, 0, 0)
        end
    end
end)

-- Hàm CircleClick (nếu chưa có)
function CircleClick(Button, X, Y)
    coroutine.resume(
        coroutine.create(
            function()
                local Circle = Instance.new("ImageLabel")
                Circle.Parent = Button
                Circle.Name = "Circle"
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BackgroundTransparency = 1.000
                Circle.ZIndex = 10
                Circle.Image = "rbxassetid://101138166721164"
                Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
                Circle.ImageTransparency = 0.7
                local NewX = X - Circle.AbsolutePosition.X
                local NewY = Y - Circle.AbsolutePosition.Y
                Circle.Position = UDim2.new(0, NewX, 0, NewY)

                local Time = 0.2
                Circle:TweenSizeAndPosition(
                    UDim2.new(0, 30.25, 0, 30.25),
                    UDim2.new(0, NewX - 15, 0, NewY - 10),
                    "Out",
                    "Quad",
                    Time,
                    false,
                    nil
                )
                for i = 1, 10 do
                    Circle.ImageTransparency = Circle.ImageTransparency + 0.01
                    wait(Time / 10)
                end
                Circle:Destroy()
            end
        )
    )
end


local Notify = FlurioreFixLib:MakeNotify({
	["Title"] = "Drakness Hub",
	["Description"] = "Welcome to Drakness Hub",
	["Color"] = Color3.fromRGB(255, 0, 255),
	["Content"] = "Welcome to Drakness Hub",
	["Time"] = 1,
	["Delay"] = 10
})
local FlurioreGui = FlurioreFixLib:MakeGui({
	["NameHub"] = "Drakness Hub",
	["Description"] = "Make by Drakness Team",
	["Color"] = Color3.fromRGB(255, 0, 255),
	["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png",
	["Name Player"] = tostring(game:GetService("Players").LocalPlayer.Name),
	["Tab Width"] = 125
})
local Tab1 = FlurioreGui:CreateTab({
	["Name"] = "Main",
	["Icon"] = "rbxassetid://7733960981"
})

local Tab2 = FlurioreGui:CreateTab({
    ["Name"] = "Logs",
    ["Icon"] = "rbxassetid://7734053495"
})

local Tab3 = FlurioreGui:CreateTab({
    ["Name"] = "Aimbot",
    ["Icon"] = "rbxassetid://7733960981"
})

local Tab4 = FlurioreGui:CreateTab({
    ["Name"] = "Silent Aim",
    ["Icon"] = "rbxassetid://7734053495"
})

local Tab5 = FlurioreGui:CreateTab({
    ["Name"] = "Features",
    ["Icon"] = "rbxassetid://7733960981"
})

local Tab6 = FlurioreGui:CreateTab({
    ["Name"] = "Setting",
    ["Icon"] = "rbxassetid://7734053495"
})

local SectionStatus = Tab1:AddSection("Information")

SectionStatus:AddButton({
    ["Title"] = "Discord Server",
    ["Content"] = "Join our Discord Server for support and updates",
    ["Icon"] = "rbxassetid://101138166721164",
    ["Callback"] = function()
        local link = "discord.gg/upEE5wkdUX"
        if setclipboard then
            setclipboard(link)
            -- dùng hệ thống thông báo của thư viện
            FlurioreFixLib:MakeNotify({
                ["Title"] = "Discord",
                ["Description"] = "Link đã được sao chép",
                ["Color"] = Color3.fromRGB(0, 170, 255),
                ["Content"] = link,
                ["Time"] = 1,
                ["Delay"] = 3
            })
        end
    end
})

SectionStatus:AddParagraph({
    ["Title"] = "Executor",
    ["Content"] = executor
})

SectionStatus:AddParagraph({
    ["Title"] = "Status",
    ["Content"] = execStatus
})

local SectionLogs = Tab2:AddSection("✏ Updated")

SectionLogs:AddParagraph({
    ["Title"] = "Changelogs",
    ["Content"] = "• Fixed Dropdown Save Settings ✔\n• Added Info Of Target (Name/Health) ✔\n• Optimized Script ✔\n• Improved Fps Boost ✔\n• Fixed Soul Guitar M1 in Silent aim ✔\n• Added RTX Graphic (Visual Vibes) ✔\n• Added Custom Global Text ✔\n• Added Dash No CD ✔\n• Added Remove Fog or Lava ✔\n• Added Z Skills Work (Except Godhuman Z) ✔\n• Added Fruit M1 Closet Attack ✔\n• Fixed Buddy Sword X in Silent aim ✔"
})

local SectionAim = Tab3:AddSection("☘ Settings")

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

local SectionSilent = Tab4:AddSection("⚓ Settings")

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

local SectionFeatures = Tab5:AddSection("⚜ Settings")

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

local SectionManager = Tab6:AddSection("💾 Settings Manager")

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

-- bật HirimiGui nếu có (UI bắt đầu mở)
local coreGui = game:GetService("CoreGui")
local hirimi = coreGui:FindFirstChild("HirimiGui")
if hirimi and hirimi:IsA("ScreenGui") then
    hirimi.Enabled = true
end
