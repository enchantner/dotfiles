return   {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require("nvim-tree").setup()
    vim.api.nvim_set_keymap('n', '<C-E>', ':NvimTreeToggle<CR>', {silent = true})
  end
}

