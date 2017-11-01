NAME=kich
VERSION=0.1.0
AUTHOR=fengb
URL=https://github.com/$(AUTHOR)/$(NAME)

DIRS=bin
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null`

PREFIX?=/usr/local

test: test/* features/*
	#test/bash_unit -f tap test/test*
	cucumber --tags ~@benchmark

benchmark: features/*
	cucumber --tags @benchmark

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(DESTDIR)$(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(DESTDIR)$(PREFIX)/$$file; done

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(DESTDIR)$(PREFIX)/$$file; done

.PHONY: all test cucumber install uninstall
