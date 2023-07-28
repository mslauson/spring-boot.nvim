local operations = require("spring-boot.operations")

--@class spring-boot
local M = {
	spring_boot_run = operations.spring_boot_run,
	spring_boot_debug = operations.spring_boot_debug,
}

---@param options? Options
function M.setup(options) end

return M
