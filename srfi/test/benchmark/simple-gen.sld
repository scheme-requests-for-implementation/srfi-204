(define-library
  (test benchmark simple-gen)
  (export simple-gen make-builder id)
  (import (scheme base)
	  (srfi-204))
  (begin
    (define (make-yield value closure)
      (list 'yield value closure))

    (define (simple-gen proc init)
      (let lp ((value init))
	(make-yield value (lambda () (lp (proc value))))))

    (define (make-builder proc init select)
      (lambda (n)
	(match-let loop ((('yield v c) (simple-gen proc init))
			 (n n)
			 (acc '()))
		   (if (zero? n)
		       (reverse acc)
		       (loop (c) (- n 1) (cons (select v) acc))))))
    (define (id x) x)))
