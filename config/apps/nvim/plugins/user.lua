return {
  "bluz71/vim-nightfly-guicolors",
  {
    "glepnir/template.nvim",
    cmd =  { 'Template', 'TemProject' },
    config = function()
      require('template').setup({
        temp_dir = "~/.config/nvim/lua/user/templates",
    })
    end,
  },
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
