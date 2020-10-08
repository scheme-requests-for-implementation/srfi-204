(cond-expand
  (chibi
    ;;export TEST_VERBOSE=true to get verbose output
    (import (srfi-test)))
  (guile
    (use-modules (srfi-204)
		 (srfi srfi-64)
		 (srfi srfi-9)
		 (rnrs unicode))
    (define non-linear-pattern #t)
    (define non-linear-pred #t)
    (define non-linear-field #t)
    (define record-implemented #t)
    (define test-name "srfi-test")
    (define scheme-version-name (string-append "guile-" (version)))
    (include-from-path "./test/srfi-common.scm"))
  (gauche
    (import (gauche base)
	    (scheme base)
	    (scheme char)
	    (scheme cxr)
	    (srfi 204)
	    (srfi 64))
    (define non-linear-pattern #t)
    (define non-linear-pred #t)
    (define non-linear-field #t)
    (define record-implemented #t)
    (define test-name "srfi-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "./test/srfi-common.scm"))
  (gerbil
    (include "../gerbil-test.ss")) ; doesn't work
  (larceny
    ;;NOTE run like:
    ;; $rlwrap larceny -r7rs -I ..
    ;; > (include "test/match-test.scm")
    (import (scheme base)
	    (scheme char)
	    (scheme cxr)
	    ;(srfi-204) doesn't work
	    (srfi 64)
	    (srfi 115)
	    (only (srfi 1) iota filter))
    (define (is-version? sym)
      (regexp-matches?
	'(seq "larceny-" (one-or-more (or numeric ".")))
	(symbol->string sym)))
    (define non-linear-pattern #t)
    (define non-linear-pred #t)
    (define non-linear-field #t)
    (define record-implemented #t)
    (define test-name "srfi-test")
    (define scheme-version-name
      (let lp ((has (features)))
	(cond
	  ((null? has) "larceny-???")
	  ((is-version? (car has)) (symbol->string (car has)))
	  (else (lp (cdr has))))))
    (begin
      (include "srfi-204.sld")
      (import (srfi-204))
      (include "test/srfi-common.scm")))
  (else))
(cond-expand
  (chibi
    (run-match-tests))
  (else))
