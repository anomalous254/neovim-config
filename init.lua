-- =========================
-- Treesitter: Quarto/Pandoc
-- =========================

local ts = vim.treesitter.language

-- Pandoc Markdown parser
pcall(function()
  ts.add('pandoc_markdown', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown.so" })
  ts.add('pandoc_markdown_inline', { path = "/usr/local/lib/libtree-sitter-pandoc-markdown-inline.so" })
  ts.register('pandoc_markdown', { 'quarto', 'rmarkdown' })
end)

-- Quarto Markdown parser
pcall(function()
  ts.add('quarto_markdown', { path = "/usr/local/lib/libtree-sitter-markdown.so" })
  ts.add('quarto_markdown_inline', { path = "/usr/local/lib/libtree-sitter-markdown-inline.so" })
  ts.register('quarto_markdown', { 'quarto', 'rmarkdown' })
end)

-- =========================
-- Require configs
-- =========================
require 'config.global'
require 'config.lazy'
require 'config.autocommands'
require 'config.redir'

-- =========================
-- Treesitter Autocmd
-- =========================
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'quarto', 'rmarkdown', 'markdown' }, -- fixed from <filetype>
  callback = function()
    -- Treesitter automatically starts when parser exists
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
  end,
})

-- =========================
-- Colorscheme
-- =========================
local use_minimal_default_colors = false

if use_minimal_default_colors then
  vim.cmd.colorscheme 'rusty'

  -- reload colors module if it was already loaded
  local mod = 'utils.colors'
  if package.loaded[mod] then
    package.loaded[mod] = nil
  end

  require(mod)
else
  local ok, _ = pcall(vim.cmd, "colorscheme kanagawa") -- safely load
  if not ok then
    vim.cmd("colorscheme rusty") -- fallback
  end
end

vim.cmd("colorscheme rusty")

-- =========================
-- Transparent background
-- =========================
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight ColorColumn ctermbg=none guibg=none
  highlight SignColumn ctermbg=none guibg=none
  highlight LineNr ctermbg=none guibg=none
  highlight CursorLine ctermbg=none guibg=none
  highlight CursorLineNr ctermbg=none guibg=none
]]
