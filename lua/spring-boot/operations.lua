local M = {}

local function get_pom_path()
	local f = io.popen(
		"find . -name 'pom.xml' -print0 | xargs -0 grep -l '<artifactId>spring-boot-maven-plugin</artifactId>'"
	)

	-- Get the result and remove the trailing newline
	local pom_path = f:read("*all"):gsub("\n$", "")
	f:close()

	-- If no pom.xml was found, print an error message and return
	if pom_path == "" then
		print("No pom.xml file with the Spring Boot Maven Plugin was found.")
		return
	end

	return pom_path
end

--@param cmd string
--@param opts spring-boot.config
local function run_cmd(cmd, opts)
	if opts.strategy.term == "toggleterm" then
		require("toggleterm").Terminal
			:new({
				cmd = cmd,
				direction = "float",
				float_opts = {
					border = "single",
				},
			})
			:toggle(cmd)
	else
		vim.fn.termopen(cmd)
	end
end

function M.spring_boot_run(opts)
	local pom_path = get_pom_path()

	local port = vim.fn.input("Enter port number: ")
	local profile = vim.fn.input("Enter profile: ")
	local managementPort = vim.fn.input("Enter management port number: ")

	-- Construct the command string
	local cmd = "mvn -f"
		.. pom_path
		.. " spring-boot:run -D.spring-boot.run.profiles="
		.. profile
		.. " -Dspring-boot.run.arguments='--server.port="
		.. port
		.. " --management.server.port"
		.. managementPort
		.. " '"
	-- Run the command in a new terminal window

	print(cmd)
	run_cmd(cmd, opts)
end

--@param opts spring-boot.config
function M.spring_boot_debug(opts)
	local pom_path = get_pom_path()

	local port = vim.fn.input("Enter port number: ")
	local profile = vim.fn.input("Enter profile: ")
	local managementPort = vim.fn.input("Enter management port number: ")

	-- Construct the command string
	local cmd = "mvn -f "
		.. pom_path
		.. " spring-boot:run -Dspring-boot.run.jvmArguments='-Xdebug"
		.. "-Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005'	-D.spring-boot.run.profiles="
		.. profile
		.. " -Dspring-boot.run.arguments='--server.port="
		.. port
		.. " --management.server.port"
		.. managementPort
		.. " '"
	-- Run the command in a new terminal window
	run_cmd(cmd, opts)
end

return M
