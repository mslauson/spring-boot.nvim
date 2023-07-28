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
}

---@param opts? spring-boot.config | nil Configuration options
function spring_boot.setup(opts)
	-- avoid setting global values outside of this function. Global state
	-- mutations are hard to debug and test, so having them in a single
	-- function/module makes it easier to reason about all possible changes
	spring_boot.options = config.setup(opts)

	-- do here any startup your plugin needs, like creating commands and
	-- mappings that depend on values passed in options
	vim.api.nvim_create_user_command("SpringBootRun", spring_boot.spring_boot_run(opts), {})
end

function spring_boot.is_configured()
	return spring_boot.options ~= nil
end

-- This is a function that will be used outside this plugin code.
-- Think of it as a public API
function spring_boot.greet()
	if not spring_boot.is_configured() then
		return
	end

	-- try to keep all the heavy logic on pure functions/modules that do not
	-- depend on Neovim APIs. This makes them easy to test
	local greeting = my_cool_module.greeting(spring_boot.options.name)
	print(greeting)
end

-- Another function that belongs to the public API. This one does not depend on
-- user configuration
function spring_boot.generic_greet()
	print("Hello, unnamed friend!")
end

spring_boot.options = nil
return spring_boot
