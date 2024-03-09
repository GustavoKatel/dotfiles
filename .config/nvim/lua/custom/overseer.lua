local opts = {
	log = {
		{
			type = "file",
			filename = "overseer.log",
			level = vim.log.levels.DEBUG,
		},
	},
}

return opts
