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
  vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
end, { desc = "Create and set a scratchpad" })
