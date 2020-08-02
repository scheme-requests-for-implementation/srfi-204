(define-library (gauche0.9.6  match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (import (only (gauche base) is-a? slot-definition-name class-slots)
	  (scheme base)
	  (rename (gauche base)
		  (slot-ref gb-slot-ref)
		  (slot-set! gb-slot-set!)))
  (begin
    (define-syntax slot-ref
      (syntax-rules ()
	((_ class inst n)
	 (if (integer? n)
	     (gb-slot-ref inst (list-ref (map slot-definition-name (class-slots class)) n))
	     (gb-slot-ref inst n)))))
    (define-syntax slot-set!
      (syntax-rules ()
	((_ class inst n value)
	 (if (integer? n)
	     (gb-slot-set! inst (list-ref (map slot-definition-name (class-slots class)) n) value)
	     (gb-slot-set! inst n value))))))
  (include "match/match.scm"))
;;; (import (gauche0.9.6 match))
;;; (import (scheme base))
