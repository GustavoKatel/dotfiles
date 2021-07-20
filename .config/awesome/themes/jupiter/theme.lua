--[[

     Jupiter Awesome WM theme
     based on Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local naughty = require("naughty")
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi
local logout_widget = require("widgets/logout")
local spotify_widget = require("widgets/spotify")
local wclock_widget = require("widgets/wclock")
local ip_country_widget = require("widgets/ip_country")
local caffeine_widget = require("widgets/caffeine")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/jupiter"
theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Hack Nerd Font Mono 9"
theme.fg_normal                                 = "#ece7e0"
theme.fg_focus                                  = "#96ae94"
theme.fg_urgent                                 = "#916E5A"
theme.bg_normal                                 = "#0a110d"
theme.bg_focus                                  = "#0a110d"
theme.bg_urgent                                 = "#0a110d"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#324A40"
theme.border_marked                             = "#916E5A"
theme.tasklist_bg_focus                         = "#0a110d"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_font                               = "Hack Nerd Font Mono 14"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_cpu_font                          = "Hack Nerd Font Mono 9"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_weather                            = theme.dir .. "/icons/dish.png"
theme.widget_clock_icon_font                    = "Hack Nerd Font Mono 12"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.tasklist_disable_task_name                = true
theme.useless_gap                               = dpi(2)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.logout_border_width                           = dpi(2)
theme.logout_border_color                           = "#916E5A"
theme.logout_text_color                             = "#ece7e0"
theme.logout_accent_color                           = "#916E5A"
theme.logout_bg_color                                = "#0a110d"
theme.notification_icon_size                        = 90
theme.notification_width                             = 500
theme.notification_height                            = 100
theme.notification_border_width                     = dpi(0)
theme.notification_border_color                     = "#916E5A"

local markup = lain.util.markup

-- Textclock
local clockicon = wibox.widget{
    markup = '',
    align  = 'center',
    valign = 'center',
    font = theme.widget_clock_icon_font,
    widget = wibox.widget.textbox
}
local clock = wclock_widget({timezones = { "America/Los_Angeles", "Europe/London" }})

-- caffeine widget
theme.caffeine_widget = caffeine_widget({ font = theme.taglist_font })

-- Weather
local weathericon = wibox.widget.imagebox(theme.widget_weather)
theme.weather = lain.widget.weather({
    city_id = 3397277, -- placeholder (João Pessoa)
    notification_preset = { font = "Terminus 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, theme.fg_focus, "N/A "),
    showpopup = "off",
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, theme.fg_focus, " " .. descr .. " @ " .. units .. "°C "))
    end
})

-- ip country
theme.ip_country = ip_country_widget({ font = theme.font })

-- Spotify
local playericon = wibox.widget.imagebox(theme.widget_music)
playericon:buttons(my_table.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell("spotify") end),
    awful.button({ }, 1, function ()
        os.execute("playerctl previous")
        theme.spotify.update()
    end),
    awful.button({ }, 2, function ()
        os.execute("playerctl play-pause")
        theme.spotify.update()
    end),
    awful.button({ }, 3, function ()
        os.execute("playerctl next")
        theme.spotify.update()
    end)))
theme.spotify = spotify_widget({ dim_when_paused = false })

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        total_gb = mem_now.used / 1024
        total_gb_str = string.format("%.2f", total_gb)
        widget:set_markup(markup.font(theme.font, " " .. total_gb_str .. " GB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        padded_value = string.format("%2d", cpu_now.usage)
        widget:set_markup(markup.font(theme.widget_cpu_font, " " .. padded_value .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})

-- / fs
-- local fsicon = wibox.widget.imagebox(theme.widget_hdd)
local fsicon = wibox.widget{
    markup = ' ',
    align  = 'center',
    valign = 'center',
    font = theme.font,
    widget = wibox.widget.textbox
}
theme.fs = lain.widget.fs({
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = "Terminus 10" },
    showpopup = "off",
    settings = function()
        widget:set_markup(markup.font(theme.font, "  " .. fs_now["/"].percentage .. "% "))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(theme.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(theme.widget_battery_low)
            else
                baticon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            baticon:set_image(theme.widget_ac)
        end
    end
})

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})
theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     theme.volume.update()
                               end)
))

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    units = math.pow(1024,2),
    settings = function()
        widget:set_markup(markup.font(theme.font,
                          markup(theme.fg_focus, " " .. string.format("%06.1f", net_now.received))
                          .. " " ..
                          markup(theme.fg_normal, " " .. string.format("%06.1f", net_now.sent) .. " ")))
    end
})

-- logout widget
local logout_button = logout_widget.widget{ icon = theme.dir .. "/icons/power.svg" }


-- Separators
local spr = wibox.widget.textbox(' | ')
local spr_lambda = wibox.widget.textbox(' λ ')
local spr_space = wibox.widget.textbox(' ')

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[7])

    awful.layout.set(lain.layout.termfair.center, awful.screen.focused().tags[1])
    awful.layout.set(awful.layout.suit.floating, awful.screen.focused().tags[5])

    local big_master_tags = {[2] = true, [3] = true, [4] = true}
    local temp_tags = {7, 8, 9}

    -- update the tags 2, 3 and 4 to make sure they have a nice master width factor (mwfact)
    local update_big_master_factors = function(c)
        for k, v in pairs(big_master_tags) do
            local tag = awful.screen.focused().tags[k]

            local cls = tag:clients()

            local floating_count = 0
            for k, c in ipairs(cls) do
                if c.floating then
                    floating_count = floating_count + 1
                end
            end

            local total_non_floating = #cls - floating_count

            if total_non_floating == 1 then
                awful.tag.incmwfact(0.3, tag)
                big_master_tags[k] = false
            elseif big_master_tags[k] == false then
                awful.tag.incmwfact(-0.3, tag)
                big_master_tags[k] = true
            end
        end
    end

    update_big_master_factors()

    client.connect_signal("manage", update_big_master_factors)
    client.connect_signal("unmanage", update_big_master_factors)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal .. "55", fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            spr_lambda,
            s.mypromptbox,
            s.mytasklist,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            clockicon,
            spr_space,
            clock,
            spr_space,
            spr,
            spr_space,
            wibox.widget.systray(),
            spr_space,
            spr,
            playericon,
            theme.spotify,
            spr_space,
            spr_space,
            spr,
            volicon,
            theme.volume.widget,
            spr,
            theme.caffeine_widget,
            spr,
            --weathericon,
            --theme.weather.widget,
            --spr,
            memicon,
            mem.widget,
            spr,
            cpuicon,
            cpu.widget,
            spr,
            tempicon,
            temp.widget,
            spr,
            fsicon,
            theme.fs.widget,
            spr,
            baticon,
            bat.widget,
            spr,
            neticon,
            net.widget,
            spr,
            theme.ip_country,
            spr,
            s.mylayoutbox,
            spr,
            logout_button,
        },
    }
end

return theme
