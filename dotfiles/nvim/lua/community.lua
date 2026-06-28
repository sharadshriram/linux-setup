if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.
 
---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Colorscheme
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- Language packs — each installs LSP + formatter + linter for that language
  { import = "astrocommunity.pack.lua" },         -- lua
  { import = "astrocommunity.pack.python" },      -- pyright + ruff + debugpy
  { import = "astrocommunity.pack.bash" },        -- bashls + shellcheck + shfmt
  { import = "astrocommunity.pack.typescript" },  -- ts_ls + prettier + eslint
  { import = "astrocommunity.pack.go" },          -- gopls + goimports + golangci-lint
  { import = "astrocommunity.pack.json" },        -- jsonls + prettier + schemastore
  { import = "astrocommunity.pack.markdown" },    -- marksman + prettier + markdownlint
}