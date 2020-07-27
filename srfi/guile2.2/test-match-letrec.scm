;;;Just a simple example so I can figure out what is going on with
;;;match-letrec
(use-modules (ice-9 match))

(match-letrec ((fac (lambda (n)
		      (if (zero? n)
			  1
			  (* n (fac (- n 1))))))
	       ((a b) (list 20 40)))
	      (list (fac a) (fac b)))
;;;Ok, this works.

;;;This is the test:
(match-letrec (((x y) (list 1 (lambda () (list a x))))
	       ((a b) (list 2 (lambda () (list x a)))))
	      (append (y) (b)))
;;;And this is what the interperter says:
;;; test-match-letrec.scm:14:41: warning: possibly unbound variable `a'
;;; test-match-letrec.scm:14:41: warning: possibly unbound variable `x'
;;; test-match-letrec.scm:15:41: warning: possibly unbound variable `x'
;;; test-match-letrec.scm:15:41: warning: possibly unbound variable `a'

;;; 
