set nocompatible                " choose no compatibility with legacy vi

set ttyfast
set ttyscroll=3
set lazyredraw

syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set wrap                      " don't wrap lines
set linebreak
set nolist
set tabstop=4  shiftwidth=4      " a tab is two spaces (or set this to 4b
set backspace=indent,eol,start  " backspace through everything in insert mode
set textwidth=0
set wrapmargin=0

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set number     " show line numbers!
set ai          " Auto identing

"" No more arrow keys
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Easy Resize
map <up> <c-w>-
map <down> <c-w>+
map <right> <c-w>>
map <left> <c-w><


" 256 Colors with Wombat
set t_Co=256
colorscheme molokai


" set list!
set listchars=tab:+-
" trail:.,precedes:<,extends:>,eol:$


command Light colorscheme summerfruit256 
command Dark  colorscheme molokai

" Cursorline 
set cursorline
set cursorcolumn


if &term =~ "xterm\\|rxvt"
	" use an orange cursor in insert mode
	let &t_SI = "\<Esc>]12;green\x7"
	" use a red cursor otherwise
	let &t_EI = "\<Esc>]12;white\x7"
	" reset cursor when vim exits
	autocmd VimLeave * silent !echo -ne "\033]112\007"
	" use \003]12;gray\007 for gnome-terminal
endif


" Mouse for Normal and Visual Mode only
set mouse=nv

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp  

" Fix the * Clipboard
set clipboard=unnamed

set wildmenu "Tab completion status bar

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
call pathogen#infect()


" Colored Statusbar for Inser/Command
" first, enable status line always
set laststatus=2

" now set it up to change the status line based on mode
if version >= 700
	au InsertEnter * hi StatusLine term=reverse ctermbg=4 gui=undercurl guisp=Magenta
	" au InsertEnter * silent !sudo lightToggle + & 
	au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
	" au InsertLeave * silent !sudo lightToggle - &

	" au FocusLost * !sudo lightToggle - &

endif


" Status Bar
set laststatus=2  " always show the status bar
set statusline=%<%f\ %h%w%m%r%y\ %{&ff}\ %=L:%l/%L\ (%p%%)\ C:%c%V\ B:%o\ F:%{foldlevel('.')} 

set foldlevel=3000
"set mouse=a
"
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=8
hi IndentGuidesEven ctermbg=8
let g:indent_guides_enable_on_vim_startup = 1

hi CSVColumnEven term=bold ctermbg=0 ctermfg=10
hi CSVColumnOdd term=bold ctermbg=2 ctermfg=0

highlight OverLength ctermbg=none ctermfg=white
match OverLength /\%81v.\+/

hi Normal ctermbg=none
hi LineNr ctermbg=Black
hi LineNr ctermfg=Blue

fixdel
imap <Del> <BS>


