set nocompatible
set ruler
set hidden
set lazyredraw
set wildmenu
set hlsearch
set textwidth=80
set ttyfast
set showmatch
set incsearch
set directory-=.
set notitle
set tabstop=8
set shiftwidth=8
set noexpandtab
set nolist

silent! set foldmethod=marker " Use braces by default
set formatoptions=tcqn1     " t - autowrap normal text
                            " c - autowrap comments
                            " q - gq formats comments
                            " n - autowrap lists
                            " 1 - break _before_ single-letter words
                            " 2 - use indenting from 2nd line of para

" tab:▸\ "
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·,eol:¬ " Unicode characters for various things

set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//
set tags=./.tags;/

" Some useful macros
nmap \A :set formatoptions+=a<CR>:echo "autowrap enabled"<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \a :set formatoptions-=a<CR>:echo "autowrap disabled"<CR>
nmap \b :set nocin tw=80<CR>:set formatoptions+=a<CR>
nmap \i vip:sort<CR>
nmap \l :setlocal number!<CR>:setlocal number?<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nmap \o :set paste!<CR>:set paste?<CR>
nmap \q :nohlsearch<CR>
nmap \s :setlocal invspell<CR>
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \u :setlocal list!<CR>:setlocal list?<CR>
nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>
nmap \z :w<CR>:!open %<CR><CR>
nmap \<F3> :AsyncRun ctags -R --exclude=.git -f .tags .<CR>

" Turn off linewise keys. Normally, the `j' and `k' keys move the cursor down one entire line. with
" line wrapping on, this can cause the cursor to actually skip a few lines on the screen because
" it's moving from line N to line N+1 in the file. I want this to act more visually - I want `down'
" to mean the next line on the screen
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

function! CleanSpaces()
  silent! execute '%s/\s\+$//ge'
  silent! execute 'g/\v^$\n*%$/norm! dd'
endfunction

function! Format()
  silent! execute 'norm! mz'

  if &ft ==? 'c' || &ft ==? 'cpp' || &ft ==? 'php'
    set formatprg=astyle\ --style=kr\ --indent=force-tab=8\
			    \ --attach-closing-while\ --align-pointer=type\ --indent-switches\
			    \ --indent-col1-comments\ --break-blocks\ --pad-oper\ --pad-comma\
			    \ --unpad-paren\ --break-one-line-headers\ --remove-braces\ --pad-header\
			    \ --attach-return-type\ --attach-return-type-decl
    silent! execute 'norm! gggqG'
  elseif &ft ==? 'java'
    set formatprg=astyle\ --mode=java
    silent! execute 'norm! gggqG'
  endif

  silent! call CleanSpaces()
  silent! execute 'retab'
  silent! execute 'gg=G'
  silent! execute 'norm! `z'
  set formatprg=
endfunction

" Trim spaces at EOL and retab
command! Clean retab | execute CleanSpaces()
command! Format execute Format()

" Close all buffers except this one
command! BufCloseOthers %bd|e#

filetype off
execute pathogen#infect()
execute pathogen#helptags()
filetype indent plugin on

let g:NERDTreeWinSize = 22
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:Tlist_WinWidth = 30

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  ['.l:branchname.'] ':''
endfunction

nnoremap <Backspace> <C-o>
nnoremap <Space> <C-i>

map <C-o> :NERDTreeToggle<CR>
map <C-e> :new<CR>
map <C-f> :enew<CR>
map <C-t> :Tlist<CR>

nmap <F2> :w <CR>
nmap <F5> :vsp <CR>
nmap <S-F5> :sp <CR>

map <F6> <C-W>w

nmap <C-d> :bd <CR>
nmap <C-l> \bt <CR>
nmap <S-F10> :BD <CR>
nmap <F10> :close <CR>

nmap <silent><M-Left> :wincmd h <CR>
nmap <silent><M-Right> :wincmd l <CR>
nmap <silent><M-Up> :wincmd k <CR>
nmap <silent><M-Down> :wincmd j <CR>

nmap <C-n> :bnext<CR>
nmap <C-m> :bprev<CR>

map <silent><C-Delete> :dd <CR>

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set laststatus=2

set statusline=
set statusline=%<%f\ %h%m%r
set statusline+=%{StatuslineGit()}
set statusline+=[%{&fileencoding?&fileencoding:&encoding}]
set statusline+=%=%-14.(%l,%c%V%)\ %P

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimResized * :wincmd =

" Make sure colored syntax mode is on, and make it Just Work with 256-color terminals.
set background=dark
let g:rehash256 = 1 " Something to do with Molokai?
" colorscheme molokai
if !has('gui_running')
  let g:solarized_termcolors=256
  if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
    set t_Co=256
  elseif has("terminfo")
    colorscheme default
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
  else
    colorscheme default
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
  " Disable Background Color Erase when within tmux - https://stackoverflow.com/q/6427650/102704
  if $TMUX != ""
    set t_ut=
  endif
endif
syntax on

" Line cursor
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline!<CR>

" Window splits & ruler are too bright, so change to white on grey (non-GUI)
highlight VertSplit cterm=NONE ctermbg=white ctermfg=white

" Some plugin seems to search for something at startup, so this fixes that.
silent! nohlsearch

" vim:set tw=80:
