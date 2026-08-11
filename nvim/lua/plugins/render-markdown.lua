return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- use the icons plugin you have installed, e.g. nvim-web-devicons
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- your configuration options here, or leave empty for defaults
      -- example: disable by default, enable with command
      enabled = false,
    },
    -- Ensure it loads for markdown files
    ft = "markdown",
    -- Optional: add a command to manually toggle the rendering
    cmd = "RenderMarkdownToggle",
  },
}
