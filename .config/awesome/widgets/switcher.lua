-------------------------------------------------
-- window switcher widget for Awesome Window Manager
-- https://github.com/GustavoKatel/dotfiles

-- @author Gustavo Sampaio
-- @copyright 2020 Gustavo Sampaio
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local capi = {keygrabber = keygrabber }
local lain = require("lain")
local dpi   = require("beautiful.xresources").apply_dpi
local markup = lain.util.markup

local switcher = {}

local function worker(args)

    local args = args or {}

    local font = args.font or "Terminus 10"
    local fg =  args.fg or "#324A40"
    local bg =  args.bg or "#d1cfbd"
    local border_color = args.border_color or "#324A40"
    local border_width = args.border_width or 5

    switcher = awful.popup {
        widget = {
            awful.widget.tasklist {
                screen   = awful.screen.focused(),
                filter   = awful.widget.tasklist.filter.currenttags,
                buttons  = awful.util.tasklist_buttons,
                -- style    = {
                --     shape = gears.shape.rounded_rect,
                -- },
                layout   = {
                    spacing = 5,
                    layout = wibox.layout.grid.horizontal
                },
                widget_template = {
                    {
                        {
                            {
                                id     = 'clienticon',
                                widget = awful.widget.clienticon,
                            },
                            margins = 4,
                            widget  = wibox.container.margin,
                        },
                        widget = wibox.container.background,
                        bg = bg,
                    },
                    id              = 'background_role',
                    forced_width    = 48,
                    forced_height   = 48,
                    bg = bg,
                    widget          = wibox.container.background,
                    create_callback = function(self, c, index, objects) --luacheck: no unused
                        self:get_children_by_id('clienticon')[1].client = c
                    end,
                },
            },
            layout = wibox.container.place,
        },
        border_color = border_color,
        border_width = border_width,
        bg = bg,
        ontop        = true,
        placement    = awful.placement.centered,
        minimum_width = dpi(300),
        -- shape        = gears.shape.rounded_rect
        visible = true,
    }

    local stop_func = function()
        capi.keygrabber.stop()
        switcher.visible = false
    end

    capi.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key then
            stop_func()
        end
    end)

    return switcher

end

return setmetatable(switcher, { __call = function(_, ...)
    return worker(...)
end })