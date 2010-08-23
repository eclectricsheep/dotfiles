" Vim color file
" Maintainer:	<first_name> <last_name>
" Last Change:	03-08-10
" URL:		http://github.com/<secondary_username>/arch_dotfiles
" 
" Based on 'desert' by Hans Fugal <hans@fugal.net>
"
" as of last change, this is only for terminal, gvim users will only get the
" desert theme.


" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="dayglo"

hi Normal	guifg=White guibg=grey20

" highlight groups
hi Cursor	guibg=indianred guifg=khaki
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded	guibg=grey30 guifg=gold
hi FoldColumn	guibg=grey30 guifg=tan
hi IncSearch	guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg	guifg=goldenrod
hi MoreMsg	guifg=SeaGreen
hi NonText	guifg=LightBlue guibg=grey30
hi Question	guifg=springgreen
hi Search	guibg=olivedrab guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
hi Title	guifg=indianred
hi Visual	gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg	guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

" syntax highlighting groups
hi Comment	guifg=SkyBlue
hi Constant	guifg=#ff6600
hi Identifier	guifg=green
hi Statement	guifg=khaki
hi PreProc	guifg=indianred
hi Type		guifg=darkkhaki
hi Special	guifg=navajowhite
"hi Underlined
hi Ignore	guifg=grey40
"hi Error
hi Todo		guifg=orangered guibg=yellow2

" color terminal definitions
hi SpecialKey	ctermfg=10
hi NonText	cterm=bold ctermfg=12
hi Directory	ctermfg=14
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	cterm=NONE ctermfg=3 ctermbg=2
hi Search	cterm=NONE ctermfg=1 ctermbg=3
hi MoreMsg	ctermfg=10
hi ModeMsg	cterm=bold ctermfg=2
hi LineNr	ctermfg=6
hi Question	ctermfg=2
hi StatusLine	cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit	cterm=reverse
hi Title	ctermfg=4
hi Visual	cterm=reverse
hi VisualNOS	cterm=bold,underline
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=6 ctermbg=NONE
hi FoldColumn	ctermfg=6 ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
hi Comment	ctermfg=7
hi Constant	ctermfg=3
hi Special	ctermfg=2
hi Identifier	ctermfg=13
hi Statement	ctermfg=2
hi PreProc	ctermfg=2
hi Type		ctermfg=1
hi Underlined	cterm=underline ctermfg=4
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=6
hi Error	cterm=bold ctermfg=7 ctermbg=1


"vim: sw=4
