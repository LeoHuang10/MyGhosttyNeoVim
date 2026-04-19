" ========== Vim 插件配置（與 Neovim 對應） ==========

" 自動檢測操作系統並設置路徑
if has('win32') || has('win64')
    let $VIMHOME = $HOME . '/vimfiles'
else
    let $VIMHOME = $HOME . '/.vim'
endif

" 確保 vim-plug 已安裝
let s:plug_path = $VIMHOME . '/autoload/plug.vim'
if empty(glob(s:plug_path))
    if has('win32')
        silent exec '!curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent exec '!curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMHOME . '/plugged')

" 主題與界面
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'

" 代碼導航
Plug 'preservim/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" 編輯增強
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'

" LSP 與補全（coc.nvim）
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 調試器
Plug 'puremourning/vimspector'

" 編程語言專用
" C 語言（無單獨插件，使用 coc-clangd 即可）
" C++ 語言
Plug 'bfrg/vim-cpp-modern'          " C++ 語法增強
" Rust
Plug 'rust-lang/rust.vim'
" Swift
Plug 'keith/swift.vim'
" Lua
Plug 'vim-lua/lua-vim'
" C#
Plug 'idbrii/vim-unityengine'
" Zig
Plug 'ziglang/zig.vim'
" Java
Plug 'neoclide/coc-java', {'do': 'npm install'}
" Go
Plug 'fatih/vim-go'
" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" TypeScript
Plug 'HerringtonDarkholme/yats.vim'
" Lisp
Plug 'vlime/vlime'
" Clojure
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace'
" Solidity
Plug 'TovarishFin/vim-solidity'
" Python
Plug 'vim-python/python-syntax'
" Ruby
Plug 'vim-ruby/vim-ruby'

" 遊戲引擎
Plug 'drichardson/vim-unreal'       " Unreal Engine
Plug 'habamax/vim-godot'            " Godot
Plug 'idbrii/vim-unityengine'       " Unity

" 數據庫
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" 任務運行
Plug 'tpope/vim-dispatch'
Plug 'skywind3000/asyncrun.vim'

" 快捷鍵提示
Plug 'liuchengxu/vim-which-key'

" 單元測試
Plug 'vim-test/vim-test'

" tmux 導航
Plug 'christoomey/vim-tmux-navigator'

" 代碼格式化
Plug 'sbdchd/neoformat'

call plug#end()

" ========== 基本設置 ==========
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

" ========== 主題 ==========
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" ========== 快捷鍵 ==========
map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR>
map <C-f> :Rg<CR>
map <C-t> :TagbarToggle<CR>
map <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
map <C-q> :q<CR>
map <leader>h :nohlsearch<CR>

" ========== NERDTree 設置 ==========
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '\.swp$', '\.DS_Store']

" ========== Airline 設置 ==========
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'gruvbox'

" ========== COC 補全 ==========
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

" ========== 語法檢查 ==========
let g:ale_linters = {
\   'rust': ['cargo', 'analyzer'],
\   'c': ['clang'],
\   'cpp': ['clang'],
\   'python': ['pylint'],
\}
let g:ale_fix_on_save = 1

" ========== 語言專用設置 ==========
let g:rustfmt_autosave = 1
let g:python_highlight_all = 1

" ========== 文件類型 ==========
filetype plugin indent on

" ========== 字體設置（僅對 GUI 生效，如 MacVim） ==========
if has("gui_running")
  if has("win32")
    set guifont=LXGW_WenKai_Mono_GB:h12
  else
    set guifont=LXGW\ WenKai\ Mono\ GB:h12
  endif
endif
