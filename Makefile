.PHONY: test

test: test/test*
	test/bash_unit -f tap test/test*
