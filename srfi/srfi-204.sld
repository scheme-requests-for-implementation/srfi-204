;;; guile and gerbil versions (srfi 204) didn't work
(cond-expand
  (guile
    (define-module (srfi srfi-204))
    (export match match-lambda match-lambda* match-let match-let*
	    match-letrec
	    ___ **1 =.. *.. *** ? $ struct object get!)
    (import (guile))
    (define-syntax slot-ref
      (syntax-rules ()
	((_ rtd rec n)
	 (if (integer? n)
	     (struct-ref rec n)
	     ((record-accessor rtd n) rec)))))

    (define-syntax slot-set!
      (syntax-rules ()
	((_ rtd rec n value)
	 (if (integer? n)
	     (struct-set! rec n value)
	     ((record-modifier rtd n) rec value)))))

    (define-syntax is-a?
      (syntax-rules ()
	((_ rec rtd)
	 (and (struct? rec)
	      (eq? (struct-vtable rec) rtd)))))
    (include-from-path "srfi/auxiliary-syntax.scm")
    (define-auxiliary-keywords ___ **1 =.. *.. *** ? $ struct object get!)
    (include-from-path "srfi/204/204.scm"))
  (gerbil
    (define-library (srfi srfi-204)
      (export match match-lambda match-lambda* match-let match-letrec match-let*
	      ___ **1 =.. *.. *** ? $ struct object get!)
      (import (scheme base)
	      (only (srfi srfi-206 all) ___ **1 =.. *.. *** ? $ struct object get!)
	      (rename (gerbil core)
		      (slot-ref ger-slot-ref)
		      (slot-set! ger-slot-set!)))
      (begin
	(define-syntax is-a?
	  (syntax-rules ()
	    ((_ rec rtd)
	     ((make-struct-predicate rtd) rec))))
	(define-syntax slot-ref
	  (syntax-rules ()
	  ((_ rtd rec n)
	   (if (integer? n)
	       (struct-field-ref rtd rec n)
	       (error "named record access not implemented" n)))))
	(define-syntax slot-set!
	  (syntax-rules ()
	  ((_ rtd rec n)
	   (if (integer? n)
	       (struct-field-set! rtd rec n)
	       (error "named record access not implemented" n))))))
      (include "204/204.scm"))))
