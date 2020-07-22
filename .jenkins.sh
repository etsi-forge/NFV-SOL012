#!/bin/bash
# Copyright ETSI 2017
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

cd "$(dirname "$0")"

run_dir="$(pwd)"

rm build/*-API.yaml
rm build/*-API.json

cd docker

chmod +x build-container.sh
./build-container.sh

chmod +x run-container.sh
./run-container.sh "${run_dir}"
OUTCOME=$?

exit $OUTCOME
