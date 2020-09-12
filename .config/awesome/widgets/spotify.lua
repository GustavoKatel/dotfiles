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
    local cur_album_art = ''

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

            album_art_url = metadata["artUrl"]:gsub("open.spotify.com", "i.scdn.co")
            awful.spawn.easy_async("/home/gustavokatel/Projects/cached_web_file.sh /tmp/album_art_ "..album_art_url, function(stdout, stderr, exitreason, exitcode)
                cur_album_art = string.match(stdout, "(.*)\n")
            end)

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


        -- local spotify_tooltip = awful.tooltip {
        --     mode = 'outside',
        --     preferred_positions = {'bottom'},
        -- }

        -- spotify_tooltip:add_to_object(spotify_widget)

        -- spotify_widget:connect_signal('mouse::enter', function()
        --     spotify_tooltip.markup = '<b>Album</b>: ' .. cur_album
        --         .. '\n<b>Artist</b>: ' .. cur_artist
        --         .. '\n<b>Song</b>: ' .. cur_title
        -- end)

    local popup_title_widget = wibox.widget{ text =  '🎵', font = font, widget = wibox.widget.textbox}
    local popup_artist_widget = wibox.widget{ text =  '🎤', font = font, widget = wibox.widget.textbox}
    local popup_album_widget = wibox.widget{ text =  '💿', font = font, widget = wibox.widget.textbox}
    local popup_album_art_widget = wibox.widget {
        image  = "",
        resize = false,
        widget = wibox.widget.imagebox
    }
    spotify_widget.spotify_popup = awful.popup {
        widget = {
            {
                popup_title_widget,
                popup_artist_widget,
                popup_album_widget,
                popup_album_art_widget,
                layout = wibox.layout.fixed.vertical,
            },
            margins = 10,
            widget  = wibox.container.margin
        },
        border_color = '#324A40',
        border_width = 5,
        visible      = false,
        ontop = true,
    }

    spotify_widget:connect_signal("mouse::enter", function()
        popup_title_widget.text = '🎵 ' .. cur_title
        popup_artist_widget.text = '🎤 ' .. cur_artist
        popup_album_widget.text = '💿 ' .. cur_album
        popup_album_art_widget.image = cur_album_art
        spotify_widget.spotify_popup:move_next_to(mouse.current_widget_geometry)
        spotify_widget.spotify_popup.visible = true
    end)
    spotify_widget:connect_signal("mouse::leave", function()
        spotify_widget.spotify_popup.visible = false
    end)

    return spotify_widget

end

return setmetatable(spotify_widget, { __call = function(_, ...)
    return worker(...)
end })