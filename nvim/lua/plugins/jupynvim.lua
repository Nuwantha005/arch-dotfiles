return {
  "sheng-tse/jupynvim",
  build = function(plugin)
    local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
    install.run(plugin)
  end,
  event = { "BufReadCmd *.ipynb", "BufNewFile *.ipynb" },
  opts = {
    log_level = "info",
    image_renderer = "placeholder",
    border = "rounded",
    auto_start_kernel = true,
  },
  config = function(_, opts)
    -- BACKWARD COMPATIBILITY HACK: 
    -- If Neovim removed vim.tbl_flatten, alias it using the modern Lua iterator protocol
    if not vim.tbl_flatten then
      vim.tbl_flatten = function(t)
        return vim.iter(t):flatten():totable()
      end
    end

    -- Safely execute the plugin setup now that the namespace is protected
    require("jupynvim").setup(opts)

    local map = vim.keymap.set
    -- Run current cell
    map("n", "<leader>nr", "<cmd>JupynvimRunCell<cr>", { desc = "Run current cell" })
    map("n", "<S-CR>", "<cmd>JupynvimRunCell<cr>", { desc = "Run current cell" })
    
    -- Cell manipulation
    map("n", "<leader>nb", "<cmd>JupynvimAddCellBelow<cr>", { desc = "Add code cell below" })
    map("n", "<leader>na", "<cmd>JupynvimAddCellAbove<cr>", { desc = "Add code cell above" })
    map("n", "<leader>nm", "<cmd>JupynvimChangeToMarkdown<cr>", { desc = "Convert cell to Markdown" })
    map("n", "<leader>nc", "<cmd>JupynvimChangeToCode<cr>", { desc = "Convert cell to Code" })
    
    -- Kernel management
    map("n", "<leader>nk", "<cmd>JupynvimSelectKernel<cr>", { desc = "Select Jupyter Kernel" })
  end,
}

