#!/bin/sh

# set up an append-only strategy for merges and conflicts
git config --global merge.pw.name 'Append-only merge strategy for pw databases'
git config --global merge.pw.driver 'tmp=$(mktemp) ; (comm -12 %A %B ; comm -13 %O %A ; comm -13 %O %B ) >| $tmp ; mv $tmp %A'

# set up the diff program for password files

# FIXME: use pw-diff instead of textconv
git config --global diff.pw.textconv "pw-show -c -d"

db_dir=${XDG_DATA_HOME:-$HOME/.local/share}/pw
grep -q '^* diff=pw merge=pw$' $db_dir/.gitattributes || \
	echo '* diff=pw merge=pw' >> $db_dir/.gitattributes
grep -q '^.* diff merge$' $db_dir/.gitattributes || \
	echo '.* diff merge' >> $db_dir/.gitattributes

# This is free software released into the public domain (CC0 license).
