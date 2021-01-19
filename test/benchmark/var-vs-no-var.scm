(test-begin test-name)
;;;log version
(test-equal scheme-version-name 1 1)

(define-syntax test-var
  (syntax-rules ()
    ((test-var syn ...)
     (begin (test-equal 
	      (string-append "var " (symbol->string 'syn))
	      1
	      (match '(1 1) (((var syn) (var syn)) syn)
		     (_ 'fail)))
	    ...))))
(test-var ...  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var)

#;(define-syntax test-no-var
  (syntax-rules ()
    ((test-var syn ...)
     (begin (test-equal 
	      (string-append "no-var " (symbol->string 'syn))
	      1
	      (match '(1 1) ((syn syn) syn)
		     (_ 'fail)))
	    ...))))
#;(test-no-var ...  =.. *.. **1 _ quote $ struct @ object =
	    and or not ? set! get! quasiquote ___ unquote
	    unquote-splicing var)
;won't run even after ~half of syntax is commented out
(test-end test-name)
