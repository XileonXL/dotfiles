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
  "tpope/vim-fugitive",
  {
    'lervag/vimtex',
    init = function ()
      vim.g.vimtex_enabled = true
      vim.g.vimtex_compiler_latexmk = {
        executable = 'latexmk',
        options = {'-pdf'},
      }
      vim.g.vimtex_compiler_auto = true
      vim.g.vimtex_view_general_options = '-reuse-instance'
      vim.g.vimtex_view_method = 'zathura'
    end,
    event = "BufWritePost *tex",
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
