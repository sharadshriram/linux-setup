-- Customize Mason

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Language servers (most are auto-installed by community packs above;
        -- these are extras or explicit pins)
        "lua-language-server",
        "pyright",
        "bash-language-server",
        "typescript-language-server",
        "gopls",

        -- Formatters
        "stylua",    -- Lua
        "prettier",  -- TS, JS, JSON, Markdown, CSS
        "shfmt",     -- Bash/sh (Google style: -i 2 -bn -ci)
        "goimports", -- Go

        -- Linters
        "shellcheck",     -- Bash
        "markdownlint",   -- Markdown

        -- Debuggers
        "debugpy",        -- Python
        "delve",          -- Go

        -- Other tools
        "tree-sitter-cli",
      },
    },
  },
}