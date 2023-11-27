require('lazy').setup({
	{
		'cranberry-clockworks/coal.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme('coal')
			vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
			vim.cmd('highlight LineNr guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE')
			vim.cmd('highlight NormalNC guibg=NONE ctermbg=NONE')
			vim.cmd('highlight CursorLine guibg=NONE ctermbg=NONE')
			-- completion menu transparent
			vim.cmd('highlight Pmenu guibg=NONE ctermbg=NONE')
			vim.cmd('highlight PmenuSel guibg=NONE ctermbg=NONE')
			-- vertical lines transparent
			vim.cmd('highlight WinSeparator guibg=None ctermbg=None')
			vim.cmd('highlight VertSplit guibg=NONE ctermbg=NONE')

			vim.cmd('highlight SignColumn guibg=NONE ctermbg=None')
		end
	},
	-- 
	{
		'jesseleite/nvim-noirbuddy',
		enabled = false,
		lazy = false,
		priority = 1000,
		dependencies = { 'tjdevries/colorbuddy.nvim' },
		config = function()
			require('noirbuddy').setup({
			  preset = 'minimal',
			})
			vim.cmd('colorscheme noirbuddy')
			-- nvim transparent
			vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
			vim.cmd('highlight LineNr guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE')
			vim.cmd('highlight NormalNC guibg=NONE ctermbg=NONE')
			vim.cmd('highlight CursorLine guibg=NONE ctermbg=NONE')
			-- completion menu transparent
			vim.cmd('highlight Pmenu guibg=NONE ctermbg=NONE')
			vim.cmd('highlight PmenuSel guibg=NONE ctermbg=NONE')
			-- vertical lines transparent
			vim.cmd('highlight VertSplit guibg=NONE ctermbg=NONE')
		end
	},
	-- Portable package manager to install and manage LSP servers, DAP servers, linters, and formatters.
  {
    'williamboman/mason.nvim',
		dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      require('mason').setup()
			require('mason-lspconfig').setup({
				automatic_installation = true,
			})
    end
  },
  -- A completion engine plugin for neovim written in Lua.
  {
    'hrsh7th/nvim-cmp',
    lazy = false,
		dependencies = {
			{
				'neovim/nvim-lspconfig',
				config = function()
					local signs = {
						Error = " ",
						Warn= " ",
						Hint = " ",
						Info= " "
					}
					for type, icon in pairs(signs) do
    				local hl = "DiagnosticSign" .. type
    				vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
					end

					local lsp = require('lspconfig')
          	local capabilities = require('cmp_nvim_lsp').default_capabilities()
          	lsp.pyright.setup{
        	  	capabilities = capabilities,
            	settings = {
              	update_in_insert = true,
              }
            }
            lsp.lua_ls.setup {
              capabilities = capabilities,
              settings = {
              	Lua = {
                	diagnostics = {
                  	-- Get the language server to recognize the 'vim' global
                    globals = { 'vim' },
                  },
									workspace = {
                  	-- make the server aware of the neovim runtime files
                    libary = vim.api.nvim_get_runtime_file('', true)
                  },
                  telemetry = {
                  	-- do not send telemetry data containing a randomized but unique identifier
                    enable = false,
                  }
								}
              }
            }
        end
      },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
    },
    config = function()
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require('cmp')
        local luasnip = require("luasnip")
        cmp.setup( {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = {
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                  -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                  -- this way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'nvim_lua' },
                { name = 'path' },
            }),
        })
    end
  },
  -- A super powerful autopair plugin for Neovim that supports multiple characters.
  {
  	'windwp/nvim-autopairs',
		config = function()
      require("nvim-autopairs").setup()
      -- inserts `(` after selecting a function or method item
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
  	end
  },
  -- Adds indentation guides to all lines.
  {
  	'lukas-reineke/indent-blankline.nvim',
  	main = "ibl",
		opt = {
			filetypes = {
				"help",
				"terminal",
				"alpha",
				"lazy",
				"NvimTree"
			}
		}
  },
  --
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
    	require('nvim-treesitter.configs').setup({
				auto_install = true,
				ensure_installed = { 'c', 'lua', 'vim'},
        highlight = {
        	enable = true,
        	use_languagetree = true
      	},
      	indent = { enable=true },
    	})
    end
  },
  -- A File Explorer for Neovim written in Lua
  {
		'nvim-tree/nvim-tree.lua',
    config = function ()
      -- disable netrw (inbuild file explorer)
      require('nvim-tree').setup({
				view = {
					width = 20,
					side = 'left',
				},
				disable_netrw = true,
				hijack_cursor = true,
				update_cwd = true,
				hijack_directories = {
					auto_open = true,
				},
				renderer = {
          root_folder_label = false,
					indent_markers = {
						enable = true,
						icons = {
							corner = "└ ",
        			edge = "│ ",
        			none = "  ",
						}
					}
				}
			})
    end
  },
  -- 
  {
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			require('telescope').setup({
				defaults = {
					mapping = {
					}
				},
				pickers = {
				},
				extensions = {
				}
			})
			vim.api.nvim_set_keymap('n', '<C-s>', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
		end
	},
	--
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup({})
		end
	},
	-- Customize start up screen
	{
		'goolord/alpha-nvim',
		event = 'VimEnter',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function ()
			local mew = {
				'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠞⢳⠀⠀⠀⠀⠀',
				'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠋⠀⢰⠎⠀⠀⠀⠀⠀',
				'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⢆⣤⡞⠃⠀⠀⠀⠀⠀⠀',
				'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⢠⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀',
				'⠀⠀⠀⠀⢀⣀⣾⢳⠀⠀⠀⠀⢸⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
				'⣀⡤⠴⠊⠉⠀⠀⠈⠳⡀⠀⠀⠘⢎⠢⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀',
				'⠳⣄⠀⠀⡠⡤⡀⠀⠘⣇⡀⠀⠀⠀⠉⠓⠒⠺⠭⢵⣦⡀⠀⠀⠀',
				'⠀⢹⡆⠀⢷⡇⠁⠀⠀⣸⠇⠀⠀⠀⠀⠀⢠⢤⠀⠀⠘⢷⣆⡀⠀',
				'⠀⠀⠘⠒⢤⡄⠖⢾⣭⣤⣄⠀⡔⢢⠀⡀⠎⣸⠀⠀⠀⠀⠹⣿⡀',
				'⠀⠀⢀⡤⠜⠃⠀⠀⠘⠛⣿⢸⠀⡼⢠⠃⣤⡟⠀⠀⠀⠀⠀⣿⡇',
				'⠀⠀⠸⠶⠖⢏⠀⠀⢀⡤⠤⠇⣴⠏⡾⢱⡏⠁⠀⠀⠀⠀⢠⣿⠃',
				'⠀⠀⠀⠀⠀⠈⣇⡀⠿⠀⠀⠀⡽⣰⢶⡼⠇⠀⠀⠀⠀⣠⣿⠟⠀',
				'⠀⠀⠀⠀⠀⠀⠈⠳⢤⣀⡶⠤⣷⣅⡀⠀⠀⠀⣀⡠⢔⠕⠁⠀⠀',
				'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠫⠿⠿⠿⠛⠋⠁⠀⠀⠀⠀',
				'',
			}
			local alpha = require('alpha')
			local dashboard = require('alpha.themes.dashboard')
			dashboard.section.header.val = mew
			dashboard.section.buttons.val = {
        dashboard.button('f', '  Find Files', ':Telescope find_files <CR>'),
        dashboard.button('r', '󱔗  Recent Files', ':Telescope oldfiles <CR>'),
        dashboard.button('u', '  Update Plugins', ':Lazy update <CR>'),
        dashboard.button('q', '  Quit Neovim', ':q! <CR>'),
			}
      dashboard.section.buttons.opts.spacing = 1
			dashboard.section.footer.val = 'Never knows best'
			dashboard.opts.opts.noautocmd = true
			alpha.setup(dashboard.opts)
		end
	},
	--
	{
		'tamton-aquib/staline.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function ()
      require "staline".setup {
        sections = {
          left = { ' ' },
          mid = {'lsp'},
          right = { 'line_column' }
        },
				lsp_symbols = { Error=" ", Info=" ", Warn=" ", Hint="" },
        defaults = {
          true_colors = true,
          line_column = ' ☰ %l/%L %c',
          branch_symbol = " ",
					exclude_fts = { 'NvimTree', 'Alpha' },
        },
      }
			-- remove background color
			vim.cmd('highlight Statusline guibg=none')
			vim.cmd('highlight StatuslineNC guibg=none')
    end
	},
})
