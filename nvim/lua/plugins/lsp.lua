return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "gopls", "rust_analyzer", "dockerls", "sqlls" },
        auto_install = true,
      })
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = "hrsh7th/cmp-nvim-lsp",
    config = function()
      local nvim_lsp = require("lspconfig")
      local util = require("lspconfig/util")

      local path = util.path

      local function get_python_path(workspace)
        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
          return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        end

        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({ "*", ".*" }) do
          local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
          if match ~= "" then
            return path.join(path.dirname(match), "bin", "python")
          end
        end

        -- Fallback to system Python.
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      -- lsp setup
      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = { "pyright", "rust_analyzer", "gopls", "tsserver", "texlab", "lua_ls", "dockerls", "sqlls" }
      for _, lsp in ipairs(servers) do
        if lsp == "lua_ls" then
          nvim_lsp[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        elseif lsp == "gopls" then
          nvim_lsp[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
              },
            },
          })
        elseif lsp == "pyright" then
          nvim_lsp[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            before_init = function(_, config)
              config.settings.python.pythonPath = get_python_path(config.root_dir)
            end
          })
        else
          nvim_lsp[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end
      end

      vim.g.go_def_mode = "gopls"
      vim.g.go_info_mode = "gopls"

      -- LSP mappings
      vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", { noremap = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>sh",
        [[<cmd>lua vim.lsp.buf.signature_help()<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>ws",
        '<cmd>lua require"metals".hover_worksheet()<CR>',
        { noremap = true }
      )
      vim.api.nvim_set_keymap("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]], { noremap = true })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>ae",
        [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>aw",
        [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]],
        { noremap = true }
      )
      vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>", { noremap = true })
      vim.api.nvim_set_keymap(
        "n",
        "[c",
        "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "]c",
        "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>",
        { noremap = true }
      )
    end,
  },
}
