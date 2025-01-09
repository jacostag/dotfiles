--- commands.lua - Commands
--
-- Author:  NTBBloodbath <bloodbathalchemist@protonmail.com>
-- URL:     https://github.com/NTBBloodbath/nvim
-- License: GPLv3
--
--- Code:
local home_dir = os.getenv("HOME")
package.path = package.path .. home_dir .. "/.config/nvim/lua/config/?.lua;"

vim.api.nvim_create_user_command("SudoWrite", function()
  require("sudo_write").write()
end, { desc = "Write file with sudo permissions" })

-- local neorg = require("neorg.core")
-- local dirman = neorg.modules.get_module("core.dirman")
-- if dirman then
--   Current_workspace = dirman.get_current_workspace()[2]
-- end

vim.api.nvim_create_user_command("Notdo", function()
  require("telescope.builtin").grep_string({
    search = [[^\s*(-|~)+.\(.\)]],
    use_regex = true,
    -- search_dirs = { tostring(Current_workspace) },
    search_dirs = { tostring("~/neorg") },
    prompt_title = "TODOs",
  })
end, { desc = "Search for todos/tasks" })

vim.api.nvim_create_user_command("Obtodo", function()
  require("telescope.builtin").grep_string({
    search = [[^\s*(-|~)+.\(.\)]],
    use_regex = true,
    search_dirs = { tostring("~/Documents/Obsidian/Obsidian") },
    prompt_title = "TODOs",
  })
end, { desc = "Search for Obsidian todos/tasks" })

vim.api.nvim_create_user_command("Sc", function()
  -- local bufnr = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  -- vim.bo[bufnr].buftype = "nofile" -- Set buffer type to "nofile"
  -- vim.bo[bufnr].readonly = false -- Set read-only to false
  -- vim.bo[bufnr].swapfile = false -- Disable swap file
  -- vim.bo[bufnr].bufhidden = "" -- Set buffer hidden state to empty
  -- vim.bo[bufnr].buflisted = true -- Add buffer to buffer list
  --vim.api.nvim_buf_set_name(bufnr, "Scratch Buffer")
  -- local win_id = vim.api.nvim_get_current_win()
  -- local orientation = "horizontal" -- or "vertical" for vertical split
  -- vim.bo.nvim_command(string.format("wincmd %s", orientation))

  -- Move the cursor to the new scratch buffer
  -- vim.api.nvim_win_set_cursor(win_id, { 0, 0 })

  --  vim.api.nvim_buf_set_name(bufnr, "*scratch*")
  require("lualine").setup({
    options = {
      disabled_filetypes = {
        statusline = { "scratch" },
        winbar = { "scratch" },
        "scratch",
      },
    },
  })
  vim.cmd("vsplit ~/.scratch.scratch")
  vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
end, { desc = "Create and set a scratchpad" })

-- Map 'q' to close the buffer in this window
-- vim.api.nvim_buf_set_keymap(
--   buf,
--   "n",
--   "q",
--   ":q!<CR>",
--   { noremap = true, silent = true }
-- )
