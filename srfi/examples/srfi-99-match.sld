;;; This works with Larceny
;;; this is a prototype of how to use srfi-99 with this
;;; library
(define-library
  (match)
  (export match match-lambda match-let match-let*
	  match-lambda* match-letrec)
  (import (srfi :99 records)
	  (scheme base))
  (begin
    (define-syntax is-a?
      (syntax-rules ()
	((_ rec rtd)
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
  (include "../srfi-204/srfi-204.scm"))
