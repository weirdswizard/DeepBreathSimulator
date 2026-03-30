local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent")

local function getRebirthCost(player)
	local rebirths = player.leaderstats.Rebirths.Value
	return 5000 * (rebirths + 1)
end

rebirthEvent.OnServerEvent:Connect(function(player)

	local money = player.leaderstats.Money

	local cost = getRebirthCost(player)

	if money.Value < cost then
		player:SetAttribute("PetResult", "Not enough coins!")
		return
	end

	-- Deduct money
	money.Value = 0

	-- Increase rebirth count
	player.leaderstats.Rebirths.Value += 1

	-- Reset stats
	player.leaderstats.MaxDepth.Value = 0

	-- Reset pets
	local pets = player:FindFirstChild("Pets")
	if pets then
		pets:ClearAllChildren()
	end

	-- Reset multiplier
	player:SetAttribute("PetMultiplier", 1)
	
	player:SetAttribute("PetResult", "Rebirthed!")

	print(player.Name.." rebirthed!")

end)
