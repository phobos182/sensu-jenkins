#!/bin/bash
ARCH="$1"

if ! [ -d $WORKSPACE/vendor/cache/ ]; then
  exit 1
fi

echo "*- PACKAGING DEPENDENCIES -*"

FILES="$WORKSPACE/vendor/cache/*"

# Get a list of development gems
DEVGEMS=`cat ./sensu.gemspec | grep -i development | cut -f2 -d'"' | tr '\n' ','`

# SED TO FIX BROKEN GEMSPECS #
export EDITOR="sed -i -e \"s/\=\,/1/g\""

# For each gem in the bundle
for f in $FILES
do
  # String manipulate the gem file into just the name of the gem
  GEM=${f##*/}
  GEM_NO_VER=`echo $GEM | awk 'BEGIN{FS=OFS="-"}{$NF=""; NF--; print}'`

  # If gem != list of development gems, then package
  if ! [[ $DEVGEMS =~ .*$GEM_NO_VER.* ]]; then
    echo "** PACKAGING ** $GEM ..."
    fpm --iteration $BUILD_NUMBER -e -a $ARCH -t rpm -s gem $f 
  fi
done

# BUILD BUNDLER #
echo "** PACKAGING ** bundler ..."
fpm --iteration $BUILD_NUMBER -a $ARCH -t rpm -s gem bundler > /dev/null 2>&1

# Clean up build artifacts
rm -rf build-rpm*

# Move the packaged gems to the RPM Repository
mv *${ARCH}*.rpm $WORKSPACE/RPMS/sensu-dependencies/$ARCH/

