local FloorChangeCheckStartDelay = 10
local CheckBatchDelay = 2
local PauseChecksUntil = 0
local StopChecks = false

function StartCheckLoop()
	StopChecks = false

	while GetInLimbus() do
		if StopChecks then
			break
		end

		if not GetChecksPaused() and GetCheckQueueHasData() then
			RunCheckBatch()
		end

		coroutine.sleep(CheckBatchDelay)
	end
end

function StopCheckLoop()
	StopChecks = true
end

function PauseChecks(PauseDuration)
	PauseChecksUntil = os.clock() + PauseDuration
end

function PauseChecksOnFloorChange()
	PauseChecks(FloorChangeCheckStartDelay)
end

function GetChecksPaused()
	if os.clock() < PauseChecksUntil then
		return true
	else
		return false
	end
end