#!/bin/bash
# Copyright ETSI 2017
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -x

proxy = ""
if [[ ! -v http_proxy ]]; then
    echo "http_proxy is not set"
elif [[ -z "$http_proxy" ]]; then
    echo "http_proxy is empty"
else
    echo "http_proxy is set to $http_proxy"
    if [[ $http_proxy =~ ^http:\/\/[0-9] ]]; then
        echo "starts with http"
        proxy=$http_proxy
    elif [[ $http_proxy =~ ^[0-9] ]]; then
        echo "starts with number"
        proxy=http://$http_proxy
    fi
fi

echo "Proxy set to $proxy"

docker build --build-arg http_proxy=$proxy --build-arg https_proxy=$proxy -t openapivalidator .