;;; This started out as a generator because that was the pattern-matching on
;;; a callable I was most familiar with but it's really just demonstrates some
;;; aspects of the module that have come up in the forum and how they might be
;;; used.

(import (srfi srfi-9))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generator: this demonstrates pattern matching on a
;; callable, I don't think it directly touches on anything
;; in the forum, except maybe tail-context.

(define-record-type <yield>
  (make-yield value closure)
  yield?
  (value yield-value)
  (closure yield-closure))

(define (simple-gen proc init)
  (let lp ((value init))
    (make-yield value (lambda () (lp (proc value))))))

(define (iota-2 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (+ n 1)) 0)))
	     (if (= v n)
		 '()
		 (cons v (lp (c))))))

(define (iota-2-2 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (+ n 1)) 0))
		 (acc '()))
	     (if (= v n)
		 (reverse acc)
		 (lp (c) (cons v acc)))))

(define (iota-2-3 n)
  (match-let lp ((($ <yield> v c) (simple-gen (lambda (n) (- n 1)) (- n 1)))
		 (acc '()))
	     (if (< v 0)
		 acc
		 (lp (c) (cons v acc)))))

(define (nfibs n)
  (match-let loop ((($ <yield> (this last) c)
		    (simple-gen (match-lambda ((this last) `(,(+ this last) ,this)))
				(list 1 0)))
		   (n n)
		   (acc '()))
	     (if (zero? n)
		 (reverse acc)
		 (loop (c) (- n 1) (cons this acc)))))

(define (make-builder proc init select)
  (lambda (n)
    (match-let loop ((($ <yield> v c) (simple-gen proc init))
		     (n n)
		     (acc '()))
	       (if (zero? n)
		   (reverse acc)
		   (loop (c) (- n 1) (cons (select v) acc))))))

(define id (lambda (x) x))
(define jota (make-builder (lambda (x) (+ x 1)) 0 id))
(define nfibs-2
  (make-builder (match-lambda ((this last) `(,(+ this last) ,this)))
		(list 1 0)
		car))

;;; some benchmarking, adding underscores to make nums more readable
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 10_000))) (car l))
;; $24 = 0
;; ;; 0.009579s real time, 0.009463s run time.  0.000000s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 10_000))) (car l))
;; $25 = 0
;; ;; 0.017753s real time, 0.017717s run time.  0.000000s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 1_000_000))) (car l))
;; $26 = 0
;; ;; 0.273366s real time, 0.301025s run time.  0.123467s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 1_000_000))) (car l))
;; $27 = 0
;; ;; 0.207538s real time, 0.267880s run time.  0.160490s spent in GC.
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2 100_000_000))) (car l))
;; allocate_stack failed: Cannot allocate memory
;; While executing meta-command:
;; Stack overflow
;; scheme@(guile-user) [5]> ,time (let ((l (iota-2-2 100_000_000))) (car l))
;; $28 = 0
;; ;; 24.418649s real time, 25.026579s run time.  15.652399s spent in GC.
;; scheme@(guile-user) [5]>
;; difference between iota-2-2 and iota-2-3 starts to show up ~10 million
;; at 1 billion both are killed.

;; the problem from AOC that took 3-at-a-time from the intcode vm could work
;; like this:

(define (next-three gen)
  (match-let* ((($ <yield> v1 c1) gen)
	       (($ <yield> v2 c2) (c1))
	       (($ <yield> v3 c3) (c2)))
	      (list (list v1 v2 v3) c3)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; checkable: this demonstrates one use case for predicates
;; that come from pattern variables. This is also a difference
;; from the matcher outlined in Wright and Duba "Pattern Matching
;; for Scheme"

(define-record-type <checkable>
  (make-checkable pred data)
  checkable?
  (pred checkable-pred)
  (data checkable-data))

(define check
  (match-lambda (($ <checkable> pred (? pred ok)) ok)
		(($ <checkable>) 'bad-data)))

;;; Wright version
(define check-2
  (match-lambda (($ <checkable> pred val)
		 (if (pred val) val 'bad-data))))

(check (make-checkable odd? 1)) ; => 1
(check (make-checkable odd? 2)) ; => 'bad-data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; successor function: uses and form and field (not predicate)
;; checking Wright and Duba's paper, there is no reference to
;; fields being from same scope as match

(define (S n) (list S n))

(define add-one
  (match-lambda
    ((and (f n) (= f next)) next)))

(define value (match-lambda ((x *** (? number? n)) (+ (length x) n))))
;;; does not work in Wright, = seems to have same properties as ?, even though
;;; not documented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; the behavior of cyclic literals has been a long-running
;; topic, the following is one matcher that acts on cyclic
;; lists (this uses constructed lists because not all
;; implementations handle cyclic literals correctly)

(define l3 (list 1 2 3))
(set-cdr! (cddr l3) l3) ;; l = '#0=(1 2 3 . #0#)
(define zero-to-three-cycle
  (match-lambda ((and c (= car c)) 0)
		((and c (= cdr c)) 1)
		((and c (= cddr c)) 2)
		((and c (= cdddr c)) 3)
		(_ 'fail)))
(define l0 (list (list)))
(set-car! l0 l0) ;; '#0=(#0#)

(zero-to-three-cycle l0) ; => 0
(zero-to-three-cycle l3) ; => 3

;;;another example using pattern variables in the predicate

(define fibby
  (match-lambda ((a b (? (lambda (x) (= (+ a b) x)) c) . rest)
		  (fibby (cons b (cons c rest))))
                 ((a b) #t)
                 ((a) #t)
                 (() #t)
		 (_ #f)))

(define fibby-2
  (match-lambda ((a b c . rest)
		  (if (= (+ a b) c)
		      (fibby (cons b (cons c rest)))
		      #f))
                 ((a b) #t)
                 ((a) #t)
                 (() #t)
		 (_ #f)))

(define fibby-3
  (match-lambda (() #t)
		((a) #t)
		((a b) #t)
		((a b . rest)
		 (match-let loop (((c . rest) rest)
			         (a a)
			         (b b))
		           (if (= c (+ a b))
			       (cond
				 ((null? rest) #t)
				 (else (loop rest b c)))
			       #f)))))
;;; first-pass benchmarking using a list of the first 10 000 Fibonacci numbers shows
;;; little difference between all these methods, possibly because doing arithmetic
;;; with page-long numbers


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; or not ellipsis patterns

;;;some or patterns

;; Any -> Boolean
(define yes-match
  (match-lambda
    ((and (? string?)
	  (or (? (lambda (s) (string-ci=? "yes" s)))
	      (? (lambda (s) (string-ci=? "y" s))))) #t)
    (_ #f)))

;; Alist -> Boolean
(define (f-g-or-b? alist)
  (let ((make-field (lambda (sym) (lambda (x) (assoc sym x)))))
  (match alist
    ((or (= (make-field 'f) p)
	 (= (make-field 'g) p)
	 (= (make-field 'b) p))
     (=> fail)
     (if p #t (fail)))
    (_ #f))))
;; doesn't work because fail moves on to next pattern

(define (f-g-or-b? alist)
  (let ((make-field (lambda (sym) (lambda (x) (assoc sym x)))))
  (match alist
    ((or (= (make-field 'f) (and (? and)))
	 (= (make-field 'g) (and (? and)))
	 (= (make-field 'b) (and (? and))))
     #t)
    (_ #f))))
;; (=> fail) does not return to revisit an or pattern,
;; (and p (? and))

(define (not-pair? x)
  (match x
    ((not (a . b)) #t)
    (_ #f)))

(define ends-in-one-of-first-three?
  (match-lambda
    ((a b c d ... x) (=> fail) (if (or (equal? a x)
				       (equal? b x)
				       (equal? c x))
				   #t
				   (fail)))
    (_ #f)))

(define ends-in-one-of-first-three?
  "#t if a list is of 4 or more, last element is equal? one of first 3"
  (match-lambda
    ((a b c d ... (or a b c)) #t)
    (_ #f)))

(define ends-in-one-of-first-three?
  (match-lambda
    ((a b c d ... x) (=> fail) (if (equal? a x)
				   #t
				   (fail)))
    ((a b c d ... x) (=> fail) (if (equal? b x)
				   #t
				   (fail)))
    ((a b c d ... x) (=> fail) (if (equal? c x)
				   #t
				   (fail)))
    (_ #f)))

;;; another example of an or pattern that
;;; misuses fail to get a wrong result.
(define ends-in-one-of-first-three?
  (match-lambda
    ((or (p b c d ... x)
	 (a p c d ... x)
	 (a b p d ... x))
     (=> fail) 
     (if (equal? x p)
	 #t
	 (fail)))
    (_ #f)))

(define (palindrome? str)
  (let loop ((chars (filter char-alphabetic? (string->list (string-foldcase str)))))
    (match chars
      (() #t)
      ((a) #t)
      ((a b ... a) (loop b))
      (_ #f))))

(define handle-arithmetic-sexpr
 (match-lambda (`(+ . ,operands) (apply + (map eval-sexpr operands)))
               (`(- . ,operands) (apply - (map eval-sexpr operands)))
               (`(* . ,operands) (apply * (map eval-sexpr operands)))
               (`(/ . ,operands) (apply / (map eval-sexpr operands)))))

(define eval-sexpr
  (match-lambda ((? number? n) n)
		 ((and arith-sexpr ((or '+ '- '* '/) . _))
		  (handle-arithmetic-sexpr arith-sexpr))
		 (_ (error "not implemented"))))

(define alist (list (cons 'a 1) (cons 'b 2) (cons 'c 3)))
(define g (match-let loop ((((sym . (get! g)) . rest) alist))
		     (cond
		       ((eq? sym 'c) g)
		       ((null? rest) #f)
		       (else (loop rest)))))

(define s (match-let loop ((((sym . (set! s)) . rest) alist))
		     (cond
		       ((eq? sym 'c) s)
		       ((null? rest) #f)
		       (else (loop rest)))))

(define g2 (match alist ((= (lambda (al) (assv 'c al))
			    (_ . (get! g)))
			 g)))

(define s2 (match alist ((= (lambda (al) (assv 'c al))
			    (_ . (set! g)))
			 g)))

(define (make-alt-pred new-pred) (lambda (a) (lambda (b) (new-pred a b))))

;;;emulate 
(import (scheme case-lambda))
(define (make-pred pred)
  (case-lambda
    ((a) (lambda (b) (pred a b)))
    ((a b) (pred a b))))

(define (make-get proc)
  (lambda (ref)
    (lambda (obj)
      (lambda ()
	(proc obj ref)))))

(define (make-set proc)
  (lambda (ref)
    (lambda (obj)
      (lambda (value)
	(proc obj ref value)))))

(import (srfi 69))
(define get-key (make-getter (lambda (obj ref) (hash-table-ref obj ref (lambda () #f)))))
(define set-key (make-setter hash-table-set!))

(define ht (make-hash-table))

(define get-mode
  (match ht ((= (get-key 'mode) gm) gm)))
(define set-mode!
  (match ht ((= (set-key 'mode) sm!) sm!)))

(define-record-type <posn> (make-posn x y) posn? (x posn-x set-posn-x!) (y posn-y set-posn-y!))
;;; (define-record-type (<posn> make-posn posn?) (fields (mutable x) (mutable y)))

(define posn-equal?
  (make-alt-pred
    (match-lambda* ((($ <posn> x y) ($ <posn> x y)) #t) (_ #f))))

(define slope-equal?
  (make-alt-pred
    (match-lambda* ((($ <posn> x y) ($ <posn> w z))
		    (cond
		      ((and (= 0 y) (= 0 z)) #t)
		      ((or (= 0 y) (= 0 z)) #f)
		      (else (= (/ x y) (/ w z))))) (_ #f))))

(define (cross-peephole vec-product)
  (match vec-product
	 (('cross a (? (posn-equal? a))) (make-posn 0 0))
	 (('cross a (? (slope-equal? a))) (make-posn 0 0))
	 (other other)))

(match (call-with-input-file "srfi/204.sld" read)
       (`(cond-expand ,@(_ *** `(import . ,rest)) (else)) rest))

(define (extract-imports file-name)
  (define extract
    (match-lambda
      (`(import . ,imports) imports)
      (((and (key *** `(import . ,imports)) inner) . rest)
       (append (if (null? key)
		   (list imports)
		   (extract inner)) (extract rest)))
      ((this . rest) (extract rest))
      (any '())))
  (call-with-input-file file-name
			(lambda (port)
			  (let loop ((port port) (out '()))
			    (if (eof-object? (peek-char port))
				out
				(loop port (append out (extract (read port)))))))))

(define (pp lst)
  (for-each (lambda (sub) (display sub) (newline)) lst))

(pp (extract-imports "../../test/data/srfi-test.scm"))

(define (match-on-file filename matcher)
  (call-with-input-file
    filename
    (lambda (port) 
      (let loop ((out '()))
	(if (eof-object? (peek-char port))
	    out
	    (loop (append out (matcher (read port)))))))))

(define extract-imports
  (match-lambda
      (`(import . ,imports) imports)
      (((and (key *** `(import . ,imports)) inner) . rest)
       (append (if (null? key)
		   (list imports)
		   (extract-imports inner)) (extract-imports rest)))
      ((this . rest) (extract-imports rest))
      (any '())))

(define (get-imports filename)
  (extract-imports (file->sexpr filename)))

(extract-imports (file->sexpr  "../test/data/srfi-test.scm"))

(extract-imports (file->sexpr  "TODO/forum-topics.scm"))

(import (srfi 204) (scheme red) (chibi json))

(get-imports "../test/data/srfi-test.scm")

(get-imports "TODO/forum-topics.scm")

(define in? (make-pred (lambda (lst obj) (member obj lst))))
(define not-in? (make-pred (lambda (lst obj) (not (member obj lst)))))

(define (clean l)
  (let ((u (if #f #f)))
    (remove (lambda (i) (equal? i u)) l)))

(match (iota 7)
       (((or (? (in? (list 2 6)) a)
	    (? (not-in? (list 2 6)) b)) ...)
	(list (clean a) (clean b))))
;; hmm...3 passes over list/derived list

(match (get-environment-variables)
        (((or ("PATH" . path)
	      ("USERPROFILE" . home)
	      ("HOME" . home)
	      ("USER" . user)
	      ("USERNAME" . user)
	      (_ . _)) ...) (list (clean path) (clean home) (clean user))))

(fold (lambda (env-var out)
	(match env-var
	      (("PATH" . path) (match-let (((a b c) out)) (list path b c)))
	      (("USERPROFILE" . home) (match-let (((a b c) out)) (list a home c))) 
	      (("HOME" . home) (match-let (((a b c) out)) (list a home c)))
	      (("USER" . user)  (match-let (((a b c) out))  (list a b user)))
	      (("USERNAME" . user)  (match-let (((a b c) out))  (list a b user)))
	      (_ out)))
      (list #f #f #f)
      (get-environment-variables))

(fold (match-lambda*
	((("PATH" . path) (p h u)) (list path h u))
	((("USERPROFILE" . home)  (p h u)) (list p home u)) 
	((("HOME" . home)  (p h u)) (list p home u))
	((("USER" . user)  (p h u))  (list p h user))
	((("USERNAME" . user)  (p h u))  (list p h user))
	(_ out) out)
      (list #f #f #f) ; (p h u) init
      (get-environment-variables))

(import (srfi 69))
(define (get-from-table key)
  (lambda (table)
    (hash-table-ref/default table key #f)))

(match (alist->hash-table (get-environment-variables))
       ((and (= (get-from-table "PATH")
		  (and (not #f) path))
	    (or (= (get-from-table "USERPROFILE")
		  (and (not #f) home))
		 (= (get-from-table "HOME")
		  (and (not #f) home)))
	     (or (= (get-from-table "USER")
		  (and (not #f) user))
		 (= (get-from-table "USERNAME")
		  (and (not #f) user)))) (list path home user)))

(define (binary->unary binary-string)
  (let loop ((digits (cons #\^ (string->list binary-string)))
	     (prev '()))
    (define (markov char-list)
      (match char-list
	     ((#\| #\0 . rest) (cons #\0 (cons #\| (cons #\| rest))))
	     ((#\1 . rest) (cons #\0 (cons #\| rest)))
	     ((#\^ #\0 . rest) (cons #\^ rest))
	     ((any . rest) (cons any (markov rest)))
	     (() '())))
    (if (equal? digits prev)
	(list->string (cdr digits))
	(loop (markov digits) digits))))

(define-syntax make-chunker-two
  (syntax-rules ()
    ((_ s ...)
     (lambda (l)
       (let lp ((l l))
	 (match l (() '())
		  ((s ... . rest) (cons (list s ...) (lp rest)))
		  (end (list end))))))))

(define (list-tree->vector-tree tree)
  (if (list? tree)
      (list->vector (map list-tree->vector-tree tree))
      tree))

(define get-close
  (match-lambda
    ((key *** (`(value . "Close") b ...)) key)
    ((key *** (k . (? vector? v)))
     (let ((len (vector-length v)))
       (let lp ((i 0))
	 (cond
	   ((= i len) 7)
	   ((get-close (vector-ref v i))
	    => (lambda (r) (append key (list k i) r)))
	   (else (lp (+ i 1)))))))
    (_ #f)))

;(get-close (car example-2)) => (menu popup menuitem 2)

(define-syntax json-key
  (syntax-rules ()
    ((_ expr)
     (let ()
       (define get-key 
	 (match-lambda
	    ((key *** expr) key)
	    ((? vector? v)
	     (=> fail)
	     (let ((len (vector-length v)))
	       (let loop ((i 0))
		 (cond
		   ((= i len) (fail))
		   ((get-key (vector-ref v i))
		    => (lambda (r) (cons i r)))
		   (else (loop (+ i 1)))))))
	    ((key *** (k . (? vector? v)))
	     (=> fail)
	     (let ((res (get-key v)))
	       (if res (append key (cons k res)) (fail))))
	    (_ #f)))
       get-key))))

 ((json-key (`(value . "Close") b ...)) (car example-2))
; (menu popup menuitem 2)

;; using srfi 133 syntax included in r7rs red:

(define-syntax json-key
  (syntax-rules ()
    ((_ expr)
     (let ()
       (define get-key 
	 (match-lambda
	    ((key *** expr) key)
	    ((? vector? v)
	     (=> fail)
	     (let* ((i (vector-index get-key v))
		    (res (get-key (vector-ref v i))))
	       (if i (cons i res) (fail))))
	    ((key *** (k . (? vector? v)))
	     (=> fail)
	     (let ((res (get-key v)))
	       (if res (append key (cons k res)) (fail))))
	    (_ #f)))
       get-key))))

(define (handle-vector val matcher fail-k)
  (match val
	  ((? vector? v)
	   (let* ((i (vector-index matcher v))
		  (r (if i (matcher (vector-ref v i)) #f)))
	     (if i (cons i r) (fail-k))))
	  ((key *** (k . (? vector? v)))
	   (let ((r (handle-vector v matcher fail-k)))
	     (if r (append key (cons k r)) (fail-k))))
	  (_ (fail-k))))

((letrec ((matcher (match-lambda
		       ((key *** ('(value . "Close") . rest)) key)
		       (val (=> fail) (handle-vector val matcher fail))
		       (_ #f))))
   matcher)
 (car example-json))

(define example-json
  '((menu (id . "file")
	  (value . "File")
	  (popup
	    (menuitem .
		      #(((value . "New") (onclick . " CreateNewDoc()"))
			((value . "Open") (onclick . "OpenDoc()"))
			((value . "Close") (onclick . "CloseDoc()"))))))))

(define (get-close json)
  (match-letrec 
    ((get-close (match-lambda
		  ((key *** ('(value . "Close") . rest)) key)
		  ((? vector? v)
		   (let ((i (vector-index get-close v)))
		     (if i
			 (cons i (get-close (vector-ref v i)))
			 #f)))
		  ((key *** (k . (? vector? v)))	
		   (let ((r (get-close v)))
		     (if r
			 (append key (cons k r))
			 #f)))
		  (_ #f)))
     ((new-json) json))
    (get-close new-json)))

(define (get-close json)
  (define get-close-inner
    (match-lambda
		  ((key *** ('(value . "Close") . rest)) key)
		  ((? vector? v)
		   (let ((i (vector-index get-close-inner v)))
		     (if i
			 (cons i (get-close-inner (vector-ref v i)))
			 #f)))
		  ((key *** (k . (? vector? v)))	
		   (let ((r (get-close-inner v)))
		     (if r
			 (append key (cons k r))
			 #f)))
		  (_ #f)))
  (get-close-inner (car json)))

(get-close example-json)
;(menu popup menuitem 2)

(define-syntax make-json-handler
  (syntax-rules ()
    ((handle-json expr sk vk vpk fk)
     (define handler
       (match-lambda
		  ((key *** ('(value . "Close") . rest))
		   (=> fail) (sk key rest handler fail))
		  ((? vector? v)
		   (=> fail) (vk v handler fail))
		  ((key *** (k . (? vector? v)))	
		   (=> fail) (vpk key k v handler fail))
		  (any (fk handler fail))))
     handler)))

((make-json-handler))

(define-syntax handle-json
  (syntax-rules ()
    ((handle-json expr sk vk vpk fk)
     (define do-json
       (match-lambda
	 ((key *** ( 'expr . out) . rest) (sk key out rest do-json))
	 ((? vector? v) (=> fail)
	  (vk v do-json fail))
	 ((key *** ((k . (? vector? v)) . out) . rest)
	  (=> fail)
	  (vpk key k v out rest do-json fail))
	 (any (fk any)))))))

((handle-json (value . "Close")
	      (lambda (k o . rest) o)
	      (lambda (v do-json fail)
		(vector-any do-json v))
	      (lambda (key k v out rest do-json fail)
		(let ((r (do-json v)))
		  (if r r (do-json rest))))
	      (lambda arg #f))
 (car example-json))


(define extract-num-addends
  (match-lambda
    (((and (k *** `(+ . ,addends)) ('+ (? number? i) ...)) . rest)
     (cons addends (extract-num-addends rest)))
    (((and (k *** `(+ . ,addends)) inner) . rest)
     (append (extract-num-addends inner)
	     (extract-num-addends rest)))
    ((this . rest) (extract-num-addends rest))
    (() '())))

(extract-num-addends '((+ (* 1 (+ 2 3)) (+ 4 5)) (- (/ 6 (+ 7 8)) (+ 9 10))))

(extract-num-addends '((+ (* 1 (+ 2 3)) (+ 4 5)) (- (/ 6 (+ 7 8)) (+ 9 10))))

; => ((2 3) (4 5) )

(define (even-for-op? n op incr id)
  (match-letrec
    (((evenlike oddlike)
      (list (lambda (n) (if (<= n id) #t (oddlike (op n incr))))
	    (lambda (n) (if (<= n id) #f (evenlike (op n incr)))))))
    (evenlike n)))

