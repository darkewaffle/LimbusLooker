local LocatedQuestionMark = {["ID"] = 0, ["Hidden"] = false}

function SetLocatedQuestionMark(TargetID, Hidden)
	LocatedQuestionMark = {["ID"]=TargetID, ["Hidden"] = Hidden}
	SetDisplayQuestionMark()
	PlayNotification()
end

function GetLocatedQuestionMarkID()
	if LocatedQuestionMark["ID"] == 0 then
		return nil
	else
		return LocatedQuestionMark["ID"]
	end
end

function GetLocatedQuestionMarkHidden()
	if LocatedQuestionMark["Hidden"] == true then
		return true
	else
		return false
	end
end

function ResetLocatedQuestionMark()
	LocatedQuestionMark = {["ID"] = 0, ["Hidden"] = false}
end