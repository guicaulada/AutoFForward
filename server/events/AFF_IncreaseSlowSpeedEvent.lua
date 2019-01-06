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

-- Increase server-side AutoFForward slow speed.
--
-- Client => AFF_IncreaseSlowSpeedEvent -> Server => broadcast AFF_SetSlowSpeedEvent

---@class AFF_IncreaseSlowSpeedEvent
AFF_IncreaseSlowSpeedEvent = {}

local AFF_IncreaseSlowSpeedEvent_mt = Class(AFF_IncreaseSlowSpeedEvent, Event)

InitEventClass(AFF_IncreaseSlowSpeedEvent, 'AFF_IncreaseSlowSpeedEvent')

function AFF_IncreaseSlowSpeedEvent:emptyNew()
    return Event:new(AFF_IncreaseSlowSpeedEvent_mt)
end

function AFF_IncreaseSlowSpeedEvent:new()
    return AFF_IncreaseSlowSpeedEvent:emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_IncreaseSlowSpeedEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_IncreaseSlowSpeedEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_IncreaseSlowSpeedEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        -- Limit state altering to master user(s) (admin)
        if user:getIsMasterUser() then
            AutoFForward.increaseSlowSpeed()
        end
    end
end
