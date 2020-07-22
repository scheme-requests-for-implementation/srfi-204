(define-library (match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (import (scheme base))
  (include "match.scm"))

;;; $larceny -r7rs -I ..
;;; > (import (scheme base) (larceny1.3 match))
;;; > (match '(mom dad sis bro)
;;;          ((date night . kids-stay-home) (list date night)))
;;;=> (mom dad) ;yay!
