function RenameNPC(TargetID, TargetName)
	windower.set_mob_name(TargetID, TargetName)
end

function RenameITG(TargetID)
	RenameNPC(TargetID, "       !! ITG !!       ")
end