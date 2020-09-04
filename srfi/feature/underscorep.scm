;;; underscorep.scm handle underscores in patterns
;;; portably in r6rs and r7rs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these are the macros Marc proposed on the forum:
;; R7RS
(define-syntax underscore?
  (syntax-rules (_)
    ((_ _ kt kf) kt)
    ((_ x kt kf) kf)))

;;R6RS
(define-syntax underscore?
  (lambda (stx)
    (syntax-case ()
      ((_ x kt kf)
       (if (and (identifier? #'x) (free-identifier=? #'x #'_))
	   #'kt
	   #'kf)))))
;;; some of the R6RS can't handle cond-expand

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; the first thing to do is find every macro with _ in its literals

;; match-two
;; match-extract-vars

;;; and then find every macro that calls match-two

;; match-one

;;and change it's calls to match-two to:
(define-syntax match-underscore
  (syntax-rules ()
    ((match-underscore v p g+s (sk ...) fk i)
     (underscore? p
		  (sk ... i)
		  (match-two v p g+s (sk ...) fk i)))))

;;; and then find every macro that calls match-extract-vars
;;; signature: (match-extract-vars pat cont (ids ...) (new-vars ...))

;; match-one
;; match-two or ___ *** ..= ..*
;; match-quasiquote
;; match-vector-tail
;; match-extract-vars almost all, _ pattern is:
;;    ((match-extract-vars _ (k ...) i v) (k ... v))
;; match-extract-vars-step
;; match-extract-quasiquote-vars
;; match-letrec-one

;; and then change their calls to match-extract-vars to
(define-syntax match-extract-underscore
  (syntax-rules ()
    ((match-extract-underscore p (k ...) i v)
     (underscore? p
		  (k ... v)
		  (match-extract-vars p (k ...) i v)))))
