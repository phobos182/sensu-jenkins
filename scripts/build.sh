#!/bin/bash

# SETUP
cd $WORKSPACE

if ! [ -d $WORKSPACE/RPMS/sensu/ ]; then
  mkdir -p $WORKSPACE/RPMS/sensu/x86_64
  mkdir -p $WORKSPACE/RPMS/sensu/i386
  mkdir -p $WORKSPACE/RPMS/sensu/noarch
  mkdir -p $WORKSPACE/RPMS/sensu-dependencies/x86_64
  mkdir -p $WORKSPACE/RPMS/sensu-dependencies/i386
  mkdir -p $WORKSPACE/RPMS/sensu-dependencies/noarch
fi

# DOWNLOAD GEM DEPENDENCIES
bundle package --verbose

## BUILD SENSU ##
gem build sensu.gemspec

## PACKAGE SENSU ##
fpm --iteration $BUILD_NUMBER --gem-bin-path=/usr/bin -a x86_64 -t rpm -s gem ./sensu*.gem
mv rubygem-sensu*.rpm $WORKSPACE/RPMS/sensu/x86_64/

## PACKAGE SENSU DEPENDENCIES ##
build-deps.sh x86_64

## CLEAN UP BUILD ARTIFACTS ##
find $WORKSPACE/RPMS/ -type d -name 'build-*' -exec rm -rf {} \;

