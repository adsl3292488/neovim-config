return {
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
		},
		opts = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

			capabilities = vim.tbl_deep_extend(
				"force",
				capabilities,
				require("blink.cmp").get_lsp_capabilities(
					{ textDocumet = { completion = { completionItem = { snippetSupport = false } } } },
					false
				)
			)

			vim.lsp.config("*", {
				root_markers = { ".git", ".root" },
				capabilities = capabilities,
			})
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						completion = {
							callSnippet = "Both",
						},
						diagnostics = {
							globals = { "vim", "Snacks" },
						},
					},
				},
			})
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--clang-tidy",
					"--background-index",
					"--offset-encoding=utf-8",
				},
				root_markers = { ".clangd", "compile_commands.json", ".git", ".root" },
				filetypes = { "c", "cpp" },
			})

			vim.g.AutoFormatFlag = true
			vim.api.nvim_create_user_command("SetAutoFormatEnable", function(opts)
				if opts.args == "true" then
					vim.g.AutoFormatFlag = true
				elseif opts.args == "false" then
					vim.g.AutoFormatFlag = false
				else
					print("Invalid argument, use true or false")
				end
			end, {
				nargs = "?",
				complete = function()
					return { "true", "false" }
				end,
			})

			return {
				ensure_installed = {
					"clangd",
					"lua_ls",
					"pyright",
					"bashls",
					"jsonls",
					"markdown_oxide",
				},
			}
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			{
				"stevearc/conform.nvim",
				event = "BufWritePre",
				opts = {
					formatters_by_ft = {
						cpp = { "clang_format" },
						c = { "clang_format" },
						python = { "black" },
						lua = { "stylua" },
						sh = { "shfmt" },
						markdown = { "prettierd" },
						makefile = { "bake" },
					},
					format_on_save = function(bufnr)
						if vim.g.AutoFormatFlag == true then
							return { timeout_ms = 500, bufnr = bufnr, lsp_format = "fallback" }
						end
						return
					end,
				},
				keys = {
					{
						"gq",
						function()
							require("conform").format({ async = true }, function(err)
								if not err then
									local mode = vim.api.nvim_get_mode().mode
									if vim.startswith(string.lower(mode), "v") then
										vim.api.nvim_feedkeys(
											vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
											"n",
											true
										)
									end
								end
							end)
						end,
						mode = { "n", "v" },
						desc = "Format file",
					},
				},
			},
			-- 'mikavilpas/blink-ripgrep.nvim'
		},
		version = "1.*",
		opts = {
			sources = {
				providers = {
					buffer = {
						min_keyword_length = 3,
					},
				},
			},
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
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			keymap = {
				preset = "enter",
				["<Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_next()
						else
							return cmp.snippet_forward()
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						else
							return cmp.snippet_backward()
						end
					end,
					"fallback",
				},
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
					selection = { preselect = true, auto_insert = true },
				},
				menu = {
					auto_show = true,
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", gap = 1, "kind" },
						},
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				ghost_text = {
					enabled = false,
					show_with_menu = false,
				},
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				max_typos = function(keyword)
					return math.floor(#keyword / 4)
				end,
				frecency = {
					enabled = false,
				},
				use_proximity = false,
				sorts = {
					"exact",
					"score",
					"sort_text",
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
						selection = { preselect = false, auto_insert = true },
					},
					ghost_text = {
						enabled = true,
					},
				},
				keymap = {
					preset = "cmdline",
				},
			},
		},
	},
}
