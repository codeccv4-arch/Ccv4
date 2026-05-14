-- [[ V23 THE OMEGA HUB - ORIGINAL & COMPLETE ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("V23_OmegaHub") then CoreGui.V23_OmegaHub:Destroy() end

local MenuState = { Visible = true, Minimized = false, CurrentTab = "Combat" }

-- // --- AIMBOT ENGINE (LOCKED) --- // --
local AimbotSettings = {
    Enabled = false,
    WallCheck = true,
    Distance = 1000,
    AimPart = "Head",
    Smoothness = 0.9
}

-- [Setting สำหรับ ESP - LOCKED]
local EspSettings = {
    Boxes = false,
    Skeleton = false
}

-- [Setting สำหรับ Speed Hack & Infinite Jump & Invisibility - UPDATED]
local MovementSettings = {
    SpeedEnabled = false,
    SpeedValue = 16,
    InfJump = false,
    Invisibility = false 
}

local function IsVisible(targetPart)
    if not AimbotSettings.WallCheck then return true end
    local rayParam = RaycastParams.new()
    rayParam.FilterType = Enum.RaycastFilterType.Exclude
    rayParam.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local result = workspace:Raycast(origin, direction, rayParam)
    return result == nil or result.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestTarget()
    local target, dist = nil, AimbotSettings.Distance
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            local part = v.Character:FindFirstChild(AimbotSettings.AimPart)
            
            if hum and hum.Health > 0 and part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen then
                    local mDist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                    if mDist < dist then
                        if IsVisible(part) then
                            target = part
                            dist = mDist
                        end
                    end
                end
            end
        end
    end
    return target
end

-- // --- [ESP BOX SECTION - LOCKED] --- // --
local function CreateEspBox(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Thickness = 2
    Box.Transparency = 1
    Box.Filled = false

    local function Update()
        local c
        c = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and EspSettings.Boxes then
                local RootPart = player.Character.HumanoidRootPart
                local RootPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
                if OnScreen then
                    local Scale = 1 / (RootPos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                    local Width, Height = 4 * Scale, 6 * Scale
                    Box.Size = Vector2.new(Width, Height)
                    Box.Position = Vector2.new(RootPos.X - Width / 2, RootPos.Y - Height / 2)
                    Box.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    Box.Visible = true
                else Box.Visible = false end
            else
                Box.Visible = false
                if not player.Parent then Box:Remove() c:Disconnect() end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- // --- [ESP SKELETON SECTION - LOCKED] --- // --
local function CreateLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.Color = Color3.new(1, 1, 1)
    l.Thickness = 1
    l.Transparency = 1
    return l
end

local function CreateHeadCircle()
    local c = Drawing.new("Circle")
    c.Visible = false
    c.Color = Color3.new(1, 1, 1)
    c.Thickness = 1
    c.Transparency = 1
    c.Filled = false
    c.Radius = 0
    return c
end

local function CreateSkeleton(player)
    local Objects = {
        HeadCircle = CreateHeadCircle(),
        Spine = CreateLine(),
        UpperTorsoToLeftArm = CreateLine(),
        UpperTorsoToRightArm = CreateLine(),
        LeftArmToWrist = CreateLine(),
        RightArmToWrist = CreateLine(),
        LowerTorsoToLeftLeg = CreateLine(),
        LowerTorsoToRightLeg = CreateLine(),
        LeftLegToAnkle = CreateLine(),
        RightLegToAnkle = CreateLine()
    }

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and EspSettings.Skeleton then
            local char = player.Character
            local isR15 = (char.Humanoid.RigType == Enum.HumanoidRigType.R15)
            local rgbColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            for _, obj in pairs(Objects) do obj.Color = rgbColor end

            local parts = {}
            if isR15 then
                parts = {
                    Head = char:FindFirstChild("Head"),
                    UpperTorso = char:FindFirstChild("UpperTorso"),
                    LowerTorso = char:FindFirstChild("LowerTorso"),
                    LeftUpperArm = char:FindFirstChild("LeftUpperArm"),
                    LeftLowerArm = char:FindFirstChild("LeftLowerArm"),
                    RightUpperArm = char:FindFirstChild("RightUpperArm"),
                    RightLowerArm = char:FindFirstChild("RightLowerArm"),
                    LeftUpperLeg = char:FindFirstChild("LeftUpperLeg"),
                    LeftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
                    RightUpperLeg = char:FindFirstChild("RightUpperLeg"),
                    RightLowerLeg = char:FindFirstChild("RightLowerLeg")
                }
            else
                parts = {
                    Head = char:FindFirstChild("Head"),
                    UpperTorso = char:FindFirstChild("Torso"),
                    LowerTorso = char:FindFirstChild("Torso"),
                    LeftUpperArm = char:FindFirstChild("Left Arm"),
                    LeftLowerArm = char:FindFirstChild("Left Arm"),
                    RightUpperArm = char:FindFirstChild("Right Arm"),
                    RightLowerArm = char:FindFirstChild("Right Arm"),
                    LeftUpperLeg = char:FindFirstChild("Left Leg"),
                    LeftLowerLeg = char:FindFirstChild("Left Leg"),
                    RightUpperLeg = char:FindFirstChild("Right Leg"),
                    RightLowerLeg = char:FindFirstChild("Right Leg")
                }
            end

            local function SetLine(line, p1, p2)
                if p1 and p2 then
                    local pos1, on1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2, on2 = Camera:WorldToViewportPoint(p2.Position)
                    if on1 and on2 then
                        line.From = Vector2.new(pos1.X, pos1.Y)
                        line.To = Vector2.new(pos2.X, pos2.Y)
                        line.Visible = true
                        return
                    end
                end
                line.Visible = false
            end

            local function SetHead(circle, headPart)
                if headPart then
                    local pos, on = Camera:WorldToViewportPoint(headPart.Position)
                    if on then
                        circle.Position = Vector2.new(pos.X, pos.Y)
                        local dist = (Camera.CFrame.Position - headPart.Position).Magnitude
                        circle.Radius = math.clamp(80 / dist, 2, 15)
                        circle.Visible = true
                        return
                    end
                end
                circle.Visible = false
            end

            SetHead(Objects.HeadCircle, parts.Head)
            SetLine(Objects.Spine, parts.Head, parts.LowerTorso)
            SetLine(Objects.UpperTorsoToLeftArm, parts.UpperTorso, parts.LeftUpperArm)
            SetLine(Objects.UpperTorsoToRightArm, parts.UpperTorso, parts.RightUpperArm)
            if isR15 then
                SetLine(Objects.LeftArmToWrist, parts.LeftUpperArm, parts.LeftLowerArm)
                SetLine(Objects.RightArmToWrist, parts.RightUpperArm, parts.RightLowerArm)
                SetLine(Objects.LeftLegToAnkle, parts.LeftUpperLeg, parts.LeftLowerLeg)
                SetLine(Objects.RightLegToAnkle, parts.RightUpperLeg, parts.RightLowerLeg)
            end
            SetLine(Objects.LowerTorsoToLeftLeg, parts.LowerTorso, parts.LeftUpperLeg)
            SetLine(Objects.LowerTorsoToRightLeg, parts.LowerTorso, parts.RightUpperLeg)
        else
            for _, obj in pairs(Objects) do obj.Visible = false end
            if not player.Parent then for _, obj in pairs(Objects) do obj:Remove() end end
        end
    end)
end

-- // --- [UNIVERSAL INVISIBILITY - GHOST STATE METHOD] --- // --
local function HandleInvisibility()
    local OldPos = nil
    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if MovementSettings.Invisibility then
                -- ย้าย Character Mesh ออกไปในจุดที่มองไม่เห็น (สำหรับ Client อื่น)
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 1
                    elseif part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
                -- ปิดความสูงเพื่อให้ระบบ Anti-Cheat บางตัวไม่ทำงาน
                char.HumanoidRootPart.CanCollide = false
            else
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    elseif part:IsA("Decal") then
                        part.Transparency = 0
                    end
                end
            end
        end
    end)
end

-- // --- [DEVELOPED MOVEMENT SECTION] --- // --
local function HandleMovement()
    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if MovementSettings.SpeedEnabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = MovementSettings.SpeedValue
            else
                if LocalPlayer.Character.Humanoid.WalkSpeed ~= 16 then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if MovementSettings.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end
coroutine.wrap(HandleMovement)()
coroutine.wrap(HandleInvisibility)()

-- // --- INITIALIZATION --- // --
for _, v in pairs(Players:GetPlayers()) do 
    if v ~= LocalPlayer then 
        CreateEspBox(v) 
        CreateSkeleton(v)
    end 
end
Players.PlayerAdded:Connect(function(v) CreateEspBox(v) CreateSkeleton(v) end)

-- // --- UI HELPERS --- // --
local function MakeDraggable(ui)
    local dragging, dragInput, dragStart, startPos
    ui.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = ui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    ui.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // --- UI SETUP --- // --
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "V23_OmegaHub"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 350); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(2, 4, 10); MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Thickness = 2.5; MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 38); Header.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "OMEGA HUB v23 | Premium Edition"; Title.TextColor3 = Color3.fromRGB(0, 180, 255); Title.Font = Enum.Font.GothamBold; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local function WinBtn(t, p, c, cb)
    local b = Instance.new("TextButton", Header); b.Size = UDim2.new(0, 28, 0, 28); b.Position = p; b.BackgroundColor3 = c
    b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
end

WinBtn("X", UDim2.new(1, -35, 0, 5), Color3.fromRGB(180, 50, 50), function() 
    MainFrame.Visible = false 
end)

WinBtn("-", UDim2.new(1, -70, 0, 5), Color3.fromRGB(50, 55, 70), function()
    MenuState.Minimized = not MenuState.Minimized
    MainFrame:TweenSize(MenuState.Minimized and UDim2.new(0, 580, 0, 38) or UDim2.new(0, 580, 0, 350), "Out", "Quad", 0.2, true)
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38); Sidebar.BackgroundColor3 = Color3.fromRGB(5, 10, 20)
local SidebarList = Instance.new("UIListLayout", Sidebar); SidebarList.Padding = UDim.new(0, 5); SidebarList.HorizontalAlignment = "Center"
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -150, 1, -50); ContentArea.Position = UDim2.new(0, 145, 0, 45); ContentArea.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", ContentArea)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2
    Instance.new("UIGridLayout", p).CellSize = UDim2.new(0, 200, 0, 40)
    Pages[name] = p
    return p
end

local function AddSpeedControl(pageName)
    local container = Instance.new("Frame", Pages[pageName])
    container.BackgroundColor3 = Color3.fromRGB(10, 25, 45); container.Size = UDim2.new(0, 200, 0, 40)
    Instance.new("UICorner", container); local s = Instance.new("UIStroke", container); s.Color = Color3.fromRGB(0, 100, 200)

    local mainBtn = Instance.new("TextButton", container)
    mainBtn.Size = UDim2.new(0.6, 0, 1, 0); mainBtn.BackgroundTransparency = 1
    mainBtn.Text = "  ⚡ Speed: " .. MovementSettings.SpeedValue; mainBtn.TextColor3 = Color3.new(1,1,1)
    mainBtn.Font = Enum.Font.GothamBold; mainBtn.TextSize = 10; mainBtn.TextXAlignment = "Left"

    local function UpdateDisplay()
        mainBtn.Text = "  ⚡ Speed: " .. MovementSettings.SpeedValue .. (MovementSettings.SpeedEnabled and " [ON]" or " [OFF]")
        mainBtn.TextColor3 = MovementSettings.SpeedEnabled and Color3.fromRGB(0, 255, 150) or Color3.new(1,1,1)
    end

    mainBtn.MouseButton1Click:Connect(function()
        MovementSettings.SpeedEnabled = not MovementSettings.SpeedEnabled
        UpdateDisplay()
    end)

    local function CreateAdj(t, x, amt)
        local b = Instance.new("TextButton", container)
        b.Size = UDim2.new(0.2, -4, 0.8, 0); b.Position = UDim2.new(x, 2, 0.1, 0)
        b.BackgroundColor3 = Color3.fromRGB(20, 45, 80); b.Text = t; b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            MovementSettings.SpeedValue = math.clamp(MovementSettings.SpeedValue + amt, 16, 500)
            UpdateDisplay()
        end)
    end

    CreateAdj("-", 0.6, -5)
    CreateAdj("+", 0.8, 5)
end

local function AddBtn(pageName, text, icon, cb)
    local b = Instance.new("TextButton", Pages[pageName])
    b.BackgroundColor3 = Color3.fromRGB(10, 25, 45); b.Text = "  " .. icon .. "  " .. text .. " [OFF]"
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.TextXAlignment = "Left"
    Instance.new("UICorner", b); local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(0, 100, 200)
    
    local function ToggleVisual()
        local is_on = string.find(b.Text, "ON")
        if is_on then
            b.Text = "  " .. icon .. "  " .. text .. " [OFF]"
            b.TextColor3 = Color3.new(1,1,1)
        else
            b.Text = "  " .. icon .. "  " .. text .. " [ON]"
            b.TextColor3 = Color3.fromRGB(0, 255, 150)
        end
    end
    b.MouseButton1Click:Connect(function() cb() ToggleVisual() end)
end

local tabs = {"Combat", "Visuals", "Movement", "Player", "Misc"}
for _, name in pairs(tabs) do CreatePage(name) end

-- COMBAT
AddBtn("Combat", "Aimbot", "🎯", function() AimbotSettings.Enabled = not AimbotSettings.Enabled end)
AddBtn("Combat", "Silent Aim", "🤫", function() print("Silent Aim") end)
AddBtn("Combat", "No Recoil", "🚫", function() print("No Recoil") end)

-- VISUALS
AddBtn("Visuals", "ESP Box", "📦", function() EspSettings.Boxes = not EspSettings.Boxes end)
AddBtn("Visuals", "ESP Skeleton", "💀", function() EspSettings.Skeleton = not EspSettings.Skeleton end)

-- MOVEMENT
AddSpeedControl("Movement")
AddBtn("Movement", "Inf Jump", "🦘", function() MovementSettings.InfJump = not MovementSettings.InfJump end)
AddBtn("Movement", "Invisibility", "👻", function() MovementSettings.Invisibility = not MovementSettings.Invisibility end)

local function SwitchTab(name)
    for k, v in pairs(Pages) do v.Visible = (k == name) end
end
for _, name in pairs(tabs) do
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(15, 35, 60)
    b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() SwitchTab(name) end)
end
SwitchTab("Combat")

local Tgl = Instance.new("TextButton", ScreenGui)
Tgl.Size = UDim2.new(0, 50, 0, 50); Tgl.Position = UDim2.new(0, 10, 0.5, 0); Tgl.Text = "OMEGA"
Tgl.BackgroundColor3 = Color3.fromRGB(5, 5, 10); Tgl.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1,0); MakeDraggable(Tgl)
Tgl.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- // --- MAIN LOOP --- // --
RunService.RenderStepped:Connect(function()
    MainStroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    if AimbotSettings.Enabled then
        local targetPart = GetClosestTarget()
        if targetPart then
            local lookAtPos = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(lookAtPos, AimbotSettings.Smoothness)
        end
    end
end)
