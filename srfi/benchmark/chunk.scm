(import (srfi srfi-1))
(define (chunk-4 l)
  (match l
	 (() l)
	 ((a b c d . r) (cons (list a b c d) (chunk-4 r)))
	 (a (list a))))

(define (chunk-4-v2 l)
  (let lp ((l l) (acc '()))
    (match l
      (() (reverse acc))
      ((a b c d . r) (lp r (cons (list a b c d) acc)))
      (a (reverse (cons (list a) acc))))))

#|
scheme@(guile-user)> (include-from-path "../srfi-204.sld")
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$1 = (0 1 2 3)
;; 1.569107s real time, 1.637423s run time.  0.757912s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$2 = (0 1 2 3)
;; 0.749622s real time, 0.758089s run time.  0.281753s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$3 = (0 1 2 3)
;; 0.689932s real time, 0.698363s run time.  0.261501s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$4 = (0 1 2 3)
;; 0.681320s real time, 0.690591s run time.  0.257421s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$5 = (0 1 2 3)
;; 0.683958s real time, 0.693265s run time.  0.261759s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$6 = (0 1 2 3)
;; 0.705514s real time, 0.718944s run time.  0.263295s spent in GC.
scheme@(srfi-204)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$7 = (0 1 2 3)
;; 0.673343s real time, 0.682822s run time.  0.262376s spent in GC.

scheme@(guile-user)> (import (ice-9 match))
scheme@(guile-user)> (define (chunk-4 l)
...   (match l
...      (() l)
...      ((a b c d . r) (cons (list a b c d) (chunk-4 r)))
...      (a (list a))))
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$1 = (0 1 2 3)
;; 1.141033s real time, 1.167376s run time.  0.495077s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$2 = (0 1 2 3)
;; 0.694569s real time, 0.723356s run time.  0.277621s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$3 = (0 1 2 3)
;; 0.716401s real time, 0.725184s run time.  0.248132s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$4 = (0 1 2 3)
;; 0.754927s real time, 0.763778s run time.  0.251674s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$5 = (0 1 2 3)
;; 0.733057s real time, 0.741295s run time.  0.238099s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$6 = (0 1 2 3)
;; 0.701148s real time, 0.709875s run time.  0.248987s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$7 = (0 1 2 3)
;; 0.688946s real time, 0.698065s run time.  0.253452s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$8 = (0 1 2 3)
;; 0.722150s real time, 0.730444s run time.  0.247968s spent in GC.
scheme@(guile-user)> ,time (let ((a (chunk-4 (iota 10000000)))) (car a))
$9 = (0 1 2 3)
;; 0.694322s real time, 0.701682s run time.  0.253721s spent in GC.
scheme@(guile-user)>

to a first approximation, anyway, it doesn't look like the underscore
macros had a big effect on the code.
|#
