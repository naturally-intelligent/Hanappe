----------------------------------------------------------------------------------------------------
-- This is a class to manage the Theme.
-- Please get an instance from the widget module.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.EventDispatcher.html">EventDispatcher</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local EventDispatcher = require "flower.EventDispatcher"
local UIEvent = require "flower.widget.UIEvent"

-- class
local ThemeMgr = class(EventDispatcher)

-- variables
local INSTANCE = nil

---
-- Return the singlton object.
function ThemeMgr.getInstance()
    if not INSTANCE then
        INSTANCE = ThemeMgr()
    end
    return INSTANCE
end

---
-- Constructor.
function ThemeMgr:init()
    assert(INSTANCE == null)

    ThemeMgr.__super.init(self)
    self.theme = require "flower.widget.BaseTheme"
end

---
-- Set the theme of widget.
-- @param theme theme of widget
function ThemeMgr:setTheme(theme)
    if self.theme ~= theme then
        self.theme = theme
        self:dispatchEvent(UIEvent.THEME_CHANGED)
    end
end

---
-- override the theme of widget.
-- @param theme theme of widget
function ThemeMgr:overrideTheme(theme)
    local newTheme = {}
    local copyTheme = function(srcTheme)
        for k, v in pairs(srcTheme) do
            if newTheme[k] ~= nil then
                local style = newTheme[k]
                for k2, v2 in pairs(v) do
                    style[k2] = v2
                end
            else
                newTheme[k] = table.copy(v)
            end
        end
    end

    copyTheme(self.theme)
    copyTheme(theme)

    self:setTheme(newTheme)
end

---
-- Return the theme of widget.
-- @return theme
function ThemeMgr:getTheme()
    return self.theme
end

return ThemeMgr