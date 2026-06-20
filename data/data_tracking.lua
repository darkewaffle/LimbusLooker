local CheckQueue = {}
local CheckSent = {}
local CheckComplete = {}

local CheckInProgress = false
local ScheduledCheckCoroutine = 0
local LastCheckTimestamp = 0
local FloorChangeCheckStartDelay = 10
local CheckBatchDelay = 2
local CheckBatchSize = 5
local CheckSentStaleSeconds = 5

local LocatedITG = 0
local LocatedITGOriginalName = ""
local LocatedQuestionMark = 0

local ShowScans = false

function QueueForCheck(NPCID, NPCIndex)
	if not CheckSent[NPCID] and not CheckComplete[NPCID] then
		table.insert(CheckQueue, {["ID"] = NPCID, ["Index"] = NPCIndex})
	end
	InitiateCheck()
end

function InitiateCheck()
	local CurrentTimestamp = os.clock()
	local SecondsSinceLastCheck = CurrentTimestamp - LastCheckTimestamp

	if not CheckInProgress and #CheckQueue > 0 and SecondsSinceLastCheck > CheckBatchDelay then
		CheckInProgress = true
		RunCheck()
	end
end

function RunCheck()
	local NextBatch = {}
	local NextBatchSize = 0
	local Iterator = 0

	if ShowScans then
		windower.add_to_chat(1, "- - Batch Starting - -")
	end

	-- Search CheckQueue for IDs that have not been checked. Place them in NextBatch.
	-- End when NextBatch has CheckBatchSize number of entries or the Iterator has exhausted all entries in CheckQueue.
	repeat
		Iterator = Iterator + 1

		local NPCToQueue = CheckQueue[Iterator]
		local NPCID = NPCToQueue["ID"]
		local NPCIndex = NPCToQueue["Index"]

		if NPCToQueue and not NextBatch[NPCID] and not CheckSent[NPCID] and not CheckComplete[NPCID] then
			NextBatch[NPCID] = NPCIndex
			NextBatchSize = NextBatchSize + 1
		end

	until NextBatchSize == CheckBatchSize or Iterator == #CheckQueue

	-- Perform the /check operation on each entry in NextBatch.
	for ID, Index in pairs(NextBatch) do
		CheckTarget(ID, Index)
	end

	-- If the Iterator reached the size of CheckQueue then the entire queue has been processed.
	-- End the current check process.
	if Iterator == #CheckQueue then
		EndCheck()

	-- If the Iterator did not reach the size CheckQueue then the queue still has data to process.
	else
		-- Move the unchecked IDs, all those with an index > Iterator, to the start of the queue.
		CheckQueue = TableMove(CheckQueue, Iterator + 1, #CheckQueue, 1, CheckQueue)

		-- All indexes > Iterator have been shifted to the front of the queue starting at position 1.
		-- Therefore the last Iterator number of indexes are no longer needed and can be set to nil.
		-- For example if Iterator = 5 and #CheckQueue = 8 then indexes 6, 7 and 8 have been moved to indexes 1, 2 and 3.
		-- And all indexes >= 4 can be set to nil.
		for i = #CheckQueue - Iterator + 1, #CheckQueue do
			CheckQueue[i] = nil
		end

		-- Schedule the scan to run again since the queu still has data to process.
		ScheduledCheckCoroutine = coroutine.schedule(RunCheck, CheckBatchDelay)
	end

end

function EndCheck()
	ScheduledCheckCoroutine = 0
	CheckQueue = {}
	CheckInProgress = false
	LastCheckTimestamp = os.clock()
end

function CheckTarget(TargetID, TargetIndex)

	local CheckPacket = WINDOWER_PACKETS.new('outgoing', 0x0DD)
	CheckPacket["Target"] = TargetID
	CheckPacket["Target Index"] = TargetIndex
	WINDOWER_PACKETS.inject(CheckPacket)

	if ShowScans then
		windower.add_to_chat(1, "/check sent for Index=" .. TargetIndex)
	end

	CheckSent[TargetID] = {["Index"] = TargetIndex, ["TimeSent"] = os.clock()}
end

function CheckResultReceived(TargetID)
	CheckSent[TargetID] = nil
	CheckComplete[TargetID] = true
end

function ValidateSentChecks()
	local CurrentTime = os.clock()

	for NPCID, NPCData in pairs(CheckSent) do
		if CurrentTime - NPCData["TimeSent"] > CheckSentStaleSeconds then
			QueueForCheck(NPCID, NPCData["Index"])
			CheckSent[NPCID] = nil
		end
	end
end

function ResetIDCheckState(ResetID)
	-- If the ID of dead enemy matched the located ITG Limbus foe then reset data so that enemies will be re-checked
	if ResetID == LocatedITG then
		ResetTrackedData()
		return
	elseif ResetID == LocatedQuestionMark then
		ResetQuestionMark()
		return
	end

	for Index, NPCData in ipairs(CheckQueue) do
		if NPCData["ID"] == ResetID then
			table.remove(CheckQueue, Index)
		end
	end

	CheckSent[ResetID] = nil
	CheckComplete[ResetID] = nil
end

function ResetTrackedData()
	CheckQueue = {}
	CheckSent = {}
	CheckComplete = {}
	CheckInProgress = false
	LocatedITG = 0
	LocatedITGOriginalName = ""
	LocatedQuestionMark = 0

	if type(ScheduledCheckCoroutine) == "thread" then
		coroutine.close(ScheduledCheckCoroutine)
		ScheduledCheckCoroutine = 0
	end
end

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

function SetLocatedQuestionMark(TargetID)
	LocatedQuestionMark = TargetID
	SetDisplayQuestionMark()
	PlayNotification()
end

function GetLocatedQuestionMark()
	if LocatedQuestionMark == 0 then
		return nil
	else
		return LocatedQuestionMark
	end
end

function ResetQuestionMark()
	LocatedQuestionMark = 0
end

function DelayCheckStart(DelayAmount)
	LastCheckTimestamp = os.clock() + DelayAmount
end

function DelayCheckStartForFloorChange()
	DelayCheckStart(FloorChangeCheckStartDelay)
end

function ToggleShowScans()
	ShowScans = not ShowScans
end