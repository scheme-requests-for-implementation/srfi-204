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

# dependencies
srfi-206 := $(wildcard srfi/206/*)
r7rs_deps := srfi/204.sld srfi/204/204.scm srfi/206.sld $(srfi-206)
chibi_deps := srfi/match-test.sld $(r7rs_deps)
r6rs_deps := srfi/204/204.scm srfi/204/auxiliary-syntax.scm
guile_deps := srfi/srfi-204.guile.sls $(r6rs_deps)
chez_deps := srfi/204/:204.chezscheme.sls $(r6rs_deps)
loko_deps := srfi/204/%3a204.loko.sls $(r6rs_deps)
match_all :=  chibi-match-test chez-match-test gauche-match-test\
	guile-match-test larceny-match-test loko-match-test
match := match-common.scm

# grab all files ending in -test.scm and use them to make targets
# so tests in example-test.scm can be run with make example-test
TESTS := $(wildcard *-test.scm)
NAMES := $(subst .scm,,$(TESTS))
LOGS := $(addsuffix .log,$(NAMES))

# add red/green [FAIL]/[PASS] to output based on the words
# unexpected|ERROR/expected
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ expected / s/$$/ $(GREEN)[PASS]$(RESET)/'\
	    | sed '/unexpected/ s/$$/ $(RED)[FAIL]$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)[FAIL]$(RESET)/'
############################################################
#			   Rules			   #
############################################################
.PHONY: check clean help

help:  ## print this message
	@grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
check: $(LOGS)  ## run all tests
	@echo "tests complete"

clean:  ## get rid of log files
	rm -f *.log

# $(NAMES): $(TESTS) ## the name of a particular test (minus .scm) runs that test
# 	@$(SCM) $(SCMFLAGS) $@.scm |& $(HANDLE_RES)

match-all: $(match_all) ## run srfi 204 library test suite with all implementations
       	

chibi-match-test: export TEST_VERBOSE=true
chibi-match-test: match-test.scm $(chibi_deps) ## run srfi 204 library test suite with chibi
	@$(CHIBISHCEME) $(CHIBISHCEMEFLAGS) $< | tee chibi-match-test.log

gauche-match-test: match-test.scm $(match) $(r7rs_deps)
	@$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

guile-match-test: match-test.scm $(match) $(guile_deps)
	@$(GUILE) $(GUILEFLAGS) $< |& $(HANDLE_RES)

larceny-match-test: match-test.scm $(match) $(r7rs_deps)
	@$(LARCENY) $(LARCENYFLAGS) $< |& $(HANDLE_RES)

srfi-test: export TEST_VERBOSE=true # for chibi
srfi-test: srfi-test.scm ## run example code in srfi 204 spec using TESTSCHEME
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

chez-match-test: chez-match-test.scm ## run tests for srfi 204 library using chezscheme
	@$(CHEZ) $(CHEZFLAGS) $< |& $(HANDLE_RES)

chez-srfi-test: chez-srfi-test.scm ## run example code in srfi 204 spec using chezscheme
	@$(CHEZ) $(CHEZFLAGS) $< |& $(HANDLE_RES)


loko-match-test: export LOKO_LIBRARY_FILE_EXTENSIONS := .sld
loko-match-test: export LOKO_LIBRARY_PATH :=\
       	$(top_srcdir):$(HOME)/.akku/lib:$$LOKO_LIBRARY_PATH
loko-match-test: loko-match-test.scm ## run tests for srfi 204 library using loko
	@$(LOKO) $(LOKOFLAGS) $< |& $(HANDLE_RES)

loko-srfi-test: export LOKO_LIBRARY_FILE_EXTENSIONS := .sld
loko-srfi-test: export LOKO_LIBRARY_PATH :=\
       	$(top_srcdir):$(HOME)/.akku/lib:$$LOKO_LIBRARY_PATH
loko-srfi-test: loko-srfi-test.scm ## run example code in srfi 204 spec using loko
	@$(LOKO) $(LOKOFLAGS) $< |& $(HANDLE_RES)

false-branch: false-branch-srfi-test.scm ## run false branches of srfi-test w/ util match
	@$(GOSH) $(GOSHFLAGS) $< |& $(HANDLE_RES)

hello-test: hello-test.scm ## run a passing test using TESTSCHEME
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

%.log: %.scm
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

