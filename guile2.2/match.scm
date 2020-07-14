(define-module (guile2.2 match)
  #:export (match match-lambda match-lambda* match-let match-letrec match-let*))

;; Support for record matching.

(define-syntax slot-ref
  (syntax-rules ()
    ((_ rtd rec n)
     (struct-ref rec n))))

(define-syntax slot-set!
  (syntax-rules ()
    ((_ rtd rec n value)
     (struct-set! rec n value))))

(define-syntax is-a?
  (syntax-rules ()
    ((_ rec rtd)
     (and (struct? rec)
          (eq? (struct-vtable rec) rtd)))))

(include-from-path "guile2.2/match/match-upstream.scm")
