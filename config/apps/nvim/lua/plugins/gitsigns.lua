-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize gitsigns behavior

---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 250,
		},
  },
}
