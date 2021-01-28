# Copyright (C) Felix Thibault (2020).  All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice (including
# the next paragraph) shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

############################################################
#			 Variables			   #
############################################################

# environment
top_srcdir = $(abspath ../)
SHELL := bash
VPATH := .:..

# interpreters and flags
GUILE = guile
GUILE-3 = ../../../tgzs/guile-3.0.4/meta/guile
GUILEFLAGS = --no-auto-compile -L $(top_srcdir) -x .guile.sls
GOSH = gosh
GOSHFLAGS = -I $(top_srcdir)
#TODO have not found a way to make larceny work from Makefile
#     open "larceny -r7rs -I .." instead and
#     (include "test/match-test.scm")
LARCENY = larceny
LARCENYFLAGS = -r7 -I $(top_srcdir) <
CHEZ = chezscheme
CHEZFLAGS = --libdirs\
	    $(top_srcdir):$$HOME/.akku/lib
CHIBISHCEME = chibi-scheme
CHIBISHCEMEFLAGS = -I $(top_srcdir)
GXI = gxi
GXIFLAGS = --lang r7rs
LOKO = loko
LOKOFLAGS = --script
UNSYNTAX = unsyntax-scheme
UNSYNTAXFLAGS = -I $(top_srcdir)
CYCC := cyclone
ICYC := icyc
ICYCFLAGS := -I $(top_srcdir)

# change when testing a new interpreter
SCM := $(GUILE)
SCMFLAGS := $(GUILEFLAGS)

# dependencies
srfi-206 := $(wildcard srfi/206/*)
r7rs_deps := srfi/204.sld srfi/204/204.scm srfi/206.sld $(srfi-206)
chibi_deps := srfi/match-test.sld $(r7rs_deps)
r6rs_deps := srfi/204/204.scm srfi/204/auxiliary-syntax.scm
guile_deps := srfi/srfi-204.guile.sls $(r6rs_deps)
chez_deps := srfi/204/:204.chezscheme.sls $(r6rs_deps) # currently these two don't work
loko_deps := srfi/204/%3a204.loko.sls $(r6rs_deps)     # due to special chars
match_all :=  chibi-match-test chez-match-test gauche-match-test\
	guile-match-test larceny-match-test loko-match-test unsyntax-match-test
srfi_all := chez-srfi-test gauche-srfi-test guile-srfi-test\
	guile-3-srfi-test larceny-srfi-test loko-srfi-test unsyntax-srfi-test
match := match-common.scm
srfi := srfi-common.scm
var := var-common.scm
r6rs_srfi := r6rs-srfi-common.scm
unsyn_deps := srfi/204/204.scm srfi/unsyntax/204.sld $(srfi-206)
cyc_dep := srfi/cyclone0.19/srfi-204.so
cyc_deps := $(cyc_dep) srfi/cyclone0.19/srfi-204.c\
	srfi/cyclone0.19/srfi-204.meta srfi/cyclone0.19/srfi-204.o
cyc_so_deps := srfi/cyclone0.19/srfi-204.sld
cyc_match := srfi/cyclone0.19/match-test.scm $(cyc_dep)

# add red/green [FAIL]/[PASS] to output based on the words
# unexpected|ERROR/expected
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ expected / s/$$/ $(GREEN)[PASS]$(RESET)/'\
	    | sed '/unexpected/ s/$$/ $(RED)[FAIL]$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)[FAIL]$(RESET)/'
HANDLE_USRES := sed '/^ok/ s/.*/$(GREEN)[PASS]&$(RESET)/'\
	      | sed '/^not ok/ s/.*/$(RED)[FAIL]&$(RESET)/'\
############################################################
#			   Rules			   #
############################################################
.PHONY: check clean help

help:  ## print this message
	@grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## get rid of log files
	rm -f *.log

.ONESHELL:
clean-cyclone:
	cd $(top_srcdir)
	$(RM) $(cyc_deps)

match-all: $(match_all) ## run all targets for (chibi match) library test suite
srfi-all: $(srfi_all) ## run all targets for examples from srfi

chibi-match-test: export TEST_VERBOSE=true
chibi-match-test: match-test.scm $(chibi_deps) ## run (chibi match) test suite with chibi
	@$(CHIBISHCEME) $(CHIBISHCEMEFLAGS) $< | tee chibi-match-test.log

chibi-srfi-test: export TEST_VERBOSE=true
chibi-srfi-test: srfi-test.scm $(chibi_dep) ## run example code in srfi 204 spec using chibi
	@$(CHIBISHCEME) $(CHIBISHCEMEFLAGS) $< | tee chibi-srfi-test.log

#cyclone-match-test: export TEST_VERBOSE=true #currently causes an error before tests run
cyclone-match-test: $(cyc_match)  ## run (chibi match) test suit using cyclone
	@$(ICYC) $(ICYCFLAGS) $< |& tee cyclone-match-test.log

$(cyc_dep): $(cyc_so_deps)
	@$(CYCC) $<

gauche-match-test: match-test.scm $(match) $(r7rs_deps) ## run (chibi match) test suite with gauche
	@$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

gauche-srfi-test: srfi-test.scm $(srfi) $(r7rs_deps) ## run example code in srfi 204 spec using gauche
	@$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

guile-match-test: match-test.scm $(match) $(guile_deps) ## run (chibi match) test suite with guile
	@$(GUILE) $(GUILEFLAGS) $< |& $(HANDLE_RES)

guile-srfi-test: srfi-test.scm $(srfi) $(guile_deps) ## run example code in srfi 204 spec using guile
	@$(GUILE) $(GUILEFLAGS) $< |& $(HANDLE_RES)

guile-var-test: var-test.scm $(var) $(guile_deps) ## run var tests using guile
	@$(GUILE) $(GUILEFLAGS) $< |& $(HANDLE_RES)

larceny-match-test: match-test.scm $(match) $(r7rs_deps) ## run (chibi match) test suite with larceny
	@$(LARCENY) $(LARCENYFLAGS) $< |& $(HANDLE_RES)

larceny-srfi-test: srfi-test.scm $(srfi) $(r7rs_deps) ## run example code in srfi 204 spec using larceny (fails b/c SRFI 26)
	@$(LARCENY) $(LARCENYFLAGS) $< |& $(HANDLE_RES)

guile-3-srfi-test: srfi-test.scm $(srfi) $(guile_deps) ## run example code in srfi 204 spec using guile-3
	@$(GUILE-3) $(GUILEFLAGS) $< |& $(HANDLE_RES)

chez-match-test: chez-match-test.scm $(match) ## run tests for (chibi match) using chezscheme
	@$(CHEZ) $(CHEZFLAGS) $< |& $(HANDLE_RES) | tee chez-match-test.log

chez-srfi-test: chez-srfi-test.scm $(r6rs_srfi) ## run example code in srfi 204 spec using chezscheme
	@$(CHEZ) $(CHEZFLAGS) $< |& $(HANDLE_RES) | tee chez-srfi-test.log


loko-match-test: export LOKO_LIBRARY_FILE_EXTENSIONS := .sld
loko-match-test: export LOKO_LIBRARY_PATH :=\
       	$(top_srcdir):$(HOME)/.akku/lib:$$LOKO_LIBRARY_PATH
loko-match-test: loko-match-test.scm $(match)  ## run tests for (chibi match) using loko
	@$(LOKO) $(LOKOFLAGS) $< |& $(HANDLE_RES) | tee loko-match-test.log

loko-srfi-test: export LOKO_LIBRARY_FILE_EXTENSIONS := .sld
loko-srfi-test: export LOKO_LIBRARY_PATH :=\
       	$(top_srcdir):$(HOME)/.akku/lib:$$LOKO_LIBRARY_PATH
loko-srfi-test: loko-srfi-test.scm $(r6rs_srfi) ## run example code in srfi 204 spec using loko
	@$(LOKO) $(LOKOFLAGS) $< |& $(HANDLE_RES) | tee loko-srfi-test.log

unsyntax-match-test: unsyntax-match-test.scm $(unsyn_deps) ## run tests for (chibi match) using unsyntax-scheme
	@$(UNSYNTAX) $(UNSYNTAXFLAGS) $< | tee unsyntax-match-test.log | $(HANDLE_USRES)

unsyntax-srfi-test: unsyntax-srfi-test.scm $(unsyn_deps) ## run example code in srfi 204 spec using unsyntax
	@$(UNSYNTAX) $(UNSYNTAXFLAGS) $< | tee unsyntax-srfi-test.log | $(HANDLE_USRES)

false-branch: false-branch-srfi-test.scm ## run false branches of srfi-test w/ util match
	@$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

hello-test: hello-test.scm ## run a passing test using SCM
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)
