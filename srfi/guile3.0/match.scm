;;;; match.sld
;;;   the module in guile2.2vis already working for Guile 2 and 3
;;;   using this one to test rnrs records-based is-a?, slot-ref, slot-set!
(define-library (guile3.0 match)
		(export match match-lambda match-lambda* match-let match-let*
			match-letrec
			___ ..1 ..= ..* *** ? $ struct object get!)

		(import (guile)
			(rnrs records procedural)
			(rnrs records inspection))
		(begin
		  (define-syntax is-a?
		    (syntax-rules ()
		      ((_ rec rtd)
		       (and (record-type-descriptor? rtd)
			    ((record-predicate rtd) rec)))))
		  (define-syntax slot-ref
		    (syntax-rules ()
		      ((_ rtd rec n)
		       (if (integer? n)
			   ((record-accessor rtd n) rec)
			   ((record-accessor rtd (name->idx rtd n)) rec)))))
		  (define-syntax slot-set!
		    (syntax-rules ()
		      ((_ rtd rec n value)
		       (if (integer? n)
			   ((record-mutator rtd n) rec value)
			   ((record-mutator rtd (name->idx rtd n)) rec value)))))
		  (define-syntax name->idx
		    (syntax-rules ()
		      ((_ rtd n)
		       (let* ((names (record-type-field-names rtd))
			      (len (vector-length names)))
			 (let lp ((i 0))
			   (cond
			     ((> i len) (error "name not in record" n))
			     ((eq? n (vector-ref names i)) i)
			     (else (lp (+ i 1 )))))))))
		  (include-from-path "match/match.scm"))
		;(include "match/match.scm") doesn't work 
		)
