(import (rename (gerbil core) (underscore? gerb-underscore?)))
    (defrules underscore?  ()
	((underscore? x kt kf)
	 (gerb-underscore? #'x) kt)
	((underscore? x kt kf)
	 kf))