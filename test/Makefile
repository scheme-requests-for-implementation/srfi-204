############################################################
#			 Variables			   #
############################################################
top_srcdir = ..
SHELL := bash
SCM = guile
SCMFLAGS = --no-auto-compile -L $(top_srcdir)
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
	rm -f $(LOGS)

$(NAMES): $(TESTS)
	@$(SCM) $(SCMFLAGS) $@.scm |& $(HANDLE_RES)

%.log: %.scm
	@$(SCM) $(SCMFLAGS) $< |& $(HANDLE_RES)

