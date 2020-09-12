-------------------------------------------------
-- Spotify Widget for Awesome Window Manager
-- Shows currently playing song on Spotify for Linux client
-- More details could be found here:
-- https://github.com/GustavoKatel/dotfiles
-- Based on
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/spotify-widget

-- @author Pavel Makhov & Gustavo Sampaio
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local naughty = require("naughty")

local GET_CURRENT_METADATA_CMD = 'playerctl metadata'
local GET_CURRENT_STATUS_CMD = 'playerctl status'

local function ellipsize(text, length)
    return (text:len() > length and length > 0)
        and text:sub(0, length - 3) .. '...'
        or text
end

local spotify_widget = {}

local function worker(args)

    local args = args or {}

    local play_icon = args.play_icon or '    '
    local pause_icon = args.pause_icon or '    '
    local font = args.font or 'Hack Nerd Font Mono 9'
    local dim_when_paused = args.dim_when_paused == nil and false or args.dim_when_paused
    local dim_opacity = args.dim_opacity or 0.2
    local max_length = args.max_length or 50
    local show_tooltip = args.show_tooltip == nil and false or args.show_tooltip

    local cur_artist = ''
    local cur_title = ''
    local cur_album = ''

    spotify_widget = wibox.widget {
        {
            id = 'titlew',
            font = font,
            widget = wibox.widget.textbox
        },
        {
            id = "icon",
            widget = wibox.widget.textbox,
        },
        {
            id = 'artistw',
            font = font,
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
        set_status = function(self, is_playing)
            self.icon.text = (is_playing and play_icon or pause_icon)
            if dim_when_paused then
                self.icon.opacity = (is_playing and 1 or dim_opacity)

                self.titlew:set_opacity(is_playing and 1 or dim_opacity)
                self.titlew:emit_signal('widget::redraw_needed')

                self.artistw:set_opacity(is_playing and 1 or dim_opacity)
                self.artistw:emit_signal('widget::redraw_needed')
            end
        end,
        set_text = function(self, artist, song)
            local artist_to_display = ellipsize(artist, max_length)
            if self.artistw.text ~= artist_to_display then
                self.artistw.text = artist_to_display
            end
            local title_to_display = ellipsize(song, max_length)
            if self.titlew.text ~= title_to_display then
                self.titlew.text = title_to_display
            end
        end
    }

    local update_widget_icon = function(widget, stdout, _, _, _)
        stdout = string.gsub(stdout, "\n", "")
        widget:set_status(stdout == 'Playing' and true or false)
    end

    local update_widget_text = function(widget, stdout, _, _, _)
        if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
            widget:set_text('','')
            widget:set_visible(false)
            return
        end

        local metadata = {}
        for line in string.gmatch(stdout, "(.-)\n") do
            local key, value = string.match(line, ":(%w+)%s+(.*)")
            metadata[key] = value
        end

        if metadata["album"] ~= nil and metadata["title"] ~=nil and metadata["artist"] ~= nil then
            cur_artist = metadata["artist"]
            cur_title = metadata["title"]
            cur_album = metadata["album"]

            widget:set_text(metadata["artist"], metadata["title"])
            widget:set_visible(true)
        end
    end

    watch(GET_CURRENT_STATUS_CMD, 1, update_widget_icon, spotify_widget)
    watch(GET_CURRENT_METADATA_CMD, 1, update_widget_text, spotify_widget)

    spotify_widget.update = function()
        awful.spawn.easy_async(GET_CURRENT_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
            update_widget_icon(spotify_widget, stdout, stderr, exitreason, exitcode)
        end)
    end

    --- Adds mouse controls to the widget:
    --  - left click - play/pause
    --  - scroll up - play next song
    --  - scroll down - play previous song
    spotify_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 1) then
            awful.spawn("playerctl play-pause", false)      -- left click
        elseif (button == 4) then
            awful.spawn("playerctl next", false)  -- scroll up
        elseif (button == 5) then
            awful.spawn("playerctl previous", false)  -- scroll down
        end
        spotify_widget.update()
    end)


    if show_tooltip then
        local spotify_tooltip = awful.tooltip {
            mode = 'outside',
            preferred_positions = {'bottom'},
        }

        spotify_tooltip:add_to_object(spotify_widget)

        spotify_widget:connect_signal('mouse::enter', function()
            spotify_tooltip.markup = '<b>Album</b>: ' .. cur_album
                .. '\n<b>Artist</b>: ' .. cur_artist
                .. '\n<b>Song</b>: ' .. cur_title
        end)
    end

    return spotify_widget

end

return setmetatable(spotify_widget, { __call = function(_, ...)
    return worker(...)
end })