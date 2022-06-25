-- user profile ( switch configurations based on the active profile )
local M = {
	config = {
		default_profile = "personal",
		env_name = "NVIM_PROFILE",
	},
}

-- @param config table
-- |-- @param config.default_profile string the fallback profile if none has been provided
-- |-- @param config.env_name string the environment variable in which is located the profile name
function M.setup(config)
	config = vim.tbl_deep_extend("keep", config or {}, M.config)

	M.config = config
end

-- @return string the current active profile
function M.get_active_profile()
	local env_profile = vim.env[M.config.env_name]
	if type(env_profile) == "string" and env_profile ~= "" then
		return env_profile
	end

	return M.config.default_profile
end

-- only execute `fn` if the profile `profile_name` is active
-- the special profile `any` can be used to execute `fn` for any active profile. I.e.: it will always be executed
-- @param profile_name string the required profile
-- @param fn function to execute
-- @return any|nil return fn(...) or nil if the profile is not active
function M.with_profile_fn(profile_name, fn, ...)
	if profile_name ~= "any" and profile_name ~= M.get_active_profile() then
		return nil
	end

	return fn(...)
end

-- index `tbl` with the current active profile
-- the special profile `default` can be used as a fallback if none of the keys match
-- @param tbl table keys are profile names, values can be anything
-- @return the value of they key matching the current profile
function M.with_profile_table(tbl)
	local active_profile = M.get_active_profile()

	local ret = tbl[active_profile]

	if not ret then
		return tbl["default"]
	end

	return ret
end

return M
