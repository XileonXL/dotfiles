-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- Compile latex project
    ["<leader>lc"] = { ":!latexmk -pdf" },
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr)
          require("astronvim.utils.buffer").close(
            bufnr)
        end)
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },

    -- Save / Close file
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
    ["<C-q>"] = { ":q<cr>" },

    -- Do not copy on register when pressing x
    ["x"] = { "_x" },

    -- Split window
    ["sv"] = { "<C-w>v" },
    ["sh"] = { "<C-w>s" },
    ["se"] = { "<C-w>=" },

    -- Buffers
    ["tn"] =
    { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
    ["tp"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
    ["<C-w>"] = { function() require("astronvim.utils.buffer").close() end, desc = "Close buffer" },
    ["<C-n>"] = { "<cmd>enew<cr>", desc = "New File" },

    -- Quit search highlight until next search
    -- ["<S-h>"] = { ":noh<cr>" },

    -- Telescope
    ["<C-b>"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    ["<C-g>"] = { function() require("telescope.builtin").grep_string() end, desc = "Find for word under cursor" },
    ["<C-p>"] = { function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end, desc = "Find files in all files" },
    ["<C-f>"] = { function() require("telescope.builtin").live_grep { additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end } end, desc = "Find words in all files" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    -- Do not copy on register when pressing x
    ["x"] = { "_x" },

    -- Maintain tab after using << or >>
    ["<"] = { "<gv" },
    [">"] = { ">gv" },
  }
}
