#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

test_dir=$DIR/..
cd $test_dir

TEST_SUCCESS="TEST SUCCESS"
TEST_FAILURE="TEST FAILURE"
TEST_IGNORED="TEST IGNORED"
# 获取这个变量，默认为 8
JAVA_VER=${JAVA_VER:-8}
echo "JAVA_VER: $JAVA_VER"

# 这边为什么 在 jobs文件夹下有这些后缀的东西？ 因为ci那边会给测试结果上传，并且在merge job中将结果进行下载，这样
RESULT_SUFFIX=result-java${JAVA_VER}.txt
mergedTestResultFile=jobs/merged-test-$RESULT_SUFFIX
rm -rf $mergedTestResultFile

# 所有测试结果都 打印一下
echo "All test results:"
for resultFile in jobs/*$RESULT_SUFFIX; do
  echo "$resultFile:"
  cat $resultFile
  echo ""
done

# 统计各个类型任务的数量 并且进行输出
cat jobs/*$RESULT_SUFFIX > $mergedTestResultFile
successTest=`grep -c "$TEST_SUCCESS" $mergedTestResultFile`
failedTest=`grep -c "$TEST_FAILURE" $mergedTestResultFile`
ignoredTest=`grep -c "$TEST_IGNORED" $mergedTestResultFile`
totalCount=`grep -c "" $mergedTestResultFile`

echo "----------------------------------------------------------"
echo "All tests count: $totalCount"
echo "Success tests count: $successTest"
echo "Ignored tests count: $ignoredTest"
echo "Failed tests count: $failedTest"
echo "----------------------------------------------------------"

if [ $ignoredTest -gt 0 ]; then
  echo "Ignored tests: $ignoredTest"
  grep "$TEST_IGNORED" jobs/testjob*$RESULT_SUFFIX
  echo "----------------------------------------------------------"
fi

if [ $failedTest -gt 0 ]; then
  echo "Failed tests: $failedTest"
  grep "$TEST_FAILURE" jobs/testjob*$RESULT_SUFFIX
  echo "----------------------------------------------------------"
fi

echo "Total: $totalCount, Success: $successTest, Failures: $failedTest, Ignored: $ignoredTest"

if [[ $(($successTest + $ignoredTest)) == $totalCount ]]; then
  test_result=0
  echo "All tests pass"
else
  test_result=1
  if [[ $failedTest -gt 0 ]]; then
    echo "Some tests failed: $failedTest"
  elif [ $successTest -eq 0 ]; then
    echo "No test pass"
  else
    echo "Test not completed"
  fi
fi
exit $test_result


