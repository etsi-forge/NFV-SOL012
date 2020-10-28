#!/bin/bash
# Copyright ETSI 2017
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

# Merges OpenAPIs interfaces in the working directory
# and validates them individually.
# Exit status is 0 if all validation passed, 1 otherwise

# Usage:
# $0 <working-directory> <storage-dir>

#set -x

function store_api () {
	f="$1"
	cp -v "$1" "${storage_dir}/"
}

function validate_api () {
  file="$1"
  api="$2"
  deliverable="$3"
  echo "--- Merging file."
  merged_file="../build/${deliverable}-${api}-API.yaml"
  json_file="../build/${deliverable}-${api}-API.json"
  json-refs resolve "${file}" > "${merged_file}"
  yaml2json "${merged_file}" > "${json_file}"
  
  # Create the PDF version
  echo "--- Create PDF..."
  oas2pdf "${json_file}" 2>/dev/null 1>/dev/null 
  mv "${deliverable}-${api}-API.pdf" "../build/"

  echo "--- Validating ${merged_file}"
  swagger-cli validate "${merged_file}"
  vres=$?
  echo "--- Validation done ($vres)."

  # If validation succedes, store the generated file
  [ $vres -a -d "/storage" ] && store_api "${merged_file}"
  [ $vres -a -d "/storage" ] && store_api "${json_file}"
  [ $vres -a -d "/storage" ] && store_api "../build/${deliverable}-${api}-API.pdf"
  
  
  return $vres
}

# usage get_api_from_fn <file_name>
#  e.g. get_api_from_fn /path/to/SOL003/Api1/Api1.yaml returns Api1
function get_api_from_fn () {
  echo "$(basename $(dirname $1))"
}

# usage get_api_from_fn <file_name>
#  e.g. get_api_from_fn /path/to/SOL003/Api1/Api1.yaml returns Api1
function get_deliverable_from_fn () {
  echo "$(basename $(dirname $(dirname $1 )))"
}

## Main ##

wd="${1?"Usage: $0 <working-directory> <storage-directory> [<filter_regex>]"}"
storage_dir="${2?"Usage: $0 <working-directory> <storage-directory> [<filter_regex>]"}"

filter="$3"
echo "Using filter '$filter'"
echo

mkdir -p "$wd/build"

echo "Entering dir $wd/src"
cd "$wd/src"

# Stores the overall validation result
# (single results in OR)
fres=0


for f in $(find -name "*.yaml") ; do
      # echo "Found yaml file: $f"
      file=$(basename "$f")
      api=$(get_api_from_fn $f)
      deliverable=$(get_deliverable_from_fn $f)
      if [ "$file" = "$api.yaml" ]; then
          if [[ -n "$filter" &&  ! "$f" =~ ^[a-zA-Z0-9\.\/\-]*$filter[a-zA-Z\.\/0-9\-]*$ ]] ; then 
            echo "Filtered out: $f (api: $api) (deliverable:$deliverable)."
          else 
            echo "-- Will validate: $f (api: $api) (deliverable:$deliverable)"         
            validate_api "$f" "$api" "$deliverable"
            res=$?
            fres=$(($fres||$res))
          fi
      fi
done

chmod -R o+w "$wd/build"

# Exit code needed for jenkins to know the verdict of the build
echo "-- Final validator returns $fres."
exit $fres
