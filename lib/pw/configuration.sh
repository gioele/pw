DB=passwords
CONFIG_FILE=${XDG_CONFIG_HOME:-$HOME/.config}/pw

CONFIG_DIRS=$(echo "${XDG_CONFIG_DIRS:-/etc/xdg}" | tr ':' '\n')
CONFIG_DIRS=$(printf '%s\n%s' "$CONFIG_DIRS" "${XDG_CONFIG_HOME:-$HOME/.config}")

old_ifs=$IFS
IFS=$(printf '\n\b')
for dir in $CONFIG_DIRS ; do
	[ -f "$dir/pw" ] && . "$dir/pw" || true
done
IFS=$old_ifs

# This is free software released into the public domain (CC0 license).
