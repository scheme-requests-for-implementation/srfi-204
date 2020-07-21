(define-library (match match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (cond-expand
   (chibi (import (chibi)))
   (else (import (except (scheme base) set!))))
  (include "../../match/match.scm"))

;;; $larceny -r7rs -I ..
;;; > (import (scheme base) (larceny1.3 match))
;;; > (match '(mom dad sis bro)
;;;          ((date night . kids-stay-home) (list date night)))
;;;=> (mom dad) ;yay!
