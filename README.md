# LimbusLooker

Example Notifications [ITG](https://i.imgur.com/kBvWFZW.png) [???](https://i.imgur.com/MJJ9DhQ.png)

## How To
1. Download limbuslooker.lua, settings.lua and each folder. limbuslooker.lua and the folders can be found in the zip file under [Releases](https://github.com/darkewaffle/LimbusLooker/releases). You only need to download the settings file if you do not already have one - although it could change over time if new settings are supported.
2. Place them in Windower\addons\limbuslooker.
3. Modify settings.lua to your liking.
3b. If you are so inclined you can overwrite the "notification.wav" file in the media folder so that your own custom sound file plays when a ??? or ITG enemy is detected.
4. "lua l limbuslooker" in game to initialize the addon.
5. Run around Limbus and it'll let you know when you are near to a ??? or "Impossible to Gauge" enemy that could spawn a ???.

## Description
LimbusLooker is an addon that will monitor incoming packets in Limbus to alert the player when a ??? is nearby. It will also send packets to /check every regular Apollyon or Temenos enemy to search for the "Impossible to Gauge" roaming NM. When the ??? or ITG enemy is found it will play a notification sound and create a text display on screen informing you of the distance, direction and enemy type. Additionally when an ITG enemy is detected the name of that enemy will be changed to "!! ITG !!" so that it stands out from other enemies that would otherwise have the same name or model.

LimbusLooker does inject packets. It is necessary to perform the /check commands. However it tries to do so responsibly by creating a queue of enemy IDs to check from incoming packets and then processing it in small batches on a delay. By default it will attempt to check 5 enemies every 2 seconds. It will only check normal Apollyon and Temenos mobs and it will only do so once for each ID unless that enemy dies, goes out of range or the ITG enemy is killed (which causes all /check results to be reset). Check results are also reset when you change floors.

Lastly all packet operations are only active in Limbus zones unless you input the 'll start' command outside of Limbus. You should have no reason to do this, LimbusLooker will start and stop those processes automatically when you enter or exit Limbus as long as the addon is loaded.

## Commands
| Command | Usage |
| --- | --- |
| ll start | Manually starts the scanning process. This is only necessary if you have manually stopped the scan or if you have reloaded LimbusLooker while inside of Limbus. |
| ll stop | Manually stops the scanning process. |
| ll show | Toggles the display of chat messages to indicate when a /check batch is started and when the commands are sent. |


## Note for Battlemod Users
LimbusLooker will block incoming /check results while in Limbus so that they do not spam your chat log. However if you use the BattleMod addon you may still receive these messages. In order to change this you will have to alter BattleMod. There are probably multiple ways to handle this but the simplest solution I found was to change line 488 in battlemod.lua from
```
	windower.add_to_chat(color,outstr)
```

to

```
	if am.message_id < 170 or am.message_id > 178 then
		windower.add_to_chat(color,outstr)
	end
```

/check messages all have a message ID between 170 and 178. So this essentially says "if the message is not a /check message then put it in the chat log". However this will affect /check messages at all times and in all zones, not just while in Limbus.

- - - - -

Bike Bell sound effect used for notifications by OTBTechno -- https://freesound.org/s/152595/ -- License: Attribution 3.0