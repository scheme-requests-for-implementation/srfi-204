(cond-expand
  (chibi
    (define-library (srfi 204)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get!)
      (import (chibi)
	      (scheme case-lambda)
	      (only (srfi 206 all) ___ **1 =.. *.. *** ? $ struct object get!))
      (include  "204/204.scm")))
  (gauche
    (define-library (srfi 204)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get!)
      (import (only (gauche base) is-a? slot-definition-name class-slots)
	      (scheme base)
	      (only (srfi 206 all) ___ **1 =.. *.. *** ? struct object get!)
	      (rename (gauche base)
		      (slot-ref gb-slot-ref)
		      (slot-set! gb-slot-set!)))
      (begin
	(define-syntax slot-ref
	  (syntax-rules ()
	    ((_ class inst n)
	     (if (integer? n)
		 (gb-slot-ref inst
			      (list-ref (map slot-definition-name
					     (class-slots class))
					n))
		 (gb-slot-ref inst n)))))
	(define-syntax slot-set!
	  (syntax-rules ()
	    ((_ class inst n value)
	     (if (integer? n)
		 (gb-slot-set! inst
			       (list-ref (map slot-definition-name
					      (class-slots class))
					 n)
			       value)
		 (gb-slot-set! inst n value))))))
      (include "204/204.scm")))
  ((or larceny (library (srfi 99)))
    (define-library (srfi 204)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get!)
      (import (scheme base)
	      (scheme case-lambda)
	      (only (srfi 206 all) ___ **1 =.. *.. *** ? $ struct object get!)
	      (srfi 99 records))
      (begin
	(define-syntax is-a?
	  (syntax-rules ()
	    ((_ rec rtd)
	     (and (rtd? rtd)
		  ((rtd-predicate rtd) rec)))))
	(define-syntax slot-ref
	  (syntax-rules ()
	    ((_ rtd rec n)
	     (if (integer? n)
		 ((rtd-accessor rtd (vector-ref (rtd-all-field-names rtd) n)) rec)
		 ((rtd-accessor rtd n) rec)))))
	(define-syntax slot-set!
	  (syntax-rules ()
	    ((_ rtd rec n value)
	     (if (integer? n)
		 ((rtd-mutator rtd (vector-ref (rtd-all-field-names rtd) n)) rec value)
		 ((rtd-mutator rtd n) rec value))))))
      (include "204/204.scm")))
  (else))
