-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize neo-tree mappings

---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
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
