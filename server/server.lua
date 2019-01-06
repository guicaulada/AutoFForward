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

-- Broadcast state to all clients

AutoFForward.broadcastEnabledState = function()
    local event = AFF_SetEnabledStateEvent:new(AutoFForward.enabled)
    g_server:broadcastEvent(event, true)
end

AutoFForward.broadcastUserList = function()
    local event = AFF_SetUserListEvent:new(json.stringify(AutoFForward.users))
    g_server:broadcastEvent(event, true)
end

AutoFForward.broadcastFastSpeed = function()
    local event = AFF_SetFastSpeedEvent:new(AutoFForward.fastSpeed)
    g_server:broadcastEvent(event, true)
end

AutoFForward.broadcastSlowSpeed = function()
    local event = AFF_SetSlowSpeedEvent:new(AutoFForward.slowSpeed)
    g_server:broadcastEvent(event, true)
end

AutoFForward.broadcastDisplayState = function()
    local event = AFF_SetDisplayStateEvent:new(AutoFForward.enabled, AutoFForward.fastSpeed, AutoFForward.slowSpeed, json.stringify(AutoFForward.users))
    g_server:broadcastEvent(event)
end

----------------------------------------------------------------

-- Set client-side variables.

---@param connection Connection
AutoFForward.setUserState = function(user)
    local event = AFF_SetUserStateEvent:new(AutoFForward.users[user:getNickname()])
    user:getConnection():sendEvent(event)
end

---@param connection Connection
AutoFForward.setEnabledState = function(connection)
    local event = AFF_SetEnabledStateEvent:new(AutoFForward.enabled)
    connection:sendEvent(event)
end

---@param connection Connection
AutoFForward.setUserList = function(connection)
    local event = AFF_SetUserListEvent:new(json.stringify(AutoFForward.users))
    connection:sendEvent(event)
end

---@param connection Connection
AutoFForward.setFastSpeed = function(connection)
    local event = AFF_SetFastSpeedEvent:new(AutoFForward.fastSpeed)
    connection:sendEvent(event)
end

---@param connection Connection
AutoFForward.setSlowSpeed = function(connection)
    local event = AFF_SetSlowSpeedEvent:new(AutoFForward.slowSpeed)
    connection:sendEvent(event)
end

---@param connection Connection
AutoFForward.setDisplayState = function(connection)
    local event = AFF_SetDisplayStateEvent:new(AutoFForward.enabled, AutoFForward.fastSpeed, AutoFForward.slowSpeed, json.stringify(AutoFForward.users))
    connection:sendEvent(event)
end

----------------------------------------------------------------

-- Server-side only functions

-- Load server-side hooks
function AutoFForward:loadMap()
    AutoFForward.loadDisplay() -- Client
    if g_server ~= nil then
        -- Server (SP,MP,dedicated)
        -- Load settings if found
        pcall(AutoFForward.loadFromXml)
        -- Append to onSaveComplete to save our own XML settings
        SavegameController.onSaveComplete = Utils.appendedFunction(SavegameController.onSaveComplete, AutoFForward.saveState)
        -- Handles when users join or leave
        Farm.onUserJoinGame = Utils.appendedFunction(Farm.onUserJoinGame, AutoFForward.updateUsers)
        Farm.onUserQuitGame = Utils.appendedFunction(AutoFForward.updateUser, Farm.onUserQuitGame)
    end
end

-- Update user list with online users
function AutoFForward.updateUsers()
    local users = {}
    local serverUsers = g_currentMission.userManager:getUsers()
    for _,user in pairs(serverUsers) do
        local nickname = user:getNickname()
        if nickname ~= 'Server' then
            if AutoFForward.users[nickname] == nil then
                AutoFForward.users[nickname] = false
            end
            users[nickname] = AutoFForward.users[nickname]
        end
    end
    AutoFForward.users = users
    AutoFForward.broadcastUserList()
end

-- Update time scale according to users states
function AutoFForward.updateTimeScale()
    fastForward = false
    if AutoFForward.enabled then
        for _,v in pairs(AutoFForward.users) do
            fastForward = v
            if not fastForward then
                break
            end
        end
    end

    if fastForward then
        g_currentMission:setTimeScale(AutoFForward.fastSpeed)
    else
        g_currentMission:setTimeScale(AutoFForward.slowSpeed)
    end
end

-- Decrease fast speed on server and broadcast to clients
function AutoFForward.decreaseFastSpeed()
    fastSpeed = AutoFForward.fastSpeed - 5
    if fastSpeed <= 0 then
        fastSpeed = 1
    end
    AutoFForward.fastSpeed = fastSpeed
    AutoFForward.broadcastFastSpeed()
    AutoFForward.updateTimeScale()
end

-- Decrease slow speed on server and broadcast to clients
function AutoFForward.decreaseSlowSpeed()
    slowSpeed = AutoFForward.slowSpeed - 5
    if slowSpeed <= 0 then
        slowSpeed = 1
    end
    AutoFForward.slowSpeed = slowSpeed
    AutoFForward.broadcastSlowSpeed()
    AutoFForward.updateTimeScale()
end

-- Increase fast speed on server and broadcast to clients
function AutoFForward.increaseFastSpeed()
    local fastSpeed
    if AutoFForward.fastSpeed == 1 then
        fastSpeed = 5
    else
        fastSpeed = AutoFForward.fastSpeed + 5
    end
    if fastSpeed > 150 then
        fastSpeed = 150
    end
    AutoFForward.fastSpeed = fastSpeed
    AutoFForward.broadcastFastSpeed()
    AutoFForward.updateTimeScale()
end

-- Increase slow speed on server and broadcast to clients
function AutoFForward.increaseSlowSpeed()
    local slowSpeed
    if AutoFForward.slowSpeed == 1 then
        slowSpeed = 5
    else
        slowSpeed = AutoFForward.slowSpeed + 5
    end
    if slowSpeed > 150 then
        slowSpeed = 150
    end
    AutoFForward.slowSpeed = slowSpeed
    AutoFForward.broadcastSlowSpeed()
    AutoFForward.updateTimeScale()
end

-- The game has now saved savegame data, so let's save our own XML file
function AutoFForward.saveState()
    pcall(AutoFForward.saveToXml)
end

-- Get XML file location (inside current savegame folder)
---@return string
function AutoFForward.getXmlFilePath()
    return g_currentMission.missionInfo.savegameDirectory .. '/AutoFForward.xml'
end

-- Load XML file state data (if it exists)
function AutoFForward.loadFromXml()
    -- Load XML file only if we're on the server-side (SP,MP,dedicated)
    if g_server ~= nil then
        local filePath = AutoFForward.getXmlFilePath()
        if not fileExists(filePath) then
            return
        end
        local xmlFile = loadXMLFile('AutoFForwardXml', filePath)
        if xmlFile ~= nil and xmlFile ~= 0 then
            local xmlKeyPath = 'AutoFForward'
            AutoFForward.enabled = Utils.getNoNil(getXMLBool(xmlFile, xmlKeyPath .. '.enabled'), true)
            AutoFForward.fastSpeed = Utils.getNoNil(getXMLInt(xmlFile, xmlKeyPath .. '.fastSpeed'), 30)
            AutoFForward.slowSpeed = Utils.getNoNil(getXMLInt(xmlFile, xmlKeyPath .. '.slowSpeed'), 1)
        end
        delete(xmlFile)
    end
end

-- Save current state data to XML file
function AutoFForward.saveToXml()
    -- Save XML file only if we're on the server-side (SP,MP,dedicated)
    if g_server ~= nil then
        local xmlFile = createXMLFile('AutoFForwardXml', AutoFForward.getXmlFilePath(), 'AutoFForward')
        if xmlFile ~= nil and xmlFile ~= 0 then
            local xmlKeyPath = 'AutoFForward'
            setXMLBool(xmlFile, xmlKeyPath .. '.enabled', AutoFForward.enabled)
            setXMLInt(xmlFile, xmlKeyPath .. '.fastSpeed', AutoFForward.fastSpeed)
            setXMLInt(xmlFile, xmlKeyPath .. '.slowSpeed', AutoFForward.slowSpeed)
            saveXMLFile(xmlFile)
        else
            print('Creating save state file failed .. : ' .. tostring(AutoFForward.getXmlFilePath()))
        end
    end
end
