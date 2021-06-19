#!/usr/bin/env bash

# 邮件程序位置
mail=$(which mutt)
# 日期时间
date=$(date +%F' '%T)
# 获取临时文件名
temp=$(mktemp tmp.XXXXXX)
subject="磁盘空间监控 $date"
# 磁盘空间使用信息重定向到临时文件
df -h > "$temp"
# 从临时文件获取邮件内容，发送邮件
$mail -s "$subject" "$1" < "$temp"
# 删除临时文件
rm -f "$temp"
