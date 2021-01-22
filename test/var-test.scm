(cond-expand
  (guile
    (use-modules (srfi srfi-204)
      	   (srfi srfi-64)
      	   (srfi srfi-9))
    (define test-name "guile-match-test")
    (define scheme-version-name (string-append "guile-" (version)))
    (include-from-path "test/var-common.scm"))
  (else))
