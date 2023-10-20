alias assume='source $(asdf which assume)'

assume_export() {
	assume --export cc-production-1/prod-administrator; assume --unset
	assume --export cc-staging-1/nonprod-administrator; assume --unset
	assume --export cc-devel-1/nonprod-administrator; assume --unset
}

granted_login() {
	granted sso login --sso-start-url https://d-926757b88b.awsapps.com/start --sso-region us-west-2
}

granted_reload() {
	firefox 'https://confluentinc.awsapps.com/start#/signout'
	sleep 5;
	granted sso-tokens clear --all
	granted sso login --sso-start-url https://d-926757b88b.awsapps.com/start --sso-region us-west-2
}

