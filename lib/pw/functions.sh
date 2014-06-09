is_numeric () { test "$1" && printf '%i' "$1" >/dev/null 2>&1 ; }

is_input_interactive () { test -t 0 ; }
is_output_interactive () { test -t 1 ; }

mktemp_pw () { mktemp ${TMPDIR:-/tmp}/pw.tmpXXXXXXXX ; }

auto_rm_cmd () { echo "trap 'rm -f \"$1\"' HUP QUIT PIPE TERM EXIT ; trap 'rm -f \"$1\" ; trap - INT ; kill -INT $$' INT" ; }

base64_pw () { base64 -w 0 | tr '/+' '_-' ; }
base64_d_pw () { tr '_-' '/+' | base64 -d 2>/dev/null ; }

sha1_pw () { sha1sum ; }

gpg_encrypt () {
	key="$1" ; shift
	opts=${GPG_OPTS:-}
	gpg ${opts} --encrypt --recipient "$key" --batch --quiet
}

gpg_decrypt () {
	opts=${GPG_OPTS:-}
	gpg ${opts} --decrypt --batch --quiet 2>/dev/null
}

matches_fields () {
	pattern=$1
	shift

	# the rest are fields

	[ -z "$pattern" ] && return 0

	for field ; do
		value=${field#*: }
		if printf '%s' "$value" | grep -q "^$pattern\$" ; then
			return 0
		fi
	done

	return 1
}

# This is free software released into the public domain (CC0 license).
