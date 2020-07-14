(import (srfi srfi-64))
;;;should always pass, use this file
;;;to make sure compiler/interpreter and flags are set up correctly
;;;like:
#|./implementation-hello-test.scm
(define test-name "implementation-hello.log")
(include-from-path "./test/hello-common.scm") 
|#

(test-begin test-name)
(test-assert (not (equal? "hello" "world")))
(test-end test-name)
