-- Song Service
-- Tom Mackintosh
-- 10th January 2021

-- Control variables
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hierarchy References
local BeatsEvent = ReplicatedStorage.Remotes.Beat

local importData = false

function Beat()
	math.randomseed(os.time())
	
	local index = math.random(1, 4)
	
	BeatsEvent:FireAllClients(index)
end

if not importData then
	while wait(1) do
		Beat()
	end
	
else
	local data = require(script.ExampleSong)
	
	if data then
		for index = 1, #data do
			wait(data[index])
			Beat()
		end
	end
end
