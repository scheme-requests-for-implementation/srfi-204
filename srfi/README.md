# Making a match library for a new implementation

1. Make a directory for that implementation in this directory

2. Write a file with any implementation dependent code in that directory, at the end include **./match/match.scm**. This may just involve copying **./match.sld** into that directory (and possibly changing the file extension) for R7RS schemes.

3. Get the library to load in the REPL and try matching a simple pattern (not using records).

4. When step 3 succeeds, follow the instructions for setting uptesting in **./test/README.md**.

# Files used to make SRFI for WCS pattern matcher.

## .:

**auxiliary-syntax.scm** macros to export auxiliary syntax

**match-implementations.md** all the documentation and implementation
for scheme pattern matching I could find.

**srfi-204.sld** Chibi, Gauche, Guile and Larceny pattern matching library definitions.

**match-test.sld** Chibi pattern matching tests

**README.md** this file

## ./examples:
files that show how library is implemented in particular use cases (ie srfi-99 records vs rnrs records)

## ./feature:
files for in-development features

## ./&lt;ImplementationVersion&gt;:
files needed to make match work in a particular implementation of scheme, and a record of any issues.

## ./not-working:
failed attempts to make module work with GNU/MIT, Rapid, Husk, Foment, Gambit, and Gerbil.

## ./ref
files used for reference.

## ./srfi-204:

**srfi-204.scm** modified Chibi pattern matching library.


## ./test:

**match-tests.scm** implementation-specific parts of match tests

**match-common.scm** match-test.sld tests re-written to use srfi-64

**loko-match-test.scm**

**match-common-r6rs.scm** match-common.scm rewritten for r6rs

**hello-test.scm** <code>cond-expand</code> to run tests in hello common. Used to check <code>SCM</code>, <code>SCMFLAGS</code> and <code>cond-expand</code> before adding <code>cond-expand</code> to **match-tests.scm**

**hello-common.scm** 2 tests that will pass.

**README.md** testing how-to

**Makefile** make \*-test runs that test using interpreter from TESTSCHEME environment variable

## ./test/logs
**\*.log** test results

