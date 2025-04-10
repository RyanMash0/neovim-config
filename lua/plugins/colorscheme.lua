return {
--	{
--		"rktjmp/lush.nvim",
--    { dir = '~/.config/nvim/lua/simple_dark', lazy = true },
--  }
	{
		"sainnhe/gruvbox-material",
			config = function ()
				-- vim.g.gruvbox_material_background = 'hard'
				vim.g.gruvbox_material_foreground = 'original'
				vim.g.gruvbox_material_transparent_background = 1
			end
	},
}
