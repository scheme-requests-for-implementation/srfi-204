############################################################
#			 Variables			   #
############################################################

# environment
top_srcdir = ..
SHELL := bash

# interpreters and flags
GUILE = guile
GUILE-3 = ../../../../tgzs/guile-3.0.4/meta/guile
GUILEFLAGS = --no-auto-compile -L $(top_srcdir) -x .sld
GOSH = gosh
GOSHFLAGS = -I $(top_srcdir)
#TODO have not found a way to make larceny work from Makefile
#     open "larceny -r7rs -I .." instead and
#     (include "test/match-test.scm")
LARCENY = larceny
LARCENYFLAGS = -r7rs -I $(top_srcdir) -program
CHEZSCHEME = chezscheme
CHEZSCHEMEFLAGS = --libdirs $(top_srcdir)/chezscheme9.5
CHIBISHCEME = chibi-scheme
CHIBISHCEMEFLAGS = -I $(top_srcdir)

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
ifeq ($(TESTSCHEME), chibi-scheme)
	SCM = $(CHIBISHCEME)
	SCMFLAGS = $(CHIBISHCEMEFLAGS)
else
	SCM = $(GUILE)
	SCMFLAGS = $(GUILEFLAGS)
endif
endif
endif
endif
endif

# used in help target
MAKEFILE_LIST = Makefile

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

$(NAMES): $(TESTS) ## the name of a particular test (minus .scm) runs that test
	@$(SCM) $(SCMFLAGS) $@.scm |& $(HANDLE_RES)

%.log: %.scm
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

