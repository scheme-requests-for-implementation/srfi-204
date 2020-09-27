;;; underscore.sls : this library keeps syntax-case from conflicting
;;; with r7rs implementations that don't recognize it (specifically #')
(library (srfi 204 underscore)
	 (export underscore?)
	 (import (rnrs base)
		 (rnrs syntax-case))
	 (define-syntax underscore?
	   (lambda (stx)
	     (syntax-case stx ()
			  ((_ x kt kf)
			   (if (and (identifier? #'x)
				    (free-identifier=? #'x #'_))
			       #'kt
			       #'kf))))))
