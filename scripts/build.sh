#!/bin/bash

# SETUP
cd $WORKSPACE

# DOWNLOAD GEM DEPENDENCIES
bundle package --verbose

## BUILD SENSU ##
gem build sensu.gemspec

## PACKAGE SENSU ##
fpm --iteration $BUILD_NUMBER --gem-bin-path=/usr/bin -a x86_64 -t rpm -s gem ./sensu*.gem

## PACKAGE SENSU DEPENDENCIES ##
build-deps.sh x86_64

## CLEAN UP BUILD ARTIFACTS ##
rm -rf $WORKSPACE/RPMS/x86_64/build-*

