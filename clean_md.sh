#!/bin/bash


if [ "$1" =  "" ]; then
	echo "Usage: $0 convertDir"
	exit 1;
fi
DIR=$1

# basic data
#CHECK_FILES=`find $DIR -name "*.md"`
FILES=`find $DIR -iname "*.md" |wc -l`
LINES=`find $DIR -iname "*.md" |xargs cat|grep -v ^$|wc -l`
echo -e "\nscan baseinfo: \n\tDIR=$DIR, \n\tFILES=$FILES, LINES=$LINES\n"

echo -e '######Start clean markdown file...\n'

# 敏感数据检查: grep -rl "敏感词" $DIR
echo -e '\n###Doing check sensitive word...'
SENS_WORDS="敏感词"
for word in $SENS_WORDS
do
	echo -e "checking: $word"
	find $DIR -iname "*.md" | xargs grep $word
done

# remove line end space, 去除行尾空格
echo -e '\n###Doing format...'
find $DIR -iname "*.md" |xargs sed -i 's/\s\+$//g'

# 清理数据：1.****  
echo -e '\n###Doing clean data...'
#sed -i r"s/****//g" `grep -rl "****" $DIR`
find $DIR -iname "*.md" |xargs sed -i r"s/****//g"


# 无序符号格式化1（慎用） regex: /^\nn /* /g
# 无序符号格式化2（慎用） regex: /^\nl /* /g


echo -e '\n######END clean\n'
