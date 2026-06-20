function ParseDialogChoice(id, original, modified, injected, blocked)
	local DialogChoicePacket = WINDOWER_PACKETS.parse('outgoing', original)

	local DialogNPCID = DialogChoicePacket["Target"]
	local DialogOption = DialogChoicePacket["Option Index"]
	local DialogMob = windower.ffxi.get_mob_by_id(DialogNPCID)

	if DialogMob then
		if DialogMob.name == "Matter Diffusion Module" and DialogOption == 100 then
			DelayCheckStartForFloorChange()
		end
	end
end