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

-- Set client-side user list display variable.
--
-- Server => AFF_SetUserListEvent

---@class AFF_SetUserListEvent
AFF_SetUserListEvent = {}

local AFF_SetUserListEvent_mt = Class(AFF_SetUserListEvent, Event)

InitEventClass(AFF_SetUserListEvent, 'AFF_SetUserListEvent')

function AFF_SetUserListEvent:emptyNew()
    return Event:new(AFF_SetUserListEvent_mt)
end

---@param users boolean
function AFF_SetUserListEvent:new(users)
    local self = AFF_SetUserListEvent:emptyNew()
    self.users = users
    return self
end

---@param streamId number
---@param connection Connection
function AFF_SetUserListEvent:readStream(streamId, connection)
    self.users = streamReadTable(streamId)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_SetUserListEvent:writeStream(streamId, connection)
    streamWriteTable(streamId, self.users)
end

---@param connection Connection
function AFF_SetUserListEvent:run(connection)
    -- Only process event on client-side
    if connection:getIsServer() then
        AutoFForward.users = self.users
    end
end
