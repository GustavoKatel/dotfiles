return {
	settings = {
		gopls = {
			buildFlags = {},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			experimentalPostfixCompletions = true,
			codelenses = {
				gc_details = true,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
		},
	},
}
