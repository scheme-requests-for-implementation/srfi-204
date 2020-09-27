;; Copyright (C) Marc Nieper-Wißkirchen (2020).  All Rights Reserved.

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
(library
  (srfi srfi-206 all)
  (export
    ;; R7RS
    else => unquote unquote-splicing _ ...
    ;; syntax-case
    ;unsyntax unsyntax-splicing
    ;; SRFI 26
    <> <...>
    ;; SRFI 190
    ;yield
    ;; SRFI 204
    $ ? get! *** ___ **1 =.. *.. struct object)
  (import (guile))
  (define-syntax define-identifier-syntax-parameter
    (syntax-rules ()
      ((_ name e)
       (define-syntax name
	 (syntax-rules ()
	   ((_ . _) e))))))
  (define-syntax define-auxiliary-syntax
    (syntax-rules ()
      ((_ name)
       (define-identifier-syntax-parameter name
					   (syntax-error "invalid use of auxiliary syntax" name)))))
  (include-from-path "srfi/srfi-206/all-definitions.scm")
  )
#|
(define-module (srfi srfi-206 all))
  (include-from-path "srfi/srfi-206/all-exports.scm")
  (import (guile))
    (define-syntax define-identifier-syntax-parameter
      (syntax-rules ()
	((_ name e)
	 (define-syntax name
	   (syntax-rules ()
	     ((_ . _) e))))))
    (define-syntax define-auxiliary-syntax
      (syntax-rules ()
	((_ name)
	 (define-identifier-syntax-parameter name
					     (syntax-error "invalid use of auxiliary syntax" name)))))
(include-from-path "srfi/srfi-206/all-definitions.scm")
|#
#|
(define-library (srfi srfi-206 all)
  (include-library-declarations "all-exports.scm")
  (import (guile))
  (cond-expand
    (else
      (define-syntax define-identifier-syntax-parameter
	(syntax-rules ()
	  ((_ name e)
	   (define-syntax name
	     (syntax-rules ()
	       ((_ . _) e))))))
    (define-syntax define-auxiliary-syntax
      (syntax-rules ()
	((_ name)
	 (define-identifier-syntax-parameter name
					     (syntax-error "invalid use of auxiliary syntax" name)))))))
(include "all-definitions.scm"))
|#
#|
(define-library (srfi srfi-206 all)
  (cond-expand
    (else
     (include-library-declarations "all-exports.scm")
     (import (scheme base))
     (cond-expand
       ((library (srfi srfi-139))
        (import (srfi srfi-139)))
       (else
        (import (rename (scheme base) (define-syntax define-syntax-parameter)))))
     (cond-expand
       (else
        (begin
          (define-syntax define-identifier-syntax-parameter
            (syntax-rules ()
              ((_ name e)
               (define-syntax name
                 (syntax-rules ()
                   ((_ . _) e)))))))))
     (begin
       (define-syntax define-auxiliary-syntax
         (syntax-rules ()
           ((_ name)
            (define-identifier-syntax-parameter name
              (syntax-error "invalid use of auxiliary syntax" name))))))
     (include "all-definitions.scm"))))
|#
