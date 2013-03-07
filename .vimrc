function! SyntaxItem()
    return synIDattr(synID(line("."),col("."),1),"name")
endfunction

if has('statusline')
    set statusline+=(%{SyntaxItem()})
    set statusline+=%f
    set statusline+=%=
    set statusline+=%-7.(%l,%c%V%)\ %<%P
endif

set number
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set laststatus=2
filetype plugin on
filetype indent on
set textwidth=77
set cino=g0
set nowrap
set modeline
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
colors elflord
