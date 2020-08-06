############################################################
#			 Variables			   #
############################################################
#TODO refactor so SCM and SCMFLAGS match implementation in
#     beginning of test name. Should probably also get rid
#     of bash dependency.
top_srcdir = ..
SHELL := bash
GUILE = guile
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
	SCM = $(GUILE)
	SCMFLAGS = $(GUILEFLAGS)
endif
endif
endif

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
.PHONY: check clean


check: $(LOGS)
	@echo "tests complete"

clean:
	rm -f *.log

$(NAMES): $(TESTS)
	@$(SCM) $(SCMFLAGS) $@.scm |& $(HANDLE_RES)

%.log: %.scm
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

