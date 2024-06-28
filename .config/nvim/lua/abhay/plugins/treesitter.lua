return {
  "nvim-treesitter/nvim-treesitter",

  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-ts-autotag",
    "hiphish/rainbow-delimiters.nvim",
    "windwp/nvim-autopairs",
  },

  build = ":TSUpdate",
  event = "bufWinEnter",

  config = function()
    local treesitter = require "nvim-treesitter.configs"
    treesitter.setup {
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "html",
        "css",
        "java",
        "javascript",
        "typescript",
        "python",
        "markdown",
        "markdown_inline",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      rainbow = {
        enable = true,
      },
    }
    require("nvim-ts-autotag").setup {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      -- Also override individual filetype configs, these take priority.
      -- Empty by default, useful if one of the "opts" global settings
      -- doesn't work well in a specific filetype
      per_filetype = {
        ["html"] = {
          enable_close = false,
        },
      },
    }
  end,
}
