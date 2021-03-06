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

;;; most of false branches were tested with (util match) from
;;; gauche, some syntax differences (no internal ellipses) made
;;; it so I never got a clean run, even using 
;;; test-read-eval-string
(test-begin (string-append test-name "-" scheme-version-name))
(test "Introduction" #t (let ((ls (list 1 2 3)))
				(match ls
				       ((1 2 3) #t))))

;; literal patterns
(test "Literal Patterns" '(ok ok)
	    (let ((ls (list 'a "b" #f 2 '() #\c)))
	      (list (match ls (('a "b" #f 2 () #\c) 'ok))
		    (match ls (`(a "b" #f 2 () #\c) 'ok)))))

(test "Self-evaluating Vector Literal" 'ok (match #(1) (#(1) 'ok)))

;; variable patterns
(test "Simple Variable" 2 (match (list 1 2 3) ((a b c) b)))
(test "Throwaway Variable" 2 (match (list 1 2 3) ((_ b _) b)))
(test "Quasi-quote variable fail"
	    'fail
	    (match (list 1 2 3) (`(a ,b c) b) (_ 'fail)))
(test "Quasi-quote variable pass"
	    2
	    (match (list 1 2 3) (`(1 ,b ,_) b) (_ 'fail)))

;; non-linear patterns
#|(if (not non-linear-pattern) (test-skip 4))|#
(test "repeated pattern" 'A (test-read-eval-string "(match (list 'A 'B 'A) ((a b a) a))"))
(test "quasi-quote fail repeated pattern" 
	    'fail
	    (test-read-eval-string "(match (list 'A 'B 'A) (`(,a b ,a) a) (_ 'fail))"))
(test "quasi-quote repeated pattern 1"
	    'A
	    (test-read-eval-string "(match (list 'A 'B 'A) (`(,a B ,a) a) (_ 'fail))"))
(test "quasi-quote repeated pattern 2"
	    'A
	    (test-read-eval-string "(match (list 'A 'B 'A) (`(,a ,b ,a) a) (_ 'fail))"))

#|(if non-linear-pattern (test-skip 4))|#
#|(test-syntax-error "error repeated pattern"
	    #t 
	    (match (list 'A 'B 'A) ((a b a) a)))|#
#|(test-syntax-error "error quasi-quote fail repeated pattern" 
	    #t
	    (match (list 'A 'B 'A) (`(,a b ,a) a) (_ 'fail)))|#
#|(test-syntax-error "error quasi-quote repeated pattern 1"
	    #t
	    (match (list 'A 'B 'A) (`(,a B ,a) a) (_ 'fail)))|#
#|(test-syntax-error "error quasi-quote repeated pattern 2"
	    #t
	    (match (list 'A 'B 'A) (`(,a ,b ,a) a) (_ 'fail)))|#

(test-eqv "repeated pattern->failure"
	 1
	 (match (list 1 2 1) 
		((a b c) (=> fail) (if (equal? a c) a (fail)))
		(_ 'fail)))

;; ellipsis patterns
(test "empty ellipsis match"
	    #t
	    (match (list 1 2) ((1 2 3 ...) #t)))
(test "empty quasi-quote splicing match"
	    #t
	    (match (list 1 2) (`(1 2 ,@3) #t)))
(test "single ellipsis match"
	    #t
	    (match (list 1 2 3) ((1 2 3 ...) #t)))
(test "single quasi-quote splicing match"
	    #t 
	    (match (list 1 2 3) (`(1 2 ,@3) #t)))
(test "triple ellipsis match"
	    #t
	    (match (list 1 2 3 3 3) ((1 2 3 ...) #t)))
(test "triple quasi-quote splicing match"
	    #t
	    (match (list 1 2 3 3 3) (`(1 2 ,@3) #t)))

(test "subexpression ellipsis match"
	    '((a stitch in) (time saves nine))
	    (match '((a time) (stitch saves) (in nine)) (((x y) ...) (list x y))))

(test "subexpression quasi-quote splicing match"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f)) (`(,@(x y)) (list x y))))

(let ()
  (define transpose
    (match-lambda (((a b ...) ...) (cons a (transpose b))) (_ '())))

  (test "double ellipsis match"
	      '((1 4) (2 5) (3 6))
	      (transpose '((1 2 3) (4 5 6)))))

(let ((palindrome? 
	(if non-linear-pattern
	      (lambda (str)
		(let loop ((chars (filter char-alphabetic?
					  (string->list (string-foldcase str)))))
		  (match chars
			 (() #t)
			 ((a) #t)
			 ((a a) #t)
			 ((a b ... a) (loop b))
			 (_ #f))))
	      (lambda (str)
		(let loop ((chars (filter char-alphabetic?
					  (string->list (string-foldcase str)))))
		  (match chars
			 (() #t)
			 ((a) #t)
			 ((a b) (eqv? a b))
			 ((a b ... c) (if (eqv? a c) (loop b) #f))
			 (_ #f)))))))

(test "middle ellipsis" #t (palindrome? "Able was I, ere I saw Elba."))
(test "middle ellipsis fail"
	    #f
	    (palindrome? "Napoleon")))

(let ()
  (define first-column
    (match-lambda (((a _ ...) ...) a)))

  (test "underscore ellipsis"
	      '(1 4 7)
	      (first-column '((1 2 3) (4 5 6) (7 8 9)))))

(test-syntax-error "**1 error" #t (match (list 1 2) ((a b c **1) c)))
(test "**1 match" '(3) (match (list 1 2 3) ((a b c **1) c)))

(let ()
  (define first-column-of-some
  (match-lambda (`(,@(a _ **1)) a)))

(test-syntax-error "quasi-quote unquote-splicing **1 error"
	    #t
	    (first-column-of-some '((1) (2))))

(test "quasi-quote unquote-splicing **1 match"
	    '(1 3)
	    (first-column-of-some '((1 2) (3 4)))))

(test "=.. match"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f))
		   (((x y) =.. 3) (list x y))
		   (_ 'fail)))

(test "=.. fail"
	    'fail
	    (match '((a b) (c d) (e f) (g h))
		   (((x y) =.. 3) (list x y))
		   (_ 'fail)))

(test "*.. 2 4 match 3"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(test "*.. 2 4 match 4"
	    '((a c e g) (b d f h))
	    (match '((a b) (c d) (e f) (g h))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(test "*.. 2 4 fail hi"
	    'fail
	    (match '((a b) (c d) (e f) (g h) (i j))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(let ()
  (define keys
	   (match-lambda (((a _ ...) ...) a) (_ 'fail)))

  (test "... proper list match" '(a b c) (keys '((a 1) (b 2) (c 3))))
  (test "... dotted-pair fail" 'fail (keys '((a . 1) (b . 2) (c . 3)))))

(let ()
  (define keys
    (match-lambda (((a . _) ...) a) (_ 'fail)))

  (test "tail pattern proper list match"
	      '(a b c)
	      (keys '((a 1) (b 2) (c 3))))
  (test "tail pattern dotted-pair match"
	      '(a b c)
	      (keys '((a . 1) (b . 2) (c . 3)))))

(test "tree match for path"
	    '(+ * +)
	    (match '(+ (* (+ 7 2) (/ 5 4)) (sqrt (+ (sqr x) (sqr y))))
		   ((a *** 7) a)))

(test "underscore tree match for destination"
	    '((+ (sqr x) (sqr y)))
	    (match '(+ (* (+ 7 2) (/ 5 4)) (sqrt (+ (sqr x) (sqr y))))
		   ((_ *** `(sqrt . ,rest)) rest)))

(test "extract imports"
	    '(((srfi srfi-204)
		   (srfi srfi-64)
		   (srfi srfi-9)
		   (rnrs unicode))
		  ((gauche base)
		   (scheme base)
		   (scheme char)
		   (scheme cxr)
		   (srfi 204)
		   (srfi 64))
		  ((scheme base)
		   (scheme char)
		   (scheme cxr)
		   (srfi 64)
		   (srfi 115)
		   (only (srfi 1) iota filter))
		  ((srfi 204)))
	    (let ()
	      (define (extract-imports file-name)
		(define extract
		  (match-lambda
		    (((_ *** `(import . ,imports)) . rest)
		     (cons imports (extract rest)))
		    ((this . rest) (extract rest))
		    (() '())))
		(call-with-input-file file-name
				      (lambda (port) (extract (read port)))))
	      (extract-imports "data/srfi-test.scm")))
	
;; boolean operators
;; using (util match) to test false branch, a number of boolean patterns
;; that are OK in (chibi match) gave errors, so did t-r-e-s conversion.
(test "empty and match" #t (match 1 ((and) #t)))
(test "and identifier match" 1 (match 1 ((and x) x)))
(test "and identifier matching literal match" 1 (match 1 ((and x 1) x)))
(test "and false match" #t (match #f ((and) #t) (_ #f)))
(test "and false catch via failure"
	    #f
	    (match #f ((and x) (=> fail) (if x #t (fail))) (_ #f)))
(test "empty or fail" #f (match 1 ((or) #t) (else #f)))
(test "or identifier match" 1 (match 1 ((or x) x)))
(test "or identifier mis-matched literal match" 1 (match 1 ((or x 2) x)))

(let ((last-matches-one-of-first-three
	(if non-linear-pattern
	    (match-lambda ((a a) #t)
			  ((a b c ... (or a b)) #t))

	    (match-lambda ((a b) (equal? a b))
			     ((a b c ... d)
			     ((a b c d ... e) (equal? c e))
			     (_ #f))))))
  (test "or pattern with repetition"
	      #t
	      (last-matches-one-of-first-three '(1 2 3 4 5 2))))

(test-assert "or ellipsis, many undef values"
	     (match (get-environment-variables)
		    (((or ("PATH" . path)
			  ("HOMEPROFILE" . home)
			  ("HOME" . home)
			  ("USER" . user)
			  ("USERNAME" . user)
			  (_ . _)) ...)
		     (list path home user))))

(define check-output
  (match-lambda (((? string?) (or (? string?) #f) (or (? string?) #f))
		 #t)
		(_ #f)))

(test-assert "fold match-lambda* as or ellipsis"
	     (check-output
	       (fold (match-lambda*
		       ((("PATH" . path) (p h u)) (list path h u))
		       ((("USERPROFILE" . home)  (p h u)) (list p home u)) 
		       ((("HOME" . home)  (p h u)) (list p home u))
		       ((("USER" . user)  (p h u))  (list p h user))
		       ((("USERNAME" . user)  (p h u))  (list p h user))
		       ((_ out) out))
		     (list #f #f #f) ; (p h u) init
		     (get-environment-variables))))

(let ()
  (define (clean lst)
  (let ((undef (when #f #f)))
    (remove (lambda (item) (equal? item undef)) lst)))
  (test "mostly defined or ellipsis"
	      (list 0 1 3 4 5)
	      (match (iota 7)
		     (((or 2 6 rest) ...) (clean rest)))))

(test "not #f match" 1 (match 1 ((and x (not #f)) x) (_ 'fail)))
(test "not #f fail" 'fail (match #f ((and x (not #f)) x) (_ 'fail)))
(test "not match" #t (match 1 ((not 2) #t)))

;; predicate and field operators
(test "predicate match" 1 (match 1 ((? odd? x) x)))

(let ()
  (define handle-arithmetic-sexpr
    (match-lambda (`(+ . ,operands) (apply + (map eval-sexpr operands)))
		  (`(- . ,operands) (apply - (map eval-sexpr operands)))
		  (`(* . ,operands) (apply * (map eval-sexpr operands)))
		  (`(/ . ,operands) (apply / (map eval-sexpr operands)))))
  (define eval-sexpr
    (match-lambda ((? number? n) n)
		  ((and pair ((or '+ '- '* '/) . rest))
		   (handle-arithmetic-sexpr pair))
		  (any (error #f "not implemented yet" any))))

  (test "quasi-quoted dotted pair/pred/boolean sexpr eval"
	      67 
	      (eval-sexpr '(+ (* 3 4 5) (- 10 3)))))

(if non-linear-pred
    (letrec ((fibby?  (match-lambda ((a b (? (lambda (x) (= (+ a b) x)) c) . rest)
					(fibby? (cons b (cons c rest))))
      ((a b) #t)
      ((a) #t)
      (() #t)
      (_ #f))))

	 (test "non-linear pred match" #t (fibby? '(4 7 11 18 29 47))))
    (test-syntax-error "error non-linear pred"
		#t
		(match '(1 2 3) ((a b (? (lambda (x) (= (+ a b))))) #t)
					       (_ #f))))

(let ()
  (define fibby?
    (match-lambda ((a b c . rest)
		   (if (= (+ a b) c)
		       (fibby? (cons b (cons c rest)))
		       #f))
		  ((a b) #t)
		  ((a) #t)
		  (() #t)
		  (_ #f)))

  (test "pred catch repetition in body match"
	      #t
	      (fibby? '(4 7 11 18 29 47))))

(test "pred false fail" 'fail (match 1 ((and n (? even?)) n) (_ 'fail)))
(test "field false match"
	    '(1 #f)
	    (match 1 ((and n (= even? r)) (list n r)) (_ 'fail)))
(test "field #f bad match"
	    #f
	    (match '(a b c d) ((or (= (lambda (x) (memq 'f x)) r)
				   (= (lambda (x) (memq 'g x)) r)
				   (= (lambda (x) (memq 'b x)) r))
			       r)
		   (_ 'fail)))

(test "field (not #f) good match"
	    '(b c d)
	    (match '(a b c d) ((or (= (lambda (x) (memq 'f x)) (and r (not #f)))
				   (= (lambda (x) (memq 'g x)) (and r (not #f)))
				   (= (lambda (x) (memq 'b x)) (and r (not #f))))
			       r)
		   (_ 'fail)))

(test "field car" 1 (match '(1 . 2) ((= car x) x)))
(let ()
  (define (square x) (* x x))
  (test "field N->N proc" 16 (match 4 ((= square x) x))))

(let ((x (cons 1 2)))
  (test "list setter test" '(1 . 3)   (match x ((1 . (set! s)) (s 3) x))))
(test "list getter test" 2 (match '(1 . 2) ((1 . (get! g)) (g))))

(let () (define alist (list (cons 'a 1) (cons 'b 2) (cons 'c 3)))

  (define get-c (match alist ((= (lambda (al) (assv 'c al))
				 (_ . (get! g)))
			      g)))
  (define set-c! (match alist ((= (lambda (al) (assv 'c al))
				  (_ . (set! s)))
			       s)))
  (test "alist get value" 3 (get-c))
  (set-c! 7)
  (test "alist get value after set" 7 (get-c))
  (test "alist get list after set" '((a . 1) (b . 2) (c . 7)) alist))

;; record operators
(let ()
  (cond-expand
    ((or r7rs (not r6rs))
     (define-record-type employee
       (make-employee name title)
       employee?
       (name employee-name)
       (title employee-title)))
    (else
      (define-record-type employee (fields name title))))
  #|(if (not record-implemented) (test-skip 2))|#
  (test "posistional record"
	      (list "Doctor" "Bob")
	      (match (make-employee "Bob" "Doctor")
		     (($ employee n t) (list t n))))

  (test "named record"
	      (list "Doctor" "Bob")
	      (match (make-employee "Bob" "Doctor")
		     ((object employee (title t) (name n)) (list t n))))

(test "record emulation via pred/field"
	    (list "Doctor" "Bob")
	    (match (make-employee "Bob" "Doctor")
		   ((and (? employee?)
			 (= employee-title t)
			 (= employee-name n))
		    (list t n)))))

(let () (cond-expand
  ((or r7rs (not r6rs))
   (define-record-type posn
	  (make-posn x y)
	  posn?
	  (x posn-x set-posn-x!)
	  (y posn-y set-posn-y!)))
  (else (define-record-type posn (fields (mutable x) (mutable y)))))
  
  #|(if (not record-implemented) (test-skip 1))|#
  (test "record setter"
	      (list 7 4)
	      (match (make-posn 3 4)
		     ((and p ($ posn (set! set-x)))
		     (set-x 7)
		     (match p (($ posn x y) (list x y)))))))

(cond-expand
  ((not larceny) ;; larceny has issues with srfi 26
   (let ()
     (cond-expand
       ((or r7rs (not r6rs))
	(define-record-type box-type
	  (box value)
	  box?
	  (value unbox set-box!)))
       (else (define-record-type (box-type box box?)
	       (fields (mutable value unbox set-box!)))))
     (define (box-equal? a b)
       (if (and (box? a) (box? b))
	   (box-equal? (unbox a) (unbox b))
	   (equal? a b)))
     (define-values (get-value set-value!)
       (match (box 1)
	      ((and (= (lambda (box) (cut unbox box)) get)
		    (= (lambda (box) (cut set-box! box <>)) set))
	       (values get set))))
     (test-assert "boxes not eqv" (not (eqv? (box 1) (box 1))))
     (test "non-linear equality predicate"
		 'ok
		 (match (list (box 1) (box 1))
			((a (? (cut box-equal? a <>))) 'ok)
			(_ 'fail)))
     (test "equality predicate in body"
		 'ok
		 (match (list (box 1) (box 1))
			((a b) (if (box-equal? a b) 'ok 'fail))))
     (test "box value via field"
		 1
		 (match (box 1) ((= unbox value) value)))
     (test "getter via field" 1 (get-value))
     (set-value! 18)
     (test "setter via field" 18 (get-value))))
  (else))

;; match/match-lambda(*)/match-let (*)/match-letrec
(test "simple match" 'ok (match '(1 1 1) ((a =.. 3) 'ok) (_ 'fail)))

(test "simple match + failure fail"
	    'fail
	    (match '(1 1 1)
		   ((a =.. 3) (=> fail)
			      (if (= (car a) 1) (fail) 'ok))
		   (_ 'fail)))
(test "simple match + failure match"
	    'ok
	    (match '(2 1 1)
		   ((a =.. 3) (=> fail)
			      (if (= (car a) 1) (fail) 'ok))
		   (_ 'fail)))

(let ()
  (cond-expand
    ((or r7rs (not r6rs))
     (define-record-type checkable
       (make-checkable pred value)
       checkable?
       (pred checkable-pred)
       (value checkable-value)))
    (else (define-record-type checkable (fields pred value))))
  (define check (if non-linear-pred
		    (match-lambda (($ checkable pred (? pred ok)) ok) (($ checkable) 'bad-data))
		    (lambda arg #f)))

  #|(if (or (not non-linear-pred) (not record-implemented)) (test-skip 2))|#
  (test "match-lambda non-linear pred match"
	1
	(check (make-checkable odd? 1)))
  (test "match-lambda non-linear pred fail"
	'bad-data
	(check (make-checkable odd? 2))))

#|(if (not non-linear-field) (test-skip 1))|#
(let ((zero-to-three-cycle (if non-linear-field
			       (match-lambda ((and c (= car c)) 0)
					     ((and c (= cdr c)) 1)
					     ((and c (= cddr c)) 2)
					     ((and c (= cdddr c)) 3)
					     (_ 'fail))
			       (lambda arg #f))))

  (define l3 (list 1 2 3))
  (set-cdr! (cddr l3) l3)
  (test "match-lambda/non-linear field"
	      3
	      (zero-to-three-cycle l3) ))
#|(if non-linear-field (test-skip 1))|#
#|(test-syntax-error "error repeated pattern in field"
	    #t
	    (match '((1 2) 1) ((a (= car a)) 'ok) (_ 'fail)))|#

(let ()
  (define multiples-of-seven?
    (match-lambda* (((? (lambda (x) (zero? (modulo x 7)))) . rest)
		    (apply multiples-of-seven? rest))
		   (() #t)
		   (_ #f)))

  (test "match-lambda*/lambda pred/tail"
	      #t
	      (multiples-of-seven? 7 14 49 28 56 77) ))

(let ()
  (define (fact n)
    (if (zero? n)
	1
	(match-let loop (((a . rest) (cdr (iota (+ n 1))))
			 (out 1))
		   (if (null? rest) (* a out) (loop rest (* a out))))))
  
  (test "match-named-let/tail"
	      39916800
	      (fact 11))
  (test "match-named-let/tail catch exceptional value"
	      1
	      (fact 0)))

;; error conditions
(test-syntax-error "error missing match expression" #t (match))
(test-syntax-error "error no match clauses" #t (match (list 1 2 3)))
(test-syntax-error "error no matching pattern" #t (match (list 1 2 3) ((a b))))
(test-syntax-error "error invalid use of ***" #t (match (list 1 2 3) ((a *** . 3) a)))
(test-syntax-error "error multiple ellipsis patterns at same level"
	    #t
	    (match '(1 1 1 2 2 2) ((a ... b ...) b)))
(test-syntax-error "error ellipsis + =.. at same level"
	    #t
	    (match '(1 1 1 2 2 2) ((a =.. 3 b ...) b)))
(test-syntax-error "error ellipsis + ,@ at same level"
	    #t
	    (match '(1 1 1 2 2 2) (`(,@a ,b ...) b)))
(test-syntax-error "error dotted tail not allowed after ellipsis"
	    #t
	    (match '(1 1 1 2 2 2) (`(,@a . b) a)))

(define message
"match w/o body screen (3 possibilities):
  undefined value
  last value
  error
  
  whichever passes is the behavior of this implementation.")
(display message)
(newline)
(test "match w/o body has undefined value" 
	    (if #f #t)
	    (match (list 1 2) ((a b))))

(test "match w/o body has last value" 
	    2
	    (match (list 1 2) ((a b))))

(test-syntax-error "match w/o body causes error" 
	    #t
	    (match (list 1 2) ((a b))))

(test-syntax-error "error match-let w/o body, let requires body"
	    #t
	    (match-let (((a b) (list 1 2)))))

(test-syntax-error "error match-lambda w/o body, lambda requires body"
	    #t
	    (match-let (((a b) (list 1 2)))))

(let ()
  (define-syntax make-chunker
    (syntax-rules ()
      ((_ s ...)
       (lambda (l)
	 (let lp ((l l))
	   (match l (() '())
		  ((s ... . rest) (cons (list s ...) (lp rest)))
		  (end (list end))))))))

  (test "match macro, no name clash"
	      '((0 1 2 3) (4 5 6 7) (8 9 10 11) (12 13 14 15) (16 17 18 19))
	      ((make-chunker a b c d) (iota 20)))

  (test-syntax-error "error match macro _ name clash"
	      #t
	      ((make-chunker a b c _) (iota 20)))

  (test-syntax-error "error match macro ___ name clash"
	      #t
	      ((make-chunker a b c ___) (iota 20))))

(test-end)
