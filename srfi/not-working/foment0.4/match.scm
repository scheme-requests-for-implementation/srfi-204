(define-library (srfi-204)
  (export match match-lambda match-lambda* match-let match-letrec match-let*
  	___ ..1 ..= ..* *** ? $ struct object get!)
  (import (scheme base))
  (include "auxiliary-syntax.scm")
  (define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!)
  (include "../match/match.scm"))
;;foment -I ..
