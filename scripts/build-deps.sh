#!/bin/bash
ARCH="$1"

if ! [ -d $WORKSPACE/vendor/cache/ ]; then
  exit 1
fi

FILES="$WORKSPACE/vendor/cache/*"

# Get a list of development gems
DEVGEMS=`cat ./sensu.gemspec | grep -i development | cut -f2 -d'"' | tr '\n' ','`

# For each gem in the bundle
for f in $FILES
do
  # String manipulate the gem file into just the name of the gem
  GEM=${f##*/}
  GEM_NO_VER=`echo $GEM | awk 'BEGIN{FS=OFS="-"}{$NF=""; NF--; print}'`
  GEM_VER=`echo $GEM | cut -f2 -d'-' | sed 's/.gem//'`

  # If gem != list of development gems, then package
  if ! [[ $DEVGEMS =~ .*$GEM_NO_VER.* ]]; then
    echo "** PACKAGING ** $GEM_VER ..."
    fpm --iteration $BUILD_NUMBER -a $ARCH -t rpm -s gem $f > /dev/null 2>&1
  fi
done

# Move the packaged gems to the RPM Repository
mv *${ARCH}*.rpm $WORKSPACE/RPMS/sensu-dependencies/$ARCH/

