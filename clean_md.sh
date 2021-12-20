#!/bin/bash


if [ "$1" =  "" ]; then
	echo "Usage: $0 convertDir"
	exit 1;
fi
DIR=$1


echo -e '######Start clean markdown file...\n'

# remove line end space, 去除行尾空格
echo -e '\nDoing fomart...'
find $DIR -iname "*.md"  |xargs sed -i 's/\s\+$//g'
find $DIR -name "*.md" |xargs cat|grep -v ^$|wc -l

# 清理数据：1.****  
echo -e '\nDoing clean data...'
#sed -i r"s/****//g" `grep -rl "****" $DIR`
find $DIR -iname "*.md"  |xargs sed -i r"s/****//g"

# 敏感数据检查: grep -rl "敏感词" $DIR
echo -e '\nDoing check sensitive word...'
SENS_WORDS="敏感词"
for word in $SENS_WORDS
do
	echo -e "checking: $word"
	find $DIR -iname "*.md" | xargs grep $word
done


# 无序符号格式化1（慎用） regex: /^\nn /* /g
# 无序符号格式化2（慎用） regex: /^\nl /* /g


echo -e '\n######END clean\n'
