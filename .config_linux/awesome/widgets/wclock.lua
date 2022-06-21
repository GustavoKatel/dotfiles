-------------------------------------------------
-- wclock widget for Awesome Window Manager
-- Shows calender (lain - cal) and world clock
-- https://github.com/GustavoKatel/dotfiles

-- @author Gustavo Sampaio
-- @copyright 2020 Gustavo Sampaio
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local lain = require("lain")
local markup = lain.util.markup

local tconcat  = table.concat


local wclock = {}

local function worker(args)

    local args = args or {}

    local font = args.font or "Terminus 10"
    local font_timezone = args.font_timezone or "Terminus 10"
    local fg =  args.fg or "#DDDDFF"
    local bg =  args.bg or "#1A1A1A"
    local border_color = args.border_color or "#324A40"
    local border_width = args.border_width or 5
    local clock_format = args.clock_format or "%a %d %b %R"

    local timezones = args.timezones or {}

    function build_clock(timeout, timezone)
        local timeout = timeout or 30

        local timezone_text = " "
        local timezone_env = ""
        if timezone ~= nil then
            timezone_text = markup.font(font_timezone, " " .. timezone .. " 🌍 ")
            timezone_env = "TZ=':".. timezone .. "' "
        end


        return awful.widget.watch(
            "bash -c \"".. timezone_env .."date +'".. clock_format .. "'\"", timeout,
            function(widget, stdout)
                widget:set_markup(timezone_text .. markup.font(font, stdout))
            end
        )
    end

    wclock = build_clock(30)

    wclock.cal = lain.widget.cal({
        attach_to = {},
        notification_preset = {
            font = font,
            fg   = fg,
            bg   = bg
        }
    })

    local separator = wibox.widget {
        orientation = "horizontal",
        color = border_color,
        forced_width = 10,
        forced_height = 10,
        widget = wibox.widget.separator
    }

    local cal_text_widget = wibox.widget{ text =  '', font = "Monospace 10", widget = wibox.widget.textbox}
    local extra_clocks_text_widget = wibox.widget {
        layout = wibox.layout.fixed.vertical
    }

    for _, timezone in pairs(timezones) do
        c = build_clock(60, timezone)
        extra_clocks_text_widget:add(c, separator)
    end


    wclock.popup = awful.popup {
        widget = {
            {
                {
                    cal_text_widget,
                    layout = wibox.container.place,
                },
                separator,
                extra_clocks_text_widget,
                layout = wibox.layout.fixed.vertical,
            },
            margins = 10,
            widget  = wibox.container.margin
        },
        border_color = border_color,
        border_width = border_width,
        visible      = false,
        ontop = true,
    }

    wclock:connect_signal("mouse::enter", function()
        cal_text_widget.markup = tconcat(wclock.cal.build())
        wclock.popup:move_next_to(mouse.current_widget_geometry)
        wclock.popup.visible = true
    end)
    wclock:connect_signal("mouse::leave", function()
        wclock.popup.visible = false
    end)

    return wclock

end

return setmetatable(wclock, { __call = function(_, ...)
    return worker(...)
end })