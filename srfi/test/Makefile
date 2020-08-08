############################################################
#			 Variables			   #
############################################################
#TODO refactor so SCM and SCMFLAGS match implementation in
#     beginning of test name. Should probably also get rid
#     of bash dependency.
top_srcdir = ..
SHELL := bash
GUILE = guile
GUILE-3 = ../../../../tgzs/guile-3.0.4/meta/guile
GUILEFLAGS = --no-auto-compile -L $(top_srcdir)
GOSH = gosh
GOSHFLAGS = -I $(top_srcdir)
#TODO have not found a way to make larceny work from Makefile
#     open "larceny -r7rs -I .." instead and
#     (include "test/match-test.scm")
LARCENY = larceny
LARCENYFLAGS = -r7rs -I $(top_srcdir) --
CHEZSCHEME = chezscheme
CHEZSCHEMEFLAGS = --libdirs $(top_srcdir)/chezscheme9.5 

# chose implentation based on TESTSCHEME
# from environment
ifeq ($(TESTSCHEME), gosh)
	SCM = $(GOSH)
	SCMFLAGS = $(GOSHFLAGS)
else
ifeq ($(TESTSCHEME), larceny)
	SCM = $(LARCENY)
	SCMFLAGS = $(LARCENYFLAGS)
else
ifeq ($(TESTSCHEME), chezscheme)
	SCM = $(CHEZSCHEME)
	SCMFLAGS = $(CHEZSCHEMEFLAGS)
else
ifeq ($(TESTSCHEME), guile-3)
	SCM = $(GUILE-3)
	SCMFLAGS = $(GUILEFLAGS)
else
	SCM = $(GUILE)
	SCMFLAGS = $(GUILEFLAGS)
endif
endif
endif
endif

MAKEFILE_LIST = Makefile
TESTS := $(wildcard *-test.scm)
NAMES := $(subst .scm,,$(TESTS))
LOGS := $(addsuffix .log,$(NAMES))
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ expected / s/$$/ $(GREEN)[PASS]$(RESET)/'\
	    | sed '/unexpected/ s/$$/ $(RED)[FAIL]$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)[FAIL]$(RESET)/'
############################################################
#			   Rules			   #
############################################################
.PHONY: check clean help useguile 

help:  ## print this message
	@grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
check: $(LOGS)  ## run all tests
	@echo "tests complete"

clean:  ## get rid of log files
	rm -f *.log

$(NAMES): $(TESTS) ## the name of a particular test (minus .scm) runs that test
	@$(SCM) $(SCMFLAGS) $@.scm |& $(HANDLE_RES)

%.log: %.scm
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

#targets that set implementation
useguile: ## set to run tests with guile
	@export TESTSCHEME=guile

usegosh: ## set to run tests with gosh
	@export TESTSCHEME=gosh

uselarceny: ## set to run tests with larceny **BROKEN**
	@export TESTSCHEME=larceny

usechezscheme: ## set to run tests with chezscheme
	@export TESTSCHEME=chezscheme

useguile-3: ## set to run with guile-3 (local alias)
	@export TESTSCHEME=guile-3
