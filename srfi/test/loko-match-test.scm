(import (loko0.5 match)
	(srfi :64)
	(srfi :0)
	(loko))
(define scheme-version-name (string-append "loko" (loko-version)))
(define test-name "loko-match-test")
(include "../feature/match-common-new.scm")

;;; like larceny:
;;; (but library directory set through environment)
;;; $rlwrap loko
;;; > (include "loko-match-test.scm")
