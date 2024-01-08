-- Tabs
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup()

		vim.api.nvim_set_keymap("n", "<C-Right>", ":bnext<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<C-Left>", ":bprevious<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<A-Right>", ":BufferLineMoveNext<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<A-Left>", ":BufferLineMovePrev<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "Q", ":BD<CR>", { noremap = true })
	end,
}
