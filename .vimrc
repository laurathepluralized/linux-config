" mapping leaders
let mapleader = "\<space>"
let maplocalleader = "\\"
let &titlestring=expand("%:t")
set title

" let g:python3_host_prog = '/usr/bin/python3.6'
set cmdheight=2
" let g:echodoc_enable_at_startup = 1
" let g:echodoc#enable_force_overwrite = 1
" let spellfile=expand('%:p:h') . '.spellfile.utf-16.add'

" see https://github.com/neovim/neovim/issues/7663
" function! InsertOnTerm()
    " if expand('%f')[:3] == 'term'
        " startinsert
    " endif 
" endfunction

" if has("nvim")
    " set guicursor=
    " tnoremap <M-[> <C-\><C-n>
    " nnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    " tnoremap <C-h> <C-\><C-n>gT:call InsertOnTerm()<cr>
    " nnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    " tnoremap <C-l> <C-\><C-n>gt:call InsertOnTerm()<cr>
    " tnoremap <M-w> <C-\><C-n>w
    " command! Newterm :tabnew | term
    " set scrollback=100000
" endif 

" temporary fix until this works natively in the terminal
" set autoread
" au FocusGained * :checktime

" terminal
" if has("nvim")
" endif 

set smartcase

"plugin management
filetype on
filetype plugin on
filetype indent on

" tagbar
nnoremap <localleader>t :TagbarToggle<CR>

"pathogen plugin
call pathogen#infect()

" color setup
" backspace/colors
set bs=2

" Make mark.vim stop trying to overwrite my mappings
let g:mw_no_mappings = 1

"colorscheme stuff
"change background
set t_Co=256
colorscheme Iosvkem
" if has("gui_running")
"     set spell
" else
    " "spell check comes out as poor highlighting
    set nospell
" endif

" nnoremap <leader>c :cnext<CR>
" nnoremap <leader>L :lnext<CR>

" ctrlp
let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/](git|hg|svn|build|build_dependencies|build_resources|devel)$',
\ 'file': '\v\.(exe|so(\.\d\.\d\.\d)?|dll|pyc)$',
\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
nnoremap <localleader>f :CtrlP getcwd()<cr>
nnoremap <localleader>b :CtrlPBuffer<cr>

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"in case there are system specific settings
" try
    " source ~/.vimrc_specific
" catch
" endtry

try
    source ~/repos/linux-config/.vimrc_extra
catch
endtry

" For conceal markers.
if has('conceal')
  set conceallevel=0 concealcursor=niv
" why I set conceallevel to 0:
" https://vi.stackexchange.com/a/7263
endif

" function! GetGitPath(fname)
    " let p = fnamemodify(a:fname, ':p:h')
    " let b = 0
    " while p != '/' && b < 30
      " let b += 1
      " if isdirectory(p . '/.git')
          " return a:fname[len(p) + 1:]
      " endif 
      " let p = fnamemodify(p, ':h')
    " endwhile 
    " return fnamemodify(a:fname, ':t')
" endfunction

" function! GetClass(fname)
    " return 'Class ' . fnamemodify(a:fname, ':r') . " {\npublic:\n    "
" endfunction

" function! GetHeaderGuard(fname)
    " let include_txt = GetGitPath(a:fname)
    " let include_txt = toupper(include_txt)
    " let include_txt = substitute(include_txt, "/", "_", "g")
    " let include_txt = substitute(include_txt, "-", "_", "g")
    " let include_txt = substitute(include_txt, "\\.", "_", "g")
    " let include_txt = include_txt . '_'
    " return include_txt
" endfunction

" airline
" let g:airline_extensions = ['tabline']
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
" let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#show_splits = 0

colorscheme Iosvkem

