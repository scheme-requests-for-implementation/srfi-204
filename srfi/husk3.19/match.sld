(define-library
  (match)
  (export match match-lambda match-lambda*
	  match-let match-let* match-letrec
	  ___ ..1 ..= ..* *** ? $ struct object get!)
  (import (scheme))
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
    (include "../auxiliary-syntax.scm")
    (define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!)
    (include "../match/match.scm")))
