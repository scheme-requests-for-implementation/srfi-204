(define-module (guile2.2 match)
  #:export (match match-lambda match-lambda* match-let match-letrec match-let*))

;;; Support for record matching.
;;;  using low-level 
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

(include-from-path "./match/match.scm")
