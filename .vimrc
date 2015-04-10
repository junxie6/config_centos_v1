" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" [START] add by danny
" [command] =======================================================
" Find String, Search String.
" Open quickfix window automatically after running grep command.
" Reference: http://blog.ijun.org/2012/01/use-grep-to-search-string-in-files.html
command! -nargs=+ Mygrep execute "silent grep! <args>" | copen

" [set] ===========================================================
" let vim correctly load these ecnoding files.
" vim開檔自動判斷檔案編碼先從utf-8開始
" This is a list of character encodings considered when starting
" to edit an existing file. When a file is read, Vim tries to
" use the first mentioned character encoding. If an error is detected,
" the next one in the list is tried. When an encoding is found that works,
" 'fileencoding' is set to it.
set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1

" Sets the character encoding for the file of this buffer.
" 建立新檔的時候以什麼編碼建立
set fileencoding=utf-8

" file default encoding utf-8
set encoding=utf-8

if has("gui_running")
  " view UTF-8 Characters in Gvim (GUI Vim)
  "set guifont=VeraMono:h10
  set guifont=Bitstream_Vera_Sans_Mono:h11:cANSI
  " set guifontwide acts as second fallback for regional languages.
  set guifontwide=MingLiu:h11
endif

" line number
set number

" Toggle auto-indenting for code paste. Note: press ctrl-v F4 to geenerate ^[[14~
"set pastetoggle=^[[14~
set pastetoggle=<F4>

" Vim will open up as many tabs as you like on startup, up to the maximum number of tabs set.
"set tabpagemax=15

" to see the tab bar all the time. Use 0 to turn off.
" Try ":verbose set showtabline?" to find out what script replaced showtabline=1 with showtabline=2
"set showtabline=2

" Set mouse equals to nothing stopping vim from interpreting the mouse clicks.
set mouse=

" controls where backup files (with ~ extension by default) go.
set backupdir=~/.vimbak

" The 'directory' option controls where swap files go.
set directory=~/.vimbak

" To enable 256 colors in vim, put this your .vimrc before setting the colorscheme.
" Note: you will also need to add following line to your ~/.cshrc:
" setenv  TERM screen-256color
" or
" setenv  TERM xterm-256color
set t_Co=256

" disable auto resize when splitting split a window.
set noequalalways

" [let] ===========================================================
" disable match parent
let loaded_matchparen=1

" Note: /usr/local/share/vim/vim73/syntax/php.vim
" php_folding = 1  for folding classes and functions
" php_folding = 2  for folding all { } regions
let php_folding=1

" to highlight SQL syntax in strings
"let php_sql_query=1

" to highlight HTML in string
"let php_htmlInStrings=1

" to disable short tags
"let php_noShortTags=1

" [map] ===========================================================
" toggle NERDTree. Note: press ctrl-v F2 to generate ^[[12~
"map ^[[12~ :NERDTreeToggle<CR>
map <F2> :NERDTreeToggle<CR>

" Stop the highlighting for the 'hlsearch' option. It is automatically turned back on when using a search command, or setting the 'hlsearch' option.
"map ^[[15~ :nohlsearch<CR>
map <F5> :nohlsearch<CR>

" Find String, Search String.
" Performing a customized grep search on the word under the cursor:
" Reference: http://blog.ijun.org/2012/01/use-grep-to-search-string-in-files.html
map <F6> :execute " grep -srnw --binary-files=without-match /www/drupal6/sites/all/modules/custom -e " . expand("<cword>") . " " <bar> cwindow<CR>

" auto align text, programming code.
map <F8> :Tabularize /=<CR>

" go to next tab
"map <c-h> :tabprev<CR>
"map <c-l> :tabnext<CR>

" go to next or previous buffer
map <c-h> :bp<CR>
map <c-l> :bn<CR>

" open BufExplorer
map <c-k> :BufExplorer<CR>

" open explore to list file in a directory
map <c-e> :Explore<CR>

" adjust windows size when there are three vertically split windows
map <c-j> <c-w>60><c-w>l<c-w>30>

" [vmap] ===========================================================
" comment and uncomment lines
vmap ,c I#<ESC>

" Convert the data column to a php debug information.
vmap ,e :call ConvColumnDataToPHPDebugInfo()<CR>

" Convert SQL query string to php string.
"vmap ,s I$sql .= "<ESC>5lx
"vmap ,n :s/$/';/<CR>:nohlsearch<CR>
"vmap ,N :s/$/ ";/<CR>:nohlsearch<CR>
vmap ,s :call ConvSQLQueryToPHPString()<CR>`<5lx

" add $out prefix for php string
"vmap ,o :s/\s\+/\0$out .= '/<CR>:nohlsearch<CR>
vmap ,o :call ConvStringToPHPString()<CR>

" convert backward slash to forward slash
vmap ,b :s/\\/\//g<CR>:nohlsearch<CR>

vmap ,w :call WrapTagToString(

" Reference: https://github.com/tpope/vim-surround
function! WrapTagToString(startTag, endTag)
  " Note: still has issue.
  "execute "s,\\(\\S\\+\\)," . a:startTag . "\1" . a:endTag . ","
endfunction

" Reference: https://github.com/tpope/vim-surround
function! ConvStringToPHPString()
  " Note: still has issue.
  " use a comma as a seperator.
  " match non-whitespace characters.
  ":s,\(\S\+\),$out .= "\1";,
endfunction

function! ConvSQLQueryToPHPString()
  " use a comma as a seperator.
  " match whitespace characters from the beginning of the line until a non-whitespace characters.
  :s,^\(\s*\)[^ \t]\@=,\1$sql .=",

  " match a newline character.
  :s,\n,";\r,
endfunction

" Reference: http://vimdoc.sourceforge.net/htmldoc/pattern.html
" Reference: http://vimregex.com/
function! ConvColumnDataToPHPDebugInfo()
  " replace comma with . '_' .
  :s,\,, . '_' . ,g

  " match whitespace characters from the beginning of the line until a non-whitespace characters.
  :s,^\(\s*\)[^ \t]\@=,\1echo ,

  " match a newline character.
  :s/\n/ . "\\n";\r/
endfunction

" [imap] ===========================================================

" [abbreviation] ==================================================
iab cc ###
iab cd ### [DEBUG]

" [other] =========================================================
" select a default color scheme
colorscheme desert256

" syntax highlighting for Drupal modules.
" Note: there is already a similar setting in /usr/local/share/vim/vim73/filetype.vim
"if has("autocmd")
  "" Drupal *.module and *.install files.
  "augroup module
    "autocmd BufRead,BufNewFile *.module set filetype=php
    "autocmd BufRead,BufNewFile *.install set filetype=php
    "autocmd BufRead,BufNewFile *.inc set filetype=php
  "augroup END
"endif

" Indentation use spaces instead of tabs.
" // ts: tabstop
" // sts: softtabstop
" // sw: shiftwidth
" Note: http://drupal.org/node/29325
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" [JavaScript] enable folding of JavaScript code ===========================
let javaScript_fold=1 " use the built-in function instead of the custom function below.

"function! JavaScriptFold() 
"    setl foldmethod=syntax
"    setl foldlevelstart=1
"    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
"
"    function! FoldText()
"        return substitute(getline(v:foldstart), '{.*', '{...}', '')
"    endfunction
"    setl foldtext=FoldText()
"endfunction
"au FileType javascript call JavaScriptFold()
"au FileType javascript setl fen
"" Note: http://amix.dk/blog/post/19132

" [END] add by danny
