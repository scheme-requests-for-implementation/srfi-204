;;; match using rnrs records
;;; r6rs style, with Chez and Loko all calls on rtd have to be
;;; replaced with calls on (record-type-descriptor rtd),
;;; with Guile this module works as is
(library (match)
	 (export match
		 match-lambda
		 match-lambda*
		 match-let
		 match-let*
		 match-letrec
		 ___ ..1 ..= ..* *** ? $ struct object get!)
	 (import (rnrs records)
		 (scheme))
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
	   ((_ rtd rec n value)
	    (if (integer? n)
		((record-mutator rtd n) rec value)
		((record-mutator rtd (name->idx rtd n)) rec value))))
	 (define-syntax name->idx
	   (syntax-rules ()
	     ((_ rtd n)
	      (let ((names (record-type-field-names rtd))
		    (len (vector-length names)))
		(let lp ((i 0))
		  (cond
		    ((> i len) (error "name not in record" n))
		    ((eq? n (vector-ref names i)) i)
		    (else (lp (+ i 1 )))))))))
	 ;;include match/match.scm however that's done
	 ;;use define-auxiliary-keywords from auxiliary-syntax.scm
	 ;;to define exports.
	 )
;;;r7rs style, auxiliary syntax exports may need to be edited
(define-library (rnrs-rec match)
	 (export match
		 match-lambda
		 match-lambda*
		 match-let
		 match-let*
		 match-letrec
		 ___ ..1 ..= ..* *** ? $ struct object get!)
	 (import (rnrs records)
		 (scheme))
	 (include "auxiliary-syntax.scm")
	 (begin
	   (define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!)
	   ((define-syntax is-a?
	      ((_ rec rtd)
	       (and (record-type-descriptor? rtd)
		    ((record-predicate rtd) rec)))))
	   (define-syntax slot-ref
	     ((_ rtd rec n)
	      (if (integer? n)
		  ((record-accessor rtd n) rec)
		  ((record-accessor rtd (name->idx n)) rec))))
	   (define-syntax slot-set!
	     ((_ rtd rec n value)
	      (if (integer? n)
		  ((record-mutator rtd n) rec value)
		  ((record-mutator rtd (name->idx rtd n)) rec value))))
	   (define-syntax name->idx
	     (syntax-rules ()
	       ((_ rtd n)
		(let ((names (record-type-field-names rtd))
		      (len (vector-length names)))
		  (let lp ((i 0))
		    (cond
		      ((> i len) (error "name not in record" n))
		      ((eq? n (vector-ref names i)) i)
		      (else (lp (+ i 1 ))))))))))
	 (include "match/match.scm"))
