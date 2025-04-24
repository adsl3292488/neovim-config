return {
	{ 'williamboman/mason.nvim', config = true },
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
		},
		opts = function()
			-- local lspconfig_defaults = require('lspconfig').util.default_config
			-- local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
			lsp_capabilities.offsetEncoding = { 'utf-16' }
			local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

			vim.g.autoformatflag = false
			vim.api.nvim_create_user_command('SetAutoFormatEnable', function(opts)
				if (opts.args == 'true') then
					vim.g.autoformatflag = true
				elseif (opts.args == 'false') then
					vim.g.autoformatflag = false
				else
					print('Invalid argument, use true or false')
				end
			end, { nargs = '?' })

			vim.keymap.set("v", "ff", function()
				vim.lsp.buf.format({ async = false })
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
			end)

			return {
				ensure_installed = {
					'clangd',
					'lua_ls',
					'pyright',
					'bashls',
					'jsonls',
					'markdown_oxide',
				},
				handlers = {
					function(server_name)
						-- lspconfig_defaults.capabilities = vim.tbl_deep_extend("force",
						-- 	lspconfig_defaults.capabilities,
						-- 	lsp_capabilities)
						lsp_capabilities = vim.tbl_deep_extend("force", lsp_capabilities,
							require('blink.cmp').get_lsp_capabilities(
								{ textDocumet = { completion = { completionItem = { snippetSupport = false } } } }, false))

						vim.lsp.config(server_name, {
							root_markers = { '.git', '.root' },
							capabilities = lsp_capabilities,
							on_attach = function(_, bufnr)
								vim.api.nvim_create_autocmd("BufWritePre", {
									group = augroup,
									buffer = bufnr,
									callback = function()
										if (vim.g.autoformatflag == true) then
											vim.lsp.buf.format({ async = false, bufnr = bufnr })
										end
									end
								})
							end,
							settings = {
								Lua = {
									runtime = {
										version = 'LuaJIT',
									},
									completion = {
										callSnippet = "Both"
									},
									diagnostics = {
										globals = { "vim", "Snacks" }
									}
								},
							}
						})
						vim.lsp.enable(server_name)
					end,
				},
			}
		end,
	},
	{
		'saghen/blink.cmp',
		dependencies = {
			{ 'rafamadriz/friendly-snippets' },
			{ 'L3MON4D3/LuaSnip',            version = 'v2.*', build = "make install jsregexp" },
			-- 'mikavilpas/blink-ripgrep.nvim'
		},
		version = '1.*',
		opts = {
			-- sources = {
			-- 	default = {
			-- 		"lsp",
			-- 		"snippets",
			-- 		"buffer",
			-- 		"path",
			-- 		-- "ripgrep",
			-- 	},
			-- providers = {
			-- 	ripgrep = {
			-- 		module = "blink-ripgrep",
			-- 		name = "Ripgrep",
			-- 		opts = {
			-- 			prefix_min_len = 3,
			-- 			context_size = 5,
			-- 			max_filesize = "1M",
			-- 			project_root_markers = { ".git", "compile_commands.json", ".root" },
			-- 			search_casing = "--ignore-case", -- smart-case,case-sensitive
			-- 		}
			-- 	},
			-- }
			snippets = {
				-- preset = "luasnip"
				expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
				active = function(filter)
					if filter and filter.direction then
						return require('luasnip').jumpable(filter.direction)
					end
					return require('luasnip').in_snippet()
				end,
				jump = function(direction) require('luasnip').jump(direction) end,
			},
			keymap = {
				preset = 'enter',
				['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
				['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
			},
			completion = {
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
					show_on_accept_on_trigger_character = true,
					show_in_snippet = true,
				},
				list = {
					selection = { preselect = true, auto_insert = true }
				},
				menu = {
					auto_show = true,
					border = "rounded",
					draw = {
						columns = {
							{ "label",     "label_description", gap = 1 },
							{ "kind_icon", gap = 1,             "kind" }
						},
						treesitter = { 'lsp' },
					}
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				ghost_text = {
					enabled = false,
					show_with_menu = false,
				}
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				max_typos = function(keyword) return math.floor(#keyword / 4) end,
				use_frecency = false,
				use_proximity = false,
				sorts = {
					'exact',
					'score',
					'sort_text',
				},
				prebuilt_binaries = {
					download = true,
					ignore_version_mismatch = false,
				},
			},
			signature = {
				enabled = true,
			},
			cmdline = {
				enabled = true,
				completion = {
					menu = {
						auto_show = true,
					},
					list = {
						selection = { preselect = false, auto_insert = true }
					},
					ghost_text = {
						enabled = true,
					}
				},
				keymap = {
					preset = 'cmdline',
				}
			},
		}
	}
	-- {
	-- 	'hrsh7th/nvim-cmp',
	-- 	event = { 'InsertEnter', 'CmdlineEnter' },
	-- 	dependencies = {
	-- 		{ 'hrsh7th/cmp-nvim-lsp' },
	-- 		{ 'hrsh7th/cmp-nvim-lua' },
	-- 		{ 'hrsh7th/cmp-buffer' },
	-- 		{ 'hrsh7th/cmp-path' },
	-- 		{ 'hrsh7th/cmp-cmdline' },
	-- 		{ 'saadparwaiz1/cmp_luasnip' },
	-- 		{ 'onsails/lspkind.nvim' },
	-- 		{ 'L3MON4D3/LuaSnip',            tag = 'v2.3.0', build = 'make install_jsregexp' },
	-- 		{ 'rafamadriz/friendly-snippets' }
	-- 	},
	-- 	opts = function()
	-- 		local cmp = require('cmp')
	-- 		local lspkind = require('lspkind')
	-- 		local luasnip = require('luasnip')
	-- 		require("luasnip.loaders.from_vscode").lazy_load()
	--
	-- 		return {
	-- 			sources = {
	-- 				{ name = 'nvim_lsp' },
	-- 				{ name = 'nvim_lua' },
	-- 				{ name = 'buffer',  keyword_length = 3 },
	-- 				{ name = 'luasnip' },
	-- 				{ name = 'path',    keyword_length = 3 },
	-- 			},
	-- 			-- completion = { autocomplete = false },
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			window = {
	-- 				completion = cmp.config.window.bordered(),
	-- 				documentation = cmp.config.window.bordered(),
	-- 			},
	-- 			formatting = {
	-- 				format = lspkind.cmp_format {
	-- 					with_text = true,
	-- 					menu = {
	-- 						buffer = "[Buffer]",
	-- 						nvim_lsp = "[LSP]",
	-- 						nvim_lua = "[Lua]",
	-- 						luasnip = "[LuaSnip]",
	-- 						path = "[Path]",
	-- 					},
	-- 				},
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				['<CR>'] = cmp.mapping(function(fallback)
	-- 					if (cmp.visible()) then
	-- 						if (luasnip.expandable()) then
	-- 							luasnip.expand()
	-- 						else
	-- 							cmp.confirm({
	-- 								select = true,
	-- 								behavior = cmp.ConfirmBehavior.Insert
	-- 							})
	-- 						end
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end),
	-- 				['<Tab>'] = cmp.mapping(function(fallback)
	-- 					if (cmp.visible()) then
	-- 						cmp.select_next_item()
	-- 					elseif (luasnip.expand_or_locally_jumpable()) then
	-- 						luasnip.jump(1)
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { "i", "s", "c" }),
	-- 				['<S-Tab>'] = cmp.mapping(function(fallback)
	-- 					if (cmp.visible()) then
	-- 						cmp.select_prev_item()
	-- 					elseif (luasnip.locally_jumpable(-1)) then
	-- 						luasnip.jump(-1)
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { "i", "s", "c" }),
	-- 				["<C-d>"] = cmp.mapping.scroll_docs(-4),
	-- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 			}),
	-- 			cmp.setup.cmdline(':', {
	-- 				sources = {
	-- 					{ name = 'cmdline' },
	-- 					{ name = 'path' },
	-- 				}
	-- 			}),
	-- 			cmp.setup.cmdline({ '/', '?' }, {
	-- 				sources = {
	-- 					{ name = 'buffer' }
	-- 				}
	-- 			})
	-- 		}
	-- 	end,
	-- },
}
