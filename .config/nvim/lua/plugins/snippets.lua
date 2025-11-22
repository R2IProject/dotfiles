return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      local ls = require("luasnip")
      ls.config.set_config(opts)

      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })
    end,
  },
}
