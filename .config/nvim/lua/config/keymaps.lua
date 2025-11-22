-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Buffer Configuration
local last_buf = nil
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_is_valid(buf) then
      last_buf = buf
    end
  end,
})

local function go_back_last_buffer()
  if last_buf and vim.api.nvim_buf_is_valid(last_buf) then
    vim.api.nvim_set_current_buf(last_buf)
  end
end

map("n", "<Tab>", ":BufferLinePick<CR>", { desc = "Pick Buffer" })
map("n", "<C-Tab>", go_back_last_buffer, { desc = "Return to last buffer" })
map("n", "<A-Tab>", ":BufferLineGoToBuffer<CR>", { desc = "Open buffer list with double Ctrl+C" })

-- Format Configuration
-- Prettier
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ async = true })
end, { desc = "Format file" })
