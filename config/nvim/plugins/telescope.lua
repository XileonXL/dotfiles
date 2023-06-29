local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local multi_open = function(pb)
  local picker = action_state.get_current_picker(pb)
  local multi = picker:get_multi_selection()
  actions.select_default(pb) -- the normal enter behaviour
  for _, j in pairs(multi) do
    if j.path ~= nil then -- is it a file -> open it as well:
      vim.cmd(string.format("%s %s", "edit", j.path))
    end
  end
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
  },
  cmd = "Telescope",
  opts = function()
    local actions = require "telescope.actions"
    local get_icon = require("astronvim.utils").get_icon
    return {
      defaults = {
        prompt_prefix = get_icon("Selected", 1),
        selection_caret = get_icon("Selected", 1),
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<CR>"] = multi_open,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
          n = {
            ["<CR>"] = multi_open,
            q = actions.close
          }
        },
      },
    }
  end,
  config = require "plugins.configs.telescope",
}



