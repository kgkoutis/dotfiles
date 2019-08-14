"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
set nocompatible
filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

" Show other people tabs
highlight SpecialKey ctermfg=1 
set list
set listchars=tab:T>

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.
set list                   " Show non-printable characters.
set wildmode    =longest,list,full   " Enable autocompletion

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "Disable automatic comment insertion
nnoremap <Leader>q autocmd TextChanged,TextChangedI <buffer> silent write " autosave on change

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

set number                 " set number
" set relativenumber         " set relative numbering 
set noerrorbells           " disable beep on errors 
set visualbell             " flash the screen instead of beeping on errors
set title                  " set the window's title, reflecting the file currently being edited

cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev QW wq
cnoreabbrev Qa qa
cnoreabbrev Qa! qa!
cnoreabbrev QA qa
cnoreabbrev QA! qa!

function! ShowColourSchemeName()
    try
        echo g:colors_name
    catch /^Vim:E121/
        echo "default
    endtry
endfunction


" Get out of text wrappers
inoremap <C-e> <C-o>A;<Esc>o
inoremap <C-w> <C-o>a,

" Set Leader key
:let mapleader = ","
" nnoremap <Leader>j <C-w>j
" nnoremap <Leader>k <C-w>k
" nnoremap <Leader>h <C-w>h
" nnoremap <Leader>l <C-w>l
nnoremap <Leader>k <C-w><C-p>
nnoremap <Leader>l <C-w><C-w>
nnoremap o o<Esc>cc
nnoremap O O<Esc>cc

"===========================================================================
" vim-addon-manager setup
fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM()

"===========================================================================
" Configure various plugins
ActivateAddons setcolors.vim
ActivateAddons vim-colorschemes
ActivateAddons vim-snippets vim-snipmate
ActivateAddons vim-surround
" ActivateAddons lightline
ActivateAddons vim-airline
ActivateAddons vim-airline-themes
ActivateAddons vim-commentary
ActivateAddons vim-multiple-cursors
ActivateAddons vim-eunuch
" ActivateAddons ag
ActivateAddons auto-pairs
ActivateAddons vim-sensible
ActivateAddons a.vim
ActivateAddons ctrlp.vim
ActivateAddons tsuquyomi
ActivateAddons Apprentice
ActivateAddons vim-github-colorscheme
ActivateAddons emmet-vim
ActivateAddons vim-mustache-handlebars
" ActivateAddons vim-gutentags
" ActivateAddons tmuxline.vim

"===========================================================================
" Configure NERDTree
ActivateAddons nerdtree
" autocmd vimenter * NERDTree " open vim as you enter in..
" autocmd VimEnter * wincmd p " ..and place the cursor to the main file
map <Leader>n :NERDTreeToggle<CR>
nmap <Leader>r :NERDTreeRefreshRoot " Refresh NERDTree Structure
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " close vim if NERDTree is the last window

"===========================================================================
" Configure NERDTree-git-plugin
ActivateAddons nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
"===========================================================================
"Configure Easymotion
ActivateAddons vim-easymotion

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"===========================================================================
" Configure indentLine
ActivateAddons indentLine
let g:indentLine_color_term = 239

"===========================================================================
" Configure rainbow
ActivateAddons rainbow
let g:rainbow_active = 1

"===========================================================================
" Configure tagbar
ActivateAddons tagbar
let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
" Support for additional tags --> https://github.com/majutsushi/tagbar/wiki
nmap <Leader>8 :TagbarToggle<CR> 

"===========================================================================
" Configure ctrlp
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

"===========================================================================
" Configure Syntastic
ActivateAddons syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

let g:syntastic_python_checkers = ['pylint --load-plugins pylint_django', 'flake8']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'
let g:syntastic_haskell_checkers = ['hlint','hdevtools','hfmt']

"===========================================================================
" Configure gitgutter
ActivateAddons vim-gitgutter
set updatetime=100

"===========================================================================
" Configure supertab
ActivateAddons supertab
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0

"===========================================================================
" Configure Ultisnips
ActivateAddons UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"===========================================================================
" Configure YouCompleteMe
ActivateAddons YouCompleteMe
  " YouCompleteMe and UltiSnips compatibility, with the helper of supertab
let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']


"===========================================================================
" Configure fugitive
ActivateAddons vim-fugitive
" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

"===========================================================================
" Configure fzf
ActivateAddons fzf
" Look for files under current directory
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
nnoremap <leader>b :FZF<CR>

"===========================================================================
" Configure vim-latex-live-preview
ActivateAddons vim-latex-live-preview
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'
