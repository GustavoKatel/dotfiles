return {
	default_provider = "ollama",
	edgy = true, -- enable this!
	single_window = false, -- set this to true if you want only one OGPT window to appear at a time
	-- debug = {
	-- 	log_level = 1,
	-- 	notify_level = 1,
	-- },
	providers = {
		ollama = {
			api_host = os.getenv("OLLAMA_API_HOST") or "http://localhost:11434",
			api_key = os.getenv("OLLAMA_API_KEY") or "",
			-- default model
			model = "mistral:7b",
			-- model definitions
			models = {
				-- alias to actual model name, helpful to define same model name across multiple providers
				coder = "deepseek-coder:6.7b",
				general_model = "mistral:7b",
			},
		},
	},
	actions = {
		quick_question = {
			type = "popup",
			args = {
				-- template expansion
				question = {
					type = "string",
					optional = "true",
					default = function()
						return vim.fn.input("question: ")
					end,
				},
			},
			system = "You are a helpful assistant",
			template = "{{{question}}}",
			strategy = "display",
		},

		custom_input = {
			type = "popup",
			args = {
				instruction = {
					type = "string",
					optional = "true",
					default = function()
						return vim.fn.input("instruction: ")
					end,
				},
			},
			system = "You are a helpful assistant",
			template = "Given the follow snippet, {{{instruction}}}.\n\nsnippet:\n```{{{filetype}}}\n{{{input}}}\n```",
			strategy = "display",
		},

		optimize_code = {
			type = "edit",
			system = "You are a helpful coding assistant. Complete the given prompt.",
			template = "Optimize the code below, following these instructions:\n\n{{{instruction}}}.\n\nCode:\n```{{{filetype}}}\n{{{input}}}\n```\n\nOptimized version:\n```{{{filetype}}}",
			strategy = "edit_code",
			params = {
				model = "coder",
				stop = {
					"```",
				},
			},
		},
	},
}
