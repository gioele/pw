PREFIX=/usr/local

.PHONY: all
all:

.PHONY: install
install:
	mkdir -p $(PREFIX)/bin
	for exe in git-pw-diff pw-autotype pw-diff pw-edit pw-insert pw-show ; do \
		cp bin/$${exe} $(PREFIX)/bin ; \
		chmod a+rx $(PREFIX)/bin/$${exe} ; \
	done
	mkdir -p $(PREFIX)/lib/pw
	chmod a+rx $(PREFIX)/lib/pw
	for lib in configuration.sh functions.sh ; do \
		cp lib/pw/$${lib} $(PREFIX)/lib/pw ; \
		chmod a+r $(PREFIX)/lib/pw/$${lib} ; \
	done

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
