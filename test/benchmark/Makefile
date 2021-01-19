# VARIABLES

# environment
top_srcdir = $(abspath ../..)
SHELL := bash
VPATH := .:../..

#interpreter, flags
GUILE = guile
GUILEFLAGS = --no-auto-compile -L $(top_srcdir) -x .guile.sls

#dependencies
var_deps := var-test.scm var-vs-no-var.scm

# add red/green [FAIL]/[PASS] to output based on the words
# unexpected|ERROR/expected
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
RESET := $(shell tput sgr0)
HANDLE_RES := sed '/ expected / s/$$/ $(GREEN)[PASS]$(RESET)/'\
	    | sed '/unexpected/ s/$$/ $(RED)[FAIL]$(RESET)/'\
	    | sed '/^ERROR:/ s/$$/ $(RED)[FAIL]$(RESET)/'

# RULES
.PHONY: clean help

help:  ## print this message
	@grep -E '^[^ :]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

var-test.log: $(var_deps) ## test various configurations of var
	@$(GUILE) $(GUILEFLAGS) $< |& $(HANDLE_RES)

clean:  ## get rid of log files
	rm -f *.log
