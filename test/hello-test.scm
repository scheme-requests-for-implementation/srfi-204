(use-modules (srfi srfi-64))
;;;should always pass, sanity check

(test-begin "hello")
(test-assert (not (equal? "hello" "world")))
(test-end "hello")
