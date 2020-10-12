(define-library (test benchmark time)
		(export time-it)
		(import (scheme base)
			(scheme write)
			(scheme time))
		(begin
		  (define-syntax time-it
		    (syntax-rules (=)
		      ((_ (= n) expr ...)
		       (let ((start (current-jiffy)))
			 (let lp ((out (begin expr ...))
				  (m (- n 1)))
			   (if (zero? m)
			       (let* ((end (current-jiffy))
				      (delta (/ (- end start)
						(jiffies-per-second)
						n
						1.0)))
				 (display (string-append
					    ";;; "
					    (number->string n)
					    " runs, average run time "
					    (number->string delta)
					    "seconds\n"))
				 out)
			       (lp (begin expr ...) (- m 1))))))
		      ((_ expr ...)
		       (let ((start (current-jiffy)))
			 (let ((out (begin expr ...)))
			   (let* ((end (current-jiffy))
				  (delta (/ (- end start)
					    (jiffies-per-second)
					    1.0)))
			     (display (string-append ";;; elapsed time "
						     (number->string delta)
						     " seconds\n"))
			     out))))))))
