local EnableSound = false
local NotificationPath = windower.addon_path .. "media/notification.wav"
local NotificationFile = io.open(NotificationPath)

if NotificationFile then
	EnableSound = true
	NotificationFile:close()
else
	EnableSound = false
end

function PlayNotification()
	if EnableSound then
		windower.play_sound(NotificationPath)
	end
end