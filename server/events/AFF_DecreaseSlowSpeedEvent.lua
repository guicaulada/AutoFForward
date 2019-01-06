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

-- Decrease server-side AutoFForward slow speed.
--
-- Client => AFF_DecreaseSlowSpeedEvent -> Server => broadcast AFF_SetSlowSpeedEvent

---@class AFF_DecreaseSlowSpeedEvent
AFF_DecreaseSlowSpeedEvent = {}

local AFF_DecreaseSlowSpeedEvent_mt = Class(AFF_DecreaseSlowSpeedEvent, Event)

InitEventClass(AFF_DecreaseSlowSpeedEvent, 'AFF_DecreaseSlowSpeedEvent')

function AFF_DecreaseSlowSpeedEvent:emptyNew()
    return Event:new(AFF_DecreaseSlowSpeedEvent_mt)
end

function AFF_DecreaseSlowSpeedEvent:new()
    return AFF_DecreaseSlowSpeedEvent:emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_DecreaseSlowSpeedEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_DecreaseSlowSpeedEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_DecreaseSlowSpeedEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        -- Limit state altering to master user(s) (admin)
        if user:getIsMasterUser() then
            AutoFForward.decreaseSlowSpeed()
        end
    end
end
