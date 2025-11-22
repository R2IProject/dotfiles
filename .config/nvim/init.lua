-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.o.shortmess = vim.o.shortmess .. "A"
vim.o.swapfile = true
vim.o.directory = vim.fn.stdpath("state") .. "/swap"
vim.o.updatetime = 4000
vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave", "VimLeave" }, {
  callback = function()
    if vim.fn.filereadable(vim.fn.swapname(vim.api.nvim_get_current_buf())) == 1 then
      vim.fn.delete(vim.fn.swapname(vim.api.nvim_get_current_buf()))
    end
  end,
})
