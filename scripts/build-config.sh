#!/bin/bash

## PACKAGE SENSU CONFIG ##
echo "** PACKAGING ** rubygem-sensu-config ..."
fpm  -n rubygem-sensu-config --description "Sensu example configurations and directory layouts" --depend "rubygem-sensu" --iteration $BUILD_NUMBER  -a noarch -t rpm -s dir -C $WORKSPACE/rpms/config --pre-install $WORKSPACE/rpms/pre --post-install $WORKSPACE/rpms/post --pre-uninstall $WORKSPACE/rpms/preun > /dev/null 2>&1

# Clean up build artifacts
rm -rf build-rpm*

# Move build into repository
mv rubygem-sensu-config*.rpm $WORKSPACE/RPMS/sensu/noarch/
