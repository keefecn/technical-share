#!/bin/bash


if [ "$1" =  "" ]; then
	echo "Usage: $0 convertDir"
	exit 1;
fi
DIR=$1

echo "######"
echo -e ' Doing clean...\n'

# remove line end space, 去除行尾空格
find $DIR -iname "*.md"  |xargs sed -i 's/\s\+$//g'
find $DIR -name "*.md" |xargs cat|grep -v ^$|wc -l

# **** 删除
sed -i r"s/****//g" `grep -rl "****" $DIR`

# 无序符号格式化1（慎用） regex: /^\nn /* /g


# 无序符号格式化2（慎用） regex: /^\nl /* /g


echo -e '\nEND clean\n'
