-- 1. Enable true color and clipboard support FIRST
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("set number")

-- 2. Bootstrap and load lazy.nvim path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load user options and initialize your plugin ecosystem
require("vim-options")
require("lazy").setup("plugins")
