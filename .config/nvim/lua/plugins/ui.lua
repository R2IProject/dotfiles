-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "mcchrish/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones_darken_comments = 45
      vim.g.zenbones_solid_line_numbers = true
      vim.g.zenbones_lighten_noncurrent = false
      vim.cmd.colorscheme("zenbones")
    end,
  },
}
