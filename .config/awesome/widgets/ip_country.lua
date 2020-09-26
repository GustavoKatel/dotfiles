-------------------------------------------------
-- IP country Widget for Awesome Window Manager
-- Shows country for your current ip (ipv4 only for now)
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

local flags = {["AD"] = "🇦🇩",["AE"] = "🇦🇪",["AF"] = "🇦🇫",["AG"] = "🇦🇬",["AI"] = "🇦🇮",["AL"] = "🇦🇱",["AM"] = "🇦🇲",["AO"] = "🇦🇴",["AQ"] = "🇦🇶",["AR"] = "🇦🇷",["AS"] = "🇦🇸",["AT"] = "🇦🇹",["AU"] = "🇦🇺",["AW"] = "🇦🇼",["AX"] = "🇦🇽",["AZ"] = "🇦🇿",["BA"] = "🇧🇦",["BB"] = "🇧🇧",["BD"] = "🇧🇩",["BE"] = "🇧🇪",["BF"] = "🇧🇫",["BG"] = "🇧🇬",["BH"] = "🇧🇭",["BI"] = "🇧🇮",["BJ"] = "🇧🇯",["BL"] = "🇧🇱",["BM"] = "🇧🇲",["BN"] = "🇧🇳",["BO"] = "🇧🇴",["BQ"] = "🇧🇶",["BR"] = "🇧🇷",["BS"] = "🇧🇸",["BT"] = "🇧🇹",["BV"] = "🇧🇻",["BW"] = "🇧🇼",["BY"] = "🇧🇾",["BZ"] = "🇧🇿",["CA"] = "🇨🇦",["CC"] = "🇨🇨",["CD"] = "🇨🇩",["CF"] = "🇨🇫",["CG"] = "🇨🇬",["CH"] = "🇨🇭",["CI"] = "🇨🇮",["CK"] = "🇨🇰",["CL"] = "🇨🇱",["CM"] = "🇨🇲",["CN"] = "🇨🇳",["CO"] = "🇨🇴",["CR"] = "🇨🇷",["CU"] = "🇨🇺",["CV"] = "🇨🇻",["CW"] = "🇨🇼",["CX"] = "🇨🇽",["CY"] = "🇨🇾",["CZ"] = "🇨🇿",["DE"] = "🇩🇪",["DJ"] = "🇩🇯",["DK"] = "🇩🇰",["DM"] = "🇩🇲",["DO"] = "🇩🇴",["DZ"] = "🇩🇿",["EC"] = "🇪🇨",["EE"] = "🇪🇪",["EG"] = "🇪🇬",["EH"] = "🇪🇭",["ER"] = "🇪🇷",["ES"] = "🇪🇸",["ET"] = "🇪🇹",["FI"] = "🇫🇮",["FJ"] = "🇫🇯",["FK"] = "🇫🇰",["FM"] = "🇫🇲",["FO"] = "🇫🇴",["FR"] = "🇫🇷",["GA"] = "🇬🇦",["GB"] = "🇬🇧",["GD"] = "🇬🇩",["GE"] = "🇬🇪",["GF"] = "🇬🇫",["GG"] = "🇬🇬",["GH"] = "🇬🇭",["GI"] = "🇬🇮",["GL"] = "🇬🇱",["GM"] = "🇬🇲",["GN"] = "🇬🇳",["GP"] = "🇬🇵",["GQ"] = "🇬🇶",["GR"] = "🇬🇷",["GS"] = "🇬🇸",["GT"] = "🇬🇹",["GU"] = "🇬🇺",["GW"] = "🇬🇼",["GY"] = "🇬🇾",["HK"] = "🇭🇰",["HM"] = "🇭🇲",["HN"] = "🇭🇳",["HR"] = "🇭🇷",["HT"] = "🇭🇹",["HU"] = "🇭🇺",["ID"] = "🇮🇩",["IE"] = "🇮🇪",["IL"] = "🇮🇱",["IM"] = "🇮🇲",["IN"] = "🇮🇳",["IO"] = "🇮🇴",["IQ"] = "🇮🇶",["IR"] = "🇮🇷",["IS"] = "🇮🇸",["IT"] = "🇮🇹",["JE"] = "🇯🇪",["JM"] = "🇯🇲",["JO"] = "🇯🇴",["JP"] = "🇯🇵",["KE"] = "🇰🇪",["KG"] = "🇰🇬",["KH"] = "🇰🇭",["KI"] = "🇰🇮",["KM"] = "🇰🇲",["KN"] = "🇰🇳",["KP"] = "🇰🇵",["KR"] = "🇰🇷",["KW"] = "🇰🇼",["KY"] = "🇰🇾",["KZ"] = "🇰🇿",["LA"] = "🇱🇦",["LB"] = "🇱🇧",["LC"] = "🇱🇨",["LI"] = "🇱🇮",["LK"] = "🇱🇰",["LR"] = "🇱🇷",["LS"] = "🇱🇸",["LT"] = "🇱🇹",["LU"] = "🇱🇺",["LV"] = "🇱🇻",["LY"] = "🇱🇾",["MA"] = "🇲🇦",["MC"] = "🇲🇨",["MD"] = "🇲🇩",["ME"] = "🇲🇪",["MF"] = "🇲🇫",["MG"] = "🇲🇬",["MH"] = "🇲🇭",["MK"] = "🇲🇰",["ML"] = "🇲🇱",["MM"] = "🇲🇲",["MN"] = "🇲🇳",["MO"] = "🇲🇴",["MP"] = "🇲🇵",["MQ"] = "🇲🇶",["MR"] = "🇲🇷",["MS"] = "🇲🇸",["MT"] = "🇲🇹",["MU"] = "🇲🇺",["MV"] = "🇲🇻",["MW"] = "🇲🇼",["MX"] = "🇲🇽",["MY"] = "🇲🇾",["MZ"] = "🇲🇿",["NA"] = "🇳🇦",["NC"] = "🇳🇨",["NE"] = "🇳🇪",["NF"] = "🇳🇫",["NG"] = "🇳🇬",["NI"] = "🇳🇮",["NL"] = "🇳🇱",["NO"] = "🇳🇴",["NP"] = "🇳🇵",["NR"] = "🇳🇷",["NU"] = "🇳🇺",["NZ"] = "🇳🇿",["OM"] = "🇴🇲",["PA"] = "🇵🇦",["PE"] = "🇵🇪",["PF"] = "🇵🇫",["PG"] = "🇵🇬",["PH"] = "🇵🇭",["PK"] = "🇵🇰",["PL"] = "🇵🇱",["PM"] = "🇵🇲",["PN"] = "🇵🇳",["PR"] = "🇵🇷",["PS"] = "🇵🇸",["PT"] = "🇵🇹",["PW"] = "🇵🇼",["PY"] = "🇵🇾",["QA"] = "🇶🇦",["RE"] = "🇷🇪",["RO"] = "🇷🇴",["RS"] = "🇷🇸",["RU"] = "🇷🇺",["RW"] = "🇷🇼",["SA"] = "🇸🇦",["SB"] = "🇸🇧",["SC"] = "🇸🇨",["SD"] = "🇸🇩",["SE"] = "🇸🇪",["SG"] = "🇸🇬",["SH"] = "🇸🇭",["SI"] = "🇸🇮",["SJ"] = "🇸🇯",["SK"] = "🇸🇰",["SL"] = "🇸🇱",["SM"] = "🇸🇲",["SN"] = "🇸🇳",["SO"] = "🇸🇴",["SR"] = "🇸🇷",["SS"] = "🇸🇸",["ST"] = "🇸🇹",["SV"] = "🇸🇻",["SX"] = "🇸🇽",["SY"] = "🇸🇾",["SZ"] = "🇸🇿",["TC"] = "🇹🇨",["TD"] = "🇹🇩",["TF"] = "🇹🇫",["TG"] = "🇹🇬",["TH"] = "🇹🇭",["TJ"] = "🇹🇯",["TK"] = "🇹🇰",["TL"] = "🇹🇱",["TM"] = "🇹🇲",["TN"] = "🇹🇳",["TO"] = "🇹🇴",["TR"] = "🇹🇷",["TT"] = "🇹🇹",["TV"] = "🇹🇻",["TW"] = "🇹🇼",["TZ"] = "🇹🇿",["UA"] = "🇺🇦",["UG"] = "🇺🇬",["UM"] = "🇺🇲",["US"] = "🇺🇸",["UY"] = "🇺🇾",["UZ"] = "🇺🇿",["VA"] = "🇻🇦",["VC"] = "🇻🇨",["VE"] = "🇻🇪",["VG"] = "🇻🇬",["VI"] = "🇻🇮",["VN"] = "🇻🇳",["VU"] = "🇻🇺",["WF"] = "🇼🇫",["WS"] = "🇼🇸",["XK"] = "🇽🇰",["YE"] = "🇾🇪",["YT"] = "🇾🇹",["ZA"] = "🇿🇦",["ZM"] = "🇿🇲"}

local GET_COUNTRY_CODE_CMD = [[ curl -s -4 https://api.myip.com | jq .cc | sed -e 's/"\(.*\)"/\1/' ]]

local ip_country_widget = {}

local function worker(args)

    local args = args or {}

    local font = args.font or beautiful.font or "Hack Nerd Font Mono 15"

    -- ip_country_widget = watch({
    --     cmd = GET_COUNTRY_CODE_CMD,
    --     timeout = 5,
    --     settings = function()
    --         widget.markup = '<span font="'.. font .. '">'..output..'</span>'
    --     end
    -- })
    ip_country_widget = wibox.widget{
        markup = '<span font="'.. font .. '">🔃</span>',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    ip_country_widget.update = function()
        awful.spawn.easy_async_with_shell(
            GET_COUNTRY_CODE_CMD,
            function(out)
                out = string.gsub(out, "\n", "")
                local flag = flags[out]
                ip_country_widget.markup = '<span font="'.. font .. '">'..flag..'</span>'
            end
        )
    end

    gears.timer {
        timeout   = 10,
        call_now  = true,
        autostart = true,
        callback  = function() ip_country_widget.update() end
    }

    return ip_country_widget

end

return setmetatable(ip_country_widget, { __call = function(_, ...)
    return worker(...)
end })