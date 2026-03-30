local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local hatchEvent = ReplicatedStorage:WaitForChild("HatchEgg")

local eggCost = 250

local pets = {
	{ name = "Tiny Fish", multiplier = 1.2, chance = 50 },
	{ name = "Jellyfish", multiplier = 1.5, chance = 35 },
	{ name = "Shark Pup", multiplier = 2.0, chance = 15 }
}

-- Create pet folder when player joins
Players.PlayerAdded:Connect(function(player)

	local petFolder = Instance.new("Folder")
	petFolder.Name = "Pets"
	petFolder.Parent = player

	player:SetAttribute("PetMultiplier", 1)

end)

-- Random pet system
local function getRandomPet()

	local roll = math.random(1,100)
	local total = 0

	for _,pet in pairs(pets) do
		total += pet.chance
		if roll <= total then
			return pet
		end
	end

end

-- Hatch logic
hatchEvent.OnServerEvent:Connect(function(player)

	if player.leaderstats.Money.Value < eggCost then
		return
	end

	local petFolder = player:FindFirstChild("Pets")
	if not petFolder then return end

	-- LIMIT = 3 PETS
	if #petFolder:GetChildren() >= 3 then
		player:SetAttribute("PetResult", "Inventory Full!")
		return
	end

	-- Deduct money
	player.leaderstats.Money.Value -= eggCost

	local pet = getRandomPet()

	-- Store pet
	local petValue = Instance.new("StringValue")
	petValue.Name = pet.name
	petValue.Parent = petFolder

	-- Popup
	player:SetAttribute("PetResult", pet.name)

	print(player.Name.." hatched "..pet.name)

end)