return {
	{ 'williamboman/mason.nvim', config = true },
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
		},
		opts = function()
			local lspconfig_defaults = require('lspconfig').util.default_config
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
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
			end, { nargs = 1 })

			vim.keymap.set("v", "ff",function ()
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
					'remark_ls',
				},
				handlers = {
					function(server_name)
						lspconfig_defaults.capabilities = vim.tbl_deep_extend("force",
							lspconfig_defaults.capabilities,
							lsp_capabilities)

						require('lspconfig')[server_name].setup({
							root_dir = require('lspconfig/util').root_pattern('.git', '.root'),
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
										globals = { "vim","Snacks" }
									}
								},
							}
						})
					end,
				},
			}
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		event = { 'InsertEnter', 'CmdlineEnter' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'hrsh7th/cmp-cmdline' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'onsails/lspkind.nvim' },
			{ 'L3MON4D3/LuaSnip',            tag = 'v2.3.0', build = 'make install_jsregexp' },
			{ 'rafamadriz/friendly-snippets' }
		},
		opts = function()
			local cmp = require('cmp')
			local lspkind = require('lspkind')
			local luasnip = require('luasnip')
			require("luasnip.loaders.from_vscode").lazy_load()

			return {
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'buffer',  keyword_length = 3 },
					{ name = 'luasnip' },
					{ name = 'path',    keyword_length = 3 },
				},
				-- completion = { autocomplete = false },
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format {
						with_text = true,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							luasnip = "[LuaSnip]",
							path = "[Path]",
						},
					},
				},
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping(function(fallback)
						if (cmp.visible()) then
							if (luasnip.expandable()) then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
									behavior = cmp.ConfirmBehavior.Insert
								})
							end
						else
							fallback()
						end
					end),
					['<Tab>'] = cmp.mapping(function(fallback)
						if (cmp.visible()) then
							cmp.select_next_item()
						elseif (luasnip.expand_or_locally_jumpable()) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if (cmp.visible()) then
							cmp.select_prev_item()
						elseif (luasnip.locally_jumpable(-1)) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					['\\]'] = cmp.mapping(function(fallback)
						if (luasnip.expandable(1)) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { 'i', 's' }),
					['\\['] = cmp.mapping(function(fallback)
						if (luasnip.jumpable(-1)) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					['<A-n>'] = cmp.mapping(function(fallback)
						if (cmp.visible()) then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'c' }),
					['<A-m>'] = cmp.mapping(function(fallback)
						if (cmp.visible()) then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { 'c' }),
				}),
				cmp.setup.cmdline(':', {
					sources = {
						{ name = 'cmdline' },
						{ name = 'path' },
					}
				}),
				cmp.setup.cmdline({ '/', '?' }, {
					sources = {
						{ name = 'buffer' }
					}
				})
			}
		end,
	},
}
