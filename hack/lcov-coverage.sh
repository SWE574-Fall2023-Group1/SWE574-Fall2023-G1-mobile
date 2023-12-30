#!/usr/bin/env bash

set -euxo pipefail

sudo apt-get update -qqy
sudo apt-get install -qqy lcov >/dev/null
cd mobile
lcov \
  --remove coverage/lcov.info \
  -o coverage/lcov_group1.info \
  'lib/network/*' \
  'lib/routes/login/bloc/*_event.dart' \
  'lib/routes/login/bloc/*_state.dart' \
  'lib/routes/login/model/*' \
  'lib/routes/register/bloc/*' \
  'lib/routes/register/model/*model*.dart' \
  'lib/routes/register/register_route.dart' \
  'lib/util/*' \
  'lib/routes/profile/bloc/*' \
  'lib/routes/profile/model/request/*' \
  'lib/routes/profile/model/response/*' \
  'lib/routes/profile/widget' \
  'lib/routes/profile/profile_route.dart' \
  'lib/routes/home/model/response/*' \
  'lib/routes/home/model/*model*.dart' \
  'lib/routes/story_detail/bloc/*' \
  'lib/routes/story_detail/model/request/*' \
  'lib/routes/story_detail/model/*model*.dart' \
  'lib/routes/story_detail/widget/*' \
  'lib/routes/story_detail/story_detail_route.dart'

genhtml coverage/lcov_group1.info \
  --output=coverage \
  --legend \
  --title "SWE574 - Fall2023 - Group1 - Mobile Test Coverage"
cd ..
