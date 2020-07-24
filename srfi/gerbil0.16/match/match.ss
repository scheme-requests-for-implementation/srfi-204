(define-library (match match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (import (scheme base))
  (include "../../match/match.scm"))
