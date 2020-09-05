(define-library (match match)
		(export
		  match
		  match-lambda
		  match-lambda*
		  match-let
		  match-let*
		  match-letrec
		  ___ ..1 ..= ..* *** ? $ struct object get!)
		(include "match.scm"))

