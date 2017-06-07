" Stop vim from folding everything it can find to fold upon file open
set nofoldenable

" YCM debugging
let g:ycm_server_python_interpreter='python3'
let g:ycm_server_keep_logfiles=1
let g:ycm_server_log_level='debug'

" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"

"enable very magic
"nnoremap / /\v
"nnoremap ? ?\v
set smartcase

"plugin management
filetype on
filetype plugin on
filetype indent on

"pathogen plugin
call pathogen#infect()

" ycm
let g:ycm_show_diagnostics_ui = 1

" togglelist settings
let g:toggle_list_no_mappings=1
nnoremap <leader>l :call ToggleLocationList()<cr>
nnoremap <leader>q :call ToggleQuickfixList()<cr>

" lvdb settings  (always toggle line numbers)
let g:lvdb_toggle_lines = 3

" color setup
" backspace/colors
set bs=2

"colorscheme stuff
colorscheme laura
"change background
set t_Co=256
if has("gui_running")
    set spell
else
    "spell check comes out as poor highlighting
    set nospell
endif

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <localleader>e :SyntasticCheck<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_checkers = ['pylint']

" note for cppcheck, you probably need a '-I' set, so use
" let g:syntastic_cpp_cppcheck_args = '-I /path/to/incl/ -I /path/to/other_incl'
"
" for cpplint, you might want
" let g:syntastic_cpp_cpplint_args = '--root=/path/to/project/root --recursive'
let g:syntastic_cpp_checkers = ['cpplint']
"let g:syntastic_cpp_checkers = []
"let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_aggregate_errors = 1


" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc)$',
\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
nnoremap <leader>p :CtrlP getcwd()<cr>


" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1




"in case there are system specific settings
try
    source ~/repos/linux-config/.vimrc_extra
    source ~/.vimrc_extra
    source ~/.vimrc_specific
    source ~/repos/linux-config/.vimrc_specific
catch
endtry

