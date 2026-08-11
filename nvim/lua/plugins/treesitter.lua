return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- 1. Initialize the modern config module
    local ts_config = require("nvim-treesitter.config")

    ts_config.setup({
      -- Enables automatic parser compilation if you enter a file without it
      auto_install = true, 
      
      -- Native highlighting configuration block
      highlight = {
        enable = true,
      },
      
      -- Smart indentation based on the syntax tree nodes
      indent = {
        enable = true,
      },
    })

    -- 2. Explicitly tell Treesitter to install your required languages
    -- (This replaces the old 'ensure_installed' array block)
    require("nvim-treesitter").install({ "c", "cpp", "python", "lua", "vim", "vimdoc" })
  end
}
