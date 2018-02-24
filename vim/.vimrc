set nocompatible
set ruler
set hidden
set lazyredraw
set wildmenu
set hlsearch
set textwidth=80

"""
set ttyfast
set showmatch
set incsearch
set directory-=.
set notitle

filetype off
execute pathogen#infect()
filetype indent plugin on

set tabstop=8
set shiftwidth=8
set noexpandtab

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let tabmode = ''

" allow toggling between local and default mode
function! TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
    let g:tabmode=''
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
    let g:tabmode='[T]'
  endif
  echo 'ts:'.&l:tabstop.', st:'.&l:softtabstop.', sw:'.&l:shiftwidth.', et:'.&l:expandtab
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  ['.l:branchname.'] ':''
endfunction

function! TabSettings()
  return '  [ts='.&l:tabstop.', sw='.&l:shiftwidth.', et='.&l:expandtab.']  '
endfunction

map <C-o> :NERDTreeToggle<CR>
nmap <F2> :w <CR>
nmap <F5> :vsp <CR>
nmap <S-F5> :sp <CR>
nmap <F4> mz:execute TabToggle() <CR>'z
map <F6> <C-W>w
nmap <F7> :tabp <CR>
nmap <F8> :tabn <CR>
nmap <F9> :bd <CR>
nmap <C-q> :BD <CR>
nmap <S-F9> :close <CR>
nmap <F10> :q <CR>

nmap <silent> <M-Left> :wincmd h <CR>
nmap <silent> <M-Right> :wincmd l <CR>
nmap <silent> <M-Up> :wincmd k <CR>
nmap <silent> <M-Down> :wincmd j <CR>
nmap <C-n> :bnext<CR>
nmap <C-m> :bprev<CR>
map <silent> <C-Delete> :dd <CR>

nnoremap <Tab> :bnext <CR>
nnoremap <S-Tab> :bprevious <CR>

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set laststatus=2

set statusline=
set statusline=%<%f\ %h%m%r
set statusline+=%{StatuslineGit()}
set statusline+=[%{&fileencoding?&fileencoding:&encoding}]
set statusline+=%{g:tabmode}
set statusline+=%=%-14.(%l,%c%V%)\ %P

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimResized * :wincmd =

