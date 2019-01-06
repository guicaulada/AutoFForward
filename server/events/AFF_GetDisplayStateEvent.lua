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

-- Register user key state on server-side.
--
-- Client => AFF_GetDisplayStateEvent -> Server => AFF_SetDisplayStateEvent

---@class AFF_GetDisplayStateEvent
AFF_GetDisplayStateEvent = {}

local AFF_GetDisplayStateEvent_mt = Class(AFF_GetDisplayStateEvent, Event)

InitEventClass(AFF_GetDisplayStateEvent, 'AFF_GetDisplayStateEvent')

function AFF_GetDisplayStateEvent:emptyNew()
    return Event:new(AFF_GetDisplayStateEvent_mt)
end

function AFF_GetDisplayStateEvent:new()
    return AFF_GetDisplayStateEvent:emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_GetDisplayStateEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_GetDisplayStateEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_GetDisplayStateEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        AutoFForward.setDisplayState(connection)
    end
end
