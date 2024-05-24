#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

JAVA_VER=${JAVA_VER:-8}

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

#拷贝 jar包和 docker目录下的一些东西 到 docker images 中
mkdir -p $DOCKER_DIR
cp -r $DIR/src/docker/* $DOCKER_DIR/
cp $DIR/target/dubbo-test-runner-*-jar-with-dependencies.jar $DOCKER_DIR/dubbo-test-runner.jar

cd $DOCKER_DIR
docker build -t dubbo/sample-test:$JAVA_VER . --build-arg DEBIAN_MIRROR=$DEBIAN_MIRROR  --build-arg JAVA_VER=$JAVA_VER
