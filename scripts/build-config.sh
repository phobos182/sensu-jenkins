#!/bin/bash

## PACKAGE SENSU CONFIG ##
echo "** PACKAGING ** rubygem-sensu-config ..."
fpm  -n rubygem-sensu-config --description "Sensu example configurations and directory layouts" --depend "rubygem-sensu" --iteration $BUILD_NUMBER  -a noarch -t rpm -s dir -C $WORKSPACE/rpms/config --pre-install $WORKSPACE/scripts/pre --post-install $WORKSPACE/scripts/post --pre-uninstall $WORKSPACE/scripts/preun > /dev/null 2>&1

