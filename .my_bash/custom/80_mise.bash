# mise shims first on PATH (installed by keyhouse-config scripts/bootstrap_mise.sh)
case ":$PATH:" in
	*":$HOME/.local/share/mise/shims:"*) ;;
	*) [ -x "$HOME/.local/bin/mise" ] && eval "$("$HOME/.local/bin/mise" activate bash --shims)" ;;
esac
