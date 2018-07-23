
" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"

"plugin management
filetype on
filetype plugin on
filetype indent on

"pathogen plugin
call pathogen#infect()

" togglelist settings
let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call ToggleQuickfixList()<cr>

" lvdb settings  (always toggle line numbers)
let g:lvdb_toggle_lines = 3
let g:lvdb_close_tabs = 1
nnoremap <localleader>d :call lvdb#Python_debug()<cr>

" color setup
" backspace/colors
set bs=2

set t_Co=256
colorscheme Iosvkem
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

