#!/bin/sh
script_dir="$(command cd "$(dirname $0)"; pwd)"
DOIT=${DOIT:-}
dummy=${dummy:-}
if [ -z "$DOIT" ]; then
  echo "Running in dry-noop mode. Use 'DOIT=true $0 $@' to run it"
  dummy="echo"
fi

cd $script_dir

find ./ -type d | sed 's|./||' | xargs -r -n 1 -I {} $dummy mkdir -p /{}
find ./ -type f -not -path ./install.sh | sed 's|./||' | xargs -r -n 1 -I {} $dummy ln -snf $script_dir/{} /{}
