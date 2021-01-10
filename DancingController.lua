-- Dancing Controller
-- Tom Mackintosh
-- 7th January 2021

-- Control variables
local Speed = 5

-- Roblox Services Import
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Hierarchy References
local Arrows = script.Arrows:GetChildren()
local Colours = script.ArrowColours:GetChildren()

local Debounce = false

function launched(index)
	if not Debounce then
		Debounce = true
		
		local ArrowObject = Arrows[index].Value
		local ArrowColourObject = Colours[index].Value
		
		local imageLabel = ArrowObject:Clone()

		imageLabel.Position = UDim2.new(imageLabel.Position.X.Scale, 0, 1, 0)
		imageLabel.Size = UDim2.new(0.25, 0, 0.3, 0)
		imageLabel.ImageColor3 = ArrowColourObject

		local inputController = script.CloneScripts["Dancing Input Controller"]:Clone()
		inputController.Disabled = false
		inputController.Parent = imageLabel

		imageLabel.Parent = script.Parent.Slide

		local targetPosition = UDim2.new(imageLabel.Position.X.Scale, 0, -1, 0)

		local tween = TweenService:Create(imageLabel, TweenInfo.new(Speed, Enum.EasingStyle.Linear), { Position = targetPosition })
		tween:Play()
		
		delay(0.1, function()
			Debounce = false
		end)

		spawn(function()
			tween.Completed:Wait()
			imageLabel:Destroy()
		end)
	end
end

ReplicatedStorage.Remotes.Beat.OnClientEvent:Connect(launched)
