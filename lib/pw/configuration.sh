DB=${XDG_DATA_HOME:-$HOME/.local/share}/pw/passwords
CONFIG_FILE=${XDG_CONFIG_HOME:-$HOME/.config}/pw

[ -f $CONFIG_FILE ] && . $CONFIG_FILE || true
