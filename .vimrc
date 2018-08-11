
" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"
let &titlestring=expand("%:t")
set title

set cmdheight=2
let g:echodoc_enable_at_startup = 1
let g:echodoc#enable_force_overwrite = 1

" see https://github.com/neovim/neovim/issues/7663
function! InsertOnTerm()
    if expand('%f')[:3] == 'term'
        startinsert
    endif 
endfunction

if has("nvim")
    set guicursor=
    tnoremap <M-[> <C-\><C-n>
    nnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    tnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    nnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    tnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    tnoremap <M-w> <C-\><C-n>w
    command! Newterm :tabnew | term
    set scrollback=50000
endif 

" temporary fix until this works natively in the terminal
set autoread
au FocusGained * :checktime

" terminal
if has("nvim")
endif 

"enable very magic
" nnoremap / /\v
nnoremap ? ?\v
" nnoremap <leader>a :qa<cr>
set smartcase

" lvdb
nnoremap <localleader>d :call lvdb#Python_debug()<cr>
nnoremap <leader>n :call lines#ToggleNumber()<cr>

"plugin management
filetype on
filetype plugin on
filetype indent on

" tagbar
nnoremap <localleader>t :TagbarToggle<CR>

" togglelist settings
let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call ToggleQuickfixList()<cr>

" lvdb settings  (always toggle line numbers)
let g:lvdb_toggle_lines = 3
let g:lvdb_close_tabs = 1
nnoremap <localleader>d :call lvdb#Python_debug()<cr>

" if has("gui_running")
    set spell
" else
    " "spell check comes out as poor highlighting
    set nospell
" endif

" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc)$',
\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
nnoremap <localleader>f :CtrlP getcwd()<cr>

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


"in case there are system specific settings
try
    source ~/.vimrc_specific
    source ~/repos/linux-config/.vimrc_specific
    source ~/repos/misc-scripts/.vimrc_specific
    source ~/repos/misc-scripts/.vimrc_extra
catch
endtry

colorscheme Iosvkem

