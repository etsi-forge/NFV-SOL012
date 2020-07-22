#!/bin/bash
# Copyright ETSI 2017
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

# Change this variable to true if you want
# to copy the created yaml files to a web served directory
#
#
WEB_PUBLISH=true

f="${1:-`pwd`}"
filter="$2"

echo "Mounting dir $f as /work"

if [ -n "$JOB_BASE_NAME" -a "$WEB_PUBLISH" = true ] ; then 
  s="/var/www/html/api/nfv/$JOB_BASE_NAME/$BUILD_NUMBER"
  mkdir -v -p "$s"
  echo "Mounting dir $s as /storage"  
  docker run -v "$f":/work -v "$s":/storage openapivalidator "/work" "/storage" "$filter"
else
  docker run -v "$f":/work openapivalidator "/work" "/storage" "$filter"
fi 




