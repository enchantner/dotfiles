return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      -- A list of parser names, or "all"
      ensure_installed = {
        "python",
        "c",
        "cpp",
        "rust",
        "scala",
        "go",
        "html",
        "css",
        "lua",
        "sql",
        "markdown",
        "markdown_inline"
      },
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true
      },
    })
  end
}
