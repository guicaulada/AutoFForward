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

-- Alter server-side AutoFForward enabled state.
--
-- Client => AFF_ToggleEnabledStateEvent -> Server => broadcast AFF_SetEnabledStateEvent

---@class AFF_ToggleEnabledStateEvent
AFF_ToggleEnabledStateEvent = {}

local AFF_ToggleEnabledStateEvent_mt = Class(AFF_ToggleEnabledStateEvent, Event)

InitEventClass(AFF_ToggleEnabledStateEvent, 'AFF_ToggleEnabledStateEvent')

function AFF_ToggleEnabledStateEvent.emptyNew()
    return Event.new(AFF_ToggleEnabledStateEvent_mt)
end

function AFF_ToggleEnabledStateEvent.new()
    return AFF_ToggleEnabledStateEvent.emptyNew()
end

---@param streamId number
---@param connection Connection
function AFF_ToggleEnabledStateEvent:readStream(streamId, connection)
    self:run(connection)
end

---@param streamId number
---@param connection Connection
function AFF_ToggleEnabledStateEvent:writeStream(streamId, connection)
end

---@param connection Connection
function AFF_ToggleEnabledStateEvent:run(connection)
    -- Only process event on server-side
    if not connection:getIsServer() then
        local user = g_currentMission.userManager:getUserByConnection(connection)

        if user == nil then
            print('unknown user')
            return
        end

        -- Limit state altering to master user(s) (admin)
        if user:getIsMasterUser() then
            AutoFForward.enabled = not AutoFForward.enabled
            AutoFForward.broadcastEnabledState()
            AutoFForward.updateTimeScale()
        end
    end
end
