local v = require("utils")

v.cmd["Ranger"] = function()
    v.cmd.FloatermNew("ranger")
end

-- disable  indent lines on floaterm windows
v.autocmd("User", "FloatermOpen", v.cmd.IndentLinesDisable)

