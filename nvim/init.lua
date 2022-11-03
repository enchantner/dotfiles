local api = vim.api
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

cmd([[packadd packer.nvim]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("Packer is not installed!")
  return
end

-- run Packer in a window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"
  use "nvim-treesitter/nvim-treesitter"
  use "folke/trouble.nvim"

  -- brackets
  use {
    "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }

  -- completion
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  })
  use "SirVer/ultisnips"
  use "quangnguyen30192/cmp-nvim-ultisnips"
  use "hrsh7th/cmp-nvim-lsp-signature-help"

  use({
    "scalameta/nvim-metals",
    requires = {
      "mfussenegger/nvim-dap",
    },
  })
  use({
    "mfussenegger/nvim-dap-python",
    requires = {
      "mfussenegger/nvim-dap",
    },
  }) 

  -- search
  use "nvim-telescope/telescope.nvim"
  use ({
      "preservim/nerdtree",
      requires = {
        "ryanoasis/vim-devicons",
        "kyazdani42/nvim-web-devicons"
      },
  })
  -- beauty
  use "morhetz/gruvbox"
  use({
    "vim-airline/vim-airline",
    requires = {
      "vim-airline/vim-airline-themes",
    }
  })
  use "qpkorr/vim-bufkill"
  use "mhinz/vim-startify"
end)

vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt_global.shortmess:remove("F")
vim.opt_global.shortmess:append("c")

vim.wo.wrap = false

opt.number = true
opt.cursorline = true
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.mouse = 'a'
opt.clipboard = "unnamedplus"
opt.pastetoggle = "<F2>"

cmd'colorscheme gruvbox'
g.python3_host_prog = '/usr/bin/python'
g.airline_powerline_fonts = true
g["airline#extensions#tabline#enabled"] = 1
g.NERDTreeShowHidden = 1
g.NERDTreeMinimalMenu = 1

-- Tree-sitter
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "c", "cpp", "rust", "scala", "go", "html", "css", "lua", "sql" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- LSP config
require("nvim-lsp-installer").setup({
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

local nvim_lsp = require('lspconfig')

local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"

local capabilities = require("cmp_nvim_lsp").default_capabilities()
metals_config.capabilities = capabilities

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Autopairs setup with nvim-cmp
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- DAP setup
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

metals_config.on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require("metals").setup_dap()
end

-- Python DAP
require('dap-python').setup('~/.pyenv/versions/debugpy/bin/python')

-- lsp setup
local servers = { "pyright", "gopls", "tsserver", "texlab", "sumneko_lua", "dockerls", "sqlls"}
for _, lsp in ipairs(servers) do
  if lsp == "sumneko_lua" then
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            }
          }
        }
    }
  else
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
  end
end

-- Specific invitation for Scala LSP
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- Completion config
local cmp = require('cmp')
cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'buffer' },
      { name = 'nvim_lsp_signature_help' },
    },
    snippet = {
      expand = function(args)
        -- For `ultisnips` user.
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ["<Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
      end,
      ["<S-Tab>"] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
      end,
    },
})

-- trouble setup
require("trouble").setup {}

vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble<cr>",
    {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble document_diagnostics<cr>",
    {silent = true, noremap = true}
)

-- autostart NERDTree 
vim.api.nvim_exec([[  
    autocmd VimEnter *
      \   if !argc()
      \ |   Startify
      \ |   NERDTree
      \ |  endif
]], false)

-- keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Save W = w
map('c', 'W', 'w')

-- NERDTree mappings
map('n', '<C-E>', ':NERDTreeToggle<CR>', {silent = true})

-- Tabs mappings
map('n', '<C-Right>', ':bnext<CR>')
map('n', '<C-Left>', ':bprevious<CR>')
map('n', 'q', ':BD<CR>')

-- Delete mappings
map('n', 'D', '"_D')
map('n', 'C', '"_C')

-- Wrap mappings
function ToggleWrap()
  if vim.wo.wrap == true then
    vim.wo.wrap = false
    vim.wo.linebreak = false
    vim.wo.list = true
    vim.opt.virtualedit = 'all'
    api.nvim_del_keymap('n', 'j')
    api.nvim_del_keymap('n', 'k')
    api.nvim_del_keymap('v', 'j')
    api.nvim_del_keymap('v', 'k')
    api.nvim_del_keymap('n', '<Down>')
    api.nvim_del_keymap('n', '<Up>')
    api.nvim_del_keymap('v', '<Down>')
    api.nvim_del_keymap('v', '<Up>')
    api.nvim_del_keymap('i', '<Down>')
    api.nvim_del_keymap('i', '<Up>')
  else
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.list = false
    vim.opt.display.lastline = true
    vim.opt.virtualedit = ''
    map('n', 'j', 'gj')
    map('n', 'k', 'gk')
    map('v', 'j', 'gj')
    map('v', 'k', 'gk')
    map('n', '<Down>', 'gj')
    map('n', '<Up>', 'gk')
    map('v', '<Down>', 'gj')
    map('v', '<Up>', 'gk')
    map('i', '<Down>', '<C-o>gj')
    map('i', '<Up>', '<C-o>gk')
  end
end
map('n', '<Leader>w', ':lua ToggleWrap()<CR>', { noremap = true, silent = true })

-- Telescope mappings
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fn', '<cmd>Telescope help_tags<cr>')

-- LSP mappings
map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- DAP mappings
map("n", "<leader>dr", "<cmd>lua require'dap'.continue()<CR>")
map("n", "<leader>dd", "<cmd>lua require'dap'.repl.toggle()<CR>")

