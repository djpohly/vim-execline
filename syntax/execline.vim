" Vim syntax file
" Language: execline
" Maintainer: Devin J. Pohly
" Latest Revision: 09 October 2016

if exists("b:current_syntax")
  finish
endif

syn iskeyword 33-126


"""
""" Top-level constructs: commands, words, comments, and blocks.  When in
""" conflict, words should take lowest priority.
"""
syn cluster elToplevel contains=elCommand,elWord,elComment,elBlock

" Provided execline commands
syn keyword elCommand 
      \ execline-cd posix-cd cd execline-umask posix-umask umask
      \ emptyenv envfile export unexport
      \ fdclose fdblock fdmove fdswap fdreserve redirfd piperw heredoc
      \ wait getcwd getpid exec tryexec exit trap withstdinas
      \ foreground background case if ifelse ifte ifthenelse
      \ backtick pipeline runblock
      \ define importas elglob elgetpositionals multidefine multisubstitute
      \ forx forstdin forbacktickx loopwhilex
      \ elgetopt shift dollarat
      \ homeof

syn keyword elDeprecated import

" Words can begin with any character greater than 0x20, and they end when
" encountering a character less than or equal to 0x20, unless prevented by an
" escape or quoted string.
syn region elWord start=/[\x21-\xff]/ end=/\_[\x00-\x20]/me=e-1 contains=@elInWord transparent

" Comments begin with #, which must occur at the beginning of a "word".  Since
" '#' does not end a word in the definition above, this will work.
syn region elComment start="#" end="$"

" Blocks begin with { and end with }, each of which must be a word in itself
" (with no quotes, escapes, or further word characters).  We add the elBrace
" matchgroup to prevent the closing brace from matching as an elWord, which
" would keep the end of the block from being recognized.
syn region elBlock matchgroup=elBrace start=/{\_[\x00-\x20]/rs=s+1,me=e-1 end=/}\_[\x00-\x20]/me=e-1 fold transparent contains=@elToplevel


"""
""" Syntax elements which occur within (and extend) words: escapes and quoted
""" strings.
"""
syn cluster elInWord contains=elEscape,elString,elSubstitution,elSimpleSub

" Any single character outside a quoted string may be escaped with a
" backslash; no special meaning is given to escapes like \n.
syn match elEscape "\\\_." contained

" Strings are straightforward
syn region elString start=/"/ end=/"/ contained contains=@elInString


"""
""" Syntax elements which occur within (and extend) quoted strings: line
""" continuations and escapes.
"""
syn cluster elInString contains=elStrContinuation,elStrEscape,elBadEscape,elSubstitution,elSimpleSub

syn match elStrContinuation +\\\n+ contained
syn match elStrEscape +\\\%([1-9]\d\{0,2}\|0\o\{1,3}\|0x\x\{1,2}\|\D\)+ contained
syn match elBadEscape +\\0\%([^0-7x]\|x\X\)+ contained


""" XXX When in quotes, simple substitution continues until (and maybe past)
""" the end of quotes, unless encountering one of $, {, }, or \.


"""
""" Substitutions (only when not interfering with execline syntax)
"""
syn match elSubstitution /\${[^${}\\"]\+}/ contained

hi def link elSimpleSub elSubstitution
syn match elSimpleSub /\$[^${}\\"\x00-\x20]\+\_[${}\\\x00-\x20]/me=e-1 contained


"""
""" Highlighting groups
"""
hi def link elCommand Statement
hi def link elComment Comment
hi def link elBrace Delimiter
hi def link elSubstitution PreProc

hi def link elEscape String
hi def link elString String

hi def link elStrContinuation Special
hi def link elStrEscape Special
hi def link elBadEscape Error
hi def link elDeprecated Error

" vim:set ts=2 sw=2 et:
