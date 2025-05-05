#!/usr/bin/env bash

# How to use: bash scripts/generate-api.bash

dart run pigeon --input pigeon/api.dart
dart format lib/src/api.g.dart

cp apple/Sources/Api.g.swift ios/Sources/
