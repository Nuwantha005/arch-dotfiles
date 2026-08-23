return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 1. Remove the 'cmd' property so the keymaps are registered cleanly right away
    keys = {
      -- 2. Ensure you hit <Space> first (the leader key), then g, then l/h/f/c
      { "<leader>gl", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff Last Commit" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Project File History" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  }
}

