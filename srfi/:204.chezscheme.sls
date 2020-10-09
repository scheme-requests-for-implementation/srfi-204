(library
  (srfi :204)
  (export
    ;;(chibi match) exports
    match match-lambda match-lambda* match-let
    match-letrec match-let*

    ;;auxilary syntax exports
    ___ **1 =..  *..  *** ?
    $ struct object get!

    ;; helper procedures
    make-match-pred make-match-get make-match-set
    )
  (import (chezscheme)
	  (srfi :0)
	  (srfi private include))
  (begin
    (include/resolve ("srfi") "auxiliary-syntax.scm")
    (define-auxiliary-keywords ___ **1 =.. *..  *** ? $ struct object get!)
    (define-syntax is-a?
      (syntax-rules ()
	((_ rec rtd)
	 ((record-predicate (record-type-descriptor rtd)) rec))))
    (define-syntax slot-ref
      (syntax-rules ()
	((_ rtd rec n)
	 (let ((rtd (record-type-descriptor rtd)))
	   (if (integer? n)
	       ((record-accessor rtd n) rec)
	       ((record-accessor rtd (name->idx rtd n)) rec))))))
    (define-syntax slot-set!
      (syntax-rules ()
	((_ rtd rec n value)
	 (let ((rtd (record-type-descriptor rtd)))
	   (if (integer? n)
	       ((record-mutator rtd n) rec value)
	       ((record-mutator rtd (name->idx rtd n)) rec value))))))
    (define-syntax name->idx
      (syntax-rules ()
	((_ rtd n)
	 (let* ((names (record-type-field-names rtd))
		(len (vector-length names)))
	   (let lp ((i 0))
	     (cond
	       ((> i len) (error "name not in record" n))
	       ((eq? n (vector-ref names i)) i)
	       (else (lp (+ i 1 )))))))))
    (include/resolve ("srfi" "204") "204.scm")))