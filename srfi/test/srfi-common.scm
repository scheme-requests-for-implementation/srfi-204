(test-begin (string-append test-name scheme-version-name))
(test-equal "Introduction" #f (let ((ls (list 1 2 3)))
				(match ls
				       ((1 2 3) #t))))

(test-equal "Literal Patterns" '(ok ok)
	    (let ((ls (list 'a "b" #f 2 '() #\c #(1))))
	      (list (match ls (('a "b" #f 2 () #\c #(1)) 'ok))
		    (match ls (`(a "b" #f 2 () #\c #(1)) 'ok)))))

(test-equal "Simple Variable" 2 (match (list 1 2 3) ((a b c) b)))
(test-equal "Throwaway Variable" 2 (match (list 1 2 3) ((_ b _) b)))
(test-equal "Quasi-quote variable fail"
	    fail
	    (match (list 1 2 3) (`(a ,b c) b) (_ 'fail)))
(test-equal "Quasi-quote variable pass"
	    2
	    (match (list 1 2 3) (`(1 ,b ,_) b) (_ 'fail)))

(if (not non-linear-pattern) (test-skip 4))
(test-equal "repeated pattern" A (match (list A B A) ((a b a) a)))
(test-equal "quasi-quote fail repeated pattern" 
	    fail
	    (match (list A B A) (`(,a b ,a) a) (_ 'fail)))
(test-equal "quasi-quote repeated pattern 1"
	    A
	    (match (list A B A) (`(,a B ,a) a) (_ 'fail)))
(test-equal "quasi-quote repeated pattern 2"
	    A
	    (match (list A B A) (`(,a ,b ,a) a) (_ 'fail)))

(if non-linear-pattern (test-skip 4))
(test-error "error repeated pattern" A (match (list A B A) ((a b a) a)))
(test-error "error quasi-quote fail repeated pattern" 
	    #t
	    (match (list A B A) (`(,a b ,a) a) (_ 'fail)))
(test-error "error quasi-quote repeated pattern 1"
	    #t
	    (match (list A B A) (`(,a B ,a) a) (_ 'fail)))
(test-error "error quasi-quote repeated pattern 2"
	    #t
	    (match (list A B A) (`(,a ,b ,a) a) (_ 'fail)))

(test-eqv "repeated pattern->failure"
	 1
	 (match (list 1 2 1) 
		((a b c) (=> fail) (if (equal? a c) a (fail)))
		(_ 'fail)))

(test-equal "empty ellipsis match"
	    #t
	    (match (list 1 2) ((1 2 3 ...) #t)))
(test-equal "empty quasi-quote splicing match"
	    #t
	    (match (list 1 2) (`(1 2 ,@3) #t)))
(test-equal "single ellipsis match"
	    #t
	    (match (list 1 2 3) ((1 2 3 ...) #t)))
(test-equal "single quasi-quote splicing match"
	    #t 
	    (match (list 1 2 3) (`(1 2 ,@3) #t)))
(test-equal "triple ellipsis match"
	    #t
	    (match (list 1 2 3 3 3) ((1 2 3 ...) #t)))
(test-equal "triple quasi-quote splicing match"
	    #t
	    (match (list 1 2 3 3 3) (`(1 2 ,@3) #t)))

(test-equal "subexpression ellipsis match"
	    ((a stitch in) (time saves nine))
	    (match '((a time) (stitch saves) (in nine)) (((x y) ...) (list x y))))

(test-equal "subexpression quasi-quote splicing match"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f)) (`(,@(x y)) (list x y))))

(let ()
  (define transpose
    (match-lambda (((a b ...) ...) (cons a (transpose b))) (_ '())))

  (test-equal "double ellipsis match"
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
		       ((a b ... a) (loop b))
		       (_ #f))))
	    (lambda (str)
	      (let loop ((chars (filter char-alphabetic?
					(string->list (string-foldcase str)))))
		(match chars
		       (() #t)
		       ((a) #t)
		       ((a b ... c) (if (eqv? a c) (loop b) #f))
		       (_ #f)))))))

(test-equal "middle ellipsis" #t (palindrome? "Able was I, ere I saw Elba."))
(test-equal "middle ellipsis fail"
	    #f
	    (palindrome? "Napoleon")))

(let ()
  (define first-column
    (match-lambda (((a _ ...) ...) a)))

  (test-equal "underscore ellipsis"
	      '(1 4 7)
	      (first-column '((1 2 3) (4 5 6) (7 8 9)))))

(test-error "**1 error" #t (match (list 1 2) ((a b c **1) c)))
(test-equal "**1 match" '(3) (match (list 1 2 3) ((a b c **1) c)))

(let ()
  (define first-column-of-some
  (match-lambda (`(,@(a _ **1)) a))))

(test-error "quasi-quote unquote-splicing **1 error"
	    #f
	    (first-column-of-some '((1) (2))))

(test-equal "quasi-quote unquote-splicing **1 match"
	    '(1 3)
	    (first-column-of-some '((1 2) (3 4))))

(test-equal "=.. match"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f))
		   (((x y) =.. 3) (list x y))
		   (_ 'fail)))

(test-equal "=.. fail"
	    fail
	    (match '((a b) (c d) (e f) (g h))
		   (((x y) =.. 3) (list x y))
		   (_ 'fail)))

(test-equal "*.. 2 4 match 3"
	    '((a c e) (b d f))
	    (match '((a b) (c d) (e f))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(test-equal "*.. 2 4 match 4"
	    '((a c e g) (b d f h))
	    (match '((a b) (c d) (e f) (g h))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(test-equal "*.. 2 4 fail hi"
	    fail
	    (match '((a b) (c d) (e f) (g h) (i j))
		   (((x y) *.. 2 4) (list x y))
		   (_ 'fail)))

(let ()
  (define keys
	   (match-lambda (((a _ ...) ...)) (_ 'fail)))

  (test-equal "... proper list match" (a b c) (keys '((a 1) (b 2) (c 3))))
  (test-equal "... dotted-pair fail" fail (keys '((a . 1) (b . 2) (c . 3)))))

(let ()
  (define keys
    (match-lambda (((a . _) ...)) (_ 'fail)))

  (test-equal "tail pattern proper list match"
	      '(a b c)
	      (keys '((a 1) (b 2) (c 3))))
  (test-equal "tail pattern dotted-pair match"
	      '(a b c)
	      (keys '((a . 1) (b . 2) (c . 3)))))

(test-equal "tree match for path"
	    '(+ * +)
	    (match '(+ (* (+ 7 2) (/ 5 4)) (sqrt (+ (sqr x) (sqr y))))
		   ((a *** 7) a)))

(test-equal "underscore tree match for destination"
	    '((+ (sqr x) (sqr y)))
	    (match '(+ (* (+ 7 2) (/ 5 4)) (sqrt (+ (sqr x) (sqr y))))
		   ((_ *** `(sqrt . ,rest)) rest)))
	
(test-equal "empty and match" #t (match 1 ((and) #t)))
(test-equal "and identifier match" 1 (match 1 ((and x) x)))
(test-equal "and identifier matching literal match" 1 (match 1 ((and x 1) x)))
(test-equal "and false match" #t (match #f ((and) #t) (_ #f)))
(test-equal "and false catch via failure"
	    #f
	    (match #f ((and x) (=> fail) (if x #t (fail))) (_ #f)))
(test-equal "empty or fail" #f (match 1 ((or) #t) (else #f)))
(test-equal "or identifier match" 1 (match 1 ((or x) x)))
(test-equal "or identifier mis-matched literal match" 1 (match 1 ((or x 2) x)))

(let ((last-matches-one-of-first-three
	(if non-linear-pattern
	    (match-lambda ((a a) #t)
			  ((a b c ... (or a b)) #t)
			  ((a b c d ... c) #t)
			  (_ #f))

	    (match-lambda ((a a) #t)
			  ((a b c ... d)
			   (=> fail)
			   (if (or (equal? d a) (equal? d b))
			       #t
			       (fail)))
			  ((a b c d ... e) (equal? c e))
			  (_ #f)))))
  (test-equal "or pattern with repetition"
	      #t
	      (last-matches-one-of-first-three '(1 2 3 4 5 2))))


(test-equal "not #f match" 1 (match 1 ((and x (not #f)) x) (_ 'fail)))
(test-equal "not #f fail" fail (match #f ((and x (not #f)) x) (_ 'fail)))
(test-equal "not match" #t (match 1 ((not 2) #t)))

(test-equal "predicate match" 1 (match 1 ((? odd? x) x)))

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
		  (_ (error "not implemented yet"))))

  (test-equal "quasi-quoted dotted pair/pred/boolean sexpr eval"
	      67 
	      (eval-sexpr '(+ (* 3 4 5) (- 10 3)))))

(if non-linear-pred
    (let ((fibby?
	    (match-lambda ((a b (? (lambda (x) (= (+ a b) x)) c) . rest)
			   (fibby? (cons b (cons c rest))))
			  ((a b) #t)
			  ((a) #t)
			  (() #t)
			  (_ #f))))

      (test-equal "non-linear pred match" #t (fibby? '(4 7 11 18 29 47))))
    (test-error "error non-linear pred"
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

  (test-equal "pred catch repetition in body match"
	      #t
	      (fibby? '(4 7 11 18 29 47))))

(test-equal "pred false fail" fail (match 1 ((and n (? even?)) n) (_ 'fail)))
(test-equal "field false match"
	    '(1 #f)
	    (match 1 ((and n (= even? r)) (list n r)) (_ 'fail)))
(test-equal "field #f bad match"
	    #f
	    (match '(a b c d) ((or (= (lambda (x) (memq 'f x)) r)
				   (= (lambda (x) (memq 'g x)) r)
				   (= (lambda (x) (memq 'b x)) r))
			       r)
		   (_ 'fail)))

(test-equal "field (not #f) good match"
	    '(b c d)
	    (match '(a b c d) ((or (= (lambda (x) (memq 'f x)) (and r (not #f)))
				   (= (lambda (x) (memq 'g x)) (and r (not #f)))
				   (= (lambda (x) (memq 'b x)) (and r (not #f))))
			       r)
		   (_ 'fail)))

(test-equal "field car" 1 (match '(1 . 2) ((= car x) x)))
(test-equal "field N->N proc" 16 (match 4 ((= square x) x)))

(let ((x (cons 1 2)))
  (test-equal "list setter test" (1 . 3)   (match x ((1 . (set! s)) (s 3) x))))
(test-equal "list getter test" 2 (match '(1 . 2) ((1 . (get! g)) (g))))

(let () (define alist (list (cons 'a 1) (cons 'b 2) (cons 'c 3)))

  (define get-c (match alist ((= (lambda (al) (assv 'c al))
				 (_ . (get! g)))
			      g)))
  (define set-c! (match alist ((= (lambda (al) (assv 'c al))
				  (_ . (set! s)))
			       s)))
  (test-equal "alist get value" 3 (get-c))
  (set-c! 7)
  (test-equal "alist get value after set" 7 (get-c))
  (test-equal "alist get list after set" '((a . 1) (b . 2) (c . 7)) alist))

(let ()
  (cond-expand
    ((or r7rs (not r6rs))
     (define-record-type employee
       (make-employee name title)
       employee?
       (name get-name)
       (title get-title)))
    (else
      (define-record-type employee (fields name title))))
  (if (not record-implemented) (test-skip 2))
  (test-equal "posistional record"
	      ("Doctor" "Bob")
	      (match (make-employee "Bob" "Doctor")
		     (($ employee n t) (list t n))))

  (test-equal "named record"
	      ("Doctor" "Bob")
	      (match (make-employee "Bob" "Doctor")
		     ((object employee (title t) (name n)) (list t n))))

(test-equal "record emulation via pred/field"
	    ("Doctor" "Bob")
	    (match (make-employee "Bob" "Doctor")
		   ((and (? employee?)
			 (= get-title t)
			 (= get-name n))
		    (list t n)))))

(let () (define-record-type posn
	  (make-posn x y)
	  posn?
	  (x posn-x set-posn-x!)
	  (y posn-y set-posn-y!))
  
  (if (not record-implemented) (test-skip 1))
  (test-equal "record setter"
	      (7 4)
	      (match (make-posn 3 4)
		     ((and p ($ posn (set! set-x)))
		     (set-x 7)
		     (match p (($ posn x y) (list x y)))))))

(test-equal "simple match" 'ok (match '(1 1 1) ((a =.. 3) 'ok) (_ 'fail)))

(test-equal "simple match + failure fail"
	    'fail
	    (match '(1 1 1)
		   ((a =.. 3) (=> fail)
			      (if (= (car a) 1) (fail) 'ok))
		   (_ 'fail)))
(test-equal "simple match + failure match"
	    'ok
	    (match '(2 1 1)
		   ((a =.. 3) (=> fail)
			      (if (= (car a) 1) (fail) 'ok))
		   (_ 'fail)))


(test-end (string-append test-name scheme-version-name))
