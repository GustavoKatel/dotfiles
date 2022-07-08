local tasks = require("tasks")

local source_npm = require("tasks.sources.npm")
local source_tasksjson = require("tasks.sources.tasksjson")

local builtin = require("tasks.sources.builtin")

require("telescope").load_extension("tasks")

tasks.setup({
    sources = {
        npm = source_npm,
        vscode = source_tasksjson,
        utils = builtin.new_builtin_source({
            sleep = {
                fn = function(ctx)
                    local pasync = require("plenary.async")

                    pasync.util.sleep(10000)
                end,
            },

            term_sleep = {
                cmd = "sleep 10",
            },

            wait_stop = {
                fn = function(ctx)
                    ctx.stop_request_receiver()
                end,
            },
        }),
    },

    runners = {
        -- NOTE: very experimental runner, use with caution
        custom_terminal = require("custom.tasks_terminal_runner"),
    },

    router = function(spec_name, spec, args, source_name)
        if spec.cmd ~= nil and spec.cmd ~= "" then
            return "custom_terminal"
        end
        return nil -- fallback to use the default router value
    end,
})
