" ========== 插件管理器 ==========
call plug#begin('~/.vim/plugged')

" ========== 基础增强插件 ==========
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-startify'
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'

" ========== 主题 ==========
Plug 'morhetz/gruvbox'

" ========== Rust 开发 ==========
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ========== C/C++ 开发 ==========
Plug 'bfrg/vim-cpp-modern'
Plug 'preservim/tagbar'
Plug 'vim-syntastic/syntastic'

" ========== Swift 开发 ==========
Plug 'keith/swift.vim'

" ========== Python 开发 ==========
Plug 'vim-python/python-syntax'

" ========== JavaScript 开发 ==========
Plug 'pangloss/vim-javascript'

" ========== Go 开发 ==========
Plug 'fatih/vim-go'

" ========== Ruby 开发 ==========
Plug 'vim-ruby/vim-ruby'

" ========== Java 开发 ==========
Plug 'artur-shaik/vim-javacomplete2'

call plug#end()

" ========== 基本设置 ==========
set number
set relativenumber
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
syntax on
set background=dark
set termguicolors
set clipboard=unnamedplus
set wildmenu
set showcmd
set laststatus=2
set cursorline
set scrolloff=5

" ========== 中文支持 ==========
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set ambiwidth=double

" ========== 主题 ==========
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" ========== 快捷键 ==========
map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR>
map <C-f> :Rg<CR>
map <C-t> :TagbarToggle<CR>
map <C-u> :UndotreeToggle<CR>
map <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
map <C-q> :q<CR>
map <leader>h :nohlsearch<CR>

" ========== NERDTree 设置 ==========
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '\.swp$', '\.DS_Store']

" ========== Airline 设置 ==========
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'gruvbox'

" ========== COC 补全 ==========
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" ========== 语法检查 ==========
let g:ale_linters = {
\   'rust': ['cargo', 'analyzer'],
\   'c': ['clang'],
\   'cpp': ['clang'],
\   'python': ['pylint'],
\}
let g:ale_fix_on_save = 1

" ========== 语言专用设置 ==========
let g:rustfmt_autosave = 1
let g:python_highlight_all = 1

" ========== 文件类型 ==========
filetype plugin indent on
