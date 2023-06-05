#!/usr/bin/env bash

# How to use: bash scripts/run-build-runner.bash

dart run build_runner build --delete-conflicting-outputs --build-filter='lib/**'
dart format .
