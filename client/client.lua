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

-- Defines client-side variables.
local defaultFontSize = 0.014
local defaultLineHeight = getTextHeight(defaultFontSize, '|')
local defaultTextColor = {1, 1, 1, 1}
local defaultTextShadowColor = {0, 0, 0, .5}

----------------------------------------------------------------

-- Request data from server

AutoFForward.getDisplayState = function()
    g_client:getServerConnection():sendEvent(AFF_GetDisplayStateEvent:new())
end

AutoFForward.toggleUserState = function()
    g_client:getServerConnection():sendEvent(AFF_ToggleUserStateEvent:new())
end

AutoFForward.toggleEnabledState = function()
    g_client:getServerConnection():sendEvent(AFF_ToggleEnabledStateEvent:new())
end

AutoFForward.decreaseFastSpeed = function()
    g_client:getServerConnection():sendEvent(AFF_DecreaseFastSpeedEvent:new())
end

AutoFForward.decreaseSlowSpeed = function()
    g_client:getServerConnection():sendEvent(AFF_DecreaseSlowSpeedEvent:new())
end

AutoFForward.increaseFastSpeed = function()
    g_client:getServerConnection():sendEvent(AFF_IncreaseFastSpeedEvent:new())
end

AutoFForward.increaseSlowSpeed = function()
    g_client:getServerConnection():sendEvent(AFF_IncreaseSlowSpeedEvent:new())
end

----------------------------------------------------------------

-- Client-side only functions

---@param unicode
---@param sym
---@param modifier
---@param isDown
function AutoFForward:keyEvent(unicode, sym, modifier, isDown)
    local modShift = (modifier == 4097.0 or modifier == 4098.0)
    local modCtrl = (modifier == 4160.0 or modifier == 4224.0)
    local modAlt = (modifier == 4352.0 or modifier == 4608.0)

    if not isDown then
        return
    end

    -- Easy way to check if we're in the placement screen or not
    if g_currentMission.placementController.camera.isActive == true then
        return
    end

    if sym == Input.KEY_slash and not modAlt then
        self.toggleUserState()
    elseif sym == Input.KEY_slash and modAlt then
        self.toggleEnabledState()
    elseif sym == Input.KEY_period and modShift then
        self.increaseFastSpeed()
    elseif sym == Input.KEY_period and modCtrl then
        self.increaseSlowSpeed()
    elseif sym == Input.KEY_comma and modShift then
        self.decreaseFastSpeed()
    elseif sym == Input.KEY_comma and modCtrl then
        self.decreaseSlowSpeed()
    end
end

-- Renders text with shadow
function renderTextWithShadow(x, y, text, textColor, shadowColor, align)
    if align ~= nil then
        setTextAlignment(align)
    else
        setTextAlignment(RenderText.ALIGN_LEFT)
    end

    setTextColor(unpack(shadowColor or defaultTextShadowColor))
    renderText(x + defaultLineHeight * 0.025, y - defaultLineHeight * 0.025, defaultFontSize, text)
    setTextColor(unpack(textColor or defaultTextColor))
    renderText(x, y, defaultFontSize, text)
end

function YesOrNo(v)
    if v then return 'YES' else return 'NO' end
end

-- Draw user list
function AutoFForward:draw()
    if AutoFForward.enabled then
        y = .23
        for k,v in pairs(AutoFForward.users) do
            renderTextWithShadow(.175, y, ('[%s] %s'):format(YesOrNo(v), k))
            y = y - .02
        end
    end
end
