"
" options
"
syntax on
filetype plugin indent on

set showcmd
set showmatch
set ic
set hls is
set smartcase
set hidden
set autowrite
set ruler
set nu
set tabstop=4
set shiftwidth=4
set pastetoggle=<F3>
set expandtab
set t_Co=256
set noswapfile
set autoread


"
" maps
"
let mapleader=" "
nnoremap <leader>"      viw<ESC>a"<ESC>hbi"<ESC>lel
nnoremap <leader>if     A {<ESC>jo}<CR><ESC>
nnoremap <leader>xif    $xxjjdd
nnoremap <leader>u      mzviwU`z
nnoremap <leader>l      mzviwu`z
nnoremap <leader>!      :!!<CR>
nnoremap <leader>e      :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <leader>f      /\%<C-R>=line('.')<CR>l
nnoremap <leader>d      0D
nnoremap <C-\> :tab split<CR>:exe("tag ".expand("<cword>"))<CR>
nnoremap <A-]> :vsp <CR>:exe("tag ".expand("<cword>"))<CR>

noremap <F2> mzgg=G'z
noremap gc dgg
noremap <TAB> <C-^>

inoremap jk <ESC>
inoremap jc <ESC>:wq<CR>
inoremap jw <ESC>:w<CR>
inoremap <C-U> <ESC>mzviwU`za
inoremap <C-L> <ESC>mzviwu`za

cnoremap w!! w !sudo tee > /dev/null %


"
" plugins managed by vim-plug
"
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
xmap <Enter> <Plug>(EasyAlign)

Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

Plug 'ctrlpvim/ctrlp.vim'

Plug 'OrangeT/vim-csharp'

Plug 'majutsushi/tagbar'
let g:tagbar_ctags_bin = '/home/user/ctags'
nmap <F4> :TagbarToggle<CR>

Plug 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'luna'

call plug#end()


"
" handy self-defined commands & functions
"

" auto commands
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
autocmd BufNewFile,BufRead *.html setlocal nowrap
autocmd BufReadPost * normal! zR

" toggle comment
augroup comment_expr
    autocmd!
    autocmd FileType c,cpp,java,php,cs      let b:comment = "// "
    autocmd FileType sh,ruby,python         let b:comment = "# "
    autocmd FileType vim                    let b:comment = "\" "
augroup END
noremap <C-C> :call Comment() <CR>
function! Comment()
    if match(getline(line(".")), "^[ \t]*" . b:comment) >= 0
        let comment_str = "s/" . escape(b:comment, "\/") . "//"
    else
        let comment_str = "s/^/" . escape(b:comment, "\/") . "/"
    endif
    exe comment_str
endfunction


" vim and bash fold
augroup filetype_vim
    autocmd!
    autocmd FileType vim,sh setlocal foldmethod=marker
augroup END


" avoid screen scrolling when change buffer
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif


" grep function
nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>
function! GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent exe "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction


"
" some notes
"

" useful shortcut keys
" gv            reselect last visual selection
" cit           edit *ml tag content
" <C-L>         :redraw!
" <C-O>         run a command in insert mode
" <C-R>         paste something under cursor to command
" <C-W>T        change split to new tab
" ]p            paste and indent
" gf            open file
" <C-W>f        open in a new window
" <C-W>gf       open in a new tab

" tag shortcut keys
" <C-]>         go to first definition
" <C-T>         jump back
" <C-W><C-]>    open the definition in a horizontal split
" g]            show defitions


" registers
" 0             last yank buffer
" 1             last delete buffer
" "             last buffer (yank or delete)
" /             last search
" :             last command
" _             black hole
