local operations = require("spring-boot.operations")
local config = require("spring-boot.config")

if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("spring_boot requires at least nvim-0.7.0.1")
	return
end

--@class spring-boot
local spring_boot = {
	spring_boot_run = operations.spring_boot_run,
	spring_boot_debug = operations.spring_boot_debug,
	opts = nil,
}

---@param opts? spring-boot.config | nil Configuration options
function spring_boot.setup(opts)
	print(opts)

	spring_boot.opts = config.setup(opts)

	-- do here any startup your plugin needs, like creating commands and
	-- mappings that depend on values passed in options
	vim.api.nvim_create_user_command("SpringBootRun", spring_boot.spring_boot_run(spring_boot.opts), {})
end

function spring_boot.is_configured()
	return spring_boot.opts ~= nil
end

-- Another function that belongs to the public API. This one does not depend on
-- user configuration
function spring_boot.generic_greet()
	print("Hello, unnamed friend!")
end

return spring_boot
