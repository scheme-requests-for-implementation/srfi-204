(define-library (larceny1.3 match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (cond-expand
   (chibi (import (chibi)))
   (else (import (scheme base))))
  (include "match/match.scm"))

;;;(match '(mom dad sis bro)
;;;       ((date night . kids-stay-home) (list date night)))
;;;=> (mom dad) ;yay!
