#!/bin/bash

# SETUP
cd $WORKSPACE
export PATH=$PATH:$WORKSPACE:$WORKSPACE/scripts

# DOWNLOAD GEM DEPENDENCIES
bundle package --verbose

## BUILD SENSU ##
gem build sensu.gemspec

## PACKAGE SENSU ##
SENSUGEM=`ls sensu*.gem`

echo "** PACKAGING ** $SENSUGEM ..."
fpm --iteration $BUILD_NUMBER --gem-bin-path=/usr/bin -a x86_64 -t rpm -s gem $SENSUGEM > /dev/null 2>&1

## PACKAGE SENSU DEPENDENCIES ##
build-deps.sh x86_64

## CLEAN UP BUILD ARTIFACTS ##
rm -rf $WORKSPACE/RPMS/x86_64/build-*

