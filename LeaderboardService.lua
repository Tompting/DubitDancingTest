-- Leaderboard Service
-- Tom Mackintosh
-- 8th January 2021

-- Roblox Services Import
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Model", player)
	leaderstats.Name = "leaderstats"
	
	local score = Instance.new("NumberValue", leaderstats)
	score.Name = "Score"
end)

local Debounce = {}

ServerStorage.Bindables.IncreaseScore.Event:Connect(function(player, delta)
	if not Debounce[player.Name] then
		Debounce[player.Name] = true
		if player.leaderstats then
			if player.leaderstats.Score then
				player.leaderstats.Score.Value = player.leaderstats.Score.Value + (delta)
			end
		end
		Debounce[player.Name] = nil
	end
end)
