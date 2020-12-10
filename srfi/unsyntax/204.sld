(define-library (srfi unsyntax 204)
  (export 
    ;; (chibi match) forms
    match match-lambda match-lambda* match-let match-letrec match-let*
    ;; auxiliary syntax 
    ___ **1 =.. *.. *** ? $ struct object get! var)
  (import (except (scheme base) define-record-type)
	  (only (srfi 206 all) ___ **1 =.. *.. *** ? $ struct object get! var)
	  (rnrs records syntactic (6))
	  (rnrs records procedural (6))
	  (rnrs records inspection (6))
	  )
  (begin
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
	     (else (lp (+ i 1 ))))))))))
  (include  "../204/204.scm"))
