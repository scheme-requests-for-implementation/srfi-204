(define test-name "guile-hello-test" )
(define implementation-name
  (let* ((module-symbol (car (module-name (current-module))))
	 (mod-name (symbol->string module-symbol)))
    (string-drop-right mod-name 4)))
(define scheme-version-name (string-append implementation-name (version)))
(include-from-path "./test/hello-common.scm")
