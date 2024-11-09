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

-- Set client-side fastForward key variable.
--
-- Server => AFF_SetUserStateEvent

---@class AFF_SetUserStateEvent
AFF_SetUserStateEvent = {}

local AFF_SetUserStateEvent_mt = Class(AFF_SetUserStateEvent, Event)

InitEventClass(AFF_SetUserStateEvent, 'AFF_SetUserStateEvent')

function AFF_SetUserStateEvent.emptyNew()
    return Event.new(AFF_SetUserStateEvent_mt)
end

---@param fastForward boolean
function AFF_SetUserStateEvent.new(fastForward)
    local self = AFF_SetUserStateEvent.emptyNew()
    self.fastForward = fastForward
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetUserStateEvent:readStream(streamId, connection)
    self.fastForward = streamReadBool(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetUserStateEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.fastForward)
end

---@param connection Connection
function AFF_SetUserStateEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.fastForward = self.fastForward
    end
end
