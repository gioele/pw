is_numeric () { test "$1" && printf '%i' "$1" >/dev/null 2>&1 ; }

error_pw () { printf 'ERROR: %s\n' "$1" >&2 ; }
msg_pw () { printf '%s\n' "$1" >&2 ; }

is_input_interactive () { test -t 0 ; }
is_output_interactive () { test -t 1 ; }

file_for_db () {
	local data_dir

	case "$1" in
		../*|./*|/*)
			echo "$1" ;;
		*)
			[ -f "$1" ] && echo "$1" && exit

			data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
			echo "$data_dir/pw/$1" ;;
	esac
}

extract_version_number () { echo "$1" | cut -c 1 ; }

encrypted_with_pk () { echo "$1" | grep -q "p" ; }

mktemp_pw () { mktemp ${TMPDIR:-/tmp}/pw.tmpXXXXXXXX ; }
mktemp_dir_pw () { mktemp -d ${TMPDIR:-/tmp}/pw.tmpXXXXXXXX ; }

auto_rm_cmd () { echo "trap 'rm -f \"$1\"' HUP QUIT PIPE TERM EXIT ; trap 'rm -f \"$1\" ; trap - INT ; kill -INT $$' INT" ; }
auto_rm_dir_cmd () { echo "trap 'rm -Rf \"$1\"' HUP QUIT PIPE TERM EXIT ; trap 'rm -f \"$1\" ; trap - INT ; kill -INT $$' INT" ; }

base64_pw () { base64 -w 0 | tr '/+' '_-' ; }
base64_d_pw () { tr '_-' '/+' | base64 -d 2>/dev/null ; }

sha1_pw () { sha1sum ; }

gpg_encrypt () {
	local key opts
	key="$1" ; shift
	opts=${GPG_OPTS:-}
	gpg ${opts} --encrypt --recipient "$key" --batch --quiet
}

gpg_decrypt () {
	local opts
	opts=${GPG_OPTS:-}
	gpg ${opts} --decrypt --batch --quiet 2>/dev/null
}

gui_send_key () { xdotool key --clearmodifiers "$1" ; }

gui_type () { xdotool type "$1" ; }

matches_field () {
	local pattern field key
	pattern="$1"
	field="$2"
	key="$3"

	[ -z "$key" ] && key='[^:]\+'

	printf '%s' "$field" | grep -q "^$key: $pattern\$"
}

# This is free software released into the public domain (CC0 license).
