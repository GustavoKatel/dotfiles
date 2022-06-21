local naughty       = require("naughty")

local notifs = {}

notifs.list = {}

notifs.max = 10


notifs.pop = function()

    for k, args in pairs(notifs.list) do
        args.notifs_ignore = true
        naughty.notify(args)
    end

end

naughty.config.notify_callback = function(args)

    if args.notifs_ignore == true then
        return args
    end

    notifs.list[#notifs.list + 1] = args

    if #notifs.list > notifs.max then
        table.remove(notifs.list, 1)
    end

    return args
end

return notifs