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

-- Alter user state on server-side.
--
-- Client => AFF_ToggleUserStateEvent -> Server => AFF_SetUserStateEvent, broadcast AFF_SetUserListEvent

---@class AFF_ToggleUserStateEvent
AFF_ToggleUserStateEvent = {}

local AFF_ToggleUserStateEvent_mt = Class(AFF_ToggleUserStateEvent, Event)

InitEventClass(AFF_ToggleUserStateEvent, 'AFF_ToggleUserStateEvent')

function AFF_ToggleUserStateEvent:emptyNew()
    return Event:new(AFF_ToggleUserStateEvent_mt)
end

function AFF_ToggleUserStateEvent:new()
    return AFF_ToggleUserStateEvent:emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_ToggleUserStateEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_ToggleUserStateEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_ToggleUserStateEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        AutoFForward.users[user:getNickname()] = not AutoFForward.users[user:getNickname()]
        AutoFForward.setUserState(user)
        AutoFForward.broadcastUserList()
        AutoFForward.updateTimeScale()
    end
end
