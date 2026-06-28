-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "python", "bash", "typescript", "javascript", "go",
        "json", "markdown", "markdown_inline",
        "lua", "vim", "vimdoc", "yaml", "toml",
      },
    },
  },
}