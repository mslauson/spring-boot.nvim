local default_config = {
	strategy = {
		term = "toggleterm",
	},
}

local M = {}
--@param opts? spring-boot.config
M.setup = function(opts)
	opts = opts or {}
	local updated_config = vim.tbl_deep_extend("force", default_config, opts)
	return updated_config
end

return M
