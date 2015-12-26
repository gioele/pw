red=$(tput setab 1)
reset=$(tput sgr0)

ok () { echo "ok" ; echo ; }
ok_step ()  { echo "ok (preparatory step)" ; }
failed () { echo $red "FAILED" $reset ; echo ; }
failed_step () { echo $red "FAILED (preparatory step)" $reset ; }

fixtures_dir="`dirname $0`/fixtures"

PW_INSERT="`dirname $0`/../bin/pw-insert -b"
PW_SHOW="`dirname $0`/../bin/pw-show"
PW_DIFF="`dirname $0`/../bin/pw-diff"

export XDG_CONFIG_HOME=${fixtures_dir}
export GPG_OPTS="--homedir ${fixtures_dir}/keys"
