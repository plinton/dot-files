set noswapfile
set expandtab
set tabstop=4
set smarttab
set shiftwidth=4
set ff=unix

set backspace=indent,eol,start
syntax enable
set nu
set ai
set si

if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

