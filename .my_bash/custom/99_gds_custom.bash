if [ -z "${VIRTUALENV}" ]; then
	workon paas-cf
fi
. ~/workspace/aws_key_management/awssts.sh
if ! echo $GEM_HOME |  grep @ -q; then
	rvm use --create ruby-2.4.1@paas-cf
fi
