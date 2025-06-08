return {
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			validate = { enable = true },
			scheumas = require("schemastore").json.schemas({
				extra = {
					{
						name = "nvim-project.json",
						description = "Project configuration for Neovim",
						fileMatch = { "**/*/.nvim/project.json" },
						uri = "file://" .. vim.fn.stdpath("config") .. "/schemas/project.json",
					},
				},
			}),
		},
	},
}
