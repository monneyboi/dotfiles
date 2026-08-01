-- ~/.config/nvim/init.lua
-- Ported from a 10-year vimscript config (init.vim) to modern Lua on Neovim 0.12.
-- Plugin manager: lazy.nvim. Completion: blink.cmp. LSP: native vim.lsp + mason.

------------------------------------------------------------------------------
-- Leader (must be set before lazy so plugin mappings pick it up)
------------------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------------------
require("lazy").setup({
  ----------------------------------------------------------------------------
  -- Syntax highlighting: nvim-treesitter (main branch / 2025 rewrite).
  -- The new API has no `ensure_installed` option: you install() parsers and
  -- start() highlighting yourself via a FileType autocmd.
  ----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local langs = {
        "c", "lua", "vim", "vimdoc", "query", "python", "typescript",
        "javascript", "svelte", "css", "html", "json", "yaml", "bash", "markdown",
      }
      require("nvim-treesitter").install(langs)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = langs,
        callback = function() vim.treesitter.start() end,
      })
    end,
  },

  -- Auto close/rename HTML/JSX tags via treesitter (replaces alvan/vim-closetag).
  {
    "windwp/nvim-ts-autotag",
    config = function() require("nvim-ts-autotag").setup() end,
  },

  ----------------------------------------------------------------------------
  -- LSP + tool management.
  -- mason-lspconfig v2 auto-enables (vim.lsp.enable) every server it installs,
  -- so there's no per-server vim.lsp.enable() boilerplate anymore.
  ----------------------------------------------------------------------------
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Language servers: mason-lspconfig installs AND auto-enables these.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls", "svelte", "vimls" },
      })

      -- Non-LSP tools (formatters) handled by mason-tool-installer.
      require("mason-tool-installer").setup({
        ensure_installed = { "prettierd", "black" },
      })

      -- Give every server blink.cmp's completion capabilities.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Carried over from the old coc-settings.json: stop pyright type-checking.
      vim.lsp.config("pyright", {
        settings = {
          python = { analysis = { typeCheckingMode = "off" } },
        },
      })
    end,
  },

  ----------------------------------------------------------------------------
  -- Formatting on save (formatter.nvim) — black for Python, prettierd for rest.
  ----------------------------------------------------------------------------
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          python = { require("formatter.filetypes.python").black },
          ["*"] = { require("formatter.defaults.prettierd") },
        },
      })
    end,
  },

  ----------------------------------------------------------------------------
  -- Completion: blink.cmp (replaces nvim-cmp + all cmp-* + vsnip).
  ----------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      -- Start from the default preset (C-n/C-p navigate, C-space show, C-e hide)
      -- then keep your old Tab/CR-to-confirm and C-b/C-f doc-scroll bindings.
      keymap = {
        preset = "default",
        ["<Tab>"]   = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"]    = { "select_and_accept", "fallback" },
        ["<C-b>"]   = { "scroll_documentation_up", "fallback" },
        ["<C-f>"]   = { "scroll_documentation_down", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      -- Command-line completion (replaces your cmp.setup.cmdline blocks).
      cmdline = { enabled = true },
    },
  },

  ----------------------------------------------------------------------------
  -- Color scheme
  ----------------------------------------------------------------------------
  {
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("sonokai")
      -- Make matching parens bold green (from the old `hi MatchParen` line).
      vim.api.nvim_set_hl(0, "MatchParen", { bold = true, ctermbg = "NONE", ctermfg = "Green" })
    end,
  },

  ----------------------------------------------------------------------------
  -- Editing helpers
  ----------------------------------------------------------------------------
  -- Auto pairs (replaces jiangmiao/auto-pairs).
  { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup({}) end },
  -- tpope classics, still best in class. Kept.
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-fugitive",

  ----------------------------------------------------------------------------
  -- Fuzzy finder (kept: fzf + fzf.vim, bound to <C-p> below).
  ----------------------------------------------------------------------------
  { "junegunn/fzf", build = ":call fzf#install()" },
  "junegunn/fzf.vim",

  ----------------------------------------------------------------------------
  -- Definitions overview (kept: tagbar, needs the `ctags` binary). <F8> toggle.
  ----------------------------------------------------------------------------
  "preservim/tagbar",

  ----------------------------------------------------------------------------
  -- Status + buffer/tab line (replaces vim-airline).
  ----------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        -- Show open buffers along the top, like airline's tabline did.
        tabline = {
          lualine_a = { { "buffers", mode = 2 } },
          lualine_z = { "tabs" },
        },
      })
    end,
  },
}, {
  -- lazy.nvim ui/options
  change_detection = { notify = false },
})

------------------------------------------------------------------------------
-- Options (ported 1:1 from the old `set ...` lines)
------------------------------------------------------------------------------
local opt = vim.opt

opt.encoding   = "utf-8"
opt.cpoptions:append("$")  -- put a `$` at the end of the changed text on `c`
opt.wrap       = false
opt.autoindent = true
opt.tabstop    = 4
opt.shiftwidth = 4
opt.expandtab  = true
opt.hlsearch   = true
opt.incsearch  = true
opt.ignorecase = true
opt.number     = true

opt.hidden     = true   -- allow buffers with unsaved changes
opt.wildmenu   = true   -- expand vim commands like :tabe
opt.wildmode   = "full"
opt.scrolloff  = 4      -- keep 4 lines off the edges when scrolling
opt.swapfile   = false  -- never used it
opt.modeline   = false  -- ignore vim modelines

opt.cmdheight  = 2      -- more space for messages

-- Some servers have issues with backup files (coc #649); harmless to keep off.
opt.backup      = false
opt.writebackup = false

-- Snappier UI/diagnostic updates (default 4000ms felt laggy).
opt.updatetime  = 250

-- Always show the sign column so text doesn't shift when diagnostics appear.
opt.signcolumn  = "yes"

vim.cmd("syntax enable")

-- Highlight Python inside markdown fenced blocks.
vim.g.markdown_fenced_languages = { "python" }

-- tagbar behaviour
vim.g.tagbar_autoclose = 1
vim.g.tagbar_autofocus = 1

-- Disable vim-surround's default mappings; we set workman-friendly ones below.
vim.g.surround_no_mappings = 1

------------------------------------------------------------------------------
-- Filetype tweaks (replaces the BufRead/BufNewFile autocmds with the modern API)
------------------------------------------------------------------------------
vim.filetype.add({
  extension = { mdx = "markdown" },
  pattern = { [".*%.yaml%.tpl"] = "yaml" },
})

------------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------------
local map = vim.keymap.set

-- Goto definition (uses LSP via tagfunc when a server is attached, else ctags).
map("n", "gd", "<C-]>", { silent = true })

-- Fugitive: git blame.
map("n", "gb", ":Git blame<CR>", { silent = true })

----------------------------------------------------------------------------
-- Workman keyboard-layout remaps.
-- These swap movement/edit keys to their Workman positions. Non-recursive.
----------------------------------------------------------------------------
local workman = {
  l = "o", o = "l", L = "O", O = "L",
  j = "n", n = "j", J = "N", N = "J",
  k = "e", e = "k", K = "E", E = "K",
  h = "y", y = "h", H = "Y", Y = "H",
}
for lhs, rhs in pairs(workman) do
  map("", lhs, rhs)  -- "" == normal + visual + operator-pending, like :noremap
end

----------------------------------------------------------------------------
-- vim-surround, remapped for Workman (`y`->`h`, so ysurround lives on `h`).
-- These must be recursive (remap = true) to expand the <Plug> mappings.
----------------------------------------------------------------------------
local plug = { remap = true, silent = true }
map("n", "ds",  "<Plug>Dsurround",  plug)
map("n", "cs",  "<Plug>Csurround",  plug)
map("n", "cS",  "<Plug>CSurround",  plug)
map("n", "hs",  "<Plug>Ysurround",  plug)
map("n", "hS",  "<Plug>YSurround",  plug)
map("n", "hss", "<Plug>Yssurround", plug)
map("n", "hSs", "<Plug>YSsurround", plug)
map("n", "hSS", "<Plug>YSsurround", plug)
map("x", "S",   "<Plug>VSurround",  plug)
map("x", "gS",  "<Plug>VgSurround", plug)

-- Fuzzy find files (Ctrl-P, like the classic CtrlP plugin).
map("n", "<C-p>", ":FZF<CR>", { silent = true })

-- Buffer management.
map("", "<C-x>", ":bd<CR>", { silent = true })  -- close buffer
map("", "<C-o>", ":bn<CR>", { silent = true })  -- next buffer
map("", "<C-y>", ":bp<CR>", { silent = true })  -- previous buffer

-- Search the visual selection (yank then search for it).
map("x", "//", [[y/<C-R>"<CR>]], { silent = true })

-- Clear search highlight.
map("n", "<leader>/", ":noh<CR>", { silent = true })

-- Toggle the tagbar.
map("n", "<F8>", ":TagbarToggle<CR>", { silent = true })

------------------------------------------------------------------------------
-- Autocommands
------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup

-- Markdown: soft-wrap on word boundaries, wrap to 80 columns.
local md = augroup("Markdown", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = md, pattern = "markdown",
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
  end,
})

-- Format on save (formatter.nvim provides :FormatWrite).
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("FormatAutogroup", { clear = true }),
  pattern = "*",
  command = "FormatWrite",
})

------------------------------------------------------------------------------
-- Diagnostics: no inline virtual text; show a float on CursorHold instead.
------------------------------------------------------------------------------
vim.diagnostic.config({ virtual_text = false })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = augroup("DiagnosticFloat", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
