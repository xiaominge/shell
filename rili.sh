#!/usr/bin/env bash

# 获取日期
date=$(date +%Y%m%d)
# 获取日历信息的网站
url="http://tools.2345.com/frame/api/GetLunarInfo?date=$date"
# 检查网址是否可访问
check_url=$(wget -nv --spider "$url" 2>&1)

if [[ $check_url == "*error404*" ]]
then
  echo "网址不可用！"
  exit
fi

# 保存数据的文件
file=/tmp/rili.html
# 下载文件
wget -O $file -o /tmp/rili.log "$url"

cat $file | tee "$file"

