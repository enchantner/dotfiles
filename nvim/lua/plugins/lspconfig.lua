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

      -- Auto-detect a project virtualenv (works for uv-created .venvs too,
      -- since they use the same pyvenv.cfg layout as any other venv).
      local function detect_python_path(workspace)
        if vim.env.VIRTUAL_ENV then
          return vim.env.VIRTUAL_ENV .. "/bin/python"
        end
        for _, pattern in ipairs({ "*", ".*" }) do
          local match = vim.fn.glob((workspace or vim.fn.getcwd()) .. "/" .. pattern .. "/pyvenv.cfg")
          if match ~= "" then
            return vim.fn.fnamemodify(match, ":h") .. "/bin/python"
          end
        end
        return vim.fn.exepath("python3")
      end

      local servers = { "pyright", "ruff", "rust_analyzer", "gopls", "ts_ls", "texlab", "lua_ls", "dockerls", "sqlls" }
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
              -- venv-selector.nvim sets pythonPath per-project when a venv
              -- is picked (<leader>vs/<leader>vc); don't clobber that choice
              local path = config.settings and config.settings.python and config.settings.python.pythonPath
              if not path or path == "" then
                config.settings.python.pythonPath = detect_python_path(config.root_dir)
              end
            end
          }
        elseif lsp == "ruff" then
          vim.lsp.config[lsp] = {
            -- pyright handles hover; ruff only lints and formats
            on_attach = function(client, bufnr)
              client.server_capabilities.hoverProvider = false
              on_attach(client, bufnr)
            end,
            capabilities = capabilities,
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
        ensure_installed = { "lua_ls", "pyright", "ruff", "gopls", "rust_analyzer", "dockerls", "sqlls" },
        auto_install = true,
      })
    end,
  },

}
