-- Exit Handler
-- Tom Mackintosh
-- 10th January 2021

-- Roblox Services Import
local Players = game:GetService("Players")

-- Reference variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = Player.Character
local Humanoid = Character.Humanoid

Player.PlayerGui.ChildRemoved:Connect(function(UI)
	if UI.Name == "Song" then
		Camera.CameraType = Enum.CameraType.Custom
		
		if Character then
			Humanoid.WalkSpeed = 16
			Humanoid.JumpPower = 50
		end
	end
end)
