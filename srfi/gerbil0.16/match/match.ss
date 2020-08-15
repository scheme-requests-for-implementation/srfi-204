(define-library (match match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*
	  ___ ..1 ..= ..* *** ? $ struct object get!)
  (import (scheme base))
  (include "../../auxiliary-syntax.scm")
  (begin
    (define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!))
  (include "../../match/match.scm"))
