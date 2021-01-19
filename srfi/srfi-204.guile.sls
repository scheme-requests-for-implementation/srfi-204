;; derived from Guile's (ice-9 match), so falls under this license

;;; Copyright (C) 2010, 2011, 2012, 2020 Free Software Foundation, Inc.
;;;
;;; This library is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Lesser General Public
;;; License as published by the Free Software Foundation; either
;;; version 3 of the License, or (at your option) any later version.
;;;
;;; This library is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this library; if not, write to the Free Software
;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

(library 
      (srfi srfi-204)
      (export
	;; (chibi match) exports
	match match-lambda match-lambda* match-let
	match-let* match-letrec

	;;extension helpers
	make-match-pred make-match-get make-match-set
	
	;;auxiliary syntax
	___ **1 =.. *.. *** ? $ struct object get! var)

      (import (guile))

      (define-syntax slot-ref
	(syntax-rules ()
	  ((_ rtd rec n)
	   (if (integer? n)
	       (struct-ref rec n)
	       ((record-accessor rtd n) rec)))))

      (define-syntax slot-set!
	(syntax-rules ()
	  ((_ rtd rec n value)
	   (if (integer? n)
	       (struct-set! rec n value)
	       ((record-modifier rtd n) rec value)))))

      (define-syntax is-a?
	(syntax-rules ()
	  ((_ rec rtd)
	   (and (struct? rec)
		(eq? (struct-vtable rec) rtd)))))

      (include-from-path "./srfi/204/auxiliary-syntax.scm")
      (define-auxiliary-keywords ___ **1 =.. *.. *** ? $ struct object get! var)
      (include-from-path "./srfi/204/204.scm"))

