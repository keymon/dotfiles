if which pnpm 2>&1 >/dev/null; then
	export PNPM_HOME="${HOME}/.local/share/pnpm"
	case ":$PATH:" in
		*":$PNPM_HOME:"*) ;;
		*) export PATH="$PNPM_HOME:$PATH" ;;
	esac
	mkdir -p "${HOME}/.local/share/pnpm"
fi
