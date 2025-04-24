-------------------------------------------------------------------------------
--  LSP Config                                                               --
-------------------------------------------------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.diagnostic.config({
	virtual_text = true
})

vim.lsp.config('ts_ls', { capabilities = capabilities })
vim.lsp.config('pyright', { capabilities = capabilities })
vim.lsp.config('texlab', { capabilities = capabilities })
vim.lsp.config('jdtls', { capabilities = capabilities })
vim.lsp.config('lua_ls', {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'}
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
			},
		},
	},
})

vim.lsp.enable("ts_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("texlab")
vim.lsp.enable("jdtls")
vim.lsp.enable("lua_ls")
