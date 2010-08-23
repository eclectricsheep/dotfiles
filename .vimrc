" Vim configuration
" Location:     ~/.vimrc
" BasedOn: desert.vim
" Comments: work in progress.  vim looks nice, but gvim still has desert colors.

"---Initialization
set nocompatible
set background=dark
syntax on
set t_Co=256
colorscheme dayglo

filetype plugin indent on

"---General behavior
set mouse=a
set backspace=indent,eol,start
set swapfile
"set directory=
set history=50
set noerrorbells
set novisualbell

"---Appearance
set number
set laststatus=2
set statusline=%<%-2.2n\ %f\ %h%m%r%w%=%-14.(%l,%c%V%)\ %P
set ruler
set cmdheight=1
set showmode
set showcmd
set wildmenu
"set wildignore=
set shortmess=filnxoOtTI
set report=0

"---Formatting
"set textwidth=80
set nowrap
set formatoptions=tcrq
set fileformats=unix,dos,mac
set listchars+=tab:>-,trail:-,extends:>,precedes:<

"---Backup
set nobackup
"set writebackup
"set backupcopy
"set backupdir=
"set backupext=.vimbak

"---Encoding
set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,default,latin1

"---Indenting
set smartindent
set autoindent
"set cindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

"---Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"---Folding
set foldmethod=manual
nnoremap <Space> za

"---Abbreviations
iab _rcb Ricky Cintron 'borosai' [borosai at gmail dot com]

"---Miscellaneous mappings
nmap Y y$
cmap w!! w !sudo tee %

"---Spell checking
function! ToggleSpell()
    if !exists("b:spell")
        setlocal spell spelllang=en_us
        let b:spell = 1
        echo "Spell Check [On]"
    else
        setlocal nospell
        unlet b:spell
        echo "Spell Check [Off]"
    endif
endfunction

nmap <F4> :call ToggleSpell()<CR>
imap <F4> <Esc>:call ToggleSpell()<CR>a

nmap    <F1>    gqap
nmap    <F2>    gqqj
nmap    <F3>    kgqj
map!    <F1>    <ESC>gqapi
map!    <F2>    <ESC>gqqji
map!    <F3>    <ESC>kgqji

"---Filetype plugins
"---XML Edit [xml.vim]
let xml_jump_string = "`"

"---Autocommands
au BufNewFile,BufRead *.xml source ~/.vim/ftplugin/xml.vim
au BufNewFile,BufRead *.xml set tabstop=2
au BufNewFile,BufRead *.xml set softtabstop=2
au BufNewFile,BufRead *.xml set shiftwidth=2

"---Filetype Textwidths
autocmd FileType tex setlocal textwidth=80
autocmd FileType text setlocal textwidth=80

"---Load mutt config
autocmd BufRead ~/.mutt/temp/mutt*  :source ~/.vim/mail.vimrc
