-- Managed by theme.sh — sets the Catppuccin Mocha colorscheme.
-- Requires the catppuccin/nvim plugin to be installed via your plugin manager.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
