function ParseActionMessage(id, original, modified, injected, blocked)
	local MessageTargetID = original:unpack("b32", 9)
	local MessageID = original:unpack("b16", 25)

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