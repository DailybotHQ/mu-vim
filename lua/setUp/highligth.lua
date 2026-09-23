require("nvim-treesitter").setup({
  highlight = {
    enable = true,
    disable = {},
    -- Neovim 0.11 ships a markdown parser that does not paint headings,
    -- emphasis, or links. The regex syntax does. 0.12's bundled parser
    -- already paints those, so leave regex off there.
    additional_vim_regex_highlighting = vim.fn.has("nvim-0.12") == 0,
  },

  autotag = {
    enable = true,
  },

  indent = {
    enable = false,
    disable = {},
  },

  ensure_installed = {
    "c",
    "cpp",
    "lua",
    "vim",
    "css",
    "html",
    "bash",
    "java",
    "rust",
    "json",
    "yaml",
    "python",
    "javascript",
    "typescript",
  },

  ignore_install = {},
})
