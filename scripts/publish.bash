#!/usr/bin/env bash

# How to use: bash scripts/publish.bash

flutter pub get
flutter format .
dart pub publish
