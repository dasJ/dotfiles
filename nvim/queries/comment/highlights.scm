; Be more important than LSP for TODO and TODO:
((tag
  (name) @text.todo @nospell
  ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @text.todo "TODO")
  (#set! "priority" 126))

("text" @text.todo @nospell
 (#eq? @text.todo "TODO")
  (#set! "priority" 126))

; Be more important than LSP for FIXME and BUG
((tag
  (name) @text.danger @nospell
  ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @text.danger "FIXME" "BUG")
  (#set! "priority" 126))

("text" @text.danger @nospell
 (#any-of? @text.danger "FIXME" "BUG")
  (#set! "priority" 126))

; Be more important than LSP for NOTE and XXX and also add TOREM
((tag
  (name) @text.note @nospell
  ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @text.note "NOTE" "XXX" "TOREM")
  (#set! "priority" 126))

("text" @text.note @nospell
 (#any-of? @text.note "NOTE" "XXX" "TOREM")
  (#set! "priority" 126))
