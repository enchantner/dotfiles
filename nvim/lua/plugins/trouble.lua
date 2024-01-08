return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup {}

    vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble<cr>",
        {silent = true, noremap = true}
    )
    vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble document_diagnostics<cr>",
        {silent = true, noremap = true}
    )
  end
}
