PREFIX=/usr/local

.PHONY: all
all:

.PHONY: install
install:
	install -d $(PREFIX)/bin
	install bin/git-pw-diff $(PREFIX)/bin
	install bin/pw-autotype $(PREFIX)/bin
	install bin/pw-edit $(PREFIX)/bin
	install bin/pw-insert $(PREFIX)/bin
	install bin/pw-show $(PREFIX)/bin
	install -d $(PREFIX)/lib/pw
	install lib/pw/configuration.sh $(PREFIX)/lib/pw
	install lib/pw/functions.sh $(PREFIX)/lib/pw

.PHONY: test
test: | test/fixtures/keys/secring.gpg test/fixtures/good
	test/show
	test/insert
	test/diff

test/fixtures/keys/secring.gpg:
	test/gen-keys

test/fixtures/good: test/fixtures/keys/secring.gpg
	test/gen-dbs

.PHONY: realclean
realclean:
	rm -Rf test/fixtures

# This is free software released into the public domain (CC0 license).
