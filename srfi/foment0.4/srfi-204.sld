(define-library (foment0.4 srfi-204)
  (export match match-lambda match-lambda* match-let match-letrec match-let*
  	___ **1 =.. *.. *** ? $ struct object get!)
  (import (scheme base))
  (include "../auxiliary-syntax.scm")
  (begin
    (define-auxiliary-keywords ___ **1 =.. *.. *** ? $ struct object get!))
  (include "../srfi-204/srfi-204.scm"))
;;foment -I ..
