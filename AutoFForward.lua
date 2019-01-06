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

-- Shared
AutoFForward = {
    enabled = true,
    fastForward = false,
    fastSpeed = 30,
    slowSpeed = 1,
    users = {}
}

-- Libraries
source(g_currentModDirectory .. 'lib/json.lua')

-- Client events
source(g_currentModDirectory .. 'client/events/AFF_SetDisplayStateEvent.lua')
source(g_currentModDirectory .. 'client/events/AFF_SetEnabledStateEvent.lua')
source(g_currentModDirectory .. 'client/events/AFF_SetFastSpeedEvent.lua')
source(g_currentModDirectory .. 'client/events/AFF_SetSlowSpeedEvent.lua')
source(g_currentModDirectory .. 'client/events/AFF_SetUserListEvent.lua')
source(g_currentModDirectory .. 'client/events/AFF_SetUserStateEvent.lua')

-- Server events
source(g_currentModDirectory .. 'server/events/AFF_DecreaseFastSpeedEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_DecreaseSlowSpeedEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_GetDisplayStateEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_IncreaseFastSpeedEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_IncreaseSlowSpeedEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_ToggleEnabledStateEvent.lua')
source(g_currentModDirectory .. 'server/events/AFF_ToggleUserStateEvent.lua')

-- Client
source(g_currentModDirectory .. 'client/client.lua')

-- Server
source(g_currentModDirectory .. 'server/server.lua')

addModEventListener(AutoFForward)
