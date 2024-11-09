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

-- Set client-side fastSpeed display variable.
--
-- Server => AFF_SetFastSpeedEvent

---@class AFF_SetFastSpeedEvent
AFF_SetFastSpeedEvent = {}

local AFF_SetFastSpeedEvent_mt = Class(AFF_SetFastSpeedEvent, Event)

InitEventClass(AFF_SetFastSpeedEvent, 'AFF_SetFastSpeedEvent')

function AFF_SetFastSpeedEvent.emptyNew()
    return Event.new(AFF_SetFastSpeedEvent_mt)
end

---@param fastSpeed boolean
function AFF_SetFastSpeedEvent.new(fastSpeed)
    local self = AFF_SetFastSpeedEvent.emptyNew()
    self.fastSpeed = fastSpeed
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetFastSpeedEvent:readStream(streamId, connection)
    self.fastSpeed = streamReadInt32(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetFastSpeedEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, self.fastSpeed)
end

---@param connection Connection
function AFF_SetFastSpeedEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.fastSpeed = self.fastSpeed
    end
end
