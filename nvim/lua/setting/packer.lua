vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	---- Fuzzy Finder ----
	--	use {
	--		'nvim-telescope/telescope.nvim', tag = '0.1.6',
	--		-- or                            , branch = '0.1.x',
	--		requires = { {'nvim-lua/plenary.nvim'} }
	--	}
--    use { "ryanoasis/vim-devicons"}
	use { "ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "nvim-tree/nvim-web-devicons" }
	}
	use { "junegunn/fzf", run = "./install --bin" }
	---- Color Scheme ---- 
	use { 'rose-pine/neovim',as = 'rose-pine'}
	use { 'catppuccin/nvim' ,as = 'catppuccin'}
	use { 'folke/tokyonight.nvim', as='tokyonight'}
	use { 'rebelot/kanagawa.nvim'}
	---- TreeSitter ----
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use ('nvim-treesitter/playground')
	---- harpoon -----
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires =  {"nvim-lua/plenary.nvim"}
	}
	---- lsp-zero ----
	use ('mbbill/undotree')
	use ('tpope/vim-fugitive')
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
			{'neovim/nvim-lspconfig'},
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'onsails/lspkind.nvim'},
			{'L3MON4D3/LuaSnip',tag = 'v2.3.0',run = 'make install_jsregexp'},
			{'rafamadriz/friendly-snippets'}
		},
	}
	use {
		"github/copilot.vim"
	}
use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
        "nvim-lua/plenary.nvim",
    },
})
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use {'stevearc/dressing.nvim'}
	use {"akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end}
end)
