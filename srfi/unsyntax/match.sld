(define-library (match)
      (export 
	;; (chibi match) forms
	match match-lambda match-lambda* match-let match-letrec match-let*
	;; auxiliary syntax 
	___ **1 =.. *.. *** ? $ struct object get! var)
      (import (scheme base)
	      (only (srfi :206 all) ___ **1 =.. *.. *** ? $ struct object get! var))
      (include  "../204/204.scm"))
