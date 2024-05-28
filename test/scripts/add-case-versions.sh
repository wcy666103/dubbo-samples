#!/bin/bash
# 匹配对应的 版本

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#通过 pom文件来哎确定projects
all_projects=`find $DIR/../.. -name pom.xml`
# 计算找到的 pom.xml 文件的数量，并将结果存储在变量 project_count 中
project_count=`echo $all_projects | tr ' ' '\n' | grep -c ""`
echo "Total projects: $project_count"

case_config_template1=$DIR/case-versions.conf.1
case_config_template2=$DIR/case-versions.conf.2
case_config_template3=$DIR/case-versions.conf.3

while read project
do
#    echo "project: $project"
    project_dir=`dirname $project`
#    如果没有该文件就继续
    if [ ! -f $project_dir/case-configuration.yml ]; then
      continue
    fi

# 所以是需要 pom 文件中显式的 配置 <spring.version> 这个属性的
    grep "<spring.version>" $project_dir/pom.xml > /dev/null

    # $? 存储了上一个命令的退出状态，0 表示成功
    result=$?
    if [ $result -eq 0 ]; then
      case_config_template=$case_config_template1
    fi
#   是1开头的spring boot 的版本
    grep "<spring-boot.version>1" $project_dir/pom.xml > /dev/null
    result=$?
    if [ $result -eq 0 ]; then
      case_config_template=$case_config_template2
    fi

    grep "<spring-boot.version>2" $project_dir/pom.xml > /dev/null
    result=$?
    if [ $result -eq 0 ]; then
      case_config_template=$case_config_template3
    fi

    if [ -z $case_config_template ]; then
      echo "not match: $project_dir"
      continue
    fi

    if [ -f $project_dir/case-versions.conf ];then
      continue
    fi

    echo "copy $case_config_template to $project_dir"

    # 使用 -n 选项确保目标文件不存在时才复制，避免覆盖现有文件  所以这个脚本就写的很迷，如果有就不复置，那就直接判断是否有这个文件如果有就continue不就不这么费劲了。
    cp -n $case_config_template $project_dir/case-versions.conf
done <<< "$all_projects"
