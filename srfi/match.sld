
(define-library (match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*
	  ___ ..1 ..= ..* *** ? $ struct object get!)
  (cond-expand
   (chibi (import (chibi)))
   (else (import (scheme base))))
  (include "match/match.scm")
  (include "auxiliary-syntax.scm")
  (begin
    (define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!)))
