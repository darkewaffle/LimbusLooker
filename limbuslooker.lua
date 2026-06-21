_addon.name = "LimbusLooker"
_addon.version = "0.9.0"
_addon.author = "darkwaffle"
_addon.command = "LL"

WINDOWER_PACKETS = require "packets"
WINDOWER_RESOURCES = require "resources"
WINDOWER_TEXTS = require "texts"
require "bit"
require "pack"

require "libraries/get_character"
require "libraries/play_notification"
require "libraries/rename_npc"
require "libraries/table_move"

require "chunks/chunk_ActionMessage"
require "chunks/chunk_DialogChoice"
require "chunks/chunk_NPCSpawn"
require "chunks/chunk_NPCUpdate"
require "data/data_tracking"
require "ui/display"

PLAYER_SETTINGS = require "settings"

local InLimbus = false
local RegisteredEventIDs = {}

local RenderInterval = .25
local LastRenderUpdate = 0

-- ChunkInEventID is a global managed in OnZone to track if OnChunkIn event is currently registered or not
-- ChunkOutEventID is a global managed in OnZone to track if OnChunkIn event is currently registered or not
-- PrerenderEventID is a global managed in OnZone to track if OnRender event is currently registered or not

function OnLoad()
	table.insert(RegisteredEventIDs, windower.register_event('zone change', OnZone))
	table.insert(RegisteredEventIDs, windower.register_event('unload', OnUnload))
	table.insert(RegisteredEventIDs, windower.register_event('addon command', OnCommand))
	CreateDisplay(false)
end

function OnZone(new_id, old_id)
	if WINDOWER_RESOURCES.zones[new_id].en == "Apollyon" or WINDOWER_RESOURCES.zones[new_id].en == "Temenos" then
		InLimbus = true
	else
		InLimbus = false
	end

	if InLimbus then
		HandleTransientEvents("start")
	end
end

function OnChunkIn(id, original, modified, injected, blocked)
	
	-- NPC status update
	if id == 0x00E then
		return ParseNPCUpdate(id, original, modified, injected, blocked)

	-- Action message
	elseif id == 0x029 then
		return ParseActionMessage(id, original, modified, injected, blocked)

	-- NPC spawn
	elseif id == 0x05B then
		ParseNPCSpawn(id, original, modified, injected, blocked)

	-- Repositioning (player changed floor in Limbus)
	elseif id == 0x065 then
		HideDisplay()
		ResetTrackedData()

	-- Zone change beginning
	elseif id == 0x00B then
		HideDisplay()
		ResetTrackedData()
		HandleTransientEvents("stop")
	end
end

function OnChunkOut(id, original, modified, injected, blocked)
	-- Player made a dialogue choice
	if id == 0x05B then
		ParseDialogChoice(id, original, modified, injected, blocked)
	end
end

function OnRender()
	local ITGID = GetLocatedITG()

	if ITGID then
		RenameITG(ITGID)
	end

	if os.clock() - LastRenderUpdate > RenderInterval then
		LastRenderUpdate = os.clock()
		if ITGID then
			SetDisplayITG()
		elseif GetLocatedQuestionMarkID() then
			SetDisplayQuestionMark()
		else
			HideDisplay()
		end
	end
end

function OnUnload()
	for _, ID in ipairs(RegisteredEventIDs) do
		windower.unregister_event(ID)
	end

	HandleTransientEvents("stop")
end

function OnCommand(...)
	local CommandParameters = {...}

	if CommandParameters[1] == "show" then
		ToggleShowScans()
	end

	if CommandParameters[1] == "start" then
		InLimbus = true
		HandleTransientEvents("start")
	end

	if CommandParameters[1] == "stop" then
		InLimbus = false
		HandleTransientEvents("stop")
	end
end

function HandleTransientEvents(Action)
	if Action == "start" then
		if not ChunkInEventID then
			ChunkInEventID = windower.register_event('incoming chunk', OnChunkIn)
		end

		if not ChunkOutEventID then
			ChunkOutEventID = windower.register_event('outgoing chunk', OnChunkOut)
		end

		if not PrerenderEventID then
			PrerenderEventID = windower.register_event('prerender', OnRender)
		end

	elseif Action == "stop" then
		if ChunkInEventID then
			windower.unregister_event(ChunkInEventID)
			ChunkInEventID = nil
		end

		if ChunkOutEventID then
			windower.unregister_event(ChunkOutEventID)
			ChunkOutEventID = nil
		end

		if PrerenderEventID then
			windower.unregister_event(PrerenderEventID)
			PrerenderEventID = nil
		end
	else
		print("Invalid action argument provided to HandleTransientEvents.")
	end
end

OnLoad()