local PlayerSettings = {}

PlayerSettings.pos = {}
PlayerSettings.bg = {}
PlayerSettings.flags = {}
PlayerSettings.text = {}
PlayerSettings.text.fonts = {}
PlayerSettings.text.stroke = {}

PlayerSettings.pos.x = 500
PlayerSettings.pos.y = 500

PlayerSettings.bg.alpha   = 128
PlayerSettings.bg.red     = 0
PlayerSettings.bg.green   = 0
PlayerSettings.bg.blue    = 0
PlayerSettings.bg.visible = true

PlayerSettings.flags.right     = false
PlayerSettings.flags.bottom    = false
PlayerSettings.flags.bold      = true
PlayerSettings.flags.draggable = false
PlayerSettings.flags.italic    = false

PlayerSettings.padding = 3

PlayerSettings.text.size  = 20
PlayerSettings.text.font  = 'Consolas'
PlayerSettings.text.alpha = 255
PlayerSettings.text.red   = 255
PlayerSettings.text.green = 255
PlayerSettings.text.blue  = 255

PlayerSettings.text.stroke.width = 1
PlayerSettings.text.stroke.alpha = 255
PlayerSettings.text.stroke.red   = 0
PlayerSettings.text.stroke.green = 0
PlayerSettings.text.stroke.blue  = 0

return PlayerSettings