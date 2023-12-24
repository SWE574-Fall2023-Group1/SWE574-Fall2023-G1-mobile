#!/usr/bin/env bash

set -euxo pipefail

sudo apt-get update -qq -y && sudo apt-get install -qq -y lcov
cd mobile
lcov \
    --remove coverage/lcov.info \
        'util/*' \
        'lib/network/*' \
        'routes/login/bloc/*_event.dart' \
        'routes/login/bloc/*_state.dart' \
        'routes/login/model/*' \
    -o coverage/lcov_group1.info
genhtml coverage/lcov_group1.info --output=coverage
cd ..
