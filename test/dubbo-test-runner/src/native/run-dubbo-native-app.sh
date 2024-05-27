#!/bin/bash

DIR=/usr/local/dubbo/
cd $DIR

source $DIR/utils.sh

# build native image first
cd $DIR/src/${SERVICE_DIR}

# for debug purpose,skip the native build，put the executable file here
if [ -f "${SERVICE_NAME}" ]; then
    ./${SERVICE_NAME} $JAVA_OPTS 2>&1
    exit 0
fi

echo "Build native app : ..."
#不能clean，因为  run-native-tests.sh 已经跑起来了
mvn --no-transfer-progress native:compile -Dmaven.test.skip=true -Pnative 2>&1 # no clean package here cause run-native-tests.sh has run it
result=$?
if [ $result -ne 0 ]; then
  echo "Build native app failure "
  exit 1
fi

# case-configuration中配置过的，需要等这些端口开了之后才往下进行
# wait ports before run app: WAIT_PORTS_BEFORE_RUN=host:port;host:port
if [ "$WAIT_PORTS_BEFORE_RUN" != "" ]; then
  echo "Waiting ports before run native app .."
  split_and_check_tcp_ports "$WAIT_PORTS_BEFORE_RUN" $SECONDS $WAIT_TIMEOUT
  result=$?
  if [ $result -ne 0 ]; then
    echo "Wait ports before run native app failure"
    exit $result
  fi
fi

#delay start
if [ $RUN_DELAY -gt 0 ]; then
  echo "Delay $RUN_DELAY s."
  sleep $RUN_DELAY
fi

echo "Running native app : ..."
start=$SECONDS
#就是将这个jar包运行？
./target/${SERVICE_NAME} $JAVA_OPTS 2>&1 &
pid=$!

echo "Wait for process to exit: $pid .."
wait $pid
result=$?
if [ $result -ne 0 ]; then
  exit $result
fi

