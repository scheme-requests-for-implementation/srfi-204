;; Copyright (C) Felix Thibault (2020).  All Rights Reserved.

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice (including
;; the next paragraph) shall be included in all copies or substantial
;; portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

(cond-expand
  ((or unsyntax (and r6rs (not r7rs)))
    (define-record-type (Point make-point point?) (fields (mutable x) (mutable y))))
  (else
    (define-record-type Point
      (make-point x y)
      point?
      (x point-x point-x-set!)
      (y point-y point-y-set!))))

(test-begin test-name)
;;;log version
(test-equal scheme-version-name 1 1)

(test-equal "any" 'ok (match 'any (_ 'ok)))
(test-equal "symbol" 'ok (match 'ok (x x)))
(test-equal "number" 'ok (match 28 (28 'ok)))
(test-equal "string" 'ok (match "good" ("bad" 'fail) ("good" 'ok)))
(test-equal "literal symbol" 'ok (match 'good ('bad 'fail) ('good 'ok)))
(test-equal "null" 'ok (match '() (() 'ok)))
(test-equal "pair" 'ok (match '(ok) ((x) x)))
(test-equal "vector" 'ok (match '#(ok) (#(x) x)))
(test-equal "any doubled" 'ok (match '(1 2) ((_ _) 'ok)))
(test-equal "and empty" 'ok (match '(o k) ((and) 'ok)))
(test-equal "and single" 'ok (match 'ok ((and x) x)))
(test-equal "and double" 'ok (match 'ok ((and (? symbol?) y) 'ok)))
(test-equal "or empty" 'ok (match '(o k) ((or) 'fail) (else 'ok)))
(test-equal "or single" 'ok (match 'ok ((or x) 'ok)))
(test-equal "or double" 'ok (match 'ok ((or (? symbol? y) y) y)))
(test-equal "or unbalanced" 1  (match 1 ((or (and 1 x) (and 2 y)) x)))
(test-equal "not" 'ok (match 28 ((not (a . b)) 'ok)))
(test-equal "pred" 'ok (match 28 ((? number?) 'ok)))
(test-equal "named pred" 29 (match 28 ((? number? x) (+ x 1))))

(test-equal "duplicate symbols pass" 'ok (match '(ok . ok) ((x . x) x)))
(test-equal "duplicate symbols fail" 'ok
	    (match '(ok . bad) ((x . x) 'bad) (else 'ok)))
(test-equal "duplicate symbols fail 2" 'ok
      (match '(ok bad) ((x x) 'bad) (else 'ok)))
(test-equal "duplicate symbols samth" 'ok
	    (match '(ok . ok) ((x . 'bad) x) (('ok . x) x)))
(test-equal "duplicate symbols bound" 3
	    (let ((a '(1 2))) (match a ((and (a 2) (1 b)) (+ a b)) (_ #f))))
(test-equal "duplicate quasiquote" 'ok
	    (match '(a b) ((or `(a ,x) `(,x b)) 'ok) (_ #f)))

(test-equal "ellipses" '((a b c) (1 2 3))
	    (match '((a . 1) (b . 2) (c . 3))
		   (((x . y) ___) (list x y))))

(test-equal "real ellipses" '((a b c) (1 2 3))
	    (match '((a . 1) (b . 2) (c . 3))
		   (((x . y) ...) (list x y))))

(test-equal "vector ellipses" '(1 2 3 (a b c) (1 2 3))
	    (match '#(1 2 3 (a . 1) (b . 2) (c . 3))
		   (#(a b c (hd . tl) ...) (list a b c hd tl))))

(test-equal "pred ellipses" '(1 2 3)
	    (match '(1 2 3)
		   (((? odd? n) ___) n)
		   (((? number? n) ___) n)))

(test-equal "failure continuation" 'ok
	    (match '(1 2)
		   ((a . b) (=> next) (if (even? a) 'fail (next)))
		   ((a . b) 'ok)))

(test-equal "let" '(o k)
	    (match-let ((x 'ok) (y '(o k))) y))

(test-equal "let*" '(f o o f)
	    (match-let* ((x 'f) (y 'o) ((z w) (list y x))) (list x y z w)))

(test-equal "getter car" '(1 2)
	    (match '(1 . 2) (((get! a) . b) (list (a) b))))

(test-equal "getter cdr" '(1 2)
	    (match '(1 . 2) ((a . (get! b)) (list a (b)))))

(test-equal "getter vector" '(1 2 3)
	    (match '#(1 2 3) (#((get! a) b c) (list (a) b c))))

(test-equal "setter car" '(3 . 2)
	    (let ((x (cons 1 2)))
	      (match x (((set! a) . b) (a 3)))
	      x))

(test-equal "setter cdr" '(1 . 3)
	    (let ((x (cons 1 2)))
	      (match x ((a . (set! b)) (b 3)))
	      x))

(test-equal "setter vector" '#(1 0 3)
	    (let ((x (vector 1 2 3)))
	      (match x (#(a (set! b) c) (b 0)))
	      x))

(test-equal "single tail" '((a b) (1 2) (c . 3))
	    (match '((a . 1) (b . 2) (c . 3))
		   (((x . y) ... last) (list x y last))))

(test-equal "single tail 2" '((a b) (1 2) 3)
	    (match '((a . 1) (b . 2) 3)
		   (((x . y) ... last) (list x y last))))

(test-equal "single duplicate tail" #f
      (match '(1 2) ((foo ... foo) foo) (_ #f)))

(test-equal "multiple tail" '((a b) (1 2) (c . 3) (d . 4) (e . 5))
	    (match '((a . 1) (b . 2) (c . 3) (d . 4) (e . 5))
		   (((x . y) ... u v w) (list x y u v w))))

(test-equal "tail against improper list" #f
	    (match '(a b c d e f . g)
		   ((x ... y u v w) (list x y u v w))
		   (else #f)))

(test-equal "Riastradh quasiquote" '(2 3)
	    (match '(1 2 3) (`(1 ,b ,c) (list b c))))

(test-equal "unquote-splicing" '(2 3)
	    (match '(1 2 3) (`(1 ,@ls) ls)))

(test-equal "unquote-splicing tail" '(b c)
	    (match '(a b c d) (`(a ,@ls d) ls)))

(test-equal "unquote-splicing tail fail" #f
	    (match '(a b c e) (`(a ,@ls d) ls) (else #f)))

(test-equal "trivial tree search" '(1 2 3)
	    (match '(1 2 3) ((_ *** (a b c)) (list a b c))))

(test-equal "simple tree search" '(1 2 3)
	    (match '(x (1 2 3)) ((_ *** (a b c)) (list a b c))))

(test-equal "deep tree search" '(1 2 3)
	    (match '(x (x (x (1 2 3)))) ((_ *** (a b c)) (list a b c))))

(test-equal "non-tail tree search" '(1 2 3)
	    (match '(x (x (x a b c (1 2 3) d e f))) ((_ *** (a b c)) (list a b c))))

(test-equal "restricted tree search" '(1 2 3)
	    (match '(x (x (x a b c (1 2 3) d e f))) (('x *** (a b c)) (list a b c))))

(test-equal "fail restricted tree search" #f
	    (match '(x (y (x a b c (1 2 3) d e f)))
		   (('x *** (a b c)) (list a b c))
		   (else #f)))

(test-equal "sxml tree search"
	    '(((href . "http://synthcode.com/")) ("synthcode"))
	    (match '(p (ul (li a (b c) (a (@ (href . "http://synthcode.com/"))
					  "synthcode") d e f)))
		   (((or 'p 'ul 'li 'b) *** ('a ('@ attrs ...) text ...))
		    (list attrs text))
		   (else #f)))

(test-equal "failed sxml tree search" #f
	    (match '(p (ol (li a (b c) (a (@ (href . "http://synthcode.com/"))
					  "synthcode") d e f)))
		   (((or 'p 'ul 'li 'b) *** ('a ('@ attrs ...) text ...))
		    (list attrs text))
		   (else #f)))

(test-equal "collect tree search"
	    '((p ul li) ((href . "http://synthcode.com/")) ("synthcode"))
	    (match '(p (ul (li a (b c) (a (@ (href . "http://synthcode.com/"))
					  "synthcode") d e f)))
		   (((and tag (or 'p 'ul 'li 'b)) *** ('a ('@ attrs ...) text ...))
		    (list tag attrs text))
		   (else #f)))

(test-equal "anded tail pattern" '(1 2)
	    (match '(1 2 3) ((and (a ... b) x) a)))

(test-equal "anded search pattern" '(a b c)
	    (match '(a (b (c d))) ((and (p *** 'd) x) p)))

(test-equal "joined tail" '(1 2)
	    (match '(1 2 3) ((and (a ... b) x) a)))

(test-equal "list **1" '(a b c)
	    (match '(a b c) ((x **1) x)))

(test-equal "list **1 failed" #f
	    (match '()
		   ((x **1) x)
		   (else #f)))

(test-equal "list **1 with predicate" '(a b c)
	    (match '(a b c)
		   (((and x (? symbol?)) **1) x)))

(test-equal "list **1 with failed predicate" #f
	    (match '(a b 3)
		   (((and x (? symbol?)) **1) x)
		   (else #f)))

(test-equal "list =.. too few" #f
	    (match (list 1 2) ((a b =.. 2) b) (else #f)))
(test-equal "list =.." '(2 3)
	    (match (list 1 2 3) ((a b =.. 2) b) (else #f)))
(test-equal "list =.. too many" #f
	    (match (list 1 2 3 4) ((a b =.. 2) b) (else #f)))
(test-equal "list =.. tail" 4
	    (match (list 1 2 3 4) ((a b =.. 2 c) c) (else #f)))
(test-equal "list =.. tail fail" #f
	    (match (list 1 2 3 4 5 6) ((a b =.. 2 c) c) (else #f)))

(test-equal "list *.. too few" #f
	    (match (list 1 2) ((a b *.. 2 4) b) (else #f)))
(test-equal "list *.. lo" '(2 3)
	    (match (list 1 2 3) ((a b *.. 2 4) b) (else #f)))
(test-equal "list *.. hi" '(2 3 4 5)
	    (match (list 1 2 3 4 5) ((a b *.. 2 4) b) (else #f)))
(test-equal "list *.. too many" #f
	    (match (list 1 2 3 4 5 6) ((a b *.. 2 4) b) (else #f)))
(test-equal "list *.. tail" 4
	    (match (list 1 2 3 4) ((a b *.. 2 4 c) c) (else #f)))
(test-equal "list *.. tail 2" 5
	    (match (list 1 2 3 4 5) ((a b *.. 2 4 c d) d) (else #f)))
(test-equal "list *.. tail" 6
	    (match (list 1 2 3 4 5 6) ((a b *.. 2 4 c) c) (else #f)))
(test-equal "list *.. tail fail" #f
	    (match (list 1 2 3 4 5 6 7) ((a b *.. 2 4 c) c) (else #f)))

(test-equal "match-named-let" 6
	    (match-let loop (((x . rest) '(1 2 3))
			     (sum 0))
		       (let ((sum (+ x sum)))
			 (if (null? rest)
			     sum
			     (loop rest sum)))))

(test-equal "match-letrec" '(2 1 1 2)
	     (match-letrec (((x y) (list 1 (lambda () (list a x))))
			    ((a b) (list 2 (lambda () (list x a)))))
			   (append (y) (b))))

(test-equal "match-letrec quote" #t
      (match-letrec (((x 'x) (list #t 'x))) x))
(let-syntax
  ((foo
     (syntax-rules ()
       ((foo x)
	(match-letrec (((x y) (list 1 (lambda () (list a x))))
		       ((a b) (list 2 (lambda () (list x a)))))
		      (append (y) (b)))))))
  (test-equal "match-letrec mnieper" '(2 1 1 2) (foo a)))

(test-equal "record positional"
	    '(1 0)
	    (match (make-point 0 1)
		   (($ Point x y) (list y x))))
(test-equal "record named"
	    '(1 0)
	    (match (make-point 0 1)
		   ((object Point (x x) (y y)) (list y x))))
(test-equal "setter record positional"
	    '(7 1)
	    (let ((p (make-point 0 1)))
	      (match p
		   ((struct Point (set! x) y) (x 7)))
	      (match-let ((($ Point a b) p))
			 (list a b))))
(test-equal "setter record named"
	    '(7 1)
	    (let ((p (make-point 0 1)))
	      (match p
		   ((object Point (x (set! x))) (x 7)))
	      (match-let (((object Point (x a) (y b)) p))
			 (list a b))))

#;(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro")
				   1
				   (match '(1 1) (((var syn) (var syn)) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var ...  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))
;; for some reason all these tests pass

(test-equal "test var var 2"
	    1
	    (match '(1 1) (((var var) (var var)) var)
		   (_ 'fail)))

#;(test-equal "test var ... 2"
	    1
	    (match '(1 1) (((var ...) (var ...)) ...)
		   (_ 'fail)))

#;(test-equal "test var =.. 2"
	    1
	    (match '(1 1) (((var =..) (var =..)) =..)
		   (_ 'fail)))

#;(test-equal "test var *.. 2"
	    1
	    (match '(1 1) (((var *..) (var *..)) *..)
		   (_ 'fail)))

(test-equal "test var **1 2"
	    1
	    (match '(1 1) (((var **1) (var **1)) **1)
		   (_ 'fail)))

(test-equal "test var _ 2"
	    1
	    (match '(1 1) (((var _) (var _)) _)
		   (_ 'fail)))

(test-equal "test var quote 2"
	    1
	    (match '(1 1) (((var quote) (var quote)) quote)
		   (_ 'fail)))

(test-equal "test var $ 2"
	    1
	    (match '(1 1) (((var $) (var $)) $)
		   (_ 'fail)))

(test-equal "test var struct 2"
	    1
	    (match '(1 1) (((var struct) (var struct)) struct)
		   (_ 'fail)))

(test-equal "test var @ 2"
	    1
	    (match '(1 1) (((var @) (var @)) @)
		   (_ 'fail)))

(test-equal "test var object 2"
	    1
	    (match '(1 1) (((var object) (var object)) object)
		   (_ 'fail)))

(test-equal "test var = 2"
	    1
	    (match '(1 1) (((var =) (var =)) =)
		   (_ 'fail)))

(test-equal "test var and 2"
	    1
	    (match '(1 1) (((var and) (var and)) and)
		   (_ 'fail)))

(test-equal "test var or 2"
	    1
	    (match '(1 1) (((var or) (var or)) or)
		   (_ 'fail)))

(test-equal "test var not 2"
	    1
	    (match '(1 1) (((var not) (var not)) not)
		   (_ 'fail)))

(test-equal "test var ? 2"
	    1
	    (match '(1 1) (((var ?) (var ?)) ?)
		   (_ 'fail)))

(test-equal "test var set! 2"
	    1
	    (match '(1 1) (((var set!) (var set!)) set!)
		   (_ 'fail)))

(test-equal "test var get! 2"
	    1
	    (match '(1 1) (((var get!) (var get!)) get!)
		   (_ 'fail)))

(test-equal "test var quasiquote 2"
	    1
	    (match '(1 1) (((var quasiquote) (var quasiquote)) quasiquote)
		   (_ 'fail)))

#;(test-equal "test var ___ 2"
	    1
	    (match '(1 1) (((var ___) (var ___)) ___)
		   (_ 'fail)))

(test-equal "test var unquote 2"
	    1
	    (match '(1 1) (((var unquote) (var unquote)) unquote)
		   (_ 'fail)))

(test-equal "test var unquote-splicing 2"
	    1
	    (match '(1 1) (((var unquote-splicing) (var unquote-splicing))
			   unquote-splicing)
		   (_ 'fail)))

(test-end test-name)
