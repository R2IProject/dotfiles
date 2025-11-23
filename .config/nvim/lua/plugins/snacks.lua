return {
  desc = "Snacks File Explorer",
  recommended = true,
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[
 /$$      /$$                 /$$$$$$$                        /$$     /$$                    
| $$$    /$$$                | $$__  $$                      | $$    |__/                    
| $$$$  /$$$$ /$$   /$$      | $$  \ $$  /$$$$$$   /$$$$$$$ /$$$$$$   /$$ /$$$$$$$  /$$   /$$
| $$ $$/$$ $$| $$  | $$      | $$  | $$ /$$__  $$ /$$_____/|_  $$_/  | $$| $$__  $$| $$  | $$
| $$  $$$| $$| $$  | $$      | $$  | $$| $$$$$$$$|  $$$$$$   | $$    | $$| $$  \ $$| $$  | $$
| $$\  $ | $$| $$  | $$      | $$  | $$| $$_____/ \____  $$  | $$ /$$| $$| $$  | $$| $$  | $$
| $$ \/  | $$|  $$$$$$$      | $$$$$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$  | $$|  $$$$$$$
|__/     |__/ \____  $$      |_______/  \_______/|_______/    \___/  |__/|__/  |__/ \____  $$
              /$$  | $$                                                             /$$  | $$
             |  $$$$$$/                                                            |  $$$$$$/
              \______/                                                              \______/ 
   Another One SweetHeart ?  ❤️❤️❤️
        ]],
      },
      sections = {
        { section = "header" },
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer({
          cwd = LazyVim.root(),
        })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
  },
}
