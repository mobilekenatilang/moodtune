#!/bin/bash

flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --debug