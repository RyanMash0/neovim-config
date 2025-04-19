return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function ()
			local telescope = require('telescope')
			local cwd = vim.fn.getcwd(0)
			local search_dirs = {
        '**/Dropbox/Personal/text_files/**',
				'**/Dropbox/UNC/**',
				'/\\.config/**',
			}

			local exclude_dirs = {
				'**/lazy/**',
				'**/swap/**',
				'**/shada/**',
				'**/\\.git/**',
			}

			local exclude_files = {
				'**/\\.DS_Store',
				'*\\.xlsx',
				'*\\.class',
				'*\\.zip',
        '*\\.jpeg',
        '*\\.jpg',
        '*\\.png',
        '*\\.docx',
        '*\\.mp3',
        '*\\.mp4',
        '*\\.mov',
        '*\\.wav',
        '*\\.pkf',
			}

			local exclude_tex = {
				'*\\.pdf',
				'*\\.fls',
				'*\\.aux',
				'*\\.synctex',
				'*\\.synctex.gz',
				'*\\.fdb_latexmk',
			}

			local find_args = { 'rg', '--files', '--hidden' }

			for i = 1, #search_dirs, 1 do
				find_args[#find_args + 1] = '--glob='..search_dirs[i]
			end

			for i = 1, #exclude_dirs, 1 do
				find_args[#find_args + 1] = '--glob=!'..exclude_dirs[i]
			end

			for i = 1, #exclude_files, 1 do
				find_args[#find_args + 1] = '--glob=!'..exclude_files[i]
			end

			for i = 1, #exclude_tex, 1 do
				find_args[#find_args + 1] = '--glob=!'..exclude_tex[i]
			end

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							['<C-h>'] = 'move_selection_previous',
							['<C-l>'] = 'move_selection_next',
						},
					},
				},
				pickers = {
					find_files = {
						cwd = '~',
						find_command = find_args,
					}
				}
			})
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
	},
}
