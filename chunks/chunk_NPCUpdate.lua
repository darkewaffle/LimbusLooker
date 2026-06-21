function ParseNPCUpdate(id, original, modified, injected, blocked)
	local NPCUpdatePacket = WINDOWER_PACKETS.parse('incoming', original)

	local NPCStatus = NPCUpdatePacket["Status"]
	local NPCIsAlive = NPCStatus <= 1
	local NPCIsDead = NPCStatus >= 2

	local NPCMaskBools = { original:unpack("q8", 11) }
	local NPCStatusChanged = NPCMaskBools[3]
	local NPCTerminated = NPCMaskBools[6]
	local NPCHidden = original:unpack("q1", 33, 2)

	local NPCDied = NPCIsDead and NPCStatusChanged

	local NPCID = NPCUpdatePacket["NPC"]
	local NPCIndex = NPCUpdatePacket["Index"]
	local NPCModel = NPCUpdatePacket["Model"]

	if NPCDied or NPCTerminated then
		ResetIDCheckState(NPCID)

	-- 2326 = Apollyon ???, 2423 = Temenos ???
	elseif (NPCModel == 2326 or NPCModel == 2423 or NPCName == "???") then
		if not GetLocatedQuestionMarkID() then
			SetLocatedQuestionMark(NPCID, NPCHidden)
		end
	
	elseif NPCIsAlive then
		local NPCMob = windower.ffxi.get_mob_by_id(NPCID)

		if NPCMob then
			local MobName = NPCMob.name
			local MobSpawnType = NPCMob.spawn_type

			if MobSpawnType == 16 and (string.sub(MobName, 1, 8) == "Apollyon" or string.sub(MobName, 1, 7) == "Temenos") then
				QueueForCheck(NPCID, NPCIndex)
			end
		end
	end
end