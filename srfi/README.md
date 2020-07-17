# Making a match library for a new implementation

1. Make a directory for that implementation in this directory

2. Write a file with any implementation dependent code in that directory, at the end include **./match/match.scm**. This may just involve copying **./match.sld** into that directory (and possibly changing the file extension) for R7RS schemes.

3. Get the library to load in the REPL and try matching a simple pattern (not using records).

4. When step 3 succeeds, follow the instructions for setting uptesting in **./test/README.md**.

# Files used to make SRFI for WCS pattern matcher.

## .:

**gauche-grammar** the syntax description from Gauche's documentation

**match-implementations.md** all the documentation and implementation
for scheme pattern matching I could find.

**match.mhtml** the documentation that goes with the Chibi Scheme
implementation of pattern matching

**match.sld** Chibi pattern matching library definition

**match-test.sld** Chibi pattern matching tests

**README.md** this file


## ./guile2.2:

**match.scm** Guile implementation of library definition, uses define-module
              and include-from-path instead of define-libarary and include and
              defines is-a? macro used in ./match/match.scm

## ./match:

**match.scm** Chibi pattern matching library implementation


## ./test:

**match-tests.scm** match-test-sld tests re-written to use srfi-64 (may also import srfi-9)

**match-common.scm** implementation-specific parts of match tests

**hello-test.scm** <code>cond-expand</code> to run tests in hello common. Used to check <code>SCM</code>, <code>SCMFLAGS</code> and <code>cond-expand</code> before adding <code>cond-expand</code> to **match-tests.scm**

**hello-common.scm** 2 tests that will pass.

**README.md** testing how-to

**Makefile** make check runs all tests

## ./test/logs
**\*.log** test results

