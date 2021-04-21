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

(import (scheme base))
(cond-expand
  (chibi
    ;;export TEST_VERBOSE=true to get verbose output
    (import (srfi 204)
	    (scheme red)
	    (only (chibi ast) chibi-version)
	    (chibi test))
    )
  (gauche
    (import (gauche base)
	    (scheme base)
	    (scheme char)
	    (scheme process-context)
	    (scheme cxr)
	    (scheme write)
	    (srfi 1)
	    (srfi 204)
	    (srfi 26)
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
	    (scheme process-context)
	    (scheme write)
	    ;(srfi 204) doesn't work
	    (srfi 64)
	    (srfi 115)
	    (srfi 26)
	    (srfi 1)
	    )
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
      (include "srfi/204.sld")
      (import (srfi 204))
      (include "test/no-srfi-26-r7rs-srfi-common.scm")))
  (else))
(cond-expand
  (chibi
    (define non-linear-pattern #t)
    (define non-linear-pred #t)
    (define non-linear-field #t)
    (define record-implemented #t)
    (define test-name "srfi-test")
    (define scheme-version-name (string-append "chibi-" chibi-version))
    (include "srfi-chibi.scm"))
  (else))
