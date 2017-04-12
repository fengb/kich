.PHONY: test cucumber

all: test cucumber

cucumber:
	cucumber

test: test/test*
	test/bash_unit -f tap test/test*
