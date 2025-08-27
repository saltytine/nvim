-- Built-in plugins
local builtin_plugins = {
  { "nvim-lua/plenary.nvim" },
  { "saltytine/todo-by-file" },
  { "saltytine/marked" },
  { "theprimeagen/harpoon" },
  { "tpope/vim-fugitive" },
  { "Eandrju/cellular-automaton.nvim" },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    config = function()
      require("peek").setup({
        filetype = { 'markdown', 'conf' }
      })
      vim.api.nvim_create_user_command("MDPreview", require("peek").open, {})
      vim.api.nvim_create_user_command("MDClose", require("peek").close, {})
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      local sm = require("supermaven-nvim")
      local api = require("supermaven-nvim.api")
      local cmp = require("cmp")

      sm.setup({})

      vim.api.nvim_create_user_command("Ap", function()
        if api.is_running() then
          api.stop()
          cmp.setup.buffer({ enabled = true })
          print("SuperMaven disabled, cmp enabled")
        else
          api.start()
          cmp.setup.buffer({ enabled = false })
          print("SuperMaven enabled, cmp disabled")
        end
      end, {})
    end,
  },

  -- File explore
  -- nvim-tree.lua - A file explorer tree for neovim written in lua
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --     opt = true,
  --   },
  --   opts = function() require "plugins.configs.tree" end,
  -- },
  -- Formatter
  -- Lightweight yet powerful formatter plugin for Neovim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
    },
  },
  -- Git integration for buffers
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  --   opts = function() require "plugins.configs.gitsigns" end,
  -- },
    -- Treesitter interface
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    evevent = { "BufReadPost", "BufNewFile", "BufWritePost" },
    cmd = { "TSInstall", "TSUpdate", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function() require "plugins.configs.treesitter" end,
  },
  -- Telescope
  -- Find, Filter, Preview, Pick. All lua, all the time.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    config = function(_)
      require("telescope").setup()
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension "fzf"
      require "plugins.configs.telescope"
    end,
  },
  -- Statusline
  -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = function() require "plugins.configs.lualine" end,
  -- },
  -- colorscheme
  {
    -- Rose-pine - Soho vibes for Neovim
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      dark_variant = "main",
    },
  },
  -- LSP stuffs
  -- Portable package manager for Neovim that runs everywhere Neovim runs.
  -- Easily install and manage LSP servers, DAP servers, linters, and formatters.
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    -- config = function() require "plugins.configs.mason" end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    lazy = true,
    config = function() require "plugins.configs.null-ls" end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VimEnter",
    lazy = false,
    config = function() require "plugins.configs.lspconfig" end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "plugins.configs.luasnip"
        end,
      },


      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind.nvim",
      },
    },
    opts = function() require "plugins.configs.cmp" end,
  },
  -- autopairing of (){}[] etc
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require ("nvim-autopairs").setup ({}) end,
  },
  -- Colorizer
  {
    "norcalli/nvim-colorizer.lua",
    config = function(_)
      require("colorizer").setup()

      -- execute colorizer as soon as possible
      vim.defer_fn(function() require("colorizer").attach_to_buffer(0) end, 0)
    end,
  },
  -- Keymappings
  -- which-key.nvim removed to disable keymap popup
}

local colorscheme_plugins = require("colors")

local exist, custom = pcall(require, "custom")
local custom_plugins = exist and type(custom) == "table" and custom.plugins or {}

-- Check if there is any custom plugins
-- local ok, custom_plugins = pcall(require, "plugins.custom")
require("lazy").setup {
  spec = { builtin_plugins, colorscheme_plugins, custom_plugins },
  lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json", -- lockfile generated after running update.
  defaults = {
    lazy = false,                                          -- should plugins be lazy-loaded?
    version = nil,
    -- version = "*", -- enable this to try installing the latest stable versions of plugins
  },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠",
      loaded = "",
      not_loaded = "",
    },
  },
  install = {
    -- install missing plugins on startup
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "rose-pine", "habamax" },
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    -- get a notification when new updates are found
    -- disable it as it's too annoying
    notify = false,
    -- check for updates every day
    frequency = 86400,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    -- get a notification when changes are found
    -- disable it as it's too annoying
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
  state = vim.fn.stdpath "state" .. "/lazy/state.json", -- state info for checker and other things
}
