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
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
      vim.keymap.set('n', '<leader>dB', dap.set_breakpoint, {})

      vim.keymap.set('n', '<leader>dc', dap.continue, {})
      vim.keymap.set('n', '<leader>do', dap.step_over, {})
      vim.keymap.set('n', '<leader>di', dap.step_into, {})
      vim.keymap.set('n', '<leader>dx', dap.step_out, {})
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
		dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
		config = function()
			require("dapui").setup()
		end,
	},
}
