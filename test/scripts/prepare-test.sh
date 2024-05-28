#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# test 目录在该目录的上一级
test_dir=$DIR/..

# 如果环境变量JOB_COUNT没有设置，则默认为5
JOB_COUNT=${JOB_COUNT:-5}
echo "JOB_COUNT: $JOB_COUNT"

# 清空目录下的东西
jobs_dir=$test_dir/jobs
mkdir -p $jobs_dir
rm -f $jobs_dir/*

# find all case-configuration.yml
CONFIG_FILE="case-configuration.yml"
test_list_file=$jobs_dir/testcases.txt
test_base_dir="$( cd $test_dir/.. && pwd )"
echo "Searching all '$CONFIG_FILE' under dir $test_base_dir .."
# grep -v 是排除这个目录下的东西
find $test_base_dir -name $CONFIG_FILE | grep -v "$test_dir" > $test_list_file

# Split test list into JOB_COUNT parts
case_index=0
# while read file 循环是用来从文件或命令输出中逐行读取内容的，在这里就是读取上边的 find输出的内容
while read file
do
  job=$((case_index % JOB_COUNT + 1))
  case_index=$((case_index + 1))
#  使用 ${file%/$CONFIG_FILE}（这是一个 Bash 参数扩展）来从 file 变量中去除文件路径的末尾部分（即 $CONFIG_FILE 的值），这样只保留目录路径。
#  然后，这个目录路径被追加到相应的作业文件中（$jobs_dir/testjob_${job}.txt）。
  echo ${file%/$CONFIG_FILE} >> $jobs_dir/testjob_${job}.txt
done < $test_list_file

#Total 94 cases split into 5 jobs:
echo "Total $case_index cases split into $JOB_COUNT jobs:"
# 计算每个作业文件中的行数
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
