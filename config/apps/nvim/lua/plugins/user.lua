-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
  },

  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- THEMES
  -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- { "Mofiqul/dracula.nvim" },
  -- { "EdenEast/nightfox.nvim" },
  -- {
  --   "rockyzhang24/arctic.nvim",
  --   branch = "v2",
  --   dependencies = { "rktjmp/lush.nvim" },
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("onedark").setup {
  --       style = "cool",
  --     }
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  -- { "rose-pine/neovim", name = "rose-pine" },
  --

  -- CODECOMPANION
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     strategies = {
  --       -- Change the default chat adapter
  --       chat = {
  --         adapter = "copilot",
  --       },
  --       inline = {
  --         adapter = "copilot",
  --       },
  --       cmd = {
  --         adapter = "copilot",
  --       },
  --     },
  --     adapters = {
  --       openai = function()
  --         return require("codecompanion.adapters").extend("openai", {
  --           schema = {
  --             model = {
  --               default = "gpt-4.1",
  --             },
  --           },
  --         })
  --       end,
  --       gepetto = function() return {} end,
  --     },
  --     opts = {
  --       -- Set debug logging
  --       log_level = "DEBUG",
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ravitemer/mcphub.nvim",
  --   },
  --   extensions = {
  --     mcphub = {
  --       callback = "mcphub.extensions.codecompanion",
  --       opts = {
  --         make_vars = true,
  --         make_slash_commands = true,
  --         show_result_in_chat = true,
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "markdown", "codecompanion" },
  -- },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false,
  --   opts = {
  --     preview = {
  --       filetypes = { "markdown", "codecompanion" },
  --       ignore_buftypes = {},
  --     },
  --   },
  -- },
  -- {
  --   "echasnovski/mini.diff",
  --   config = function()
  --     local diff = require "mini.diff"
  --     diff.setup {
  --       -- Disabled by default
  --       source = diff.gen_source.none(),
  --     }
  --   end,
  -- },
  -- {
  --   "HakonHarnes/img-clip.nvim",
  --   opts = {
  --     filetypes = {
  --       codecompanion = {
  --         prompt_for_file_name = false,
  --         template = "[Image]($FILE_PATH)",
  --         use_absolute_path = true,
  --       },
  --     },
  --   },
  -- },

  -- -- Copilot
  -- {
  --   "github/copilot.vim",
  --   "zbirenbaum/copilot.lua",
  -- },
}
