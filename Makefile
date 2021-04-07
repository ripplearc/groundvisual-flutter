SHELL := /bin/bash

log:help

## install_debug_build   : build debug version and then install
install_debug_build:
	$(info  Build and Install Debug Build 🐞🐞🐞)
	flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-debug.yaml
	flutter build apk --debug --split-per-abi --no-sound-null-safety
	flutter install

## install_release_build    : build release version and then install
install_release_build:
	$(info  Build and Install Release Build 📔📔📔)
	flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-release.yaml
	flutter build apk --split-per-abi --no-sound-null-safety
	flutter install

## install_web_build    : build web version and then run the server
install_web_build:
	$(info  Build and Run Web Build 🎭🎭🎭)
	flutter build web --no-sound-null-safety
	flutter pub global run dhttpd --path ~/Documents/rc/Software/groundvisual_flutter/build/web

help: Makefile
	sed -n "s/^##//p" $<
