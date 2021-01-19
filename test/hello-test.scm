;; Copyright (C) Felix Thibault (2020).  All Rights Reserved.

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice (including
;; the next paragraph) shall be included in all copies or substantial
;; portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

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
