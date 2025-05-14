return {
  "rcarriga/nvim-notify",
  enabled = false,
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  opts = {
    stages = "static",
    timeout = 3000,
    max_height = function()
      return 0
    end,
    max_width = function()
      return 0
    end,
    on_open = function(win)
      -- vim.api.nvim_win_set_config(win, { zindex = -20,  })

    end,
  },
  init = function()
    -- when noice is not enabled, install notify on VeryLazy
    if not LazyVim.has("noice.nvim") then
      LazyVim.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end
  end,
}
