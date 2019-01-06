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

-- Decrease server-side AutoFForward fast speed.
--
-- Client => AFF_DecreaseFastSpeedEvent -> Server => broadcast AFF_SetFastSpeedEvent

---@class AFF_DecreaseFastSpeedEvent
AFF_DecreaseFastSpeedEvent = {}

local AFF_DecreaseFastSpeedEvent_mt = Class(AFF_DecreaseFastSpeedEvent, Event)

InitEventClass(AFF_DecreaseFastSpeedEvent, 'AFF_DecreaseFastSpeedEvent')

function AFF_DecreaseFastSpeedEvent:emptyNew()
    return Event:new(AFF_DecreaseFastSpeedEvent_mt)
end

function AFF_DecreaseFastSpeedEvent:new()
    return AFF_DecreaseFastSpeedEvent:emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_DecreaseFastSpeedEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_DecreaseFastSpeedEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_DecreaseFastSpeedEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        -- Limit state altering to master user(s) (admin)
        if user:getIsMasterUser() then
            AutoFForward.decreaseFastSpeed()
        end
    end
end
