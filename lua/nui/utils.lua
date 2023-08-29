local Popup = require("nui.popup")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local M = {}

local popup = Popup({
	enter = true,
	focusable = true,
	border = {
		style = "rounded",
	},
	position = "50%",
	size = {
		width = "80%",
		height = "60%",
	},
})

-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
	popup:unmount()
end)

local menu = function(opts)
	return Menu({
		position = "50%",
		size = {
			width = 25,
			height = 5,
		},
		border = {
			style = "single",
			text = {
				top = "[Choose-an-Element]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = opts.lines,
		max_width = 20,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			print("Menu Closed!")
		end,
		on_submit = function(item)
			print("Menu Submitted: ", item.text)
		end,
	})
end

-- mount the component

M.showMenu = function(items, opts)
	local menuLines = {}

	for _, item in pairs(items) do
		table.insert(menuLines, item)
	end

	opts.lines = menuLines
	local runMenu = menu(opts)

	runMenu:mount()
end

return M
