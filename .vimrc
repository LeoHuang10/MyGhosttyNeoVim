" ========== 專業遊戲開發 ==========

" ========== Vim 插件配置 ==========

" ---------- 自動檢測操作系統並設置路徑 ----------
if has('win32') || has('win64')
    let $VIMHOME = $HOME . '/vimfiles'
else
    let $VIMHOME = $HOME . '/.vim'
endif

" ---------- 確保 vim-plug 已安裝 ----------
let s:plug_path = $VIMHOME . '/autoload/plug.vim'
if empty(glob(s:plug_path))
    if executable('curl')
        silent exec '!curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    elseif executable('wget')
        silent exec '!wget -O ' . s:plug_path . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        echoerr "需要 curl 或 wget 來下載 vim-plug，請手動安裝。"
    endif
    if filereadable(s:plug_path)
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

call plug#begin($VIMHOME . '/plugged')

" ========== 主題與界面 ==========
Plug 'morhetz/gruvbox'                      " 深色護眼配色主題
Plug 'itchyny/lightline.vim'                " 輕量級狀態欄
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }   " 側邊欄文件樹
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }      " 模糊查找核心
Plug 'junegunn/fzf.vim'                     " fzf Vim 集成
Plug 'mhinz/vim-startify'                   " 啟動界面美化
Plug 'ryanoasis/vim-devicons'               " 文件類型圖標

" ========== AI 輔助編程 ==========
Plug 'github/copilot.vim'                   " GitHub 官方 AI 代碼補全

" ========== Git 集成 ==========
Plug 'tpope/vim-fugitive'                   " Git 操作封裝
Plug 'airblade/vim-gitgutter'               " 行號旁顯示 Git 變更狀態
Plug 'rhysd/conflict-marker.vim'            " 合併衝突標記處理

" ========== 代碼導航 ==========
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }    " 代碼結構大綱
Plug 'ludovicchabant/vim-gutentags'         " 自動管理 ctags

" ========== 編輯增強 ==========
Plug 'jiangmiao/auto-pairs'                 " 括號、引號自動配對
Plug 'preservim/nerdcommenter'              " 批量注釋/取消注釋
Plug 'junegunn/vim-easy-align'              " 文本對齊
Plug 'mg979/vim-visual-multi'               " 多光標編輯
Plug 'Yggdroot/indentLine'                  " 顯示縮進對齊線
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } } " 自動生成文檔注釋

" ========== LSP 與智能編碼核心 ==========
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP 客戶端
Plug 'dense-analysis/ale'                   " 異步語法檢查引擎

" ========== 調試器 ==========
Plug 'puremourning/vimspector', { 'do': './install_gadget.py --all' } " 多語言圖形化調試器

" ========== C/C++ 底層開發（CryEngine / Unreal Engine） ==========
Plug 'bfrg/vim-cpp-modern', { 'for': ['c', 'cpp'] }     " C++ 語法高亮增強（支援 C++11/14/17/20/23）
Plug 'vim-scripts/a.vim', { 'for': ['c', 'cpp'] }       " .c/.h 文件快速切換

" ========== C# 語言支持（CryEngine C# / Godot C# / Unity） ==========
Plug 'OmniSharp/omnisharp-vim', { 'for': 'cs' }         " C# LSP 客戶端，提供補全、定義跳轉、重構

" ========== 遊戲引擎專用插件 ==========
" CryEngine: 無專屬插件，通過 C++/C# 工具鏈完美支持

" Unreal Engine: 社區唯一活躍維護的 UE Vim 插件
Plug 'drichardson/vim-unreal', { 'for': 'cpp' }

" Bevy: 無專屬插件，通過 Rust 工具鏈完美支持
Plug 'rust-lang/rust.vim', { 'for': 'rust' }            " Rust 官方語法插件

" Godot: Vim 官方維護者開發，支援 GDScript 語法高亮、折疊、運行命令
Plug 'habamax/vim-godot', { 'for': ['gdscript', 'gd'] }

" Unity: 支援構建輸出解析、ALE 集成、ShaderLab 識別
Plug 'idbrii/vim-unityengine', { 'for': 'cs' }

" ========== 其他編程語言支持 ==========
Plug 'fatih/vim-go', { 'for': 'go' }                    " Go 語言官方工具集成
Plug 'vim-python/python-syntax', { 'for': 'python' }    " Python 增強語法高亮
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascriptreact'] }
Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascriptreact'] }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'typescriptreact'] }
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'tomlion/vim-solidity', { 'for': 'solidity' }
Plug 'udalov/kotlin-vim', { 'for': 'kotlin' }
Plug 'keith/swift.vim', { 'for': 'swift' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }

" ========== 數據庫交互 ==========
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui', { 'on': 'DBUI' }

" ========== 異步任務與測試 ==========
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-test/vim-test'

" ========== 輔助工具 ==========
Plug 'liuchengxu/vim-which-key'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sbdchd/neoformat'

call plug#end()

" =============================================================================
" 基本編輯設置
" =============================================================================
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
set wildmenu
set showcmd
set laststatus=2
set cursorline
set scrolloff=5
set autoread

if has('mac')
    set clipboard=unnamed
elseif has('unix')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set ambiwidth=double

" ========== 真彩色支持 ==========
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" ========== 主題設置 ==========
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_termcolors = 256
let g:gruvbox_italic = 1
colorscheme gruvbox

" ========== 快捷鍵映射 ==========
map <C-n> :NERDTreeToggle<CR>
map <C-p> :Files<CR>
map <C-f> :Rg<CR>
map <C-t> :TagbarToggle<CR>
map <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
map <C-q> :q<CR>
map <leader>h :nohlsearch<CR>
map <leader>w :WhichKey<CR>

" ========== NERDTree 設置 ==========
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '\.swp$', '\.DS_Store']
let NERDTreeHighlightCursorline=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" ========== Lightline 設置 ==========
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" ========== coc.nvim 智能補全配置 ==========
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

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)

" ========== ALE 語法檢查配置 ==========
let g:ale_linters = {
\   'c': ['clang'],
\   'cpp': ['clang'],
\   'cs': ['OmniSharp'],
\   'python': ['pylint', 'mypy'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'go': ['gopls'],
\   'rust': ['cargo', 'analyzer'],
\}
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 0

" ========== Neoformat 格式化配置 ==========
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_cs = ['csharpier']
let g:neoformat_enabled_go = ['gofmt']
let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_c = ['clang-format']
let g:neoformat_enabled_cpp = ['clang-format']

" ========== vimspector 調試器快捷鍵 ==========
nmap <F5> <Plug>VimspectorContinue
nmap <F6> <Plug>VimspectorStop
nmap <F9> <Plug>VimspectorToggleBreakpoint
nmap <F10> <Plug>VimspectorStepOver
nmap <F11> <Plug>VimspectorStepInto
nmap <F12> <Plug>VimspectorStepOut

" ========== 語言專用設置 ==========
let g:rustfmt_autosave = 1
let g:python_highlight_all = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 0
let g:go_highlight_format_strings = 0

" ========== omnisharp-vim 設置 ==========
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlighting = 3

" ========== 測試運行器 ==========
let test#strategy = 'asyncrun'
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

" ========== 文件類型檢測 ==========
filetype plugin indent on

" ========== GUI 字體設置 ==========
if has("gui_running")
  if has("win32")
    set guifont=LXGW_WenKai_Mono_GB:h12
  else
    set guifont=LXGW\ WenKai\ Mono\ GB:h12
  endif
endif

" ========== 其他便捷設置 ==========
inoremap jk <Esc>:w<CR>
if has('unix')
    vnoremap <C-c> "+y
endif
au FocusGained,BufEnter * checktime
if exists('g:loaded_webdevicons')
    " call webdevicons#refresh()
endif
