-------------------------------------------------
-- Logout widget V2 for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-widget

-- @author Pavel Makhov & Gustavo Sampaio
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local capi = {keygrabber = keygrabber }
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awesomebuttons = require("awesome-buttons.awesome-buttons")


local HOME_DIR = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/awesome-wm-widgets/experiments/logout-widget'


local w = wibox {
    bg = beautiful.fg_normal,
    max_widget_size = 500,
    ontop = true,
    height = 200,
    width = 400,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    border_color = '#324A40',
    border_width = 5,
}

local action = wibox.widget {
    text = ' ',
    widget = wibox.widget.textbox
}


local function create_button(icon_name, action_name, color, onclick)

    local button = awesomebuttons.with_icon{ type = 'flat', icon = icon_name, color = color, onclick = onclick }
    button:connect_signal("mouse::enter", function(c) action.markup = '<span color="'.. action.text_color .. '">'..action_name..'</span>' end)
    button:connect_signal("mouse::leave", function(c) action:set_text(' ') end)
    return button
end

local function launch(args)

    local args = args or {}

    local bg_color = args.bg_color or beautiful.logout_bg_color or beautiful.bg_normal
    local accent_color = args.accent_color or beautiful.logout_accent_color or beautiful.bg_focus
    local text_color = args.text_color or beautiful.logout_text_color or beautiful.fg_normal
    local border_width = args.border_width or beautiful.logout_border_width or beautiful.border_width
    local border_color = args.border_color or beautiful.logout_border_color or beautiful.border_color
    local phrases = args.phrases or {'Goodbye!'}

    local onlogout = args.onlogout or function () awesome.quit() end
    local onlock = args.onlock or function() awful.spawn.with_shell("gnome-screensaver-command -l") end
    local onreboot = args.onreboot or function() awful.spawn.with_shell("systemctl reboot") end
    local onsuspend = args.onsuspend or function() awful.spawn.with_shell("systemctl suspend") end
    local onpoweroff = args.onpoweroff or function() awful.spawn.with_shell("systemctl poweroff") end

    w:set_bg(bg_color)
    w.border_width = border_width
    w.border_color = border_width

    local phrase_widget = wibox.widget{
        markup = '<span color="'.. text_color .. '" size="20000">' .. phrases[ math.random( #phrases ) ] .. '</span>',
        align  = 'center',
        widget = wibox.widget.textbox
    }
    action.text_color = text_color

    local stop_func = function()
        phrase_widget:set_text('')
        capi.keygrabber.stop()
        w.visible = false
    end

    local create_button_callback = function(cb)
        return function()
            cb()
            stop_func()
        end
    end

    w:setup {
        {
            phrase_widget,
            {
                {
                    create_button('log-out', 'Log Out', accent_color, create_button_callback(onlogout)),
                    create_button('lock', 'Lock', accent_color, create_button_callback(onlock)),
                    create_button('refresh-cw', 'Reboot', accent_color, create_button_callback(onreboot)),
                    create_button('moon', 'Suspend', accent_color, create_button_callback(onsuspend)),
                    create_button('power', 'Power Off', accent_color, create_button_callback(onpoweroff)),
                    id = 'buttons',
                    spacing = 8,
                    layout = wibox.layout.fixed.horizontal
                },
                valigh = 'center',
                layout = wibox.container.place
            },
            {
                action,
                haligh = 'center',
                layout = wibox.container.place
            },
            spacing = 32,
            layout = wibox.layout.fixed.vertical
        },
        id = 'a',
        shape_border_width = 1,
        valigh = 'center',
        layout = wibox.container.place
    }

    w.visible = true

    awful.placement.centered(w)
    capi.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key then
            stop_func()
        end
    end)
end

local function widget(args)
    local icon = args.icon or WIDGET_DIR .. '/power.svg'

    local res = wibox.widget {
        {
            {
                image = icon,
                widget = wibox.widget.imagebox
            },
            margins = 4,
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal,
    }

    res:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                launch(args)
            end)
        ))

    return res

end

return {
    launch = launch,
    widget = widget
}
