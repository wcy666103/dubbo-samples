#!/bin/bash

# 为了使用镜像，直接封装好的操作
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEBIAN_MIRROR=http://mirrors.aliyun.com $DIR/dubbo-test-runner/build.sh
