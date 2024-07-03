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
vim.keymap.set("n", "<leader>?", "<cmd>Telescope keymaps<CR>", { desc = "Show keymaps" })
vim.keymap.set(
  "n",
  "<leader>tm",
  "<cmd>!zellij run -d right -- glow -p % <CR>",
  { desc = "Preview markdown on new pane" }
)
