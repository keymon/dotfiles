" Include https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" Syntax setup
syntax on
filetype plugin indent on

" Color scheme
set background=dark

let g:solarized_termcolors=256
colorscheme solarized

" Required for NerdCommenter https://github.com/scrooloose/nerdcommenter
filetype plugin indent on

" NerdTree setup
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Allow buffers to go to background unchaged (required for navigate tabs)
set hidden

" Other custom options
" from http://nvie.com/posts/how-i-boosted-my-vim/
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode

set pastetoggle=<F2> " change paste mode on/off
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set smarttab      " insert tabs on:q the start of a line according to
                    "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

set nobackup
" set noswapfile

set mouse=a

" clear the search with ,/
nmap <silent> ,/ :nohlsearch<CR>

" force write
cmap w!! w !sudo tee % >/dev/null

" Navigation
" Map Ctrl+Arrows in mac OAOAOBOCODOAOBOB OA OAOB
map! <ESC>[OA <C-Up>
map! <ESC>[OB <C-Down>
map! <ESC>[OD <C-Left>
map! <ESC>[OC <C-Right>
map <C-Right> :bn<CR>
map <C-Left> :bp<CR>


