return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- Optional, but recommended for icons
  },
  config = function()
    -- This is where you can add custom settings
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true, -- This shows hidden files by default
        },
      },
    })

    -- This sets a shortcut: press 'Space' then 'e' to open the tree
    vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Toggle Neo-tree" })
  end,
}
