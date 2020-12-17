call plug#begin('~/.config/nvim/plugged')
" Aesthetics
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'jdsimcoe/abstract.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'eemed/sitruuna.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'ParamagicDev/vim-medic_chalk'

" Surround text objects
Plug 'tpope/vim-surround'

" Auto match brackers and quotes
Plug 'jiangmiao/auto-pairs'

" Comment code faster
Plug 'preservim/nerdcommenter'

" Expand snippets into HTML trees
Plug 'mattn/emmet-vim'

" Sensible defaults
Plug 'tpope/vim-sensible'

" Unix command goodness
Plug 'tpope/vim-eunuch'

" More focused editing
Plug 'junegunn/goyo.vim'

" Editorconfig support
Plug 'editorconfig/editorconfig-vim'

" Syntax Highlighting
Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'evanleck/vim-svelte'

" Magit for vim
Plug 'tpope/vim-fugitive'
" Gitgutter
Plug 'airblade/vim-gitgutter'

" IDE features
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" From
" https://github.com/junegunn/fzf.vim/issues/210#issuecomment-341531470
" set rtp+=/usr/local/opt/fzf
Plug 'preservim/nerdtree'

" Completion
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

call plug#end()
