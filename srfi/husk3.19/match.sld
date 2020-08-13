(define-library
  (match)
  (export match match-lambda match-lambda*
		 match-let match-let* match-letrec)
  (import (scheme)
	  (scheme base))
  (begin
  #|
    (define-syntax is-a?
      ((_ rec rtd)
       ((record-predicate rtd) rec)))
    (define-syntax slot-ref
      ((_ rtd rec n)
       (if (integer? n)
	   (record-ref rec n)
	   ((record-accessor rtd n) rec))))
    (define-syntax slot-set!
      ((_ rtd rec n value)
       (if (integer? n)
	   (record-set! rec n value)
	   ((record-mutator rtd n) rec value))))
    |#
    (include "../match/match.scm")))
