############################################################
#			 Variables			   #
############################################################
#TODO refactor so SCM and SCMFLAGS match implementation in
#     beginning of test name. Should probably also get rid
#     of bash dependency.
top_srcdir = ..
SHELL := bash
#SCM = guile
#SCMFLAGS = --no-auto-compile -L $(top_srcdir)
#SCM = gosh
#SCMFLAGS = -I $(top_srcdir)
SCM = larceny
SCMFLAGS = -r7rs -I $(top_srcdir)
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

