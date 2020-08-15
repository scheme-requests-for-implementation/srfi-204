;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; procedures for factoring auxiliary keyword definition out of other
;;; code in library- (different implementations have different unbound
;;; keywords: @ is bound in guile, $ in gauche, struct in racket, so
;;; I want to do the binding in the sld instead of the common scm.)
;;; based on code in Amirouche Boubekki's (Apache Licensed) Arew
;;; Scheme's implementation of Alex Shinn's (Public Domain) match
;;; and code John Cowan shared in "In favor of explicit argument" thread
;;; on SRFI 197 forum.

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
