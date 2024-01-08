-- keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Save W = w
map('c', 'W', 'w')

-- move lines
map('n', '<C-Up>', ':m .-2<CR>==')
map('n', '<C-Down>', ':m .+1<CR>==')

-- vim.api.nvim_set_keymap(
--   "n",
--   "<C-E>",
--   ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
--   { noremap = true }
-- )

-- Tabs mappings
-- if vim.loop.os_uname().sysname == 'Darwin' then


-- Delete mappings
map('n', 'D', '"_D')
map('n', 'C', '"_C')

-- Wrap mappings
function ToggleWrap()
  if vim.wo.wrap == true then
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.wo.list = true
    vim.opt.virtualedit = 'all'
    vim.api.nvim_del_keymap('n', 'j')
    vim.api.nvim_del_keymap('n', 'k')
    vim.api.nvim_del_keymap('v', 'j')
    vim.api.nvim_del_keymap('v', 'k')
    vim.api.nvim_del_keymap('n', '<Down>')
    vim.api.nvim_del_keymap('n', '<Up>')
    vim.api.nvim_del_keymap('v', '<Down>')
    vim.api.nvim_del_keymap('v', '<Up>')
    vim.api.nvim_del_keymap('i', '<Down>')
    vim.api.nvim_del_keymap('i', '<Up>')
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.list = false
    vim.opt.display.lastline = true
    vim.opt.virtualedit = ''
    map('n', 'j', 'gj')
    map('n', 'k', 'gk')
    map('v', 'j', 'gj')
    map('v', 'k', 'gk')
    map('n', '<Down>', 'gj')
    map('n', '<Up>', 'gk')
    map('v', '<Down>', 'gj')
    map('v', '<Up>', 'gk')
    map('i', '<Down>', '<C-o>gj')
    map('i', '<Up>', '<C-o>gk')
  end
end
map('n', '<Leader>w', ':lua ToggleWrap()<CR>', { noremap = true, silent = true })

