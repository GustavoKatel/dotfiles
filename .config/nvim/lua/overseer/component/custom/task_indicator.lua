-- based on https://github.com/stevearc/overseer.nvim/blob/390332d4687e3d07495a545ba11e62fcf30339f1/lua/overseer/component/on_result_diagnostics.lua
local constants = require("overseer.constants")
local STATUS = constants.STATUS

-- Shows the indicator of the task result as extmarks
---@type overseer.ComponentFileDefinition
local comp = {
	desc = "Shows the task status as extmarks",
	params = {
		-- virtual_text = {
		-- 	desc = "Override the default diagnostics.virtual_text setting",
		-- 	type = "boolean",
		-- 	optional = true,
		-- },
		-- signs = {
		-- 	desc = "Override the default diagnostics.signs setting",
		-- 	type = "boolean",
		-- 	optional = true,
		-- },
		-- underline = {
		-- 	desc = "Override the default diagnostics.underline setting",
		-- 	type = "boolean",
		-- 	optional = true,
		-- },
		-- remove_on_restart = {
		-- 	desc = "Remove diagnostics when task restarts",
		-- 	type = "boolean",
		-- 	optional = true,
		-- },
	},
	constructor = function(params)
		local function remove_extmarks(self)
			for _, bufnr in ipairs(self.bufnrs) do
				vim.api.nvim_buf_clear_namespace(bufnr, self.ns, 0, -1)
			end
			self.bufnrs = {}
		end
		return {
			bufnrs = {},
			on_init = function(self, task)
				self.ns = vim.api.nvim_create_namespace("overseer_indicator_" .. task.name)
			end,
			on_status = function(self, task)
				remove_extmarks(self)

				local bufnr = task.metadata.bufnr
				local range = task.metadata.range

				local sign = " "
				local sign_hl = "DiagnosticInfo"

				if task.status == STATUS.SUCCESS then
					sign = " "
					sign_hl = "DiagnosticOk"
				end
				if task.status == STATUS.FAILURE then
					sign = " "
					sign_hl = "DiagnosticError"
				end
				if task.status == STATUS.CANCELED then
					sign = " 󰜺"
					sign_hl = "DiagnosticWarn"
				end

				table.insert(self.bufnrs, bufnr)
				vim.api.nvim_buf_set_extmark(bufnr, self.ns, range.start.line, range.start.character, {
					sign_text = sign,
					sign_hl_group = sign_hl,
				})
			end,
			on_reset = function(self, task)
				if params.remove_on_restart then
					remove_extmarks(self)
				end
			end,
			on_dispose = function(self, task)
				remove_extmarks(self)
			end,
		}
	end,
}

return comp
