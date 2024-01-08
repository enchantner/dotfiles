-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt_global.shortmess:remove("F")
vim.opt_global.shortmess:append("c")

vim.wo.wrap = false

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.mouse = 'a'
vim.opt.clipboard = "unnamedplus"
vim.opt.pastetoggle = "<F2>"

vim.cmd.colorscheme "catppuccin"
vim.g.python3_host_prog = '~/.pyenv/versions/neovim/bin/python'
