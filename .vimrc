set nocompatible

"filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'            " Vundle updates itself
Plugin 'itchyny/lightline.vim'           " The nice bar below
Plugin 'junegunn/fzf'                    " Fuzy finder pt1
Plugin 'junegunn/fzf.vim'                " Fuzy finder pt2
Plugin 'w0rp/ale'                        " Async linter Need to install linter though
Plugin 'airblade/vim-gitgutter'          " Shows changes in vim for git !!Probation!!
Plugin 'tpope/vim-eunuch'                " Adds commands like mkdir to vim
Plugin 'editorconfig/editorconfig-vim'   " Allows editor configs for different projects!
Plugin 'scrooloose/nerdtree'             " Adds filetree to left
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'bronson/vim-trailing-whitespace' " Highlites trailing space in red
" Plugin 'nathanaelkane/vim-indent-guides' " Shows indentation
" Plugin 'terryma/vim-multiple-cursors'    " Allows multiple cursers

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Shows cool status bar
set laststatus=2

" Shows line number
set number

" Deals with tab sillyness
set expandtab
set tabstop=4
set shiftwidth=4

" Nerdtree settings
" autocmd vimenter * NERDTree " Open by default
autocmd StdinReadPre * let s:std_in=1 " Open if no file is specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd StdinReadPre * let s:std_in=1 " Open on directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close vim if left window is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" arrow keys
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '|'
" CTL+n is now nerdtree toggle
map <C-n> :NERDTreeToggle<CR>

" Enable guides by default
let g:indent_guides_enable_on_vim_startup = 1

" OPAM SETTINGS

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
