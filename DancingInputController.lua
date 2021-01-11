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

function CheckInput(input)
		if 0.15 <= Arrow.Position.Y.Scale and Arrow.Position.Y.Scale <= 0.25 then
			if table.find(validInput, input) then
				CorrectInput(3)
			else
				IncorrectInput()
			end

			script.Parent:Destroy()
		elseif 0.1 <= Arrow.Position.Y.Scale and Arrow.Position.Y.Scale <= 0.3 then
			if table.find(validInput, input) then
				CorrectInput(1)
			else
				IncorrectInput()
			end
			script.Parent:Destroy()
		end
end

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == Enum.KeyCode.Up or
			input.KeyCode == Enum.KeyCode.Down or
			input.KeyCode == Enum.KeyCode.Right or
			input.KeyCode == Enum.KeyCode.Left then
			
			CheckInput(input.KeyCode)
		end
	end
end)

UserInputService.TouchSwipe:Connect(function(swipeDirection, numberOfTouches, gameProcessed)
	if not gameProcessed then
		CheckInput(swipeDirection)
	end
end)
