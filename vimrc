" ============================================================
" 編碼與基礎
" ============================================================
set encoding=utf-8
set fileencodings=utf-8,gbk,big5,latin1
set termencoding=utf-8
scriptencoding utf-8

" ============================================================
" 界面
" ============================================================
set number
set relativenumber
set mouse=a
set clipboard=unnamedplus
set termguicolors
set signcolumn=number
set linespace=2
set guifont=LXGW\ WenKai\ Mono\ GB:h12

" ============================================================
" 行為
" ============================================================
set hidden
set nobackup
set nowritebackup
set updatetime=300
set timeoutlen=400
set splitright
set splitbelow
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline

" ============================================================
" 語言 - 默認繁體，智能切換並記住
" ============================================================
let s:localfile = expand('~/.vimrc.local')
if filereadable(s:localfile)
  execute 'source ' . s:localfile
else
  language messages zh_TW.utf-8
  set langmenu=zh_TW.utf-8
endif

command! SetCN call writefile(['language messages zh_CN.utf-8'], expand('~/.vimrc.local')) | execute 'language messages zh_CN.utf-8' | echo '已切换至简体中文界面，重启后保持'
command! SetTW call writefile(['language messages zh_TW.utf-8'], expand('~/.vimrc.local')) | execute 'language messages zh_TW.utf-8' | echo '已切換至繁體中文界面，重啟後保持'

nnoremap <leader>zh :SetCN<CR>
nnoremap <leader>zt :SetTW<CR>

" ============================================================
" 插件列表
" ============================================================
call plug#begin('~/.vim/plugged')

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'voldikss/vim-floaterm'
Plug 'Yggdroot/indentLine'

call plug#end()

" ============================================================
" Catppuccin Mocha 主題（與 Starship 調色板完全一致）
" ============================================================
set background=dark
let g:catppuccin_flavour = 'mocha'
colorscheme catppuccin

" ============================================================
" 強制純白文本
" ============================================================
hi! Normal        guibg=NONE guifg=#ffffff
hi! NormalFloat   guibg=NONE guifg=#ffffff
hi! NormalNC      guibg=NONE guifg=#ffffff
hi! Identifier    guibg=NONE guifg=#ffffff
hi! Function      guibg=NONE guifg=#ffffff

" ============================================================
" 全局透明（Ghostty 毛玻璃紫色背景透出）
" ============================================================
hi! SignColumn    guibg=NONE
hi! EndOfBuffer   guibg=NONE
hi! StatusLine    guibg=NONE
hi! StatusLineNC  guibg=NONE
hi! TabLine       guibg=NONE
hi! TabLineFill   guibg=NONE
hi! TabLineSel    guibg=NONE
hi! CursorLine    guibg=NONE
hi! CursorColumn  guibg=NONE
hi! FoldColumn    guibg=NONE
hi! Folded        guibg=NONE
hi! VertSplit     guibg=NONE
hi! ColorColumn   guibg=NONE
hi! NERDTreeNormal guibg=NONE

" ============================================================
" NERDTree 文件圖標顏色（Catppuccin Mocha 調色板）
" ============================================================
hi! DevIconC       guifg=#a6e3a1
hi! DevIconRust    guifg=#fab387
hi! DevIconJava    guifg=#fab387
hi! DevIconPython  guifg=#f9e2af
hi! DevIconKotlin  guifg=#f9e2af
hi! DevIconNode    guifg=#a6e3a1
hi! DevIconBun     guifg=#a6e3a1
hi! DevIconGo      guifg=#a6e3a1
hi! DevIconHaskell guifg=#a6e3a1
hi! DevIconDocker  guifg=#74c7ec
hi! DevIconPHP     guifg=#b4befe

" ============================================================
" airline 狀態欄 - Catppuccin Mocha 彩虹色塊
" ============================================================
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:airline_section_a = airline#section#create(['mode'])
let g:airline_section_b = airline#section#create(['branch'])
let g:airline_section_c = airline#section#create(['filetype'])
let g:airline_section_x = airline#section#create(['tagbar'])
let g:airline_section_y = airline#section#create(['fileformat','encoding'])
let g:airline_section_z = airline#section#create(['%l/%L'])

hi! airline_a      guifg=#11111b guibg=#f38ba8
hi! airline_b      guifg=#11111b guibg=#fab387
hi! airline_c      guifg=#11111b guibg=#f9e2af
hi! airline_x      guifg=#11111b guibg=#a6e3a1
hi! airline_y      guifg=#11111b guibg=#74c7ec
hi! airline_z      guifg=#11111b guibg=#b4befe
hi! airline_a_bold guifg=#11111b guibg=#f38ba8 gui=bold
hi! airline_z_bold guifg=#11111b guibg=#b4befe gui=bold

" ============================================================
" 快捷鍵（Leader = 空格）
" ============================================================
let mapleader = " "

" 語言切換
nnoremap <leader>zh :SetCN<CR>
nnoremap <leader>zt :SetTW<CR>

" 文件樹
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

" 模糊搜索
nnoremap <leader>f  :Files<CR>
nnoremap <leader>b  :Buffers<CR>
nnoremap <leader>h  :History<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <C-p>      :Files<CR>

" LSP
nnoremap <leader>gd <Plug>(coc-definition)
nnoremap <leader>gr <Plug>(coc-references)
nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>ca <Plug>(coc-codeaction)
nnoremap <leader>qf <Plug>(coc-fix-current)
nnoremap K          :call CocActionAsync('doHover')<CR>

" 補全
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" 浮動終端
nnoremap <leader>t  :FloatermToggle<CR>
tnoremap <leader>t  <C-\><C-n>:FloatermToggle<CR>

" 快速跳轉
nmap <leader>s <Plug>(easymotion-s2)

" 對齊
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" 分屏切換
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 取消搜索高亮
nnoremap <esc> :noh<CR>

" ============================================================
" 縮進線
" ============================================================
let g:indentLine_char = '│'
let g:indentLine_color_term = 239
