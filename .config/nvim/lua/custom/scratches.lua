-- some helpers to manage scratches
local project = require("custom.project")

local default_opts = {
	repo = "git@github.com:GustavoKatel/.scratches.git",
	location = "$HOME/.scratches",

	sync_upstream = true,
}

local M = {
	_state = {
		last_floating_window = nil,
	},
	_opts = {},
}

function M.setup(opts)
	M._opts = vim.tbl_extend("force", {}, default_opts, opts or {})

	M._opts.location = vim.fn.expand(M._opts.location)

	if M._opts.sync_upstream then
		if vim.fn.isdirectory(M._opts.location) == 0 then
			local Job = require("plenary.job")

			vim.notify("could not find .scratches repo. Cloning...")
			Job:new({
				command = "git",
				args = { "clone", M._opts.repo, M._opts.location },
				cwd = vim.fn.getcwd(),
				env = vim.env,
				on_start = function()
					vim.notify("cloning remote scratches repo", vim.log.levels.INFO)
				end,
				on_exit = function(j, code)
					local notify = vim.schedule_wrap(vim.notify)

					if code == 0 then
						notify(".scratches upstream ready!", vim.log.levels.INFO)
					else
						local stdout = table.concat(j:result(), "\n")
						notify(
							string.format("error trying to clone .scratches repo: %s %s", code, stdout),
							vim.log.levels.ERROR
						)
					end
				end,
			}):start() -- or start()
		end
	end
end

function M.get_scratch_filename()
	return ".scratches/notes.md"
end

function M.setup_local_folder()
	if M._opts.sync_upstream then
		local project_name = project.current.name

		local scratch_folder = (project.current.scratches or {}).folder or (M._opts.location .. "/" .. project_name)
		scratch_folder = vim.fn.expand(scratch_folder)

		local remote_exists = vim.fn.isdirectory(scratch_folder) == 1
		local local_exists = vim.fn.isdirectory(".scratches") == 1

		if not remote_exists then
			vim.api.nvim_command(":!mkdir -p " .. scratch_folder)

			-- local exists, apply migration
			if local_exists then
				vim.notify("scratches migration: starting", vim.log.levels.INFO)
				vim.api.nvim_command(":!cp -r .scratches/* " .. scratch_folder .. "/")
				vim.api.nvim_command(":!rm -rf .scratches")
				vim.notify("scratches migration: done", vim.log.levels.INFO)
			end
		end

		if not local_exists then
			vim.api.nvim_command(":!ln -s " .. scratch_folder .. " .scratches")
		end
	end
end

function M.open_scratch_file_floating(opts)
	if M._state.last_floating_window ~= nil then
		vim.api.nvim_win_close(M._state.last_floating_window, false)
		M._state.last_floating_window = nil
	end

	opts = vim.tbl_deep_extend("force", { percentWidth = 0.8, percentHeight = 0.8 }, opts or {})

	-- Get the current UI
	local ui = vim.api.nvim_list_uis()[1]

	local width = math.floor(ui.width * opts.percentWidth)
	local height = math.floor(ui.height * opts.percentHeight)

	-- Create the floating window
	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = (ui.width / 2) - (width / 2),
		row = (ui.height / 2) - (height / 2),
		anchor = "NW",
		--style = "minimal",
		border = "rounded",
	}
	local winnr = vim.api.nvim_open_win(0, true, win_opts)
	M._state.last_floating_window = winnr

	M.setup_local_folder()

	vim.api.nvim_command("edit! " .. M.get_scratch_filename())

	local bufnr = vim.api.nvim_get_current_buf()

	local closing_keys = { "q", "<ESC>" }

	for _, key in ipairs(closing_keys) do
		vim.keymap.set({ "n" }, key, function()
			vim.api.nvim_command(":w!")
			vim.api.nvim_win_close(0, false)
			M._state.last_floating_window = nil
		end, { buffer = bufnr })
	end
end

vim.api.nvim_create_user_command("ScratchOpenFloat", M.open_scratch_file_floating, {})

M.setup()

return M
