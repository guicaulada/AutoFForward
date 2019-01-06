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

-- Set client-side display variables.
--
-- Server => AFF_SetDisplayStateEvent

---@class AFF_SetDisplayStateEvent
AFF_SetDisplayStateEvent = {}

local AFF_SetDisplayStateEvent_mt = Class(AFF_SetDisplayStateEvent, Event)

InitEventClass(AFF_SetDisplayStateEvent, 'AFF_SetDisplayStateEvent')

function AFF_SetDisplayStateEvent:emptyNew()
    return Event:new(AFF_SetDisplayStateEvent_mt)
end

---@param enabled boolean
---@param fastSpeed boolean
---@param slowSpeed boolean
function AFF_SetDisplayStateEvent:new(enabled, fastSpeed, slowSpeed, users)
    local self = AFF_SetDisplayStateEvent:emptyNew()
    self.enabled = enabled
    self.fastSpeed = fastSpeed
    self.slowSpeed = slowSpeed
    self.users = users
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetDisplayStateEvent:readStream(streamId, connection)
    self.enabled = streamReadBool(streamId)
    self.fastSpeed = streamReadInt(streamId)
    self.slowSpeed = streamReadInt(streamId)
    self.users = streamReadTable(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetDisplayStateEvent:writeStream(streamId, connection)
    streamWriteBool(streamId, self.enabled)
    streamWriteInt(streamId, self.fastSpeed)
    streamWriteInt(streamId, self.slowSpeed)
    streamWriteTable(streamId, self.users)
end

---@param connection Connection
function AFF_SetDisplayStateEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.enabled = self.enabled
        AutoFForward.fastSpeed = self.fastSpeed
        AutoFForward.slowSpeed = self.slowSpeed
        AutoFForward.users = self.users
    end
end
