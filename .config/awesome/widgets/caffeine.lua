-------------------------------------------------
-- Caffeine Widget for Awesome Window Manager
-- Inhibits light-locker temporarly
-- More details could be found here:
-- https://github.com/GustavoKatel/dotfiles

-- @author Gustavo Sampaio
-- @copyright 2020 Gustavo Sampaio
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")

local INHIBIT_CMD = {"light-locker-command", "-i"}
local DISABLE_INHIBIT_CMD = {"killall", "light-locker-command"}
local CHECK_INHIBIT_CMD = [[ pidof light-locker-command ]]

local caffeine_widget = {}

local function worker(args)

    local args = args or {}

    local font = args.font or beautiful.font or "Hack Nerd Font Mono 15"

    local enabled_icon = args.active_icon or "  "
    local disabled_icon = args.active_icon or " ﯈ "

    caffeine_widget = wibox.widget{
        markup = '<span font="'.. font .. '">'.. disabled_icon ..'</span>',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    caffeine_widget.set_icon = function(enabled)
        local icon = disabled_icon
        if enabled then
            icon = enabled_icon
        end

        caffeine_widget.markup = '<span font="'.. font .. '">'.. icon ..'</span>'
    end

    caffeine_widget.toggle = function()
        caffeine_widget.check_state(function(enabled)
            cmd = INHIBIT_CMD
            if enabled then
                cmd = DISABLE_INHIBIT_CMD
            end

            caffeine_widget.set_icon(not enabled)

            awful.spawn.easy_async(
                cmd,
                function(out) caffeine_widget.check_state() end
            )
        end)
    end

    caffeine_widget.check_state = function(cb)
        awful.spawn.easy_async(
            CHECK_INHIBIT_CMD,
            function(out, err, reasone, code)
                local enabled = code == 0

                caffeine_widget.set_icon(enabled)

                if cb ~= nil then
                    cb(enabled)
                end
            end
        )
    end

    gears.timer {
        timeout   = 10,
        call_now  = true,
        autostart = true,
        callback  = function() caffeine_widget.check_state() end
    }

    --- Adds mouse controls to the widget:
    --  - left click - play/pause
    --  - scroll up - play next song
    --  - scroll down - play previous song
    caffeine_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 1) then
        elseif (button == 4) then
        elseif (button == 5) then
        end
        caffeine_widget.toggle()
    end)

    return caffeine_widget

end

return setmetatable(caffeine_widget, { __call = function(_, ...)
    return worker(...)
end })