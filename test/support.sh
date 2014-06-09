ok () { echo "ok" ; echo ; }
failed () { echo "FAILED" ; echo ; }

fixtures_dir="`dirname $0`/fixtures"

PW_INSERT="`dirname $0`/../bin/pw-insert -b"
PW_SHOW="`dirname $0`/../bin/pw-show"

export XDG_CONFIG_HOME=${fixtures_dir}
export GPG_OPTS="--homedir ${fixtures_dir}/keys"
