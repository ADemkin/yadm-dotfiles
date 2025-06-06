if exists("b:current_syntax")
  finish
endif

syn match statusPending '\[\s\]'
syn match statusDone '\[x\]'

hi def link statusPending Include
hi def link statusDone Macro
