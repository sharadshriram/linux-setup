-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Python: yapf for Google style (80 cols, 4-space indent)
      null_ls.builtins.formatting.yapf.with({
        extra_args = { "--style", "{based_on_style: google, column_limit: 80}" },
      }),

      -- Bash: shfmt with Google Shell Style Guide flags
      -- -i 2: 2-space indent
      -- -bn: binary ops at start of line
      -- -ci: case indent
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2", "-bn", "-ci" },
      }),

      -- Diagnostics
      null_ls.builtins.diagnostics.shellcheck,
    })
  end,
}