#!/usr/bin/env bash

set -euxo pipefail

cd mobile
flutter --version
flutter pub get
flutter test --coverage
cd ..
