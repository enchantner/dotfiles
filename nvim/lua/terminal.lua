-- bottom terminal panel (Trouble-style toggle), no plugins
local term_buf, term_win = nil, nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  vim.cmd("botright split")

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end

  term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(term_win, 15)
  vim.cmd("startinsert")
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
    vim.opt_local.buflisted = false
  end,
})

vim.keymap.set('n', '<leader>t', toggle_terminal, { silent = true, desc = "Toggle terminal panel" })
vim.keymap.set('t', '<leader>t', toggle_terminal, { silent = true, desc = "Toggle terminal panel" })
