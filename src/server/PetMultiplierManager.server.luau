local Players = game:GetService("Players")

local multipliers = {
	["Tiny Fish"] = 1.2,
	["Jellyfish"] = 1.5,
	["Shark Pup"] = 2
}

local function updateMultiplier(player)

	local pets = player:FindFirstChild("Pets")
	if not pets then return end

	local total = 1

	for _,pet in pairs(pets:GetChildren()) do

		local multi = multipliers[pet.Name]

		if multi then
			total *= multi
		end

	end

	player:SetAttribute("PetMultiplier", total)

end

Players.PlayerAdded:Connect(function(player)

	local petFolder = player:WaitForChild("Pets")

	petFolder.ChildAdded:Connect(function()
		updateMultiplier(player)
	end)

	petFolder.ChildRemoved:Connect(function()
		updateMultiplier(player)
	end)

end)