return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = false,
      color_overrides = {
        mocha = {
          base = "#1D2127",
          mantle = "#1D2127",
          crust = "#1D2127",
        },
      },
      term_colors = true,
      background = { dark = "mocha" },
      styles = { comments = { "italic" }, keywords = { "italic" } },
      integrations = {
        aerial = true,
        dap = true,
        dap_ui = true,
        mason = true,
        neotree = true,
        treesitter = true,
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "Normal",
        "NormalFloat",
        "FloatBorder",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "TelescopeNormal",
        "TelescopeBorder",
        "Pmenu",
        "PmenuSel",
        "LspFloatWinNormal",
        "LspFloatWinBorder",
        "NotifyBackground",
        "BufferLineFill",
        "StatusLine",
        "StatusLineNC",
      },

      groups = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
      },
    },
    config = function(_, opts)
      require("transparent").setup({
        winblend = 5,
        hl_groups = opts.groups,
        extra_groups = opts.extra_groups,
      })

      vim.api.nvim_set_hl(0, "Normal", { bg = "#0f0f17", fg = "#cdd6f4" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e", blend = 5 })
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#1e1e2e", blend = 5 })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1e1e2e", blend = 5 })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e1e2e", blend = 5 })

      vim.g.transparent_enabled = true
    end,
  },
}
