return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				-- Python formatting/import-sorting is handled by the ruff LSP
				-- (see plugins/lspconfig.lua) instead of black/isort here.
				-- null_ls.builtins.diagnostics.pylint.with({
        --     only_local = "~/.pyenv/versions/testnvim/bin",
        -- }),
			},
		})
		vim.keymap.set("n", "<leader>gf", function()
			-- default timeout_ms (1000) can be too short for ruff's first
			-- response on a real project, and a sync timeout fails silently
			vim.lsp.buf.format({ timeout_ms = 5000 })
		end, {})
	end,
}
