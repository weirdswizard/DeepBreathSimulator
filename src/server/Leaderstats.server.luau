game.Players.PlayerAdded:Connect(function(player)

	player:SetAttribute("PetMultiplier",1)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Money = Instance.new("IntValue")
	Money.Name = "Money"
	Money.Value = 5000
	Money.Parent = leaderstats

	local MaxDepth = Instance.new("IntValue")
	MaxDepth.Name = "MaxDepth"
	MaxDepth.Value = 0
	MaxDepth.Parent = leaderstats
	
	local Rebirths = Instance.new("IntValue")
	Rebirths.Name = "Rebirths"
	Rebirths.Value = 0
	Rebirths.Parent = leaderstats

end)