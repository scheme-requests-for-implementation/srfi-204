##Files used to make SRFI for WCS pattern matcher.

####.:

**gauche-grammar** the syntax description from Gauche's documentation

**match-implementations.md** all the documentation and implementation
for scheme pattern matching I could find.

**match.mhtml** the documentation that goes with the Chibi Scheme
implementation of pattern matching

**match.sld** Chibi pattern matching library definition

**match-test.sld** Chibi pattern matching tests

**README.md** this file

**srfi-template.html** the filled-out SRFI


####./match:

**match.scm** Chibi pattern matching library implementation


####./guile2.2:

**match.scm** Guile implementation of library definition, uses define-module
              and include-from-path instead of define-libarary and include and
              defines is-a? macro used in upstream

####./guile2.2/match:

**match-upstream.scm** no changes from ./match/match.scm

####./test:

**guile2.2-test.scm** match-test-sld tests re-written to use srfi-64 and srfi-9

**hello-test.scm** should always pass

**Makefile** make check runs all tests

**\*.log** test results

