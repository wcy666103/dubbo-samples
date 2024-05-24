#!/bin/bash
# 和 build-test-image 内容一样
# Use mirror:
# DEBIAN_MIRROR=http://mirrors.aliyun.com ./build-test-image.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#会调用该sh，构建镜像，然后构建nacos镜像
$DIR/dubbo-test-runner/build-native.sh

$DIR/build-nacos-image.sh
