local lsp_zero = require('lsp-zero')

--lsp_zero.on_attach(function(client, bufnr)
--  lsp_zero.default_keymaps({buffer = bufnr})
--end)

----------------------------------
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'ts_ls',
		'clangd',
		'lua_ls',
		'jsonls',
		'bashls',
		'remark_ls',
		'pyright'
	},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({
				root_dir = require('lspconfig/util').root_pattern('.git', '.root'),
				capabilities = lsp_capabilities,
				on_attach = function(_, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end
					})
				end,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Both"
						},
						diagnostics = {
							globals = { "vim" }
						}
					},
				}
			})
		end
	},
	lua_ls = function()
		local lua_opts = lsp_zero.nvim_lua_ls()
		require('lspconfig').lua_ls.setup(lua_opts)
	end
})

--------- auto Completion --------
local cmp = require('cmp')
-- local cmp_action = require('lsp-zero').cmp_action()
local luasnip = require('luasnip')
local lspkind = require('lspkind')
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'buffer',  keyword_length = 3 },
		{ name = 'luasnip' },
		{ name = 'path' },
	},
	snippet = {
		expand = function(args)
			require 'luasnip'.lsp_expand(args.body)
		end,
	},
	--	completion = {autocomplete = false},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping(function(fallback)
			if (cmp.visible()) then
				if (luasnip.expandable()) then
					luasnip.expand()
				else
					cmp.confirm({
						select = true,
						behavior = cmp.ConfirmBehavior.Insert,
					})
				end
			else
				fallback()
			end
		end),
		["<C-space>"] = cmp.mapping.complete(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		-- ['<Tab>'] = cmp.mapping(function (fallback)
		-- 	if (cmp.visible()) then
		-- 		cmp.select_next_item()
		-- 	elseif (luasnip.locally_jumpable(1)) then
		-- 		luasnip.jump(1)
		-- 	else
		-- 		fallback()
		-- 	end
		-- 	end,{"i","s"}),
		-- ['<S-Tab>'] = cmp.mapping(function (fallback)
		-- 	if(cmp.visible()) then
		-- 		cmp.select_prev_item()
		-- 	elseif luasnip.locally_jumpable(-1) then
		-- 		luasnip.jump(-1)
		-- 	else
		-- 		fallback()
		-- 	end
		-- 	end,{"i","s"}),

		["<Tab>"] = cmp.mapping(function(fallback)
			if (cmp.visible()) then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if (cmp.visible()) then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['\\]'] = cmp.mapping(function()
			luasnip.jump(1)
		end, { 'i', 's' }),
		['\\['] = cmp.mapping(function()
			luasnip.jump(-1)
		end, { 'i', 's' }),
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
	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[api]",
				luasnip = "[snip]",
			},
		},
	},
})
cmp.setup.cmdline(':', {
	sources = {
		{ name = 'path' },
		{ name = 'cmdline' }
	}
})
cmp.setup.cmdline({ '/', '?' }, {
	sources = {
		{ name = 'buffer' }
	}
})
