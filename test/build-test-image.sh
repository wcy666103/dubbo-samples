#!/bin/bash

# Use mirror:
# DEBIAN_MIRROR=http://mirrors.aliyun.com ./build-test-image.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 也仅仅只是构建镜像
$DIR/dubbo-test-runner/build.sh

$DIR/build-nacos-image.sh
