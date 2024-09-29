vim.api.nvim_create_user_command("Kube", function()
	require("kubectl").open()
end, {
	desc = "Open kubectl",
})
vim.api.nvim_create_user_command("KubeOpen", function()
	require("kubectl").open()
end, {
	desc = "Open kubectl",
})

vim.api.nvim_create_user_command("KubeClose", function()
	require("kubectl").close()
end, {
	desc = "Close kubectl",
})

vim.api.nvim_create_user_command("KubeToggle", function()
	require("kubectl").toggle()
end, {
	desc = "Toggle kubectl",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("kube_user_customizations", { clear = true }),
	pattern = {
		"k8s_deployments",
		"k8s_pods",
		"k8s_configmaps",
		"k8s_secrets",
		"k8s_services",
		"k8s_ingresses",
	},
	callback = function(opts)
		vim.keymap.set("n", "<C-d>", "<cmd>lua require('kubectl').close()<CR>", { buffer = opts.buf })
	end,
})

return {}
