local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local BREATH_DRAIN = 9 -- per second

local ocean = workspace:WaitForChild("Ocean")
local shoreSpawn = workspace:WaitForChild("ShoreSpawn")

-- ✅ Dynamic Max Breath
local function getMaxBreath(player)
	local upgrades = player:FindFirstChild("Upgrades")

	if upgrades then
		local level = upgrades.BreathLevel.Value
		return 100 + (level - 1) * 30
	end

	return 100
end

-- Zone multiplier
local function getZoneMultiplier(depth)
	if depth < 150 then
		return 1
	elseif depth < 400 then
		return 2
	elseif depth < 900 then
		return 3
	else
		return 5
	end
end

-- Zone name
local function getZoneName(depth)
	if depth < 150 then
		return "Coral Reef"
	elseif depth < 400 then
		return "Deep Sea"
	elseif depth < 900 then
		return "Dark Ocean"
	else
		return "Abyss"
	end
end

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function(character)

		local root = character:WaitForChild("HumanoidRootPart")

		-- ✅ USE upgrade-based breath
		local breath = getMaxBreath(player)
		local diveDepth = 0

		player:SetAttribute("Breath", breath)
		player:SetAttribute("Depth", 0)
		player:SetAttribute("Reward", 0)
		player:SetAttribute("Zone", "Coral Reef")

		local connection

		connection = RunService.Heartbeat:Connect(function(dt)

			if not character.Parent then
				connection:Disconnect()
				return
			end

			if not root or not player.Parent then return end

			local oceanSize = ocean.Size
			local oceanPos = ocean.Position
			local oceanTop = oceanPos.Y + (oceanSize.Y / 2)
			local oceanBottom = oceanPos.Y - (oceanSize.Y / 2)

			local inX = math.abs(root.Position.X - oceanPos.X) <= oceanSize.X / 2
			local inZ = math.abs(root.Position.Z - oceanPos.Z) <= oceanSize.Z / 2
			local belowSurface = root.Position.Y < oceanTop
			local aboveBottom = root.Position.Y > oceanBottom

			if inX and inZ and belowSurface and aboveBottom then

				-- Drain breath
				breath -= BREATH_DRAIN * dt
				if breath < 0 then
					breath = 0
				end

				player:SetAttribute("Breath", breath)

				local currentDepth = math.floor(oceanTop - root.Position.Y)
				player:SetAttribute("Depth", currentDepth)

				local zone = getZoneName(currentDepth)
				player:SetAttribute("Zone", zone)

				if currentDepth > diveDepth then
					diveDepth = currentDepth
				end

				-- Leaderboard record
				if currentDepth > player.leaderstats.MaxDepth.Value then
					player.leaderstats.MaxDepth.Value = currentDepth
				end

				if breath <= 0 then

					print("Teleporting. Depth:", diveDepth)

					local multiplier = getZoneMultiplier(diveDepth)
					local reward = diveDepth * multiplier

					local petMulti = player:GetAttribute("PetMultiplier") or 1
					local rebirths = player.leaderstats.Rebirths.Value
					local rebirthMulti = 1 + (rebirths * 0.5)

					reward = math.floor(reward * petMulti * rebirthMulti)

					player.leaderstats.Money.Value += reward
					player:SetAttribute("Reward", reward)

					root.CFrame = shoreSpawn.CFrame + Vector3.new(0,5,0)

					-- ✅ RESET WITH UPGRADED VALUE
					breath = getMaxBreath(player)
					diveDepth = 0

					player:SetAttribute("Breath", breath)
					player:SetAttribute("Depth", 0)
				end

			else
				-- ✅ ALSO RESET HERE
				breath = getMaxBreath(player)

				player:SetAttribute("Breath", breath)
				player:SetAttribute("Depth", 0)
			end

		end)

	end)

end)