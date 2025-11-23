return {
  -- Disable ErrorLens completely
  { "chikko80/error-lens.nvim", enabled = false },

  -- Kill inlay hints globally
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { virtual_text = false },
    },
  },

  -- Kill current-word highlighting from LSP
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.documentHighlightProvider = false
            client.server_capabilities.inlayHintProvider = false
          end
        end,
      })
    end,
  },
}
