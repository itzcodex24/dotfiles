return {
  "akinsho/bufferline.nvim",
  optional = true,
  opts = function(_, opts)
    opts.options = {
      transparent_background = true,
      view = "default",
      numbers = "none",
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is deduplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      -- separator_style = { "▏", "▕" },
      -- separator_style = { "│", "│" },
      separator_style = "thin",
      -- separator_style = "thin",        --  "slant" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      -- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
      --   -- add custom logic
      --   return buffer_a.modified > buffer_b.modified
      -- end
      hover = {
        enabled = true,
        delay = 10,
        reveal = { 'close' }
      },
      offsets = {
        {
          filetype = "NvimTree",
          text = "Files",
          text_align = "center",
        },
        {
          filetype = "DiffviewFiles",
          text = "Source Control",
          text_align = "center",
        },
      },
    }


    local Offset = require("bufferline.offset")
    if not Offset.edgy then
      local get = Offset.get
      Offset.get = function()
        if package.loaded.edgy then
          local old_offset = get()
          local layout = require("edgy.config").layout
          local ret = { left = "", left_size = 0, right = "", right_size = 0 }
          for _, pos in ipairs({ "left", "right" }) do
            local sb = layout[pos]
            local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
            if sb and #sb.wins > 0 then
              ret[pos] = old_offset[pos .. "_size"] > 0 and old_offset[pos]
                  or pos == "left" and ("%#Bold#" .. title .. "%*" .. "%#BufferLineOffsetSeparator#│%*")
                  or pos == "right" and ("%#BufferLineOffsetSeparator#│%*" .. "%#Bold#" .. title .. "%*")
              ret[pos .. "_size"] = old_offset[pos .. "_size"] > 0 and old_offset[pos .. "_size"] or sb.bounds.width
            end
          end
          ret.total_size = ret.left_size + ret.right_size
          if ret.total_size > 0 then
            return ret
          end
        end
        return get()
      end
      Offset.edgy = true
    end
  end,
}
