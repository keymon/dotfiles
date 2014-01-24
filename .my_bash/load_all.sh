for i in $(dirname -- $BASH_SOURCE)/*.sh; do
	case $i in
		$BASH_SOURCE) continue;;
		*) . ./$i;;
	esac
done
