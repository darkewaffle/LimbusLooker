function ParseNPCSpawn(id, original, modified, injected, blocked)
	local NPCSpawnPacket = WINDOWER_PACKETS.parse('incoming', original)

	local NPCID = NPCSpawnPacket["ID"]
	local NPCIndex = NPCSpawnPacket["Index"]
	local NPCType = NPCSpawnPacket["Type"]

	if NPCType == 3 then
		ResetIDCheckState(NPCID)
	end

end