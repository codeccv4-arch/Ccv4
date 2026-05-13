--// BY. CCV4
--// ULTRA MODERN HUB
--// MOBILE + PC
--// DRAGGABLE ICON
--// ESP + AIM ASSIST + ANTI LAG

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

local ESP_ENABLED = false
local AIM_ENABLED = false
local ANTILAG_ENABLED = false

local AIM_FOV = 120
local AIM_SMOOTHNESS = 0.10

local ESPFolder = nil
local AimConnection = nil

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CCV4_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- MAIN FRAME
--==================================================

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,270,0,240)
Main.Position = UDim2.new(0.5,-135,0.5,-120)
Main.BackgroundColor3 = Color3.fromRGB(12,12,12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = Main
MainStroke.Color = Color3.fromRGB(255,170,0)
MainStroke.Thickness = 2

local MainGradient = Instance.new("UIGradient")
MainGradient.Parent = Main
MainGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10))
}

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "by. CCV4"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.fromRGB(255,170,0)
Title.TextSize = 24

--==================================================
-- ICON BUTTON
--==================================================

local ToggleMenu = Instance.new("ImageButton")
ToggleMenu.Parent = ScreenGui
ToggleMenu.Size = UDim2.new(0,70,0,70)
ToggleMenu.Position = UDim2.new(0,20,0.5,-35)

-- ไม่มีกรอบสี่เหลี่ยม
ToggleMenu.BackgroundTransparency = 1

-- ไอคอน
ToggleMenu.Image = "rbxassetid://6031094678"

ToggleMenu.AutoButtonColor = false

-- Glow
local Glow = Instance.new("ImageLabel")
Glow.Parent = ToggleMenu
Glow.BackgroundTransparency = 1
Glow.Size = UDim2.new(1.9,0,1.9,0)
Glow.Position = UDim2.new(-0.45,0,-0.45,0)
Glow.ZIndex = 0
Glow.Image = "rbxassetid://5028857084"
Glow.ImageTransparency = 0.4

--==================================================
-- ICON EFFECT
--==================================================

ToggleMenu.MouseEnter:Connect(function()

	TweenService:Create(
		ToggleMenu,
		TweenInfo.new(0.15),
		{
			Size = UDim2.new(0,76,0,76),
			Rotation = 10
		}
	):Play()
end)

ToggleMenu.MouseLeave:Connect(function()

	TweenService:Create(
		ToggleMenu,
		TweenInfo.new(0.15),
		{
			Size = UDim2.new(0,70,0,70),
			Rotation = 0
		}
	):Play()
end)

--==================================================
-- FLOAT EFFECT
--==================================================

task.spawn(function()

	while true do

		TweenService:Create(
			ToggleMenu,
			TweenInfo.new(
				1.5,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				ImageTransparency = 0.1
			}
		):Play()

		task.wait(1.5)

		TweenService:Create(
			ToggleMenu,
			TweenInfo.new(
				1.5,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				ImageTransparency = 0
			}
		):Play()

		task.wait(1.5)
	end
end)

--==================================================
-- DRAG ICON SYSTEM
--==================================================

local dragging = false
local dragInput
local dragStart
local startPos

local function Update(input)

	local delta = input.Position - dragStart

	ToggleMenu.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,

		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

ToggleMenu.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = ToggleMenu.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false
			end
		end)
	end
end)

ToggleMenu.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput and dragging then
		Update(input)
	end
end)

--==================================================
-- MENU TOGGLE
--==================================================

local MenuOpen = true

ToggleMenu.MouseButton1Click:Connect(function()

	MenuOpen = not MenuOpen

	if MenuOpen then

		Main.Visible = true

		TweenService:Create(
			Main,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Back
			),
			{
				Size = UDim2.new(0,270,0,240)
			}
		):Play()

	else

		TweenService:Create(
			Main,
			TweenInfo.new(0.2),
			{
				Size = UDim2.new(0,0,0,0)
			}
		):Play()

		task.wait(0.2)

		Main.Visible = false
	end
end)

--==================================================
-- BUTTON CREATOR
--==================================================

local function CreateButton(text, posY)

	local Button = Instance.new("TextButton")
	Button.Parent = Main
	Button.Size = UDim2.new(0,225,0,44)
	Button.Position = UDim2.new(0.5,-112,0,posY)
	Button.BackgroundColor3 = Color3.fromRGB(22,22,22)
	Button.Text = text
	Button.Font = Enum.Font.GothamBold
	Button.TextColor3 = Color3.new(1,1,1)
	Button.TextSize = 17
	Button.AutoButtonColor = false

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,14)

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Button
	Stroke.Color = Color3.fromRGB(255,170,0)
	Stroke.Thickness = 2

	return Button
end

--==================================================
-- ESP SYSTEM
--==================================================

local function ClearESP()

	if ESPFolder then
		ESPFolder:Destroy()
		ESPFolder = nil
	end
end

local function CreateESP()

	ClearESP()

	ESPFolder = Instance.new("Folder")
	ESPFolder.Parent = ScreenGui

	for _,player in pairs(Players:GetPlayers()) do

		if player ~= LocalPlayer then

			local function AddESP(character)

				if not ESP_ENABLED then
					return
				end

				local Highlight = Instance.new("Highlight")
				Highlight.Parent = ESPFolder
				Highlight.Adornee = character
				Highlight.FillColor = Color3.fromRGB(255,170,0)
				Highlight.OutlineColor = Color3.new(1,1,1)
				Highlight.FillTransparency = 0.5
				Highlight.DepthMode =
					Enum.HighlightDepthMode.AlwaysOnTop
			end

			if player.Character then
				AddESP(player.Character)
			end

			player.CharacterAdded:Connect(AddESP)
		end
	end
end

--==================================================
-- AIM ASSIST
--==================================================

local function IsVisible(targetPart)

	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {
		LocalPlayer.Character,
		Camera
	}

	local result = workspace:Raycast(
		origin,
		direction,
		params
	)

	if result then
		return result.Instance:IsDescendantOf(
			targetPart.Parent
		)
	end

	return true
end

local function GetClosestPlayer()

	local Closest = nil
	local ClosestDistance = AIM_FOV

	for _,player in pairs(Players:GetPlayers()) do

		if player ~= LocalPlayer
		and player.Character
		and player.Character:FindFirstChild("Head")
		and player.Character:FindFirstChild("Humanoid") then

			local Humanoid = player.Character.Humanoid

			if Humanoid.Health > 0 then

				local Head = player.Character.Head

				if IsVisible(Head) then

					local Position, Visible =
						Camera:WorldToViewportPoint(
							Head.Position
						)

					if Visible then

						local Distance = (
							Vector2.new(Position.X, Position.Y)
							-
							Vector2.new(
								Camera.ViewportSize.X/2,
								Camera.ViewportSize.Y/2
							)
						).Magnitude

						if Distance < ClosestDistance then

							ClosestDistance = Distance
							Closest = player
						end
					end
				end
			end
		end
	end

	return Closest
end

local function EnableAim()

	if AimConnection then
		AimConnection:Disconnect()
	end

	AimConnection = RunService.RenderStepped:Connect(function()

		if not AIM_ENABLED then
			return
		end

		local Target = GetClosestPlayer()

		if Target
		and Target.Character
		and Target.Character:FindFirstChild("Head") then

			local Head = Target.Character.Head.Position

			local NewCF = CFrame.new(
				Camera.CFrame.Position,
				Head
			)

			Camera.CFrame = Camera.CFrame:Lerp(
				NewCF,
				AIM_SMOOTHNESS
			)
		end
	end)
end

local function DisableAim()

	if AimConnection then
		AimConnection:Disconnect()
		AimConnection = nil
	end
end

--==================================================
-- ANTI LAG
--==================================================

local function EnableAntiLag()

	settings().Rendering.QualityLevel =
		Enum.QualityLevel.Level01

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end

		if v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("Explosion") then
			v.BlastPressure = 0
			v.BlastRadius = 0
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.SmoothPlastic
			v.Reflectance = 0
		end
	end
end

--==================================================
-- BUTTONS
--==================================================

local ESPButton = CreateButton(
	"ESP : OFF",
	60
)

ESPButton.MouseButton1Click:Connect(function()

	ESP_ENABLED = not ESP_ENABLED

	if ESP_ENABLED then

		CreateESP()

		ESPButton.Text = "ESP : ON"

	else

		ClearESP()

		ESPButton.Text = "ESP : OFF"
	end
end)

local AimButton = CreateButton(
	"AIM ASSIST : OFF",
	115
)

AimButton.MouseButton1Click:Connect(function()

	AIM_ENABLED = not AIM_ENABLED

	if AIM_ENABLED then

		EnableAim()

		AimButton.Text = "AIM ASSIST : ON"

	else

		DisableAim()

		AimButton.Text = "AIM ASSIST : OFF"
	end
end)

local LagButton = CreateButton(
	"ANTI LAG : OFF",
	170
)

LagButton.MouseButton1Click:Connect(function()

	ANTILAG_ENABLED = not ANTILAG_ENABLED

	if ANTILAG_ENABLED then

		EnableAntiLag()

		LagButton.Text = "ANTI LAG : ON"

	else

		LagButton.Text = "ANTI LAG : OFF"
	end
end)

--==================================================
-- OPEN EFFECT
--==================================================

Main.Size = UDim2.new(0,0,0,0)

TweenService:Create(
	Main,
	TweenInfo.new(
		0.4,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	),
	{
		Size = UDim2.new(0,270,0,240)
	}
):Play()

--==================================================
-- NOTIFICATION
--==================================================

pcall(function()

	StarterGui:SetCore("SendNotification",{
		Title = "by. CCV4",
		Text = "Hub Loaded Successfully",
		Duration = 4
	})
end)
