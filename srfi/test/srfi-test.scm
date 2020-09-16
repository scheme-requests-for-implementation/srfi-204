(define non-linear-pattern #t)
(define non-linear-pred #t)
(define non-linear-field #t)
(define record-implemented #t)
(define test-name "srfi-test")
(cond-expand
  (chibi
    ;;export TEST_VERBOSE=true to get verbose output
    (import (srfi-test)))
  (guile
    (use-modules (srfi-204)
	    (srfi srfi-64)
	    (srfi srfi-9)
	    (rnrs unicode))
    (define (square x) (* x x))
    (define scheme-version-name (string-append "guile-" (version)))
    (include-from-path "./test/srfi-common.scm"))
  (gauche
    (import (only (gauche base) gauche-version)
	    (srfi-204)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-match-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "srfi-common.scm"))
  (gerbil
    (include "../gerbil-test.ss")) ; doesn't work
  (larceny
    ;;NOTE run like:
    ;; $rlwrap larceny -r7rs -I ..
    ;; > (include "test/match-test.scm")
    (import (scheme base)
	    ;(srfi-204) doesn't work
	    (srfi 64)
	    (srfi 115))
    (define (is-version? sym)
      (regexp-matches?
	'(seq "larceny-" (one-or-more (or numeric ".")))
	(symbol->string sym)))
    (define test-name "larceny-match-tests")
    (define scheme-version-name
      (let lp ((has (features)))
	(match has
	       (() "larceny-???")
	       (((? symbol? (? is-version? sym)) . rest) (symbol->string sym))
	       ((this . rest) (lp rest)))))
    (begin
      (include "srfi-204.sld")
      (import (srfi-204))
      (include "test/srfi-common.scm"))))
(cond-expand
  (chibi
    (run-match-tests))
  (else))
