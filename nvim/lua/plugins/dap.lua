return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-- Scala DAP
			dap.configurations.scala = {
				{
					type = "scala",
					request = "launch",
					name = "Run",
					metals = {
						runType = "runOrTestFile",
					},
				},
			}

			-- DAP mappings
			vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>lua require'dap'.continue()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dd", "<cmd>lua require'dap'.repl.toggle()<CR>", { noremap = true })
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			-- Python DAP
			require("dap-python").setup("~/.pyenv/versions/debugpy/bin/python")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
		end,
	},
}
