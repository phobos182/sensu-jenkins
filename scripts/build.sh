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
sudo bundle package --verbose
sudo chown -R jenkins: *

## BUILD SENSU ##
echo "*- BUILDING GEM -* sensu ..."
gem build sensu.gemspec

## PACKAGE SENSU ##
SENSUGEM=`ls sensu*.gem`
echo "** PACKAGING ** $SENSUGEM ..."
fpm --iteration $BUILD_NUMBER --gem-bin-path=/usr/bin -a x86_64 -t rpm -s gem $SENSUGEM > /dev/null 2>&1
rm -rf build-rpm*
mv rubygem-sensu*.rpm $WORKSPACE/RPMS/sensu/x86_64/

## PACKAGE SENSU DEPENDENCIES ##
#build-deps.sh x86_64
build-config.sh

## CREATE RPM REPOSITORIES ##
createrepo -v $WORKSPACE/RPMS/sensu/x86_64
createrepo -v $WORKSPACE/RPMS/sensu/i386
createrepo -v $WORKSPACE/RPMS/sensu/noarch
createrepo -v $WORKSPACE/RPMS/sensu-dependencies/x86_64
createrepo -v $WORKSPACE/RPMS/sensu-dependencies/i386
createrepo -v $WORKSPACE/RPMS/sensu-dependencies/noarch

