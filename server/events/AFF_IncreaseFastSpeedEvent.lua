--[[
    AutoFForward - Automatically fast-forwards time when all users online agree.
    Copyright (C) 2019  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
]]

-- Increase server-side AutoFForward fast speed.
--
-- Client => AFF_IncreaseFastSpeedEvent -> Server => broadcast AFF_SetFastSpeedEvent

---@class AFF_IncreaseFastSpeedEvent
AFF_IncreaseFastSpeedEvent = {}

local AFF_IncreaseFastSpeedEvent_mt = Class(AFF_IncreaseFastSpeedEvent, Event)

InitEventClass(AFF_IncreaseFastSpeedEvent, 'AFF_IncreaseFastSpeedEvent')

function AFF_IncreaseFastSpeedEvent.emptyNew()
    return Event.new(AFF_IncreaseFastSpeedEvent_mt)
end

function AFF_IncreaseFastSpeedEvent.new()
    return AFF_IncreaseFastSpeedEvent.emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_IncreaseFastSpeedEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_IncreaseFastSpeedEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_IncreaseFastSpeedEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        -- Limit state altering to master user(s) (admin)
        if user:getIsMasterUser() then
            AutoFForward.increaseFastSpeed()
        end
    end
end
