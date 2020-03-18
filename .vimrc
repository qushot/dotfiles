"##### SETTINGS #####
" 文字コード: UTF-8
set fenc=utf-8
" バックアップファイルを作らない
set nobackup

" ##### 見た目 #####
" 行番号
set number
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" 現在の行を強調
set cursorline
" ステータスラインを常に表示
set laststatus=2
" ターミナルのタイトルをセットする
set title
" 色分け
syntax on
" タブ幅をスペース4つ分
set tabstop=4
" タブを半角スペースで挿入する
" set expandtab
" vimが読み込む際のタブ幅をスペース4つ分にする
set shiftwidth=4
" 自動でインデントしてくれる
set smartindent
" コマンドラインモードの補完
set wildmenu wildmode=longest:full,full
" OSのクリップボードを使う
set clipboard+=unnamed
" ターミナルでマウスを使用できるようになる
if has ("mouse")
	set mouse=a
	set guioptions+=a
	set ttymouse=xterm2
endif
" カーソルを常に画面の中央に表示させる
" set scrolloff=999{
" Unicodeで行末が変になる問題を解決
set ambiwidth=double
" コマンド、検索パターンを50まで保存
set history=50
" インクリメンタルサーチを有効にする
set incsearch
" 大文字小文字を区別しない
set ignorecase
" 大文字で検索されたら対象を大文字限定にする
set smartcase
" 行末まで検索したら行頭に戻る
set wrapscan
" カーソルの回り込みができるようにする
set whichwrap=b,s,[,],<,>
" バックスペースを、空白、行末、行頭でも使えるように
set backspace=indent,eol,start
" 不可視文字を可視化
set list
set listchars=tab:▸-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" 分割関連
nnoremap s <Nop>
" ウィンドウの移動
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sw <C-w>w
" ウィンドウの入れ替え
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
" ウィンドウの大きさ
nnoremap so <C-w>_<C-w>|
nnoremap s= <C-w>=
nnoremap sO <C-w>=
" ウィンドウの分割
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" 閉じる
nnoremap sq :<C-u>q<CR>
" jjをEscに
inoremap <silent> jj <esc>

" 全角スペース・行末のスペース・タブの可視化
function! TwoByteSpace()
	highlight TwoByteSpace cterm=reverse ctermfg=DarkGray gui=reverse guifg=DarkGray
endfunction
if has('syntax')
	augroup TwoByteSpace
		autocmd!
		autocmd ColorScheme       * call TwoByteSpace()
		autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('TwoByteSpace', '　')
	augroup end
	call TwoByteSpace()
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/moto/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/moto/.cache/dein')
  call dein#begin('/Users/moto/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/moto/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  call dein#add('fatih/vim-go')
  call dein#add('Shougo/unite.vim')
  call dein#add('scrooloose/nerdtree')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------