local v = require("utils")

v.cmd["UpdateAll"] = function()
    v.cmd.CocUpdate()

    v.cmd.TSUpdate()

    v.cmd.VimspectorUpdate()

    v.cmd.PackerSync()
end
