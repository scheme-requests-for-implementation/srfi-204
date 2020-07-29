(cond-expand
  (guile
    (import (guile2.2 match)
	    (srfi srfi-64)
	    (srfi srfi-9))
    (define test-name "guile-match-test")
    (define scheme-version-name (string-append "guile-" (version)))
    (include-from-path "./test/match-common.scm"))
  (gauche
    (import (only (gauche base) gauche-version is-a? slot-ref slot-set!)
	    (gauche0.9.6 match)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-match-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "match-common.scm"))
  (larceny
    ;;NOTE run like:
    ;; $rlwrap larceny -r7rs -I ..
    ;; > (include "test/match-test.scm")
    (import (scheme base)
	    (larceny1.3 match)
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
    (include "test/match-common.scm")))
