--// MODERN HUB FINAL
--// ALL FUNCTIONS FULLY TOGGLEABLE
--// MOBILE + PC
--// LOCALSCRIPT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- STATES
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
ScreenGui.Name = "by.CCV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,260,0,230)
Main.Position = UDim2.new(0.5,-130,0.5,-115)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = Main
MainStroke.Color = Color3.fromRGB(0,170,255)
MainStroke.Thickness = 2

local Gradient = Instance.new("UIGradient")
Gradient.Parent = Main
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10))
}

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,45)
Title.BackgroundTransparency = 1
Title.Text = "MODERN HUB"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22

--==================================================
-- TOGGLE MENU
--==================================================

local MenuOpen = true

local ToggleMenu = Instance.new("TextButton")
ToggleMenu.Parent = ScreenGui
ToggleMenu.Size = UDim2.new(0,60,0,60)
ToggleMenu.Position = UDim2.new(0,20,0.5,-30)
ToggleMenu.BackgroundColor3 = Color3.fromRGB(0,170,255)
ToggleMenu.Text = "≡"
ToggleMenu.TextColor3 = Color3.new(1,1,1)
ToggleMenu.Font = Enum.Font.GothamBold
ToggleMenu.TextSize = 28

Instance.new("UICorner", ToggleMenu).CornerRadius = UDim.new(1,0)

ToggleMenu.MouseButton1Click:Connect(function()

	MenuOpen = not MenuOpen

	if MenuOpen then

		Main.Visible = true

		TweenService:Create(
			Main,
			TweenInfo.new(0.25),
			{
				Size = UDim2.new(0,260,0,230)
			}
		):Play()

	else

		TweenService:Create(
			Main,
			TweenInfo.new(0.25),
			{
				Size = UDim2.new(0,0,0,0)
			}
		):Play()

		task.wait(0.25)

		Main.Visible = false
	end
end)

--==================================================
-- BUTTON CREATOR
--==================================================

local function CreateButton(text, posY)

	local Button = Instance.new("TextButton")
	Button.Parent = Main
	Button.Size = UDim2.new(0,220,0,42)
	Button.Position = UDim2.new(0.5,-110,0,posY)
	Button.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Button.Text = text
	Button.Font = Enum.Font.GothamBold
	Button.TextColor3 = Color3.new(1,1,1)
	Button.TextSize = 16
	Button.AutoButtonColor = false

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,12)

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Button
	Stroke.Color = Color3.fromRGB(0,170,255)

	Button.MouseEnter:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = Color3.fromRGB(0,170,255)
			}
		):Play()
	end)

	Button.MouseLeave:Connect(function()

		TweenService:Create(
			Button,
			TweenInfo.new(0.15),
			{
				BackgroundColor3 = Color3.fromRGB(35,35,35)
			}
		):Play()
	end)

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
	ESPFolder.Name = "ESPFolder"
	ESPFolder.Parent = ScreenGui

	for _,player in pairs(Players:GetPlayers()) do

		if player ~= LocalPlayer then

			local function AddESP(character)

				if not ESP_ENABLED then
					return
				end

				if character and character:FindFirstChild("HumanoidRootPart") then

					local Highlight = Instance.new("Highlight")
					Highlight.Adornee = character
					Highlight.FillColor = Color3.fromRGB(0,170,255)
					Highlight.OutlineColor = Color3.new(1,1,1)
					Highlight.FillTransparency = 0.5
					Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Highlight.Parent = ESPFolder
				end
			end

			if player.Character then
				AddESP(player.Character)
			end

			player.CharacterAdded:Connect(AddESP)
		end
	end
end

--==================================================
-- AIM FUNCTIONS
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
-- OPEN ANIMATION
--==================================================

Main.Size = UDim2.new(0,0,0,0)

TweenService:Create(
	Main,
	TweenInfo.new(
		0.35,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	),
	{
		Size = UDim2.new(0,260,0,230)
	}
):Play()

--==================================================
-- NOTIFICATION
--==================================================

pcall(function()

	StarterGui:SetCore("SendNotification",{
		Title = "Modern Hub",
		Text = "All Functions Loaded",
		Duration = 3
	})
end)
