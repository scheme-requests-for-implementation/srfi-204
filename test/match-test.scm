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

;this is for r7rs
(import (scheme base))
(cond-expand
  (chibi
    ;;export TEST_VERBOSE=true to get verbose output
    (import (srfi match-test)))
  (cyclone
    (import (except (scheme base) equal?)
	(scheme write)
	(srfi cyclone0.19 srfi-204)
	(only (cyclone test) test-begin test test-end))
    (define test-name "cyclone-match-test")
    (define scheme-version-name (string-append "cyclone-" *version*))
    (include "../srfi/cyclone0.19/match-test.scm"))
  (gauche
    (import (only (gauche base) gauche-version)
	    (srfi 204)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-match-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "match-common.scm"))
  (gerbil
    (include "../srfi/gerbil-test.ss")) ; doesn't work
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
      (include "srfi/204.sld")
      (import (srfi 204))
      (include "test/match-common.scm")))
  ;does not work
  (unsyntax
    (import (except (scheme base) define-record-type)
	    (rnrs records syntactic (6))
	    (srfi 64)
	    (srfi 204))
    (define test-name "unsyntax-match-test")
    (define scheme-version-name (symbol->string (car (features))))
    )
  (else))
(cond-expand
  (chibi
    (run-match-tests))
  (else))
