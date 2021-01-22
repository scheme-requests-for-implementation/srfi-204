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

(test-begin test-name)
(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with =..")
				   '(1 2 3 4 5)
				   (match '(1 2 3 4 5) (((var syn) =.. 5) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with *..")
				   '(1 2 3 4 5)
				   (match '(1 2 3 4 5) (((var syn) *.. 2 7) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with **1")
				   '(1 2 3 4 5)
				   (match '(1 2 3 4 5) (((var syn) **1) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with _")
				   1
				   (match '(1 2 3 4 5) (((var syn) _ _ _ _) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with quote")
				   1
				   (match '(1 (a b c d))
					  (((var syn) (quote (a b c d))) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(cond-expand
  ((and r6rs (not r7rs))
    (define-record-type (Point make-point point?) (fields (mutable x) (mutable y))))
  (else
    (define-record-type Point
      (make-point x y)
      point?
      (x point-x point-x-set!)
      (y point-y point-y-set!))))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with $")
				   (list 3 4)
				   (match (make-point 3 4)
					  (($ Point (var syn) b) (list syn b))
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with struct")
				   (list 3 4)
				   (match (make-point 3 4)
					  ((struct Point (var syn) b) (list syn b))
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with =")
				   '(b c d)
				   (match '(a b c d)
					  ((= (lambda (x) (memq 'b x)) (var syn))
					   syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with and")
				   1
				   (match '(1 (a b c d))
					  (((and (var syn) 1) (quote (a b c d))) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with or")
				   1
				   (match 1
					  ((or (var syn) 2 3) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with and-not")
				   1
				   (match 1
					  ((and (var syn) (not 2)) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

(let-syntax ((test-var (syntax-rules ()
			 ((test-var syn ...)
			  (begin (test-equal
				   (string-append "var " (symbol->string 'syn) " in macro with ?")
				   '(a b c d)
				   (match '(a b c d)
					  ((? pair? (var syn)) syn)
					  (_ 'fail)))
				 ...)))))
  (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var))

;; tfw you get halfway done before you remember DRY
#;(let-syntax
  ((make-test
     (syntax-rules ()
       ((make-test syn1 syn2 res arg)
	(test-equal
	  (string-append "var " (symbol->string 'syn1) " in macro with "
			 (symbol->string 'syn2))
	  res
	  arg)))))
  (let-syntax
    ((test-var
       (syntax-rules ()
	 ((test-var syn ...)
	  (begin (make-test
		   syn
		   set!
		   '(3 . 2)
		   (let ((x '(1 2)))
		     (match x
			    (((set! (var syn)) . b)
			     (syn 3)))
		     x))
		 ...)
	  (begin
	    (make-test
	      syn
	      get!
	      '(1 . 2)
	      (let ((x '(1 2)))
		(match x
		       (((get! (var syn)) . b)
			(list (syn) . b)))))
	    ...)))))
    (test-var #|...|#  =.. *.. **1 _ quote $ struct @ object =
	      and or not ? set! get! quasiquote ___ unquote
	      unquote-splicing var)))

(test-end test-name)
