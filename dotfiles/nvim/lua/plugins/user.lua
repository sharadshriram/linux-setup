---@type LazySpec
return {
  -- Disable better-escape (conflicts with terminal workflows)
  { "max397574/better-escape.nvim", enabled = false },

  -- Snacks: disable animated scrolling (can feel laggy on large files)
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      dashboard = {
        preset = {
          header = table.concat({
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          }, "\n"),
        },
      },
    },
  },

  -- Transparency (move here from root — was in wrong location before)
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Uncomment to enable transparent background:
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      return opts
    end,
  },
}