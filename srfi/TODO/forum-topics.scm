;;; This started out as a generator because that was the pattern-matching on
;;; a callable I was most familiar with but it's really just demonstrates some
;;; aspects of the module that have come up in the forum and how they might be
;;; used.

(import (srfi srfi-9))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generator: this demonstrates pattern matching on a
;; callable, I don't think it directly touches on anything
;; in the forum, except maybe tail-context.

(define-record-type <yield>
  (make-yield value closure)
  yield?
  (value yield-value)
  (closure yield-closure))

(define (simple-gen proc init)
  (let lp ((value init))
    (make-yield value (lambda () (lp (proc value))))))

(define (iota-2 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (+ n 1)) 0)))
	     (if (= v n)
		 '()
		 (cons v (lp (c))))))

(define (iota-2-2 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (+ n 1)) 0))
		 (acc '()))
	     (if (= v n)
		 (reverse acc)
		 (lp (c) (cons v acc)))))

(define (iota-2-3 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (- n 1)) (- n 1)))
		 (acc '()))
	     (if (< v 0)
		 acc
		 (lp (c) (cons v acc)))))

;;; some benchmarking, adding underscores to make nums more readable
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 10_000))) (car l))
;; $24 = 0
;; ;; 0.009579s real time, 0.009463s run time.  0.000000s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 10_000))) (car l))
;; $25 = 0
;; ;; 0.017753s real time, 0.017717s run time.  0.000000s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 1_000_000))) (car l))
;; $26 = 0
;; ;; 0.273366s real time, 0.301025s run time.  0.123467s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 1_000_000))) (car l))
;; $27 = 0
;; ;; 0.207538s real time, 0.267880s run time.  0.160490s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 100_000_000))) (car l))
;; allocate_stack failed: Cannot allocate memory
;; While executing meta-command:
;; Stack overflow
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 100_000_000))) (car l))
;; $28 = 0
;; ;; 24.418649s real time, 25.026579s run time.  15.652399s spent in GC.
;; scheme@(guile-user) [5]>
;; difference between iota-2-2 and iota-2-3 starts to show up ~10 million
;; at 1 billion both are killed.

;; the problem from AOC that took 3-at-a-time from the intcode vm could work
;; like this:

(define (next-three gen)
  (match-let* ((($ <yield> v1 c1) gen)
	       (($ <yield> v2 c2) (c1))
	       (($ <yield> v3 c3) (c2)))
	      (list (list v1 v2 v3) c3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; checkable: this demonstrates one use case for predicates
;; that come from pattern variables. This is also a difference
;; from the matcher outlined in Wright and Duba "Pattern Matching
;; for Scheme"

(define-record-type <checkable>
  (make-checkable pred data)
  checkable?
  (pred checkable-pred)
  (data checkable-data))

(define check
  (match-lambda (($ <checkable> pred (? pred ok)) ok)
		(($ <checkable>) 'bad-data)))

;;; Wright version
(define check-2
  (match-lambda (($ <checkable> pred val)
		 (if (pred val) val 'bad-data))))

(check (make-checkable odd? 1)) ; => 1
(check (make-checkable odd? 2)) ; => 'bad-data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; successor function: uses and form and field (not predicate)
;; checking Wright and Duba's paper, there is no reference to
;; fields being from same scope as match

(define (S n) (list S n))

(define add-one
  (match-lambda
    ((and (f n) (= f next)) next)))

(define value (match-lambda ((x *** (? number? n)) (+ (length x) n))))
;;; does not work in Wright, = seems to have same properties as ?, even though
;;; not documented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; the behavior of cyclic literals has been a long-running
;; topic, the following is one matcher that acts on cyclic
;; lists (this uses constructed lists because not all
;; implementations handle cyclic literals correctly)

(define l3 (list 1 2 3))
(set-cdr! (cddr l3) l3) ;; l = '#0=(1 2 3 . #0#)
(define zero-to-three-cycle
  (match-lambda ((and c (= car c)) 0)
		((and c (= cdr c)) 1)
		((and c (= cddr c)) 2)
		((and c (= cdddr c)) 3)
		(_ 'fail)))
(define l0 (list (list)))
(set-car! l0 l0) ;; '#0=(#0#)

(zero-to-three-cycle l0) ; => 0
(zero-to-three-cycle l3) ; => 3

;;;another example using pattern variables in the predicate

(define fibby
  (match-lambda* ((a b (? (lambda (x) (= (+ a b) x)) c) . rest)
		  (apply fibby (cons b (cons c rest))))
                 ((a b) #t)
                 ((a) #t)
                 (() #t)
		 (_ #f)))
