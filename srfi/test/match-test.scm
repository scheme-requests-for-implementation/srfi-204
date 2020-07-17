(cond-expand
  (guile
    (import (guile2.2 match)
	    (srfi srfi-64)
	    (srfi srfi-9))
    (define test-name "guile-match-test")
    (define scheme-version-name (string-append "guile-" (version)))
    (include-from-path "./test/match-common.scm"))
  (gauche
    (import (only (gauche base) gauche-version)
	    (gauche0.9.6 match)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-match-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "match-common.scm")))
