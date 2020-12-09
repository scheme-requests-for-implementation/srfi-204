(cond-expand
  (guile
    (define test-name "guile-hello-test" )
    (define scheme-version-name (string-append "guile-" (version)))
    (import (srfi srfi-9)
	    (srfi srfi-64))
    (include-from-path "./test/hello-common.scm"))
  (gauche
    (import (only (gauche base) gauche-version)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-hello-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "hello-common.scm"))
  (larceny
    ;;NOTE run like:
    ;; $rlwrap larceny -r7rs -I ..
    ;; > (include "test/hello-test.scm")
    (import (scheme base)
	    (srfi 64)
	    (srfi 115))
    (define (is-version sym)
      (regexp-matches
	'(seq "larceny-" (one-or-more (or numeric ".")))
	(symbol->string sym)))
    (define test-name "larceny-hello-test")
    (define scheme-version-name
      (let lp ((has (features)))
	(cond
	  ((null? has) "larceny-???")
	  ((and (symbol? (car has)) (is-version (car has))) =>
	   (lambda (match) (regexp-match-submatch match 0)))
	  (else (lp (cdr has))))))
    (include "test/hello-common.scm"))
  (unsyntax
    (import (scheme base)
	    (srfi :64))
    (define test-name "unsyntax-hello-test")
    (define scheme-version-name (symbol->string (car (features))))
    (include "hello-common.scm"))
  )
