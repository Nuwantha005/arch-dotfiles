return {
  -- 1. Core Image Engine
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",            -- Leverages Kitty's GPU rendering protocol
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false, -- Keeps diagram visible while you edit it
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown" },
        },
      },
      max_width = 100,
      max_height = 20,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
    },
  },

  -- 2. Mermaid Diagram Engine & PNG Exporter
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    opts = {
      renderer_options = {
        mermaid = {
          background = "transparent", -- Seamless look on your terminal background
          theme = "dark",            -- Options: dark, default, forest, neutral
          scale = 3,                 -- High scale (3x) ensures crisp PNG exports
        },
      },
    },
    config = function(_, opts)
      require("diagram").setup(opts)

      -- Complete multi-diagram PNG export automation
      -- Replaced <leader>me with Alt+m to avoid conflict with mark menu shortcuts
      vim.keymap.set("n", "<M-m>", function()
        vim.cmd("write") -- Ensure file changes are saved first
        
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local current_file = vim.api.nvim_buf_get_name(0)
        if current_file == "" then
          vim.notify("Please save the file first!", vim.log.levels.WARN)
          return
        end

        local file_base = current_file:gsub("%.md$", "")
        local in_mermaid = false
        local current_diagram_lines = {}
        local diagram_count = 0

        vim.notify("Parsing and exporting all diagrams...", vim.log.levels.INFO)

        -- FIXED: Added 'in ipairs(lines)' syntax validation loop
        for _, line in ipairs(lines) do
          if line:match("^```mermaid") then
            in_mermaid = true
            current_diagram_lines = {}
            diagram_count = diagram_count + 1
          elseif line:match("^```$") and in_mermaid then
            in_mermaid = false
            
            -- Create a clean temporary file path for compilation
            local tmp_file = "/tmp/nv_mermaid_" .. diagram_count .. ".mmd"
            local output_png = file_base .. "_diagram_" .. diagram_count .. ".png"
            
            -- Write content block out
            local f = io.open(tmp_file, "w")
            if f then
              f:write(table.concat(current_diagram_lines, "\n"))
              f:close()
              
              -- Execute compilation tracking callbacks asynchronously
              vim.fn.jobstart({ "mmdc", "-i", tmp_file, "-o", output_png, "-s", "3" }, {
                on_exit = function(_, exit_code)
                  if exit_code == 0 then
                    vim.notify("Saved diagram #" .. diagram_count .. " -> " .. output_png, vim.log.levels.INFO)
                  else
                    vim.notify("Failed to export diagram #" .. diagram_count, vim.log.levels.ERROR)
                  end
                  os.remove(tmp_file) -- clean up temporary scratch file
                end,
              })
            end
          elseif in_mermaid then
            table.insert(current_diagram_lines, line)
          end
        end

        if diagram_count == 0 then
          vim.notify("No mermaid code blocks discovered in this file.", vim.log.levels.WARN)
        end
      end, { desc = "Mermaid Export all to PNG" })
    end,
  },
}
