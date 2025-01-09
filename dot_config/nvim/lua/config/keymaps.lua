-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume telescope" }
)
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
-- vim.keymap.set(
--   "n",
--   "<leader>?",
--   "<cmd>Telescope keymaps<CR>",
--   { desc = "Show keymaps" }
-- )
vim.keymap.set(
  "n",
  "<leader>om",
  "<cmd>!zellij run -d right -- glow -p % <CR>",
  { desc = "Preview [m]arkdown on new pane" }
)

vim.keymap.set(
  "x",
  "<leader>te",
  [["_dP]],
  { desc = "Yank and paste properly" }
)

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "keep cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "keep cursor centered" })
vim.keymap.set(
  "n",
  "<BS>",
  "db",
  { desc = "Move to the first non-blank character" }
)

vim.keymap.set("i", "<c-y>", function()
  require("telescope.builtin").registers()
end, { remap = true, silent = false, desc = "paste register i insert mode" })
