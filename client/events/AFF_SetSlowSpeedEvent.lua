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

-- Set client-side slowSpeed display variable.
--
-- Server => AFF_SetSlowSpeedEvent

---@class AFF_SetSlowSpeedEvent
AFF_SetSlowSpeedEvent = {}

local AFF_SetSlowSpeedEvent_mt = Class(AFF_SetSlowSpeedEvent, Event)

InitEventClass(AFF_SetSlowSpeedEvent, 'AFF_SetSlowSpeedEvent')

function AFF_SetSlowSpeedEvent:emptyNew()
    return Event:new(AFF_SetSlowSpeedEvent_mt)
end

---@param slowSpeed boolean
function AFF_SetSlowSpeedEvent:new(slowSpeed)
    local self = AFF_SetSlowSpeedEvent:emptyNew()
    self.slowSpeed = slowSpeed
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetSlowSpeedEvent:readStream(streamId, connection)
    self.slowSpeed = streamReadInt(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetSlowSpeedEvent:writeStream(streamId, connection)
    streamWriteInt(streamId, self.slowSpeed)
end

---@param connection Connection
function AFF_SetSlowSpeedEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.slowSpeed = self.slowSpeed
    end
end
