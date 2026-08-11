return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- The old configs module is gone. 
    -- Simply use require("nvim-treesitter.config") if customizing paths,
    -- or configure built-in features directly.

    -- Example of the new basic initialization:
    local configs = require("nvim-treesitter.config")

    -- Note: Options like 'ensure_installed' have changed or moved.
    -- Refer to the updated nvim-treesitter documentation for advanced flags.
  end
}
