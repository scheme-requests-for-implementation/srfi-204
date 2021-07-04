(use-modules (srfi srfi-204)
	 (srfi srfi-64)
	 (srfi srfi-9)
	 (srfi srfi-26)
	 (rnrs unicode)
	 (srfi srfi-1))
(define (get-environment-variables)
  (let ((env (environ)))
    (map (lambda (env-str)
	   (let ((=-idx (string-index env-str #\=))
		 (len (string-length env-str)))
	     (cons (substring env-str 0 =-idx)
		   (substring env-str (+ =-idx 1) len))))
	 env)))
(define non-linear-pattern #t)
(define non-linear-pred #t)
(define non-linear-field #t)
(define record-implemented #t)
(define test-name "srfi-test")
(define scheme-version-name (string-append "guile-" (version)))
(include-from-path "./test/srfi-common.scm")