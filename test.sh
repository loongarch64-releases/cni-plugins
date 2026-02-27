#!/bin/bash

set -x;

test(){
    local version=$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r ".tag_name")
    version=${version#v}
    docker build -t containernetworking-plugins-builder .
    docker run -v$(pwd):/workspace -e PLUGINS_VERSION=${version} containernetworking-plugins-builder
}

test
