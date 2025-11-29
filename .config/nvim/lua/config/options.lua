-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_check_order = false
vim.g.root_spec = { "cwd" }
vim.opt.laststatus = 0
vim.api.nvim_set_hl(0, "Comment", { fg = "#888c94", italic = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#555a60" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b9bdc2", bold = true })
vim.opt.clipboard = "unnamedplus"
