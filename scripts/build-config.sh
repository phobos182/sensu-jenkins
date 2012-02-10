#!/bin/bash

## GET FILES TO PACKAGE ##
FILES=$(find ./rpms/config/ -xtype f|sed -e 's/\.\/rpms\/config//'|xargs -L1 -I{} echo "{}\n"|tr -d '\n'|sed -e 's/\//\\\//g')

## SET EDITOR TO REPLACE FILE LIST / CHANGE OWNER ##
export EDITOR="sed -i -e \"s/^\/\./$FILES/g\""

## PACKAGE SENSU CONFIG ##
echo "** PACKAGING ** rubygem-sensu-config ..."
fpm  -n rubygem-sensu-config --description "Sensu example configurations and directory layouts" -d "rubygem-sensu" --iteration $BUILD_NUMBER  -a noarch -t rpm -s dir -e -C $WORKSPACE/rpms/config --pre-install $WORKSPACE/rpms/pre --post-install $WORKSPACE/rpms/post --pre-uninstall $WORKSPACE/rpms/preun --url "https://github.com/sonian/sensu" > /dev/null 2>&1

# Clean up build artifacts
rm -rf build-rpm*

# Move build into repository
mv rubygem-sensu-config*.rpm $WORKSPACE/RPMS/sensu/noarch/
