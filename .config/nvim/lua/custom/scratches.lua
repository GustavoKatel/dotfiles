-- some helpers to manage scratches

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
		local upstream_folder_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

		upstream_folder_name = M._opts.location .. "/" .. upstream_folder_name

		vim.api.nvim_command(":!mkdir -p " .. upstream_folder_name)

		-- already exists, copy content over
		if vim.fn.isdirectory(".scratches") then
			vim.api.nvim_command(":!cp -r .scratches/* " .. upstream_folder_name .. "/")
			vim.api.nvim_command(":!rm -rf .scratches")
		end

		vim.api.nvim_command(":!ln -s " .. upstream_folder_name .. " .scratches")
		return
	end

	vim.api.nvim_command(":silent !mkdir -p .scratches")
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

function M.sync()
	if not M._opts.sync_upstream then
		vim.notify("sync not enabled", vim.log.levels.INFO)
		return
	end

	-- this is done in a terminal to allow git inputs
	local function wrap_command(cmd)
		return "split term://" .. M._opts.location .. "//" .. cmd
	end

	-- vim.api.nvim_command(wrap_command("git add . && git commit -am 'sync' && git pull && git push"))
	-- TODO: automate this
	-- vim.api.nvim_command(wrap_command("sleep 3; git add . && git commit -am 'sync'"))
	vim.cmd.split("term://" .. M._opts.location .. "//" .. vim.env.SHELL)
end

vim.api.nvim_create_user_command("ScratchOpenFloat", M.open_scratch_file_floating, {})
vim.api.nvim_create_user_command("ScratchSync", M.sync, {})

M.setup()

return M
