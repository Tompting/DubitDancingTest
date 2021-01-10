-- Dancefloor Service
-- Tom Mackintosh
-- 8th January 2021

-- Roblox Service Imports
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hierarchy References
local BindablesFolder = ServerStorage.Bindables
local DanceAnimation = script.Animations.Dance
local DancefloorPart = script.References.Dancefloor.Value

local dancefloor = {}
local animTracks = {}

BindablesFolder.PlayerEntered.Event:Connect(function(player)
	local ui = ServerStorage.UI.Song:Clone()
	ui.Parent = player.PlayerGui
	
	dancefloor[player.Name] = true
	
	local animTrack = player.Character.Humanoid:LoadAnimation(DanceAnimation)
	animTrack.Looped = true
	animTrack:AdjustSpeed(0.5)
	animTracks[player.Name] = animTrack
end)

BindablesFolder.PlayerLeft.Event:Connect(function(player)
	local ui = player.PlayerGui:FindFirstChild("Song")
	if ui then
		ui:Destroy()
	end
	
	dancefloor[player.Name] = nil
	
	if player.Character then
		for _, animTrack in pairs (player.Character.Humanoid:GetPlayingAnimationTracks()) do
			animTrack:Stop()
		end
	
		player.Character.Animate.Disabled = false
	end
end)

ReplicatedStorage.Remotes.Play.OnServerEvent:Connect(function(player)
	if dancefloor[player.Name] then
		if animTracks[player.Name] then
			player.Character.Animate.Disabled = true
			animTracks[player.Name]:Play()
		end
	end
end)

ReplicatedStorage.Remotes.IncreaseSpeed.OnServerEvent:Connect(function(player, speed)
	if dancefloor[player.Name] then
		if animTracks[player.Name] then
			animTracks[player.Name]:AdjustSpeed(animTracks[player.Name].Speed + (speed / 10))
			
			if animTracks[player.Name].Speed > 3 then
				animTracks[player.Name]:AdjustSpeed(3)
			elseif animTracks[player.Name].Speed < 0.5 then
				animTracks[player.Name]:AdjustSpeed(0.5)
				print("Tripped.")
			end
			
			if speed > 0 then
				BindablesFolder.IncreaseScore:Fire(player, animTracks[player.Name].Speed)
			end
		end
	end
end)

function getPlayerFromHit(hit)
	local character = hit.Parent
	if character and hit.Name == "Head" then
		local player = game.Players:GetPlayerFromCharacter(character)
		if player then
			return player
		end
	end
end

DancefloorPart.Touched:Connect(function(hit)
	local player = getPlayerFromHit(hit)
	if player and animTracks[player] == nil then
		BindablesFolder.PlayerEntered:Fire(player)
	end
end)

DancefloorPart.TouchEnded:Connect(function(hit)
	local player = getPlayerFromHit(hit)
	if player then
		BindablesFolder.PlayerLeft:Fire(player)
		animTracks[player.Name] = nil
		dancefloor[player.Name] = nil
	end
end)
