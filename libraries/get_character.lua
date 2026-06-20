function GetCharacterAsMob()
	local PlayerData = windower.ffxi.get_player()

	if PlayerData then
		local PlayerMobData = windower.ffxi.get_mob_by_id(PlayerData.id)
		if PlayerMobData then
			return PlayerMobData
		end
	end

	return {}
end

function GetCharacterCoordinates()
	local PlayerMobData = GetCharacterAsMob()
	return PlayerMobData.x or 0, PlayerMobData.y or 0, PlayerMobData.z or 0
end

function GetCharacterAngleToMob(MobData)
	local PlayerX, PlayerY = GetCharacterCoordinates()

	local DeltaX = MobData.x - PlayerX
	local DeltaY = MobData.y - PlayerY

	local DirectionRadians = math.atan2(DeltaY, DeltaX)
	if DirectionRadians < 0 then
		DirectionRadians = DirectionRadians + (2 * math.pi)
	end

	-- Convert radians to degrees
	return DirectionRadians * 57.2958
end

function GetCharacterCardinalToMob(MobData, ReturnLong)
	local DirectionDegreesToMob = GetCharacterAngleToMob(MobData)

	local DegreeInterval = math.floor((DirectionDegreesToMob / 45) + .5)

	local CardinalMap = {
		[0] = {["long"] = "East", ["short"] = "E"},
		[1] = {["long"] = "Northeast", ["short"] = "NE"},
		[2] = {["long"] = "North", ["short"] = "N"},
		[3] = {["long"] = "Northwest", ["short"] = "NW"},
		[4] = {["long"] = "West", ["short"] = "W"},
		[5] = {["long"] = "Southwest", ["short"] = "SW"},
		[6] = {["long"] = "South", ["short"] = "S"},
		[7] = {["long"] = "Southeast", ["short"] = "SE"},
		[8] = {["long"] = "East", ["short"] = "E"}
	}

	if not ReturnLong then
		return CardinalMap[DegreeInterval].short
	else
		return CardinalMap[DegreeInterval].long
	end
end
