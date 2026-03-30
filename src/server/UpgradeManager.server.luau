local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local upgradeEvent = ReplicatedStorage:WaitForChild("UpgradeBreath")

local upgradeCosts = {
	200,
	500,
	1200,
	2500
}

Players.PlayerAdded:Connect(function(player)

	local upgrades = Instance.new("Folder")
	upgrades.Name = "Upgrades"
	upgrades.Parent = player

	local breathLevel = Instance.new("IntValue")
	breathLevel.Name = "BreathLevel"
	breathLevel.Value = 1
	breathLevel.Parent = upgrades

end)

upgradeEvent.OnServerEvent:Connect(function(player)

	local level = player.Upgrades.BreathLevel.Value

	if level >= 5 then return end

	local cost = upgradeCosts[level]

	if player.leaderstats.Money.Value >= cost then

		player.leaderstats.Money.Value -= cost
		player.Upgrades.BreathLevel.Value += 1

	end

end)