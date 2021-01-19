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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; procedures for factoring auxiliary keyword definition out of other
;;; code in library- (different implementations have different unbound
;;; keywords: @ is bound in guile, $ in gauche, struct in racket, so
;;; I want to do the binding in the sld instead of the common scm.)
;;; based on code in Amirouche Boubekki's (Apache Licensed) Arew
;;; Scheme's implementation of Alex Shinn's (Public Domain) match
;;; and code John Cowan shared in "In favor of explicit argument" thread
;;; on SRFI 197 forum. This predates and in R7RS is replaced by SRFI-206
(define-syntax define-auxiliary-keyword
  (syntax-rules ()
    ((_ name)
     (define-syntax name
       (syntax-rules ()
	 ((** head . tail)
	  (syntax-error "invalid auxiliary syntax" head . tail)))))))

(define-syntax define-auxiliary-keywords
  (syntax-rules ()
    ((_ name* ...)
     (begin (define-auxiliary-keyword name*) ...))))
