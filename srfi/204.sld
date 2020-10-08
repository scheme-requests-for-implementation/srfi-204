(cond-expand
  (chibi
    (define-library (srfi 204)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; extension helpers
	make-match-pred make-match-get make-match-set
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
	;; extension helpers
	make-match-pred make-match-get make-match-set
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get!)
      (import (only (gauche base) is-a? slot-definition-name class-slots)
	      (scheme base)
	      (only (srfi 206 all) ___ **1 =.. *.. *** ? struct object get!)
	      (rename (gauche base)
		      (slot-ref gb-slot-ref)
		      (slot-set! gb-slot-set!)))
      ;(include "auxiliary-syntax.scm")
      (begin
	;(define-auxiliary-keywords ___ **1 =.. *.. *** ? struct object get!)
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
  (guile
    (define-module (srfi 204))
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
    (include-from-path "auxiliary-syntax.scm")
    (define-auxiliary-keywords ___ **1 =.. *.. *** ? $ struct object get!)
    (include "204/204.scm"))
  (larceny
    (define-library (srfi 204)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; extension helpers
	make-match-pred make-match-get make-match-set
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get!)
      (import (scheme base)
	      (scheme case-lambda)
	      (only (srfi 206 all) ___ **1 =.. *.. *** ? $ struct object get!)
	      (srfi 99 records))
      (begin
	(define-syntax is-a?
	  (syntax-rules ()
	    ((_ rec rtd) ;should this be wrapped in (and (rtd? rtd))
	     ((rtd-predicate rtd) rec))))
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
