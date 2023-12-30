#!/usr/bin/env zsh

cd ../mobile || return

flutter test --coverage

lcov \
  --remove coverage/lcov.info \
  -o coverage/lcov_group1.info \
  'lib/network/*' \
  'lib/util/*' \
  'lib/routes/*/bloc/*_event.dart' \
  'lib/routes/*/bloc/*_state.dart' \
  'lib/routes/*/model/request/*' \
  'lib/routes/*/model/response/*' \
  'lib/routes/login/model/*' \
  'lib/routes/register/bloc/*' \
  'lib/routes/register/model/*model*.dart' \
  'lib/routes/register/register_route.dart' \
  'lib/routes/edit_story/model/*' \
  'lib/routes/recommendations/model/*' \
  'lib/routes/search/model/*' \
  'lib/routes/activity_stream/model/*' \
  'lib/routes/profile/bloc/*' \
  'lib/routes/profile/widget' \
  'lib/routes/profile/profile_route.dart' \
  'lib/routes/home/model/response/*' \
  'lib/routes/home/model/*model*.dart' \
  'lib/routes/story_detail/bloc/*' \
  'lib/routes/story_detail/model/request/*' \
  'lib/routes/story_detail/model/*model*.dart' \
  'lib/routes/story_detail/widget/*' \
  'lib/routes/story_detail/story_detail_route.dart' \
  'lib/routes/create_story/model/*' \
  'lib/routes/create_story/create_story_repository.dart'

genhtml coverage/lcov_group1.info \
  --output=coverage \
  --legend \
  --title "SWE574 - Fall2023 - Group1 - Mobile Test Coverage"

open coverage/html/index.html

cd ..
