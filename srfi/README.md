# Making a match library for a new implementation

1. For R7RS, add a new cond-expand block to **204.sld**, if not using (srfi 99) [with (srfi 99) ((or larceny (library (srfi 99))) ...) block should work]. For R6RS make a file in the format :204.implementation.sls %3a204.implementation.sls or srfi-204.implementation.sls, according to the format your implementation uses. The library definition will:
  - contain implementation-dependent code (imports and is-a? slot-ref and slot-set!)
  - define auxiliary syntax via (only (srfi 206 all) ...) or auxiliary-syntax.scm
  - include 204/204.scm

2. Get the library to load in the REPL and try matching a simple pattern (not using records).

3. When step 2 succeeds, follow the instructions for setting up testing in **./test/README.md**.


## .:

**auxiliary-syntax.scm** macros to export auxiliary syntax

**204.sld** Chibi, Gauche, and Larceny pattern matching library definitions.

**206.sld** R7RS version of (srfi 206)

**:204.chezscheme.sls** Chez library definition

**%3a204.loko.sls** Loko library definition

**srfi-204.guile.sls** Guile library definition
 - guile needs to know about this file extension:
   - $ guile -x .guile.sls

**match-test.sld** Chibi pattern matching tests

**README.md** this file

## ./204:

**204.scm** modified Chibi pattern matching library.

## ./cyclone0.19
**srfi-204.sld** version that will compile to srfi-204.so

## ./206:
 files needed for (srfi 206 all)
