return {
	{
	  "lervag/vimtex",
	  lazy = false,     -- we don't want to lazy load VimTeX
	  -- tag = "v2.15", -- uncomment to pin to a specific release
	  init = function()
	    -- VimTeX configuration goes here, e.g.
	    vim.g.vimtex_view_method = "skim"
			local latexmk_engine = {}
			latexmk_engine._ = '-lualatex'
			vim.g.vimtex_compiler_latexmk_engines = latexmk_engine
	  end
	},
	{
	  "micangl/cmp-vimtex",
	},
}
