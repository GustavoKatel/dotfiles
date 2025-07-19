return {
	command = {},
	init_options = {
		command = {
			"go",
			"tool",
			"golangci-lint",
			"run",
			"--output.json.path=stdout",
			"--output.text.path=/dev/null",
			"--show-stats=false",
			-- "--issues-exit-code=1",
			-- "--allow-parallel-runners",
		},
	},
}
