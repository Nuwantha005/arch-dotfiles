return {
  {
    "caelestia",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1001, -- Higher priority than default themes to persist across Neovim restarts
    config = function()
      local dir = vim.fn.expand("~/.local/state/caelestia")
      local theme_file = dir .. "/nvim-colors.lua"

      local function reload_caelestia_colors()
        if vim.fn.filereadable(theme_file) == 0 then return end

        package.loaded["caelestia_colors"] = nil
        local ok, caelestia = pcall(dofile, theme_file)
        if not ok or not caelestia or type(caelestia.colours) ~= "table" then return end

        -- Set background mode ('dark' or 'light')
        if caelestia.mode then
          vim.opt.background = caelestia.mode
        end

        local c = caelestia.colours

        -- Apply Caelestia Material 3 highlight groups
        vim.api.nvim_set_hl(0, "Normal", { fg = c.onSurface, bg = c.surface })
        vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.onSurface, bg = c.surfaceContainer })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = c.surfaceContainer })
        vim.api.nvim_set_hl(0, "LineNr", { fg = c.outline })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.primary, bold = true })
        vim.api.nvim_set_hl(0, "Visual", { bg = c.secondaryContainer, fg = c.onSecondaryContainer })

        -- Sync pywal.nvim if installed
        local pywal_ok, pywal = pcall(require, "pywal")
        if pywal_ok then
          pcall(pywal.setup)
        end

        -- Sync lualine if installed
        local lualine_ok, lualine = pcall(require, "lualine")
        if lualine_ok then
          pcall(lualine.setup, {})
        end
      end

      -- Initial load on Neovim startup
      reload_caelestia_colors()

      -- Watch the DIRECTORY (~/.local/state/caelestia) instead of the file path directly.
      -- This guarantees inotify handles atomic file renames (os.replace) without dropping events.
      local uv = vim.uv or vim.loop
      local watcher = uv.new_fs_event()

      if watcher then
        watcher:start(dir, {}, vim.schedule_wrap(function(err, fname, _)
          if not err and fname == "nvim-colors.lua" then
            reload_caelestia_colors()
          end
        end))
      end
    end,
  },
}
