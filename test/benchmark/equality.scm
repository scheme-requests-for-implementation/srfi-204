(cond-expand
  (guile (import (srfi srfi-27)))
  (else (import (srfi 27))))
(import (test benchmark  time)
	(scheme base)
	(scheme case-lambda)
	(srfi-204)
	(srfi 1))

;;; unlike FIBBY?, LOCAL-SAMENESS (and co) are designed
;;; to recur over all of (NRANDS N), each member of which is
;;; either 0 or 1, so big number math should never be an issue
;;; that overwhelms the differnces between the matchers.

;;; N -> [List-of B]
;;;      B is 0|1
;;;      length of list is N
; (define nrands
;   (make-builder (lambda arg (random-integer 2))
; 		(random-integer 2)
;		id))
;;; > (define k200 (nrands 200000))
(define (nrands n) (map (lambda arg (random-integer 2)) (iota n)))

(define (local-sameness seq)
  (let lp ((seq seq)
	   (acc 0))
    (match seq
	   ((a a . rest) (lp (cons a rest) (+ acc 1)))
	   ((a b . rest) (lp (cons b rest) (- acc 1)))
	   (_ acc))))
;;; > (time-it (= 20) (local-sameness k200))
;;; ;;; 20 runs, average run time 0.8993seconds
;;; -659


(define (make-alternate-pred pred)
  (case-lambda
    ((a) (lambda (b) (pred a b)))
    ((a b) (pred a b))))

(define alt-=? (make-alternate-pred =))

(define (local-sameness-2 seq)
  (define alt-=? (make-alternate-pred =))
  (let lp ((a (car seq))
	   (seq (cdr seq))
	   (acc 0))
    (match seq
	   (((? (alt-=? a) b) . rest) (lp b rest (+ acc 1)))
	   ((b . rest) (lp b rest (- acc 1)))
	   (_ acc))))
;;; > (time-it (= 20) (local-sameness-2 k200))
;;; ;;; 20 runs, average run time 0.7414seconds
;;; -659

(define (local-sameness-3 seq)
  (define alt-=? (make-alternate-pred =))
  (let lp ((a (car seq))
	   (seq (cdr seq))
	   (acc 0))
    (match seq
	   ((b . rest)
	    (if (alt-=? a b)
		(lp b rest (+ acc 1))
		(lp b rest (- acc 1))))
	   (_ acc))))
;;; > (time-it (= 20) (local-sameness-3 k200))
;;; ;;; 20 runs, average run time 0.5978seconds
;;; -659

(define (local-sameness-4 seq)
  (define alt-=? (make-alternate-pred =))
  (let lp ((a (car seq))
	   (seq (cdr seq))
	   (acc 0))
    (match seq
	   ((b . rest)
	    (if (= a b)
		(lp b rest (+ acc 1))
		(lp b rest (- acc 1))))
	   (_ acc))))
;;; > (time-it (= 20) (local-sameness-4 k200))
;;; ;;; 20 runs, average run time 0.58445seconds
;;; -659


(define (chunk-2 seq)
  (let lp ((seq seq) (out '()))
    (match seq
	 ((a b . rest) (lp rest (cons (list a b) out)))
	 (() (reverse out))
	 (any (reverse (cons any out))))))

(define (chunk-sameness seq)
  (let lp ((seq seq)
	   (out 0))
    (match seq
	 (((a a) . rest) (lp rest (+ out 1)))
	 (((a b) . rest) (lp rest (- out 1)))
	 (_ out))))
;;; > (define k200ch (chunk-2 k200))
;;; > (time-it (= 20) (chunk-sameness k200ch))
;;; ;;; 20 runs, average run time 0.37585seconds
;;; -558

(define (chunk-sameness-2 seq)
  (let lp ((seq seq)
	   (out 0))
    (match seq
	 (((a (? (alt-=? a))) . rest) (lp rest (+ out 1)))
	 (((a b) . rest) (lp rest (- out 1)))
	 (_ out))))
;;; > (time-it (= 20) (chunk-sameness-2 k200ch))
;;; ;;; 20 runs, average run time 0.40975seconds
;;; -558

(define (chunk-sameness-3 seq)
  (let lp ((seq seq)
	   (out 0))
    (match seq
	 (((a b) . rest) 
	  (if (alt-=? a b) 
	      (lp rest (+ out 1))
	      (lp rest (- out 1))))
	 (_ out))))
;;; > (time-it (= 20) (chunk-sameness-3 k200ch))
;;; ;;; 20 runs, average run time 0.33555seconds
;;; -558

(define (chunk-sameness-4 seq)
  (let lp ((seq seq)
	   (out 0))
    (match seq
	 (((a b) . rest) 
	  (if (= a b) 
	      (lp rest (+ out 1))
	      (lp rest (- out 1))))
	 (_ out))))
;;; > (time-it (= 20) (chunk-sameness-4 k200ch))
;;; ;;; 20 runs, average run time 0.2989seconds
;;; -558

(define (chunk-sameness-5 seq)
  (define alt-=? (make-alternate-pred =))
  (let lp ((seq seq)
	   (out 0))
    (match seq
	 (((a b) . rest) 
	  (if (alt-=? a b) 
	      (lp rest (+ out 1))
	      (lp rest (- out 1))))
	 (_ out))))
;;; > (time-it (= 20) (chunk-sameness-5 k200ch))
;;; ;;; 20 runs, average run time 0.3683seconds
;;; -558
