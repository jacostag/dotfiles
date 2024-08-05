return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    -- "BufReadPre /home/gosz/Documents/Obsidian/Obsidian/**/**.md",
    -- "BufNewFile /home/gosz/Documents/Obsidian/Obsidian/**/**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "/home/gosz/Documents/Obsidian/Obsidian/notes",
      },
      -- {
      --   name = "aix",
      --   path = "/home/gosz/Documents/Obsidian/Obsidian/aix",
      -- },
    },
    -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
    -- 'workspaces'. For example:
    -- dir = "~/vaults/work",

    -- Optional2, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "notes",

    templates = {
      folder = "~/Documents/Obsidian/Obsidian/Templates/",
      -- date_format = "%Y-%m-%d-%a",
      -- time_format = "%H:%M",
    },

    daily_notes = {
      -- Optional2, if you keep daily notes in a separate directory.
      folder = "DailyNotes",
      -- Optional2, if you want to change the date format for the ID of daily notes.
      date_format = "%Y/%m/%Y-%m-%d",
      -- Optional2, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
      -- Optional2, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional2, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "/home/gosz/Documents/Obsidian/Obsidian/Templates/Dailies.md",
      pass_on_todos = true,
    },
    -- Optional2, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional2, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    -- way then set 'mappings = {}'.
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
      -- vim.keymap.set("n", "<leader>os", "<cmd>ObsidianQuickSwitch<CR>", { desc = "[O]bsidian Quick[S]witch" }),
      -- vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "[O]bsidian [N]ew note" }),
      -- vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "[O]bsidian [F]ollow link" }),
      -- vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "[O]bsidian [B]acklinks" }),
      -- vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "[O]bsidian [T]oday" }),
      -- vim.keymap.set("n", "<leader>oi", "<cmd>ObsidianLinks<CR>", { desc = "[O]bsidian l[I]nks" }),
    },

    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "notes_subdir",
    -- Optional2, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional2, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.title)
      return path:with_suffix(".md")
    end,

    -- Optional2, customize how wiki links are formatted. You can set this to one of:
    --  * "use_alias_only", e.g. '[[Foo Bar]]'
    --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
    --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
    --  * "use_path_only", e.g. '[[foo-bar.md]]'
    -- Or you can set it to a function that takes a table of options and returns a string, like this:
    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    -- Optional2, customize how markdown links are formatted.
    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional2, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
    },
    -- Optional2, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      enable = true, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  },
  require("which-key").add({
    { "<leader>o", group = "obsidian" },
    {
      "<leader>oi",
      "<cmd>ObsidianLink<CR>",
      desc = "Obsidian [i]nsert link to",
      mode = "v",
    },
    {
      "<leader>or",
      "<cmd>ObsidianLinkNew<CR>",
      desc = "Obsidian link to [N]ew",
      mode = "v",
    },
    {
      mode = { "n", "v" },
      {
        "<leader>os",
        "<cmd>ObsidianQuickSwitch<CR>",
        desc = "[O]bsidian Quick[S]witch",
      },
      { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "[O]bsidian [N]ew note" },
      {
        "<leader>of",
        "<cmd>ObsidianFollowLink<CR>",
        desc = "[O]bsidian [F]ollow link",
      },
      {
        "<leader>ob",
        "<cmd>ObsidianBacklinks<CR>",
        desc = "[O]bsidian [B]acklinks",
      },
      { "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "[O]bsidian [T]oday" },
      { "<leader>ol", "<cmd>ObsidianLinks<CR>", desc = "[O]bsidian [l]inks" },
    },
  }),
}
