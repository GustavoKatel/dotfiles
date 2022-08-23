local tasks = require("tasks")

local source_npm = require("tasks.sources.npm")
local source_tasksjson = require("tasks.sources.tasksjson")
local source_cargo = require("tasks.sources.cargo")
local source_dap = require("tasks.sources.dap")
local Source = require("tasks.lib.source")

local runner_builtin = require("tasks.runners.builtin")

tasks.setup({
	sources = {
		npm = source_npm,
		vscode = source_tasksjson,
		cargo = source_cargo,
		dap = source_dap,
		utils = Source:create({
			specs = {
				sleep = {
					fn = function(_ctx)
						local pasync = require("plenary.async")

						pasync.util.sleep(10000)
					end,
				},

				term_sleep = {
					cmd = "echo 'sleeping...'; sleep 60",
				},

				wait_stop = {
					fn = function(ctx)
						ctx.stop_request_receiver()
					end,
				},
			},
		}),
	},

	runners = {
		builtin = runner_builtin:with({ sticky_terminal_window = true }),
	},

	logger = {
		level = "debug",
	},
})
