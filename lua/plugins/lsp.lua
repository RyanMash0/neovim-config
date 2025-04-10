return {
	{
		'L3MON4D3/LuaSnip',
		build = 'make install_jsregexp'
	},
	{
		'onsails/lspkind.nvim'
	},
  {
    'hrsh7th/nvim-cmp',
    config = function()

			local luasnip = require('luasnip')
			local lspkind = require('lspkind')
      local cmp = require('cmp')

      cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = 'text',
						maxwidth = {
							menu = math.floor(0.45 * vim.api.nvim_win_get_height(0)),
							abbr = math.floor(0.45 * vim.api.nvim_win_get_height(0)),
						},
						ellipsis_char = '...',
						show_labelDetails = true,
						before = function (entry, vim_item)
							local src = entry.source
							local server_name
--							-- To inspect entry
--							local file_path = '.config/nvim/output.txt'
--							local file = io.open(file_path, 'a+')
--							file:write(vim.inspect(entry))
--							file:close()
							vim_item.menu = ({
								vimtex = vim_item.menu,
								buffer = '[Buffer]',
								luasnip = '[LuaSnip]',
								-- Potentially add others
							})[src.name]
							if src.name == 'nvim_lsp' then
									server_name = src.source.client.name
									vim_item.menu = ({
										ts_ls = '[TypeScript LS]',
										pyright = '[Pyright]',
										lua_ls = '[Lua LS]',
										texlab = '[TexLab]',
										jdtls = '[Jdtls]',
										-- Don't forget to add other language servers
									})[server_name]
							end
							return vim_item
						end
					}),
				},
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
								if luasnip.expandable() then
										luasnip.expand()
								else
										cmp.confirm({
												select = true,
										})
								end
						else
								fallback()
						end
				end),

				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),

				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
        },
				sources = {
					{ name = 'buffer' },
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
      })

			cmp.setup.filetype('tex', {
				sources = {
					{ name = 'buffer' },
					{ name = 'nvim_lsp',
						entry_filter = function (entry, ctx)
							local types = require('cmp.types')
							local comp_kind = types.lsp.CompletionItemKind[entry:get_kind()]
							return comp_kind ~= 'Function' and comp_kind ~= 'Enum' and comp_kind ~= 'Class'
						end
					},
					{ name = 'luasnip' },
					{ name = 'vimtex',
						entry_filter = function (entry, ctx)
							return entry:get_word() ~= 'begin'
						end
					},
				},
			})
    end
  },
	{
		'saadparwaiz1/cmp_luasnip',
	},
	{
		'hrsh7th/cmp-nvim-lsp',
	},
  {
    'neovim/nvim-lspconfig',
    config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			vim.diagnostic.config({
				virtual_text = true
			})
      require('lspconfig').ts_ls.setup{ capabilities = capabilities, }
			require('lspconfig').pyright.setup{ capabilities = capabilities, }
			require('lspconfig').texlab.setup{ capabilities = capabilities, }
			require('lspconfig').jdtls.setup{ capabilities = capabilities, }
      require('lspconfig').lua_ls.setup {
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
			}
    end
  },
}
