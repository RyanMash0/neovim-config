return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function ()
			local telescope = require('telescope')
			local search_dirs = {
				'**/Dropbox/UNC/**',
				'\\.config/**',
				'\\.local/**',
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
			}
			local exclude_tex = {
				'*\\.pdf',
				'*\\.fls',
				'*\\.aux',
				'*\\.synctex',
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
				pickers = {
					find_files = {
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
