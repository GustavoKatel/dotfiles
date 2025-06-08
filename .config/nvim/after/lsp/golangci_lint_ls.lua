return {
	command = {},
	init_options = {
		command = {
			"go",
			"tool",
			"golangci-lint",
			"run",
			"--out-format",
			"json",
			-- "--issues-exit-code=1",
			-- "--allow-parallel-runners",
		},
	},
}
