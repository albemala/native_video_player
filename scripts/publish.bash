#!/usr/bin/env bash

# How to use: bash scripts/publish.bash

flutter pub get
dart format .
dart pub publish
