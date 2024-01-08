return {
	"jackMort/ChatGPT.nvim",
	-- event = "VeryLazy",
  lazy = true,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("chatgpt").setup({
			api_key_cmd = "op read op://personal/OpenAI_API/password --no-newline",
		})
	end,
}
