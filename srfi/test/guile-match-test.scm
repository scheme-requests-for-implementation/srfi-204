(import (guile2.2 match))
(define test-name "guile-match-test")
(define implementation-name
  (let* ((module-symbol (car (module-name (current-module))))
	 (mod-name (symbol->string module-symbol)))
    (string-drop-right mod-name 4)))
(define scheme-version-name (string-append implementation-name (version)))
(include-from-path "./test/tests-common.scm")
