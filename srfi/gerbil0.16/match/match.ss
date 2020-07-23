(define-library (match match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (cond-expand
   (chibi (import (chibi)))
   (else (import (except (scheme base) set!))))
  (include "../../match/match.scm"))
