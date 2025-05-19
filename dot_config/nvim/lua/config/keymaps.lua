-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.set(
--   "n",
--   "<leader>sx",
--   require("telescope.builtin").resume,
--   { noremap = true, silent = true, desc = "Resume telescope" }
-- )
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
-- vim.keymap.set(
--   "n",
--   "<leader>?",
--   "<cmd>Telescope keymaps<CR>",
--   { desc = "Show keymaps" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>om",
--   "<cmd>!zellij run -d right -- glow -p % <CR>",
--   { desc = "Preview [m]arkdown on new pane" }
-- )

vim.keymap.set(
  "n",
  "<leader>om",
  "<cmd>!tmux split-window -h; tmux send -t2 'glow -p %' Enter <CR>",
  { desc = "Preview [m]arkdown on new pane" }
)

vim.keymap.set(
  "n",
  "<leader>ct",
  "<cmd>!~/.local/bin/task-annotate.sh '%:p' <CR>",
  { desc = "Add current file to a new taskwarrior task" }
)

vim.keymap.set(
  "x",
  "<leader>te",
  [["_dP]],
  { desc = "Yank and paste properly" }
)

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })
-- vim.keymap.set("n", "n", "nzzzv", { desc = "keep cursor centered" })
-- vim.keymap.set("n", "N", "Nzzzv", { desc = "keep cursor centered" })
vim.keymap.set(
  "n",
  "<BS>",
  "db",
  { desc = "Delete back until the first non-blank character" }
)

-- vim.keymap.set("i", "<c-y>", function()
--   require("telescope.builtin").registers()
-- end, { remap = true, silent = false, desc = "paste register i insert mode" })

vim.keymap.set("n", "<leader>mb", function()
  vim.opt.spelllang = "en,es"
  vim.cmd("echo 'Spell language set to Spanish and English'")
end, { desc = "Spelling language Spanish and English" })

vim.keymap.set("n", "<leader>me", function()
  vim.opt.spelllang = "en"
  vim.cmd("echo 'Spell language set to English'")
end, { desc = "Spelling language English" })

vim.keymap.set("n", "<leader>ms", function()
  vim.opt.spelllang = "es"
  vim.cmd("echo 'Spell language set to Spanish'")
end, { desc = "Spelling language Spanish" })

vim.keymap.set(
  "n",
  "<leader>mr",
  "1z=",
  { desc = "Auto replace first spelling option" }
)

vim.keymap.set("n", "<leader>mn", "[s", { desc = "Next spelling option" })
