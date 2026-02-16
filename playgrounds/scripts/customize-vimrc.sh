cat <<'EOF' >> $HOME/.vimrc
syntax on
colorscheme slate

hi SpellBad term=reverse ctermbg=red

set number relativenumber
set cursorline
set showcmd   "shows current command in the statusline
set exrc      "read <cwd>/.vimrc
set ttyfast   "more characters will be sent to the screen for redrawing
set wildmenu  "a better menu in command mode
set wildmode=longest:full,full
set colorcolumn=81
highlight ColorColumn ctermbg=235 guibg=#2c2d27

set hlsearch  "highlights search results
set ignorecase smartcase
set shortmess-=S
hi Search ctermbg=DarkGray
hi Search ctermfg=Red
hi QuickFixLine term=reverse ctermbg=52  "change QuickFix selected line color

set laststatus=2
set statusline=%f\:%l\:%c\ \[%L\]

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

filetype plugin indent on

set runtimepath^=~/.fzf
set runtimepath^=~/.vim/bundle/fzf.vim

set grepprg=rg\ --vimgrep\ --smart-case\ --follow
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
EOF