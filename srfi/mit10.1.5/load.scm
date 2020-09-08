(define load-env (extend-top-level-environment (the-environment)))
(define current-env (the-environment))

(define (self-relatively thunk)
  (let ((place (ignore-errors current-load-pathname)))
    (if (pathname? place)
	(with-working-directory-pathname
	 (directory-namestring place)
	 thunk)
	(thunk))))

(define (load-relative filename env)
  (self-relatively (lambda () (load filename env))))

(load-relative "match" load-env)
;(load-relative "../auxiliary-syntax.scm" load-env)
;:(define-auxiliary-keywords __ **1 =.. *.. *** ? $ struct object get!)

(let ((export-list '(shinn-match
                        match-let* match-named-let match-letrec match-let
                        match-lambda* match-lambda
			___ **1 =.. *.. *** ? $ struct object get!)))
  (for-each (lambda (sym)
              (if (eq? sym 'match)
                  (environment-define-macro
                   current-env 'shinn-match
                   (environment-lookup-macro load-env 'match))
                  (environment-define-macro
                   current-env sym
                   (environment-lookup-macro load-env sym))))
            export-list))

;; (shinn-match (iota 5)
;;              ((first rest ...) (pp rest)))
;; (shinn-match (iota 5)
;;              ((first rest ...) (pp first)))
