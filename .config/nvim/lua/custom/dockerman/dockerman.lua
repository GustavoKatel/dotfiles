local NuiTree = require("nui.tree")
local NuiLine = require("nui.line")
local nio = require("nio")
local actions = require("custom.dockerman.actions")

local vim_call = nio.wrap(function(fn, cb)
	vim.schedule(function()
		cb(fn())
	end)
end, 2)

local M = {}

function M.setup()
	M.ns_id = vim.api.nvim_create_namespace("custom.dockerman")

	M.setup_highlights()

	M.update_requested = nio.control.event()
	M.render_semaphore = nio.control.semaphore(1)
	M.update_iteration = 0
end

function M.create_buffer()
	M.bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("filetype", "dockerman", {
		buf = M.bufnr,
	})

	vim.api.nvim_buf_set_name(M.bufnr, "dockerman")
	vim.keymap.set("n", "<CR>", M.key_enter, { buffer = M.bufnr })

	M.create_tree()

	M._update_loop()
	M.request_update()
end

function M.get_buffer()
	if not M.bufnr or not vim.api.nvim_buf_is_valid(M.bufnr) then
		M.create_buffer()
	end

	return M.bufnr
end

function M.setup_highlights()
	vim.cmd.highlight({ "link", "DockermanContainerUp", "DiagnosticOk" })
	vim.cmd.highlight({ "link", "DockermanContainerDown", "Normal" })
end

function M.open()
	vim.api.nvim_open_win(M.get_buffer(), false, {
		split = "right",
	})
	vim.cmd.wincmd("=")

	M._safe_render()
end

function M.create_tree()
	local bufnr = M.get_buffer()

	local nodes = {
		NuiTree.Node({ text = "Containers", id = "containers" }, {}),
		NuiTree.Node({ text = "Volumes", id = "volumes" }, {}),
		NuiTree.Node({ text = "Images", id = "images" }, {}),
		NuiTree.Node({ text = "Networks", id = "networks" }, {}),
	}

	local tree = NuiTree({
		bufnr = bufnr,
		nodes = nodes,
	})

	M.tree = tree

	M.tree:get_node("-containers"):expand()

	M._safe_render()
	M.request_update()

	if M.timer then
		M.timer:stop()
		M.timer:close()
	end

	local timer = vim.uv.new_timer()
	timer:start(1000, 0, function()
		M.request_update()
	end)
	M.timer = timer
end

function M._update_or_add_node(node, parent_id)
	local existing_node = M.tree:get_node("-" .. node.id)
	if existing_node then
		for key, value in pairs(node) do
			existing_node[key] = value
		end
		existing_node.iteration = M.update_iteration
		return existing_node
	end

	node.iteration = M.update_iteration
	local new_node = NuiTree.Node(node)
	M.tree:add_node(new_node, parent_id)
	return new_node
end

local function _get_process_json_output(cmd, args)
	local proc = nio.process.run({
		cmd = cmd,
		args = args,
	})

	local _, output = pcall(proc.stdout.read)

	proc.close()

	local results = {}

	if output == nil then
		return results
	end

	for i, line in ipairs(vim.split(output, "\r?\n")) do
		if line ~= "" then
			local ok, result = pcall(vim.json.decode, line)
			if ok then
				table.insert(results, result)
			end
		end
	end

	return results
end

local function _get_container_labels(container)
	local parsed = {}

	local labels = vim.split(container.Labels, ",")

	for _, label in ipairs(labels) do
		local key, value = unpack(vim.split(label, "="))
		parsed[key] = value
	end

	return parsed
end

function M.get_containers_nodes()
	local results = _get_process_json_output("docker", { "ps", "-a", "--format", "{{json . }}" })

	local containers = {}

	for _, result in ipairs(results) do
		local container = {
			name = result.Names,
			text = result.Names,
			id = "container/" .. result.ID,
			container_id = result.ID,
			image = result.Image,
			status = result.Status,
			state = result.State,
			labels = _get_container_labels(result),
		}

		container.text = vim_call(function()
			local line = NuiLine()
			if container.state == "running" then
				line:append("  ", "DockermanContainerUp")
			else
				line:append("  ", "DockermanContainerDown")
			end

			line:append(container.name)
			return line
		end)

		local parent_id = "-containers"

		local compose_project = container.labels["com.docker.compose.project"]
		if compose_project then
			local compose_parent = M._update_or_add_node(
				{ text = "  " .. compose_project, id = "compose/" .. compose_project },
				"-containers"
			)
			parent_id = compose_parent:get_id()
			compose_parent:expand()
		end

		local parent = M._update_or_add_node(container, parent_id)

		M._update_or_add_node({
			text = "   Attach",
			id = container.id .. "/attach",
			action = actions.container_attach,
			container = container,
		}, parent:get_id())
		M._update_or_add_node({
			text = "   Logs",
			id = container.id .. "/logs",
			action = actions.container_logs,
			container = container,
		}, parent:get_id())
		M._update_or_add_node({
			text = "   Inspect",
			id = container.id .. "/inspect",
			action = actions.container_inspect,
			container = container,
		}, parent:get_id())
		M._update_or_add_node({
			text = "   Menu",
			id = container.id .. "/menu",
			action = actions.container_menu,
			container = container,
		}, parent:get_id())
		M._update_or_add_node({ text = " ------- ", id = container.id .. "/actions_sep" }, parent:get_id())
		M._update_or_add_node(
			{ text = " 󰻾 " .. result.ID, id = container.id .. "/id", container = container },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = "  " .. result.Image, id = container.id .. "/image", container = container },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󱤦 " .. result.Status, id = container.id .. "/status", container = container },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󰱓 " .. (result.Ports or "-"), id = container.id .. "/ports", container = container },
			parent:get_id()
		)
	end

	return containers
end

function M.get_volume_nodes()
	local results = _get_process_json_output("docker", { "volume", "ls", "--format", "{{json .}}" })

	local volumes = {}

	for _, result in ipairs(results) do
		local text = result.Name

		if #text > 20 then
			text = text:sub(1, 10) .. "..." .. text:sub(-10)
		end

		local volume = {
			name = result.Name,
			text = text,
			id = "volume/" .. result.Name,
			volume_id = result.Name,
		}

		local parent = M._update_or_add_node(volume, "-volumes")

		M._update_or_add_node({
			text = "   Inspect",
			id = volume.id .. "/inspect",
			action = actions.volume_inspect,
			volume = volume,
		}, parent:get_id())
		M._update_or_add_node({ text = " ------- ", id = volume.id .. "/actions_sep" }, parent:get_id())
		M._update_or_add_node(
			{ text = " 󰻾 " .. result.Name, id = volume.id .. "/id", volume = volume },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󰣳 " .. result.Size, id = volume.id .. "/size", volume = volume },
			parent:get_id()
		)
	end

	return volumes
end

function M.get_image_nodes()
	local results = _get_process_json_output("docker", { "image", "ls", "--format", "{{json .}}" })

	local images = {}

	for _, result in ipairs(results) do
		local name = "  " .. result.Repository .. ":" .. result.Tag

		local image = {
			name = name,
			text = name,
			id = "image/" .. result.ID,
			image_id = result.ID,
		}

		local parent = M._update_or_add_node(image, "-images")

		M._update_or_add_node({
			text = "   Inspect",
			id = image.id .. "/inspect",
			action = actions.image_inspect,
			image = image,
		}, parent:get_id())
		M._update_or_add_node({
			text = "   Menu",
			id = image.id .. "/menu",
			action = actions.image_menu,
			image = image,
		}, parent:get_id())
		M._update_or_add_node({ text = " ------- ", id = image.id .. "/actions_sep" }, parent:get_id())
		M._update_or_add_node({ text = " 󰻾 " .. result.ID, id = image.id .. "/id", image = image }, parent:get_id())
		M._update_or_add_node(
			{ text = " 󰣳 " .. result.Size, id = image.id .. "/size", image = image },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󰃭 " .. result.CreatedSince, id = image.id .. "/created_since", image = image },
			parent:get_id()
		)
	end

	return images
end

function M.get_network_nodes()
	local results = _get_process_json_output("docker", { "network", "ls", "--format", "{{json .}}" })

	local networks = {}

	for _, result in ipairs(results) do
		local network = {
			name = result.Name,
			text = result.Name,
			id = "network/" .. result.ID,
			network_id = result.ID,
		}

		local parent = M._update_or_add_node(network, "-networks")

		M._update_or_add_node({
			text = "   Inspect",
			id = network.id .. "/inspect",
			action = actions.network_inspect,
			network = network,
		}, parent:get_id())
		M._update_or_add_node({
			text = "   Menu",
			id = network.id .. "/menu",
			action = actions.network_menu,
			network = network,
		}, parent:get_id())
		M._update_or_add_node({ text = " ------- ", id = network.id .. "/actions_sep" }, parent:get_id())
		M._update_or_add_node(
			{ text = " 󰻾 " .. result.ID, id = network.id .. "/id", network = network },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󰩠 IPv6: " .. result.IPv6, id = network.id .. "/ipv6", network = network },
			parent:get_id()
		)
		M._update_or_add_node(
			{ text = " 󰙵 " .. result.Driver, id = network.id .. "/driver", network = network },
			parent:get_id()
		)
	end

	return networks
end

function M.cleanup_stale_nodes(parent_id)
	local nodes = M.tree:get_nodes(parent_id)

	for _, node in ipairs(nodes) do
		if node.iteration and node.iteration ~= M.update_iteration then
			M.tree:remove_node(node:get_id())
		end
		M.cleanup_stale_nodes(node:get_id())
	end
end

function M._safe_render()
	local render = nio.wrap(function(cb)
		vim.schedule(function()
			M.tree:render()
			cb()
		end)
	end, 1)

	nio.run(function()
		M.render_semaphore.with(render)
	end)
end

function M.request_update()
	M.update_requested.set()
end

function M._update_loop()
	nio.run(function()
		while true do
			M.update_requested.wait()

			M.update_iteration = M.update_iteration + 1
			M.update_iteration = M.update_iteration % 10000000

			M.get_containers_nodes()
			M.get_volume_nodes()
			M.get_image_nodes()
			M.get_network_nodes()

			M.cleanup_stale_nodes()

			M._safe_render()
		end
	end)
end

function M.key_enter()
	local node = M.tree:get_node()
	if node then
		if node:is_expanded() then
			node:collapse()
		else
			node:expand()
		end

		if node.action then
			node.action(node)
		end

		M._safe_render()
	end
end

M.setup()

return M
