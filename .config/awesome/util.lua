-- this is heavily based on https://github.com/lcpz/lain/blob/master/util/init.lua

local awful = require("awful")
local naughty = require("naughty")

local util = {}

function util.add_tag(args)
    local args = args or {}
    local layout = args.layout or awful.layout.suit.floating
    local fallback_name = args.fallback_name or "缾"
    local volatile = args.volatile == nil and true or args.volatile

    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(name)
            local name = name

            if not name or #name == 0 then
                name = fallback_name
            end

            if not name or #name == 0 then return end
            awful.tag.add(name, { screen = awful.screen.focused(), layout = layout, volatile = volatile }):view_only()
        end
    }
end

function util.delete_tag(args)
    local args = args or {}

    local index_ignore = args.index_ignore or {}

    local t = awful.screen.focused().selected_tag
    if not t then return end

    for k, v in ipairs(index_ignore) do
        if v == t.index then
            return
        end
    end

    t:delete()
end

function util.execute(args, cb)
    awful.spawn.easy_async_with_shell(
        args,
        function(out)
            if cb ~= nil then
                cb(out)
            end
        end
    )
end

return util