#!/usr/bin/env bash

set -euxo pipefail

cd mobile
flutter --version
flutter pub get
flutter test --coverage
flutter test golden_test/ --update-goldens
cd ..
