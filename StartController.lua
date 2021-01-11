-- Start Controller
-- Tom Mackintosh
-- 8th January 2021

-- Controls
local ToggleGame = Enum.KeyCode.E
local CameraOffset = CFrame.new(0, 0, -10)

-- Roblox Service Imports
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hierarchy References
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = Player.Character
local Humanoid = Character:WaitForChild("Humanoid")
local StandardAnimateScript = Character.Animate

local SongUIContainer = script.Parent
local SongControllerScript = SongUIContainer["Song Controller"]

-- This manages player controls when unexpected events happen, such as teleporting or being pushed out of the dancefloor.
local ExitHandler = script["Exit Handler"]:Clone()
ExitHandler.Disabled = false
ExitHandler.Parent = Player.PlayerScripts

SongUIContainer.Prompt.Visible = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)

function EndGame()
	
	Camera.CameraType = Enum.CameraType.Custom
	Humanoid.WalkSpeed = 16
	Humanoid.JumpPower = 50

	local animTracks = Humanoid:GetPlayingAnimationTracks()
	for i = 1, #animTracks do
		animTracks[i]:Stop()
	end

	StandardAnimateScript.Disabled = false

	SongUIContainer.Slide.Visible = false
	SongUIContainer.Targets.Visible = false
end

function StartGame()
	Camera.CameraType = Enum.CameraType.Scriptable
	Humanoid.WalkSpeed = 0
	Humanoid.JumpPower = 0

	StandardAnimateScript.Disabled = true

	Camera.CFrame = Character.Head.CFrame:ToWorldSpace(CameraOffset)
	Camera.CFrame = CFrame.new(Camera.CFrame.Position, Character.Head.Position)

	ReplicatedStorage.Remotes.Play:FireServer()

	SongUIContainer.Slide.Visible = true
	SongUIContainer.Targets.Visible = true
	
	SongControllerScript.Disabled = false
end

SongUIContainer.Prompt.TextButton.MouseButton1Click:Connect(function()
	if SongUIContainer.Slide.Visible == false then
		StartGame()
	else
		EndGame()
	end
end)

-- Toggles whether the user is playing the minigame.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == ToggleGame then
			if SongUIContainer.Slide.Visible == false then
				StartGame()
			else
				EndGame()
			end
		end
	end
end)
