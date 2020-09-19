
local awful = require("awful")

local floating2  = { name = "floating2" }

function floating2.arrange(p)
    local cls = p.clients

    -- if #cls == 0 then return end

    local fn = (awful.placement.no_overlap + awful.placement.no_offscreen)

    for k, c in ipairs(cls)
    do
        -- g = awful.placement.no_overlap(c)
        -- c:geometry(g)
        fn(c)
    end
end


return floating2