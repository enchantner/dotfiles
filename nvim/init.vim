set clipboard=unnamedplus
set number
set mouse=a
set termguicolors
set nowrap
set hidden
set cursorline

" set guicursor=a:blinkwait5-blinkon5-blinkoff5
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

syntax enable
filetype plugin on
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" autocompletion for nvim-compe
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menu,menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

set nocompatible

call plug#begin('~/.local/share/nvim/plugged')

" Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'cespare/vim-toml'
Plug 'lyokha/vim-xkbswitch'

Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
" Plug 'dense-analysis/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
" Plug 'neovimhaskell/haskell-vim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'simrat39/rust-tools.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'qpkorr/vim-bufkill'
Plug 'ryanoasis/vim-devicons'
Plug 'google/vim-jsonnet'
" dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
" telescope
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

colorscheme gruvbox
set background=dark

let g:python3_host_prog = '/usr/bin/python'

lua << EOF
local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

require('rust-tools').setup({})

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `ultisnips` user.
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'buffer' },
    }
  })

  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }

  vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble<cr>",
    {silent = true, noremap = true}
  )
  vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble lsp_document_diagnostics<cr>",
    {silent = true, noremap = true}
  )

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  
end


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local servers = { "pyright", "gopls", "tsserver", "texlab" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities
  }
end
EOF

" run Python scripts on F9
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

autocmd BufNewFile,BufRead SConscript set syntax=python
autocmd BufNewFile,BufRead SConsBuilders set syntax=python

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
" let g:tex_conceal='abdmg'

" auto kb switch in Normal mode
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'

" nerdcommenter config

let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

let g:AutoPairsShortcutToggle = "<leader>p"

" Open ranger instead of NERDTree when specifying directory
" let g:NERDTreeHijackNetrw = 0
" let g:ranger_replace_netrw = 1
let g:ranger_map_keys = 0
map <leader>fr :Ranger<CR>

" Telescope mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

let g:indentLine_char = '|i'
let g:indentLine_setConceal = 2

" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = ""

nmap <silent> <C-E> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
nnoremap q :BD<CR> 
nmap <C-Right> :bnext<CR>
nmap <C-Left> :bprevious<CR>

" just exit
nnoremap ZQ :qa!<CR>

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsEditSplit = "vertical"

au BufNewFile,BufRead Jenkinsfile setf groovy

" Disable quote concealing in JSON and Markdown files
let g:vim_json_conceal=0
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" Disable autojump in AutoPairs
if get(g:, 'AutoPairsFlyMode', 0) == 0
function! s:replace_autopairs_map(char)
  let afterStr = strpart(getline('.'), col('.')-1)
  if afterStr =~ '^\s*'.a:char
    return a:char
  elseif afterStr =~ '^\s*$'
    let nextLineNum = getpos('.')[1] + 1
    let nextLine = getline(nextLineNum)
    while nextLineNum <= line('$') && nextLine =~ '^\s*$'
      let nextLineNum += 1
      let nextLine = getline(nextLineNum)
    endwhile
    if nextLine =~ '^\s*'.a:char
      return a:char
    else
      return AutoPairsInsert(a:char)
    endif
  else
    return AutoPairsInsert(a:char)
  endif
endfunction

function! s:disable_autopair_flymod()
  if b:autopairs_loaded < 2
    iunmap <buffer> }
    iunmap <buffer> ]
    iunmap <buffer> )
    iunmap <buffer> `
    iunmap <buffer> '
    iunmap <buffer> "
    inoremap <buffer> <silent> } <c-r>=<SID>replace_autopairs_map('}')<cr>
    inoremap <buffer> <silent> ] <c-r>=<SID>replace_autopairs_map(']')<cr>
    inoremap <buffer> <silent> ) <c-r>=<SID>replace_autopairs_map(')')<cr>
    inoremap <buffer> <silent> ` <c-r>=<SID>replace_autopairs_map('`')<cr>
    inoremap <buffer> <silent> ' <c-r>=<SID>replace_autopairs_map("'")<cr>
    inoremap <buffer> <silent> " <c-r>=<SID>replace_autopairs_map('"')<cr>
  endif
  let b:autopairs_loaded = 2
endfunction

augroup AutoPairs
  autocmd InsertEnter * call s:disable_autopair_flymod()
augroup END
endif

autocmd VimEnter *
      \   if !argc()
      \ |   Startify
      \ |   NERDTree
      \ |  endif
