-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local au = vim.api.nvim_create_autocmd
-- Auto cd to current buffer path
au("BufEnter", {
  pattern = "*",
  command = "silent! lcd %:p:h",
})

-- Update file on external changes
au({ "FocusGained", "TermClose", "TermLeave" }, {
  pattern = "<buffer>",
  command = "checktime",
})

-- Trim trailing whitespaces
au("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.api.nvim_exec2([[keepjumps keeppatterns silent! %s/\s\+$//e]], {})
    vim.fn.winrestview(save)
  end,
})

au("BufEnter", {
  pattern = "*",
  command = "Neotree close",
})
