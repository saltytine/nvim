-- <leader> is a space now
local map = vim.keymap.set
local cmd = vim.cmd

-- <leader> and x exits nvim alltogether
-- <leader> and q exits the current file
map("n", "<leader>x", ":qa!<CR>", {})
map("n", "<leader>q", ":q!<CR>", {})
-- Fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>", {})
-- Move around splits
map("n", "<leader>u", "<C-w>k", { desc = "switch window up (top row)" })
map("n", "<leader>h", "<C-w>h", { desc = "switch window left (top row)" })
map("n", "<leader>j", "<C-w>j", { desc = "switch window down (top row)" })
map("n", "<leader>k", "<C-w>l", { desc = "switch window right (top row)" })
map("n", "<leader>d", ":vsplit ", {})
map("n", "<C-Right>", "$", {})
map("n", "<C-Left>", "0", {})
map("n", "<S-Right>", "w", {})
map("n", "<S-Left>", "b", {})
map("v", "<S-Right>", "w", {})
map("v", "<S-Left>", "b", {})
map("v", "<C-Right>", "$", {})
map("v", "<C-Left>", "0", {})
map("i", "<S-Right>", "<C-o>w", {})
map("i", "<S-Left>", "<C-o>b", {})
map("i", "<C-Right>", "<C-o>$", {})
map("i", "<C-Left>", "<C-o>0", {})
map("v", "<Tab>", ">gv", {})
map("v", "<leader><Tab>", "<gv", {})
map("n", "<leader><Up>", "gg0", {})
map("n", "<leader><Down>", "G$", {})
map("v", "<leader><Up>", "gg0", {})
map("v", "<leader><Down>", "G$", {})
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", {})
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", {})
map("n", "<C-w>", "@w", {})
map("i", "<C-c>", "<C-c>l", {})
map("n", "<leader>w", ":let @w = ''<CR>", {})
map("n", "<leader>e", ":Ex<CR>", {})

map("n", "<leader>=", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<leader>-", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<leader>==", "<cmd>vertical resize +5<CR>", { desc = "Increase window width" })
map("n", "<leader>--", "<cmd>vertical resize -5<CR>", { desc = "Decrease window width" })

-- Reload configuration without restart nvim
-- Or you don't want to use plenary.nvim, you can use this code
-- function _G.reload_config()
-- 	for name, _ in pairs(package.loaded) do
-- 		if name:match("^me") then
-- 			package.loaded[name] = nil
-- 		end
-- 	end

-- 	dofile(vim.env.MYVIMRC)
-- 	vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
-- end
function _G.reload_config()
  local reload = require("plenary.reload").reload_module
  reload("me", false)

  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

map("n", "rr", _G.reload_config, { desc = "Reload configuration without restart nvim" })

-- Telescope
local builtin = require "telescope.builtin"
map("n", "<leader>f", builtin.find_files, { desc = "Open Telescope to find files" })
map("n", "<leader>g", builtin.live_grep, { desc = "Open Telescope to do live grep" })
map("n", "<leader>b", builtin.buffers, { desc = "Open Telescope to list buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Open Telescope to show help" })
map("n", "<leader>fo", builtin.oldfiles, { desc = "Open Telescope to list recent files" })
map("n", "<leader>cm", builtin.git_commits, { desc = "Open Telescope to list git commits" })

-- LSP
map(
  "n",
  "<leader>gm",
  function() require("conform").format { lsp_fallback = true } end,
  { desc = "General Format file" }
)

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP Diagnostic loclist" })

-- Comment
map("n", "mm", "gcc", { desc = "Toggle comment", remap = true })
map("v", "mm", "gc", { desc = "Toggle comment", remap = true })

-- Terminal
map("n", "tt", function()
  local height = math.floor(vim.o.lines / 2)
  cmd("belowright split | resize " .. height .. " | terminal")
end, { noremap = true, silent = true })
