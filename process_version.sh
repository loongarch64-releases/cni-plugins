#!/bin/bash
set -euo pipefail

readonly version="$1"

readonly org='containernetworking'
readonly proj='plugins'
readonly arch='loongarch64'
readonly goarch='loong64'
readonly proj_name="${proj}-${version}"

# 映射目录
readonly workspace="/workspace"
readonly dists="${workspace}/dists"
readonly patches="${workspace}/patches"

readonly build="/build"
readonly source_root="${build}/${proj_name}"
readonly build_root="${build}/${proj_name}"
readonly package_root="${dists}/${proj_name}"

mkdir -p "${build}"

fetch_source_code()
{
    rm -rf "${source_root}"
    git clone --branch "v${version}" --depth=1 "https://github.com/${org}/${proj}" "${source_root}"
}

build(){
    pushd "${build_root}"
        ./build_linux.sh
    popd
}

package(){
    rm -rf "${package_root}"
    mkdir -p "${package_root}"
    local cni_tar="cni-plugins-linux-${goarch}-v${version}.tgz"
    pushd "${package_root}"
        cp ${build_root}/bin/* ./
        cp ${source_root}/{LICENSE,README.md} ./
        tar czvf "${cni_tar}" *
        sha256sum "${cni_tar}" >> "${cni_tar}.sha256sum"
        find ./ -maxdepth 1 -type f ! -name *.tgz ! -name *.sha256sum -delete
    popd

}

main()
{
    fetch_source_code
    build
    package
}

main "$@"
