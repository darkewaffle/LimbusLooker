function ParseActionMessage(id, original, modified, injected, blocked)
	local ActionMessagePacket = WINDOWER_PACKETS.parse('incoming', original)
	local MessageID = ActionMessagePacket["Message"]
	local MessageTargetID = ActionMessagePacket["Target"]
	local MessageTargetIndex = ActionMessagePacket["Target Index"]

	-- 249 is "${target}'s strength is impossible to gauge!"
	if MessageID == 249 then
		CheckResultReceived(MessageTargetID)
		if not GetLocatedITG() then
			SetLocatedITG(MessageTargetID)
		end

	-- 170 through 178 are the messages corresponding to difficulty checks for non NMs.
	elseif MessageID >= 170 and MessageID <= 178 then
		CheckResultReceived(MessageTargetID)
		return true
	end
end