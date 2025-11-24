return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      return true
    end,

    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      menu = {
        auto_show = false,
      },
      ghost_text = {
        enabled = false,
      },
      documentation = {
        auto_show = true,
      },
    },
  },
}
