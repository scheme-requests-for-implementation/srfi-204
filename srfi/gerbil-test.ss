(add-load-path ".")
(import (scheme base)
	(scheme write)
	(srfi srfi-204)
	(std test)
	(std srfi 9))
(define gerbil-tests
  (test-suite
    "gerbil-match-test"
    (define-record-type Point
      (make-point x y)
      point?
      (x point-x point-x-set!)
      (y point-y point-y-set!))
      (display (string-append "gerbil-" (gerbil-version-string)))
      (newline)
      (test-case "test: any"
      (check (match 'any (_ 'ok)) => 'ok ))
      (test-case "test: symbol"
      (check (match 'ok (x x)) => 'ok ))
      (test-case "test: number"
      (check (match 28 (28 'ok)) => 'ok ))
      (test-case "test: string"
      (check (match "good" ("bad" 'fail) ("good" 'ok)) => 'ok ))
      (test-case "test: literal symbol"
      (check (match 'good ('bad 'fail) ('good 'ok)) => 'ok ))
      (test-case "test: null"
      (check (match '() (() 'ok)) => 'ok ))
      (test-case "test: pair"
      (check (match '(ok) ((x) x)) => 'ok ))
      (test-case "test: vector"
      (check (match '#(ok) (#(x) x)) => 'ok ))
      (test-case "test: any doubled"
      (check (match '(1 2) ((_ _) 'ok)) => 'ok ))
      (test-case "test: and empty"
      (check (match '(o k) ((and) 'ok)) => 'ok ))
      (test-case "test: and single"
      (check (match 'ok ((and x) x)) => 'ok ))
      (test-case "test: and double"
      (check (match 'ok ((and (? symbol?) y) 'ok)) => 'ok ))
      (test-case "test: or empty"
      (check (match '(o k) ((or) 'fail) (else 'ok)) => 'ok ))
      (test-case "test: or single"
      (check (match 'ok ((or x) 'ok)) => 'ok ))
      (test-case "test: or double"
      (check (match 'ok ((or (? symbol? y) y) y)) => 'ok ))
      (test-case "test: not"
      (check (match 28 ((not (a . b)) 'ok)) => 'ok ))
      (test-case "test: pred"
      (check (match 28 ((? number?) 'ok)) => 'ok ))
      (test-case "test: named pred"
      (check (match 28 ((? number? x) (+ x 1))) => 29 ))

      (test-case "test: duplicate symbols pass"
      (check (match '(ok . ok) ((x . x) x)) => 'ok ))
      (test-case "test: duplicate symbols fail"
      (check (match '(ok . bad) ((x . x) 'bad) (else 'ok)) => 'ok
	     ))
      (test-case "test: duplicate symbols samth"
      (check (match '(ok . ok) ((x . 'bad) x) (('ok . x) x)) => 'ok
	     ))
      (test-case "test: duplicate symbols bound"
      (check (let ((a '(1 2))) (match a ((and (a 2) (1 b)) (+ a b)) (_ #f))) => 3
	     ))
      (test-case "test: duplicate quasiquote"
      (check (match '(a b) ((or `(a ,x) `(,x b)) 'ok) (_ #f)) => 'ok
	     ))

      (test-case "test: ellipses"
      (check (match '((a . 1) (b . 2) (c . 3))
		    (((x . y) ___) (list x y))) => '((a b c) (1 2 3))
	     ))

      (test-case "test: real ellipses"
      (check (match '((a . 1) (b . 2) (c . 3))
		    (((x . y) ...) (list x y))) => '((a b c) (1 2 3))
	     ))

      (test-case "test: vector ellipses"
      (check (match '#(1 2 3 (a . 1) (b . 2) (c . 3))
		    (#(a b c (hd . tl) ...) (list a b c hd tl))) => '(1 2 3 (a b c) (1 2 3))
	     ))

      (test-case "test: pred ellipses"
      (check (match '(1 2 3)
		    (((? odd? n) ___) n)
		    (((? number? n) ___) n)) => '(1 2 3)
	     ))

      (test-case "test: failure continuation"
      (check (match '(1 2)
		    ((a . b) (=> next) (if (even? a) 'fail (next)))
		    ((a . b) 'ok)) => 'ok
	     ))

      (test-case "test: let"
      (check (match-let ((x 'ok) (y '(o k))) y) => '(o k)
	     ))

      (test-case "test: let*"
      (check (match-let* ((x 'f) (y 'o) ((z w) (list y x))) (list x y z w)) => '(f o o f)
	     ))

      (test-case "test: getter car"
      (check (match '(1 . 2) (((get! a) . b) (list (a) b))) => '(1 2)
	     ))

      (test-case "test: getter cdr"
      (check (match '(1 . 2) ((a . (get! b)) (list a (b)))) => '(1 2)
	     ))

      (test-case "test: getter vector"
      (check (match '#(1 2 3) (#((get! a) b c) (list (a) b c))) => '(1 2 3)
	     ))

      (test-case "test: setter car"
      (check (let ((x (cons 1 2)))
	       (match x (((set! a) . b) (a 3)))
	       x) => '(3 . 2)
	     ))

      (test-case "test: setter cdr"
      (check (let ((x (cons 1 2)))
	       (match x ((a . (set! b)) (b 3)))
	       x) => '(1 . 3)
	     ))

      (test-case "test: setter vector"
      (check (let ((x (vector 1 2 3)))
	       (match x (#(a (set! b) c) (b 0)))
	       x) => '#(1 0 3)
	     ))

      (test-case "test: single tail"
      (check (match '((a . 1) (b . 2) (c . 3))
		    (((x . y) ... last) (list x y last))) => '((a b) (1 2) (c . 3))
	     ))

      (test-case "test: single tail 2"
      (check (match '((a . 1) (b . 2) 3)
		    (((x . y) ... last) (list x y last))) => '((a b) (1 2) 3)
	     ))

      (test-case "test: single duplicate tail" 
	    (check (match '(1 2) ((foo ... foo) foo) (_ #f)) => #f
	    ))

      (test-case "test: multiple tail"
      (check (match '((a . 1) (b . 2) (c . 3) (d . 4) (e . 5))
		    (((x . y) ... u v w) (list x y u v w))) => '((a b) (1 2) (c . 3) (d . 4) (e . 5))
	     ))

      (test-case "test: tail against improper list"
      (check (match '(a b c d e f . g)
		    ((x ... y u v w) (list x y u v w))
		    (else #f)) => #f
	     ))

      (test-case "test: Riastradh quasiquote"
      (check (match '(1 2 3) (`(1 ,b ,c) (list b c))) => '(2 3)
	     ))

      (test-case "test: unquote-splicing"
      (check (match '(1 2 3) (`(1 ,@ls) ls)) => '(2 3)
	     ))

      (test-case "test: unquote-splicing tail"
      (check (match '(a b c d) (`(a ,@ls d) ls)) => '(b c)
	     ))

      (test-case "test: unquote-splicing tail fail"
      (check (match '(a b c e) (`(a ,@ls d) ls) (else #f)) => #f
	     ))

      (test-case "test: trivial tree search"
      (check (match '(1 2 3) ((_ *** (a b c)) (list a b c))) => '(1 2 3)
	     ))

      (test-case "test: simple tree search"
      (check (match '(x (1 2 3)) ((_ *** (a b c)) (list a b c))) => '(1 2 3)
	     ))

      (test-case "test: deep tree search"
      (check (match '(x (x (x (1 2 3)))) ((_ *** (a b c)) (list a b c))) => '(1 2 3)
	     ))

      (test-case "test: non-tail tree search"
      (check (match '(x (x (x a b c (1 2 3) d e f))) ((_ *** (a b c)) (list a b c))) => '(1 2 3)
	     ))

      (test-case "test: restricted tree search"
      (check (match '(x (x (x a b c (1 2 3) d e f))) (('x *** (a b c)) (list a b c))) => '(1 2 3)
	     ))

      (test-case "test: fail restricted tree search"
      (check (match '(x (y (x a b c (1 2 3) d e f)))
		    (('x *** (a b c)) (list a b c))
		    (else #f)) => #f
	     ))

      (test-case "test: sxml tree search"
      (check (match '(p (ul (li a (b c) (a (@ (href . "http://synthcode.com/"))
					   "synthcode") d e f)))
		    (((or 'p 'ul 'li 'b) *** ('a ('@ attrs ...) text ...))
		     (list attrs text))
		    (else #f)) => '(((href . "http://synthcode.com/")) ("synthcode"))
	     ))

      (test-case "test: failed sxml tree search"
      (check (match '(p (ol (li a (b c) (a (@ (href . "http://synthcode.com/"))
					   "synthcode") d e f)))
		    (((or 'p 'ul 'li 'b) *** ('a ('@ attrs ...) text ...))
		     (list attrs text))
		    (else #f)) => #f
	     ))

      (test-case "test: collect tree search"
      (check (match '(p (ul (li a (b c) (a (@ (href . "http://synthcode.com/"))
					   "synthcode") d e f)))
		    (((and tag (or 'p 'ul 'li 'b)) *** ('a ('@ attrs ...) text ...))
		     (list tag attrs text))
		    (else #f)) => '((p ul li) ((href . "http://synthcode.com/")) ("synthcode"))
	     ))

      (test-case "test: anded tail pattern"
      (check (match '(1 2 3) ((and (a ... b) x) a)) => '(1 2)
	     ))

      (test-case "test: anded search pattern"
      (check (match '(a (b (c d))) ((and (p *** 'd) x) p)) => '(a b c)
	     ))

      (test-case "test: joined tail"
      (check (match '(1 2 3) ((and (a ... b) x) a)) => '(1 2)
	     ))

      (test-case "test: list **1"
      (check (match '(a b c) ((x **1) x)) => '(a b c)
	     ))

      (test-case "test: list **1 failed"
      (check (match '()
		    ((x **1) x)
		    (else #f)) => #f
	     ))

      (test-case "test: list **1 with predicate"
      (check (match '(a b c)
		    (((and x (? symbol?)) **1) x)) => '(a b c)
	     ))

      (test-case "test: list **1 with failed predicate"
      (check (match '(a b 3)
		    (((and x (? symbol?)) **1) x)
		    (else #f)) => #f
	     ))

      (test-case "test: list =.. too few"
      (check (match (list 1 2) ((a b =.. 2) b) (else #f)) => #f
	     ))
      (test-case "test: list =.."
      (check (match (list 1 2 3) ((a b =.. 2) b) (else #f)) => '(2 3)
	     ))
      (test-case "test: list =.. too many"
      (check (match (list 1 2 3 4) ((a b =.. 2) b) (else #f)) => #f
	     ))
      (test-case "test: list =.. tail"
      (check (match (list 1 2 3 4) ((a b =.. 2 c) c) (else #f)) => 4
	     ))
      (test-case "test: list =.. tail fail"
      (check (match (list 1 2 3 4 5 6) ((a b =.. 2 c) c) (else #f)) => #f
	     ))

      (test-case "test: list *.. too few"
      (check (match (list 1 2) ((a b *.. 2 4) b) (else #f)) => #f
	     ))
      (test-case "test: list *.. lo"
      (check (match (list 1 2 3) ((a b *.. 2 4) b) (else #f)) => '(2 3)
	     ))
      (test-case "test: list *.. hi"
      (check (match (list 1 2 3 4 5) ((a b *.. 2 4) b) (else #f)) => '(2 3 4 5)
	     ))
      (test-case "test: list *.. too many"
      (check (match (list 1 2 3 4 5 6) ((a b *.. 2 4) b) (else #f)) => #f
	     ))
      (test-case "test: list *.. tail"
      (check (match (list 1 2 3 4) ((a b *.. 2 4 c) c) (else #f)) => 4
	     ))
      (test-case "test: list *.. tail 2"
      (check (match (list 1 2 3 4 5) ((a b *.. 2 4 c d) d) (else #f)) => 5
	     ))
      (test-case "test: list *.. tail"
      (check (match (list 1 2 3 4 5 6) ((a b *.. 2 4 c) c) (else #f)) => 6
	     ))
      (test-case "test: list *.. tail fail"
      (check (match (list 1 2 3 4 5 6 7) ((a b *.. 2 4 c) c) (else #f)) => #f
	     ))

      (test-case "test: match-named-let"
      (check (match-let loop (((x . rest) '(1 2 3))
			      (sum 0))
			(let ((sum (+ x sum)))
			  (if (null? rest)
			      sum
			      (loop rest sum)))) => 6
	     ))

      (test-case "match-letrec" 
	     (check (match-letrec (((x y) (list 1 (lambda () (list a x))))
				   ((a b) (list 2 (lambda () (list x a)))))
				  (append (y) (b))) => '(2 1 1 2)))

      (test-case "test: match-letrec quote"
        (check (match-letrec (((x 'x) (list #t 'x))) x) =>  #t))
      
      '(test-case "test: match-letrec mnieper" 
		 (let-syntax
        ((foo
          (syntax-rules ()
            ((foo x)
             (match-letrec (((x y) (list 1 (lambda () (list a x))))
                            ((a b) (list 2 (lambda () (list x a)))))
                           (append (y) (b)))))))
        (check (foo a) => '(2 1 1 2))))

	  (test-case "record positional"
		(check
		  (match (make-point 0 1)
		       (($ Point x y) (list y x))) => '(1 0)))
	  (test-case "record named"
		(check
		  (match (make-point 0 1)
		       ((@ Point (x x) (y y)) (list y x))) => '(1 0))))
      )
(run-test-suite! gerbil-tests)
(test-report-summary!)
