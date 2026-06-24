local LocatedITG = 0
local LocatedITGOriginalName = ""

function SetLocatedITG(TargetID)
	LocatedITG = TargetID
	LocatedITGOriginalName = windower.ffxi.get_mob_by_id(TargetID).name
	SetDisplayITG()
	PlayNotification()
end

function GetLocatedITG()
	if LocatedITG == 0 then
		return nil
	else
		return LocatedITG
	end
end

function GetLocatedITGOriginalName()
	return LocatedITGOriginalName
end

function ResetLocatedITG()
	LocatedITG = 0
	LocatedITGOriginalName = ""
end