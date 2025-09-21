return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    idle = {
      timeout = 1000 * 60 * 60 * 12
    },
    buttons = {
      {
        label = function(_opts)
          return 'Github'
        end,
        url = function(_opts)
          return 'https://github.com/itzcodex24'
        end
      }
    }
  }
}
