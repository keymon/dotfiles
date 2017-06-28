# Config for MMG
mmgaws() {
    workon mmg
    append_path PATH ~/workspace/blackbox/bin
    append_path PATH ~/local/mmg
    export AWS_DEFAULT_REGION=eu-west-1
    eval $(
        EMAIL=hector.rivas@mergermarket.com \
        MMG_PASSWORD=$(pass work/mmg/hector.rivas@mergermarket.com) \
        ~/mmg/mmgaws/mmgaws $1 ${2:-admin}
    )
    AWS_ACCOUNT_NAME=$1
}


