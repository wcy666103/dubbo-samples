#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

test_dir=$DIR/..

JOB_COUNT=${JOB_COUNT:-5}
echo "JOB_COUNT: $JOB_COUNT"

jobs_dir=$test_dir/jobs
mkdir -p $jobs_dir
rm -f $jobs_dir/*

# find all case-configuration.yml
CONFIG_FILE="case-configuration.yml"
test_list_file=$jobs_dir/testcases.txt
test_base_dir="$( cd $test_dir/.. && pwd )"
echo "Searching all '$CONFIG_FILE' under dir $test_base_dir .."
find $test_base_dir -name $CONFIG_FILE | grep -v "$test_dir" > $test_list_file

# Split test list into JOB_COUNT parts
case_index=0
while read file
do
  job=$((case_index % JOB_COUNT + 1))
  case_index=$((case_index + 1))
  echo ${file%/$CONFIG_FILE} >> $jobs_dir/testjob_${job}.txt
done < $test_list_file

#Total 94 cases split into 5 jobs:
echo "Total $case_index cases split into $JOB_COUNT jobs:"
grep -r "" -c $jobs_dir


# 脚本总输出：
#JOB_COUNT: 5
 #Searching all 'case-configuration.yml' under dir /home/wcy_spark/dubbo-samples ..
 #Total 94 cases split into 5 jobs:   下边都是真实存在的文件：文件行数量
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testcases.txt:94
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testjob_1.txt:19
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testjob_2.txt:19
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testjob_3.txt:19
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testjob_4.txt:19
 #/home/wcy_spark/dubbo-samples/test/scripts/../jobs/testjob_5.txt:18
