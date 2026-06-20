function ParseNPCUpdate(id, original, modified, injected, blocked)
	local NPCUpdatePacket = WINDOWER_PACKETS.parse('incoming', original)

	local NPCStatus = NPCUpdatePacket["Status"]
	local NPCIsAlive = NPCStatus <= 1
	local NPCIsDead = NPCStatus >= 2

	local NPCMask = IntToBinary(NPCUpdatePacket["Mask"])
	local NPCVisible = NPCMask[3] == "0"
	local NPCHidden = NPCMask[3] == "1"
	local NPCStatusHasChanged = NPCMask[6] == "1"

	local NPCDied = NPCIsDead and NPCStatusHasChanged

	local NPCID = NPCUpdatePacket["NPC"]
	local NPCIndex = NPCUpdatePacket["Index"]
	local NPCModel = NPCUpdatePacket["Model"]

	if NPCDied or NPCHidden then
		ResetIDCheckState(NPCID)

	-- 2326 = Apollyon ???, 2423 = Temenos ???
	elseif (NPCModel == 2326 or NPCModel == 2423 or NPCName == "???") and NPCVisible then
		if not GetLocatedQuestionMark() then
			SetLocatedQuestionMark(NPCID)
		end
	
	elseif NPCIsAlive and NPCVisible then
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