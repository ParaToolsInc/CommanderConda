#!/usr/bin/env bash

# set -o verbose
set -o errexit
set -o pipefail
set -o nounset

case "${ARCH}" in
    x86_64)
        DOCKER_ARCH=amd64
        DOCKERIMAGE=condaforge/linux-anvil-comp7:88138de6129f
        ;;
    ppc64le)
        DOCKER_ARCH=ppc64le
        DOCKERIMAGE=condaforge/linux-anvil-ppc64le
        ;;
    aarch64)
        DOCKER_ARCH=arm64v8
        DOCKERIMAGE=condaforge/linux-anvil-aarch64
        ;;
esac

export DOCKER_ARCH
export DOCKERIMAGE

echo "============= Create build directory ============="
mkdir -p build/ || true
chmod 777 build/

echo "============= Enable QEMU ============="
docker run --rm --privileged multiarch/qemu-user-static:register --reset --credential yes

echo "============= Build the installer ============="
# See github actions issue #241 comment here: https://github.com/actions/runner/issues/241#issuecomment-577360161
script -e -c "docker run --rm -ti -v $(pwd):/construct -e GITHUB_REF -e ARCH -e COMMANDERCONDA_VERSION -e COMMANDERCONDA_NAME $DOCKERIMAGE /construct/scripts/build.sh"

echo "============= Test the installer ============="
for TEST_IMAGE_NAME in "ubuntu:20.04" "ubuntu:16.04" "ubuntu:18.04" "centos:7" "debian:buster" "opensuse:42.3"
do
  echo "============= Test installer on $TEST_IMAGE_NAME ============="
  script -e -c "docker run --rm -ti -v $(pwd):/construct -v $(pwd)/build/qemu/qemu-${ARCH}-static:/usr/bin/qemu-${ARCH}-static -e GITHUB_REF -e ARCH ${DOCKER_ARCH}/$TEST_IMAGE_NAME /construct/scripts/test.sh"
done
