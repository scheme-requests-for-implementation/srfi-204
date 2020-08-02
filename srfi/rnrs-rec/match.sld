;;;match using rnrs records
(library (match)
	 (export match
		 match-lambda
		 match-lambda*
		 match-let
		 match-let*
		 match-letrec)
	 (import (rnrs records syntactic)
		 (rnrs records procedural)
		 (rnrs records inspection))
	 (define-syntax is-a?
	   ((_ rec rtd)
	    (and (record-type-descriptor? rtd)
		 ((record-predicate rtd) rec))))
	 (define-syntax slot-ref
	   ((_ rtd rec n)
	    (if (integer? n)
		((record-accessor rtd n) rec)
		((record-accessor rtd (name->idx n)) rec))))
	 (define-syntax slot-set!
	   ((_ rtd rec n)
	    (if (integer? n)
		((record-mutator rtd n) rec)
		((record-mutator rtd (name->idx rtd n)) rec))))
	 (define-syntax name->idx
	   ((_ rtd n)
	    (let ((names (record-type-field-names rtd))
		  (len (vector-length names)))
	      (let lp ((i 0))
		(cond
		  ((> i len) (error "name not in record" n))
		  ((eq? n (vector-ref names i)) i)
		  (else (lp (+ i 1 ))))))))
	 ;;include match/match.scm however that's done
	 )
