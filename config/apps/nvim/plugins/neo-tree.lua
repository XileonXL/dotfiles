return {
  "nvim-neo-tree/neo-tree.nvim",
  -- opts = function(_, opts)
  --   opts.window.mappings = {
  --     ["tp"] = "prev_source",
  --     ["tn"] = "next_source",
  --   }
  --   opts.sources = { "filesystem", "buffers" }
  -- end,
  opts = {
    sources = { "filesystem", "buffers" },
    window = {
      mappings = {
        ["tn"] = "next_source",
        ["tp"] = "prev_source",
      },
    },
  },
}
