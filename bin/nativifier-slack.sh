#!/bin/sh
nativefier -n slack-confluent --disable-gpu \
    --internal-urls='.*\.slack.com|confluent.okta.com' \
    --title-bar-style hidden \
    --single-instance --electron-version 27.0.0 \
    https://confluent.slack.com/ ~/nativefier-apps
