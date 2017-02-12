# Load the custom .*-pass I have
for i in ~/.password-store ~/.*-pass; do
	[ -e $i/.load.bash ] && . $i/.load.bash
done
