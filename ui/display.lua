function GetDisplaySettings()

	local DisplaySettings = {}
	DisplaySettings.pos = {}
	DisplaySettings.bg = {}
	DisplaySettings.flags = {}
	DisplaySettings.text = {}
	DisplaySettings.text.fonts = {}
	DisplaySettings.text.stroke = {}

	DisplaySettings.pos.x = PLAYER_SETTINGS.pos.x or math.floor(windower.get_windower_settings().x_res * .44)
	DisplaySettings.pos.y = PLAYER_SETTINGS.pos.y or math.floor(windower.get_windower_settings().y_res * .1)


	DisplaySettings.bg.alpha   = PLAYER_SETTINGS.bg.alpha   or 128
	DisplaySettings.bg.red     = PLAYER_SETTINGS.bg.red     or 0
	DisplaySettings.bg.green   = PLAYER_SETTINGS.bg.green   or 0
	DisplaySettings.bg.blue    = PLAYER_SETTINGS.bg.blue    or 0
	DisplaySettings.bg.visible = PLAYER_SETTINGS.bg.visible or false

	if PLAYER_SETTINGS.flags.bold == false then
		DisplaySettings.flags.bold = false
	else
		DisplaySettings.flags.bold = true
	end

	DisplaySettings.flags.right     = PLAYER_SETTINGS.flags.right     or false
	DisplaySettings.flags.bottom    = PLAYER_SETTINGS.flags.bottom    or false
	DisplaySettings.flags.draggable = PLAYER_SETTINGS.flags.draggable or false
	DisplaySettings.flags.italic    = PLAYER_SETTINGS.flags.italic    or false

	DisplaySettings.padding = PLAYER_SETTINGS.padding or 0

	DisplaySettings.text.size  = PLAYER_SETTINGS.text.size  or 24
	DisplaySettings.text.font  = PLAYER_SETTINGS.text.font  or 'Consolas'
	DisplaySettings.text.alpha = PLAYER_SETTINGS.text.alpha or 204
	DisplaySettings.text.red   = PLAYER_SETTINGS.text.red   or 255
	DisplaySettings.text.green = PLAYER_SETTINGS.text.green or 255
	DisplaySettings.text.blue  = PLAYER_SETTINGS.text.blue  or 255

	DisplaySettings.text.stroke.width = PLAYER_SETTINGS.text.stroke.width or 3
	DisplaySettings.text.stroke.alpha = PLAYER_SETTINGS.text.stroke.alpha or 128
	DisplaySettings.text.stroke.red   = PLAYER_SETTINGS.text.stroke.red   or 0
	DisplaySettings.text.stroke.green = PLAYER_SETTINGS.text.stroke.green or 0
	DisplaySettings.text.stroke.blue  = PLAYER_SETTINGS.text.stroke.blue  or 0

	return DisplaySettings
end

function CreateDisplay(CreateVisible)
	local DisplaySettings = GetDisplaySettings()
	LLDisplay = WINDOWER_TEXTS.new("LL Display", DisplaySettings)
	LLDisplay:visible(CreateVisible)
end

function SetDisplayContent(NewText)
	LLDisplay:text(NewText)
end

function ShowDisplay()
	LLDisplay:visible(true)
end

function HideDisplay()
	LLDisplay:visible(false)
end

function SetDisplayITG()
	SetDisplayForMob(GetLocatedITG(), "ITG = " .. GetLocatedITGOriginalName())
end

function SetDisplayQuestionMark()
	if GetLocatedQuestionMarkHidden() then
		SetDisplayForMob(GetLocatedQuestionMarkID(), "??? (Inactive)")
	else
		SetDisplayForMob(GetLocatedQuestionMarkID(), "??? (Active)")
	end
end

function SetDisplayForMob(TargetID, DisplayLabel)
	local Mob = windower.ffxi.get_mob_by_id(TargetID)

	if Mob then
		local MobDistance = math.sqrt(Mob.distance)
		local CardinalDirection = "~" .. GetCharacterCardinalToMob(Mob)
		local DisplayBuffer = " "
		
		local Line1 = DisplayBuffer .. DisplayLabel .. DisplayBuffer
		local Line2 = DisplayBuffer .. string.format("%2s %.1f", CardinalDirection, MobDistance) .. DisplayBuffer
		
		local Line1Width = #Line1
		local Line2Width = #Line2
		local WidthDifference = math.abs(Line1Width - Line2Width)

		if math.abs(Line1Width - Line2Width) > 1 then
			local Padding = string.rep(DisplayBuffer, math.floor(WidthDifference / 2))
			
			if Line1Width > Line2Width then
				Line2 = Padding .. Line2 .. Padding
			else
				Line1 = Padding .. Line1 .. Padding
			end
		end

		LLDisplay:text(Line1 .. "\n" .. Line2)
		ShowDisplay()
	end
end