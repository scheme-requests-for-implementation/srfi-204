(define-library (larceny1.3 match)
  (export match match-lambda match-lambda* match-let match-letrec match-let*)
  (import (scheme base)
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
	((_ rtd rec n)
	 (if (integer? n)
	     ((rtd-mutator rtd (vector-ref (rtd-all-field-names rtd) n)) rec)
	     ((rtd-mutator rtd n) rec))))))
  (include "match/match.scm"))

;;; $larceny -r7rs -I ..
;;; > (import (scheme base) (larceny1.3 match))
;;; > (match '(mom dad sis bro)
;;;          ((date night . kids-stay-home) (list date night)))
;;;=> (mom dad) ;yay!
