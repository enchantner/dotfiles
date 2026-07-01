return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {"hrsh7th/cmp-nvim-lsp"},
    config = function()

      -- lsp setup
      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = { "pyright", "rust_analyzer", "gopls", "ts_ls", "texlab", "lua_ls", "dockerls", "sqlls" }
      for _, lsp in ipairs(servers) do
        if lsp == "lua_ls" then
          vim.lsp.config[lsp] = {
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
          }
        elseif lsp == "gopls" then
          vim.lsp.config[lsp] = {
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
          }
        elseif lsp == "pyright" then
          vim.lsp.config[lsp] = {
            on_attach = on_attach,
            capabilities = capabilities,
            before_init = function(_, config)
              config.settings.python.pythonPath = vim.fn.exepath("python3")
            end
          }
        else
          vim.lsp.config[lsp] = {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end
        vim.lsp.enable(lsp)
      end

      -- autoformat on save for Rust projects
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format({
            async = false,
            filter = function(client) return client.name == "rust_analyzer" end,
          })
        end,
      })

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

}
