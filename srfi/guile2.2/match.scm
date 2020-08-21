(define-module (guile2.2 match)
  #:export (match
	     match-lambda
	     match-lambda*
	     match-let
	     match-letrec
	     match-let*
	     ___ ..1 ..= ..* *** ? $ struct object get!))

;;; Support for record matching.
;;;  using low-level 
;;;  tried to re-implement using goops got:
;;;   (is-a? rec rtd) => #f
;;;   (class-name rtd) => error
;;;   (is-a? rec (class-of (make-struct/no-tail rtd))) => #t
;;;   but
;;;  (class-slots (class-of (make-struct/no-tail rtd))) => ()
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
(include-from-path "./auxiliary-syntax.scm")
(define-auxiliary-keywords ___ ..1 ..= ..* *** ? $ struct object get!)
(include-from-path "./srfi-204/match.scm")
