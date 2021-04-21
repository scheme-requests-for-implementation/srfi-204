(import (scheme base))
(cond-expand
  (gauche
    (import (gauche base)
	    (scheme base)
	    (scheme char)
	    (scheme cxr)
	    (util match)
	    (srfi-64))
    (define non-linear-pattern #f)
    (define non-linear-pred #f)
    (define non-linear-field #f)
    (define record-implemented #t)
    (define test-name "false-branch-srfi-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "./test/srfi-common.scm"))
  (else))

