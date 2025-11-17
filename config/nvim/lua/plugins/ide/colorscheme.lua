return {
	-- catppuccin dark
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			integrations = {
				dashboard = true,
				bufferline = true,
				mason = true,
				mini = true,
				notify = true,
				noice = true,
				snacks = {
					enabled = true,
					indent_scope_color = "mocha",
				},
				which_key = true,
				blink_cmp = {
					style = "bordered",
				},
				lsp_trouble = true,
				neotree = true,
			},
		},
	},
}
