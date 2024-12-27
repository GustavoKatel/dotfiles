local parser = {
	diagnostics = {
		{
			"extract",
			{
				append = false,
			},
			"^=== (FAIL): (.+) (.+) %((%d+%.%d+)s%)",
			"status",
			"_path",
			"test_name",
			"duration",
		},
		{
			"extract",
			{
				append = false,
				postprocess = function(item)
					item.filename = vim.fs.joinpath(item._path, item.filename)
				end,
			},
			"^%s*(.*):(%d+):%s*(.*)$",
			"filename",
			"lnum",
			"text",
		},
		{
			"loop",
			{
				"parallel",
				{
					"always",
					{ "extract", { append = true }, "^%s+Messages:%s+(.+)", "text" },
				},
				{
					"invert",
					{
						"sequence",
						{ "test", "^%s+--- FAIL:" },
						{ "append" },
					},
				},
			},
		},
	},
}

return parser
