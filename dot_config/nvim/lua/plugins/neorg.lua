return {
  "nvim-neorg/neorg",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-neorg/neorg-telescope" },
    { "bottd/neorg-worklog" },
    { "benlubas/neorg-interim-ls" },
    -- { "benlubas/neorg-query" },
    { "juniorsundar/neorg-extras" },
    { "benlubas/neorg-se" },
    -- { "nvim-telescope/telescope.nvim" },
    -- { "neorg-snack_picker/pickers/find_linkable" },
    { "nvim-neorg/lua-utils.nvim" },
    { "pysan3/pathlib.nvim" },
    { "nvim-neotest/nvim-nio" },
  },
  ft = "norg",
  cmd = { "Neorg" },
  opts = {
    load = {
      ["external.agenda"] = {}, -- OPTIONAL if you don't want the agenda features
      ["external.roam"] = {}, -- OPTIONAL if you don't want the roam features
      ["external.many-mans"] = {
        config = {
          treesitter_fold = true, -- Set to 'false' if your package manager is currently NOT lazy.nvim
        },
      },
      ["core.defaults"] = {},
      ["core.autocommands"] = {},
      ["core.clipboard"] = {},
      -- ["core.completion"] = {
      --   config = { engine = "nvim-cmp" },
      -- },
      ["core.export"] = {},
      ["core.export.markdown"] = {},
      -- ["core.integrations.nvim-cmp"] = {
      --   config = {
      --     sources = {
      --       { name = "neorg" },
      --     },
      --   },
      -- },
      ["core.journal"] = {},
      ["core.keybinds"] = {},
      -- config = {
      --   neorg_leader = ",",
      -- },
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/neorg/notes",
          },
          default_workspace = "notes",
        },
      },
      ["core.concealer"] = { -- We added this line!
        config = { -- We added a `config` table!
          icon_preset = "varied", -- And we set our option here.
          icons = {
            delimiter = {
              horizontal_line = {
                highlight = "@neorg.delimiters.horizontal_line",
              },
            },
            code_block = {
              -- If true will only dim the content of the code block (without the
              -- `@code` and `@end` lines), not the entirety of the code block itself.
              content_only = true,
              -- The width to use for code block backgrounds.
              --
              -- When set to `fullwidth` (the default), will create a background
              -- that spans the width of the buffer.
              --
              -- When set to `content`, will only span as far as the longest line
              -- within the code block.
              width = "content",
              -- Additional padding to apply to either the left or the right. Making
              -- these values negative is considered undefined behaviour (it is
              -- likely to work, but it's not officially supported).
              padding = {
                -- left = 20,
                -- right = 20,
              },
              -- If `true` will conceal (hide) the `@code` and `@end` portion of the code
              -- block.
              conceal = true,
              nodes = { "ranged_verbatim_tag" },
              highlight = "CursorLine",
              -- render = module.public.icon_renderers.render_code_block,
              insert_enabled = true,
            },
          },
        },
      },
      ["core.integrations.telescope"] = {
        config = {
          insert_file_link = {
            show_title_preview = true,
          },
        },
      },
      ["core.highlights"] = {},
      ["core.integrations.treesitter"] = {},
      ["core.itero"] = {},
      ["core.queries.native"] = {},
      ["core.summary"] = {},
      ["core.ui"] = {},
      ["core.ui.calendar"] = {},
      ["core.text-objects"] = {},
      ["core.looking-glass"] = {},
      ["core.qol.todo_items"] = {},
      ["core.qol.toc"] = {},
      ["core.esupports.metagen"] = {
        config = { type = "auto" },
      },
      ["core.esupports.hop"] = {},
      ["core.esupports.indent"] = {
        config = {
          indents = {
            _ = { indent = 2 },
            heading1 = { indent = 0 },
            heading2 = { indent = 2 },
            heading3 = { indent = 4 },
            heading4 = { indent = 6 },
            heading5 = { indent = 8 },
            heading6 = { indent = 10 },
          },
        },
      },
      ["external.worklog"] = {
        config = { default_workspace_title = "notes" },
      },
      -- ["external.query"] = {
      --   -- Populate the database. Indexing happens on a separate thread, so doesn't block
      --   -- neovim. We also
      --   index_on_launch = true,
      --
      --   -- Update the db entry when a file is written
      --   update_on_change = true,
      -- },
      ["external.interim-ls"] = {},
      ["core.completion"] = {
        config = { engine = { module_name = "external.lsp-completion" } },
      },
    },
  },
  -- require("cmp").setup.buffer({
  -- require("cmp").setup({
  --   sources = { name = "Neorg" },
  -- }),
  require("which-key").add({
    { "<leader>n", group = "neorg" },
    {
      mode = { "n" },
      {
        "<leader>nt",
        "<Plug>(neorg.pivot.list.toggle)",
        desc = "[t]oggle list",
      },
      {
        "<leader>nc",
        "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
        desc = "TODO task [c]ycle",
      },
      {
        "<leader>nf",
        "<Plug>(neorg.telescope.find_norg_files)",
        desc = "[f]ind norg files",
      },
      {
        "<leader>nh",
        "<Plug>(neorg.telescope.search_headings)",
        desc = "search [h]eadings",
      },
      {
        "<leader>nw",
        "<Plug>(neorg.telescope.switch_workspace)",
        desc = "switch [w]orkspace",
      },
      {
        "<leader>ni",
        "<Plug>(neorg.telescope.insert_link)",
        desc = "[i]nsert link",
      },
      {
        "<leader>nf",
        "<Plug>(neorg.telescope.insert_file_link)",
        desc = "insert [f]ile link",
      },
      {
        "<leader>nk",
        "<Plug>(neorg.telescope.find_linkable)",
        desc = "find lin[k]able",
      },
      {
        "<leader>nb",
        "<Plug>(neorg.telescope.backlinks.file_backlinks)",
        desc = "find [b]acklinks",
      },
      {
        "<leader>nm",
        "<Plug>(neorg.looking-glass.magnify-code-block)",
        desc = "[m]agnify code block",
      },
      {
        "<leader>nj",
        "<Cmd>Neorg journal<CR>",
        desc = "Neorg [j]ournal",
      },
    },
  }),
}
