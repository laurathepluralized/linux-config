" Vim color file for light-colored BG for use in sun
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Jul 23

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set background=light
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "laura_light"

"highlight Comment	 ctermfg=8			cterm=bold			  guifg=#808080 gui=bold
highlight Constant	 ctermfg=1			cterm=bold guifg=#d70000 gui=none
highlight Identifier ctermfg=6			 		   guifg=#00c0c0
highlight Statement  ctermfg=99			cterm=bold guifg=#875fff gui=bold
highlight PreProc ctermfg=99			cterm=bold			  guifg=#875fff gui=bold
highlight Type		 ctermfg=2		    cterm=bold		  guifg=#00c000 gui=bold
highlight Special	 ctermfg=12						  guifg=#0000ff
highlight Error      ctermfg=9  ctermbg=3            guifg=#ff0000
highlight Todo		 ctermfg=4  ctermbg=3            guifg=#000080 guibg=#c0c000
"highlight Directory  ctermfg=2						  guifg=#00c000
highlight StatusLine ctermfg=17 ctermbg=12 cterm=none guifg=#00005f guibg=#0000ff gui=none
"highlight Normal									  guifg=#ffffff guibg=#000000
highlight Search				ctermbg=52 cterm=bold					guibg=#c0c000 gui=bold
highlight String ctermfg=1      ctermbg=NONE cterm=bold guifg=#d70000 guibg=NONE gui=NONE
" vim: sw=2
