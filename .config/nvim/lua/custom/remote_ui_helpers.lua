local function detach_all()
	for _, ui in pairs(vim.api.nvim_list_uis()) do
		if ui.chan and not ui.stdout_tty then
			vim.fn.chanclose(ui.chan)
		end
	end
end

vim.api.nvim_create_user_command("RemoteUIDetachAll", function(opts)
	detach_all()
end, { desc = "toggle markdown checkboxes", range = true })
