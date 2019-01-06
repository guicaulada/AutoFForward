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

-- Set client-side enabled display variable.
--
-- Server => AFF_SetEnabledStateEvent

---@class AFF_SetEnabledStateEvent
AFF_SetEnabledStateEvent = {}

local AFF_SetEnabledStateEvent_mt = Class(AFF_SetEnabledStateEvent, Event)

InitEventClass(AFF_SetEnabledStateEvent, 'AFF_SetEnabledStateEvent')

function AFF_SetEnabledStateEvent:emptyNew()
    return Event:new(AFF_SetEnabledStateEvent_mt)
end

---@param enabled boolean
function AFF_SetEnabledStateEvent:new(enabled)
    local self = AFF_SetEnabledStateEvent:emptyNew()
    self.enabled = enabled
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetEnabledStateEvent:readStream(streamId, connection)
    self.enabled = streamReadBool(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetEnabledStateEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.enabled)
end

---@param connection Connection
function AFF_SetEnabledStateEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.enabled = self.enabled
    end
end
