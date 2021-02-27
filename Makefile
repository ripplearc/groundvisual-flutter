SHELL := /bin/bash

log:help

## install_debug_build   : build debug version and then install
install_debug_build:
	$(info  Build and Install Debug Build 🐞🐞🐞)
	flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-debug.yaml
	flutter build apk --debug --split-per-abi
	flutter install

## install_release_build    : build release version and then install
install_release_build:
	$(info  Build and Install Release Build 📔📔📔)
	flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-release.yaml
	flutter build apk --split-per-abi
	flutter install

help: Makefile
	sed -n "s/^##//p" $<
