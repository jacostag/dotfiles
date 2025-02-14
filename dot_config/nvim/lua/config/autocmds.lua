-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local au = vim.api.nvim_create_autocmd

-- Update file on external changes
au({ "FocusGained", "TermClose", "TermLeave" }, {
  pattern = "<buffer>",
  command = "checktime",
})

-- Trim trailing whitespaces
-- au("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     local save = vim.fn.winsaveview()
--     vim.api.nvim_exec2([[keepjumps keeppatterns silent! %s/\s\+$//e]], {})
--     vim.fn.winrestview(save)
--   end,
-- })

au("BufEnter", {
  pattern = "*.md",
  command = "set colorcolumn=80 textwidth=80 linebreak",
})

au("BufEnter", {
  pattern = "*",
  command = "set colorcolumn=80",
})

au({ "TextChanged", "TextChangedI" }, {
  pattern = { "*.md", "*.norg" },
  command = "silent write",
})

au({ "TextChanged", "TextChangedI" }, {
  pattern = "*.norg",
  command = "Neorg update-metadata",
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*.norg",
--   callback = function()
--     require("cmp").setup.buffer({
--       sources = { name = "neorg" },
--     })
--   end,
-- })

au("BufNewFile", {
  pattern = "*.norg",
  command = "Neorg inject-metadata",
})

au("BufEnter", {
  pattern = "~/scratch.scratch",
  command = "setlocal noswapfile | setlocal buftype=nofile | setlocal bufhidden=hide",
})

-- wrap and check for spell in norg and neorg filetypes
au("FileType", {
  pattern = { "norg", "neorg" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

--the idea is to sync system and nvim clipboard only when is gaining or loosing focus
-- vim.api.nvim_create_autocmd({ "FocusGained" }, {
--   group = vim.api.nvim_create_augroup(
--     "clipboard-sync-to-register",
--     { clear = true }
--   ),
--   callback = function()
--     vim.cmd(':let @+=@"')
--     vim.notify("Copy from Clipboard to Register", "info")
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "FocusLost" }, {
--   group = vim.api.nvim_create_augroup(
--     "register-sync-to-clipboard",
--     { clear = true }
--   ),
--   callback = function()
--     vim.cmd(':let @"=@+')
--     vim.notify("Copy from Register to Clipboard", "info")
--   end,
-- })
