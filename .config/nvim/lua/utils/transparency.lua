local M = {}

local transparent = true

local groups = {
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

  -- UI
  "LineNr",
  "CursorLineNr",
  "SignColumn",
  "FoldColumn",
  "VertSplit",
  "EndOfBuffer",

  -- Floats & popups
  "NormalFloat",
  "FloatBorder",
  "Pmenu",
  "PmenuSel",

  -- Telescope
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopeResultsNormal",
  "TelescopeResultsBorder",
  "TelescopePreviewNormal",
  "TelescopePreviewBorder",

  -- Tree-sitter context
  "TSContext",
  "TreesitterContext",

  -- Diagnostics
  "DiagnosticVirtualTextError",
  "DiagnosticVirtualTextWarn",
  "DiagnosticVirtualTextInfo",
  "DiagnosticVirtualTextHint",
}

function M.toggle()
  transparent = not transparent

  for _, group in ipairs(groups) do
    if transparent then
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    else
      vim.api.nvim_set_hl(0, group, {})
    end
  end

  vim.notify(transparent and "Transparency ON" or "Transparency OFF", vim.log.levels.INFO)
end

return M
