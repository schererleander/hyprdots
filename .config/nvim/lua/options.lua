local options = {
	list = false,
	backup = false,									-- creates a backup file
  clipboard = "unnamedplus",			-- allows neovim to access the system clipboard
  conceallevel = 0,								-- so that `` is visible in markdown files
  fileencoding = "utf-8",					-- the encoding written to a file
  hidden = true,									-- required to keep multiple buffers and open multiple buffers
  hlsearch = true,								-- highlight all matches on previous search pattern
  ignorecase = true,							-- ignore case in search patterns
  mouse = "a",										-- allow the mouse to be used in neovim
  laststatus = 3,
	showmode = false,								-- we don't need to see things like -- INSERT -- anymore
  smartcase = true,								-- smart case
  smartindent = true,							-- make indenting smarter again
  splitbelow = true,							-- force all horizontal splits to go below current window ↕️
  splitright = true,							-- force all vertical splits to go to the right of current window ↔️
  swapfile = false,								-- creates a swapfile
  termguicolors = true,						-- set term gui colors (most terminals support this)
  timeoutlen = 100,								-- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,								-- enable persistent undo
  updatetime = 300,								-- faster completion (4000ms default) ⚡
  writebackup = false,						-- if a file is being edited by another program, it is not allowed to be edited
  expandtab = false,							-- use tabs instead of spaces ␣
  pumheight = 10,
	cmdheight = 2,
	shiftwidth = 2,									-- the number of spaces inserted for each indentation
  tabstop = 2,										-- insert 2 spaces for a tab ⇥
  cursorline = false,							-- highlight the current line (disabled for now)
  number = false,									-- set numbered lines
  relativenumber = false,					-- set relative numbered lines
  numberwidth = 4,								-- set number column width to 2 (default 4)
  wrap = false,										-- display lines as one long lines
}

vim.opt.shortmess:append 'c'

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.wo.list = false

vim.cmd 'set whichwrap+=<,>,[,],h,l'
