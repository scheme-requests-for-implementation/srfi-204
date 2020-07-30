;;; Haven't found any implementations to test this with
;;; but this is a prototype of how to use srfi-99 with this
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
	 (equal? rtd (record-rtd rec)))))
    (define-syntax slot-ref
      (syntax-rules ()
	((_ rtd rec n)
	 (if (integer? n)
	     ((rtd-accessor (vector-ref (rtd-all-field-names rtd) n)) rec)
	     ((rtd-accessor rtd n) rec)))))
    (define-syntax slot-set!
      (syntax-rules ()
	((_ rtd rec n)
	 (if (integer? n)
	     ((rtd-mutator (vector-ref (rtd-all-field-names rtd) n)) rec)
	     ((rtd-mutator rtd n) rec))))))
  (include "../match/match.scm"))
