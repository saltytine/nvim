--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/lualine.lua
-- Description: Pacman config for lualine
-- Credit: shadmansaleh & his evil theme: https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
local lualine = require "lualine"
local lualine_require = require "lualine_require"
local utils = require "utils"

local function loadcolors()
  local colors = {
    bg      = '#262626', -- Background
    fg      = '#d0d0d0', -- Foreground
    yellow  = '#d7af5f',
    cyan    = '#5fafd7',
    black   = '#1c1c1c',
    green   = '#5faf5f',
    white   = '#d0d0d0',
    magenta = '#af5faf',
    blue    = '#5f87af',
    red     = '#af5f5f',
  }

  -- Try to load pywal colors
  local modules = lualine_require.lazy_require {
    utils_notices = "lualine.utils.notices",
  }
  local sep = package.config:sub(1, 1)
  local wal_colors_path = table.concat({ os.getenv "HOME", ".cache", "wal", "colors.sh" }, sep)
  local wal_colors_file = io.open(wal_colors_path, "r")

  if wal_colors_file == nil then
    modules.utils_notices.add_notice("lualine.nvim: " .. wal_colors_path .. " not found")
    return colors
  end

  local ok, wal_colors_text = pcall(wal_colors_file.read, wal_colors_file, "*a")
  wal_colors_file:close()

  if not ok then
    modules.utils_notices.add_notice(
      "lualine.nvim: " .. wal_colors_path .. " could not be read: " .. wal_colors_text
    )
    return colors
  end

  local wal = {}

  for line in vim.gsplit(wal_colors_text, "\n") do
    if line:match "^[a-z0-9]+='#[a-fA-F0-9]+'$" ~= nil then
      local i = line:find "="
      local key = line:sub(0, i - 1)
      local value = line:sub(i + 2, #line - 1)
      wal[key] = value
    end
  end

  -- Color table for highlights
  colors = {
    bg = wal.background,
    fg = wal.foreground,
    yellow = wal.color3,
    cyan = wal.color4,
    black = wal.color0,
    green = wal.color2,
    white = wal.color7,
    magenta = wal.color5,
    blue = wal.color6,
    red = wal.color1,
  }

  return colors
end

local colors = loadcolors()

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand "%:t") ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "Lazy", "NvimTree" },
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = {
        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },
      inactive = {
        c = {
          fg = colors.fg,
          bg = colors.bg,
        },
      },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  tabline = {
    lualine_a = {
      {
        "buffers",
        max_length = vim.o.columns * 2 / 3,
        show_filename_only = false,
        mode = 0, -- 0: Shows buffer name
        -- 1: Shows buffer index
        -- 2: Shows buffer name + buffer index
        -- 3: Shows buffer number
        -- 4: Shows buffer name + buffer number

        right_padding = 5,
        left_padding = 5,

        -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
        use_mode_colors = true,
        buffers_color = {
          -- Same values as the general color option can be used here.
          active = {
            fg = colors.fg,
            bg = colors.bg,
            gui = "bold",
          }, -- Color for active buffer.
          inactive = {
            fg = utils.darken(colors.fg, 0.3),
            bg = utils.darken(colors.bg, 0.3),
          }, -- Color for inactive buffer.
        },
        symbols = {
          modified = " ●", -- Text to show when the buffer is modified
          alternate_file = "", -- Text to show to identify the alternate file
          directory = "", -- Text to show when the buffer is a directory
        },
      },
    },
  },

  extensions = {
    "nvim-tree",
    "mason",
    "fzf",
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component) table.insert(config.sections.lualine_c, component) end

-- Inserts a component in lualine_x ot right section
local function ins_right(component) table.insert(config.sections.lualine_x, component) end

ins_left {
  -- mode component
  function() return "vim" end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.fg,
      i = colors.green,
      v = colors.blue,
      [""] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.yellow,
      S = colors.yellow,
      [""] = colors.yellow,
      ic = colors.yellow,
      R = colors.white,
      Rv = colors.white,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    return {
      fg = mode_color[vim.fn.mode()],
    }
  end,
}

ins_left {
  "branch",
  icon = " ",
  color = {
    fg = colors.magenta,
    gui = "bold",
  },
}

ins_left {
  "diff",
  -- Is it me or the symbol for modified us really weird
  symbols = { added = " ", modified = "󰝤 ", removed = " " },
  diff_color = {
    added = {
      fg = colors.green,
    },
    modified = {
      fg = colors.yellow,
    },
    removed = {
      fg = colors.red,
    },
  },
  cond = conditions.hide_in_width,
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it"s any number greater then 2
ins_left { function() return "%=" end }

ins_right {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = {
    error = " ",
    warn = " ",
    info = " ",
    hints = "󰛩 ",
  },
  diagnostics_color = {
    color_error = {
      fg = colors.red,
    },
    color_warn = {
      fg = colors.yellow,
    },
    color_info = {
      fg = colors.cyan,
    },
    color_hints = {
      fg = colors.magenta,
    },
  },
  always_visible = false,
}

ins_right {
  "fileformat",
  fmt = string.upper,
  icons_enabled = true,
  color = {
    fg = colors.green,
    gui = "bold",
  },
}

ins_right {
  "location",
  color = {
    fg = colors.fg,
    gui = "bold",
  },
}

ins_right {
  "progress",
  color = {
    fg = colors.fg,
    gui = "bold",
  },
}

-- Now don"t forget to initialize lualine
lualine.setup(config)
