#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

JAVA_VER=${JAVA_VER:-8}

# 会创建target/docker 目录
DOCKER_DIR=$DIR/target/docker

echo "Building dubbo-test-runner .."
echo "Java version: $JAVA_VER"
cd $DIR
mvn clean package -DskipTests
result=$?
if [ $result -ne 0 ]; then
  echo "Build dubbo-test-runner failure"
  exit $result
fi

#拷贝 jar包和 src中docker目录下的一些东西 拷贝到这个目录下
mkdir -p $DOCKER_DIR
cp -r $DIR/src/docker/* $DOCKER_DIR/
cp $DIR/target/dubbo-test-runner-*-jar-with-dependencies.jar $DOCKER_DIR/dubbo-test-runner.jar

# 进入 target/docker目录下
cd $DOCKER_DIR
#docker构建镜像
docker build -t dubbo/sample-test:$JAVA_VER . --build-arg DEBIAN_MIRROR=$DEBIAN_MIRROR  --build-arg JAVA_VER=$JAVA_VER
