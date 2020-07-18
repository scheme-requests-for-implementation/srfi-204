(cond-expand
  (guile
    (define test-name "guile-hello-test" )
    (define scheme-version-name (string-append "guile-" (version)))
    (import (srfi srfi-9)
	    (srfi srfi-64))
    (include-from-path "./test/hello-common.scm"))
  (gauche
    (import (only (gauche base) gauche-version)
	    (scheme base)
	    (srfi-64))
    (define test-name "gauche-hello-test")
    (define scheme-version-name (string-append "gauche-" (gauche-version)))
    (include "hello-common.scm")))
