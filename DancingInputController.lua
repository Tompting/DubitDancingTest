-- Dancing Input Controller
-- Tom Mackintosh
-- 7th January 2021

-- Controls
local Inputs = {
	Enum.KeyCode.Right,
	Enum.KeyCode.Down,
	Enum.KeyCode.Left,
	Enum.KeyCode.Up,
}

-- Roblox Service Imports
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hierarchy References
local Arrow = script.Parent
local IncreaseSpeedRemote = ReplicatedStorage.Remotes.IncreaseSpeed

local validInput = Inputs[(Arrow.Rotation + 90) / 90]

function IncorrectInput()
	ReplicatedStorage.Remotes.IncreaseSpeed:FireServer(-5)
	local tween = TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = Arrow.Rotation + 360} )
	tween:Play()
	tween.Completed:Wait()
end
 
function CorrectInput(Score)
	IncreaseSpeedRemote:FireServer(Score)
	local tween = TweenService:Create(script.Parent, TweenInfo.new(0.5), { Size = UDim2.new(0, 0, 0,0 ) })
	tween:Play()
	tween.Completed:Wait()
end

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if table.find(Inputs, input.KeyCode) then
			if 0.15 <= Arrow.Position.Y.Scale and Arrow.Position.Y.Scale <= 0.25 then
				if input.KeyCode == validInput then
					CorrectInput(3)
				else
					IncorrectInput()
				end
				
				script.Parent:Destroy()
			elseif 0.1 <= Arrow.Position.Y.Scale and Arrow.Position.Y.Scale <= 0.3 then
				if input.KeyCode == validInput then
					CorrectInput(1)
				else
					IncorrectInput()
				end
				script.Parent:Destroy()
			end
		end
	end
end)
