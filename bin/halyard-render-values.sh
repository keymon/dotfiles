#!/bin/bash

set -e -o pipefail -u

service=$1

halprod() {
    $HOME/bin/halctl \
    --vault-token $(cat ~/.vault-token) \
    --context prod \
    --vault-login-path auth/app/prod/login \
    --vault-oidc-role halyard-prod $@
}

cat ./.halyard/${service}.yaml | \
    sed '
        s|\(source: helm://helm-cloud\)/.*|\1/cc-empty-service-hector|;
        s|\(sourceVersion:\) .*|\1 0.0.0|
    ' > ./.halyard/${service}.values.yaml

halprod renderer verify-render-for-cluster \
    -c eks-mothership-devel \
    -f ./.halyard/${service}.values.yaml  | tee /tmp/values.yaml

cat <<EOF

File in /tmp/values.yaml. To test it:

    helm template ./charts/${service} -f /tmp/values.yaml
EOF
