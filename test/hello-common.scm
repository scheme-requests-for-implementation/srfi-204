;;;should always pass, use this file
;;;to make sure compiler/interpreter and flags are set up correctly
;;;like:
;;; ./implementation-hello-test.scm
;;; (define test-name "implementation-hello.log")
;;; (define scheme-version-name (version))
;;; (include-from-path "./test/hello-common.scm")

(test-begin test-name)
(test-equal scheme-version-name 1 1)
(test-assert (not (equal? "hello" "world")))
(test-end test-name)
