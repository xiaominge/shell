#!/usr/bin/env bash

# 配置文件保存需要监控的目录
configFile=./dir_monitor_config
# 保存信息的临时文件
temp=dir_monitor.txt
#遍历输出目录的监控信息
while read -r opt || [ -n "$opt" ]
do
  echo "目录 $opt 的使用情况："
  du -k -d 1 "$opt" 2>/dev/null |
  sort -rn |
  sed -e '11,$d' -e '=' |
  sed 'N; s/\n/ /' |
  gawk '{printf $1":" "\t" $3 "\t" $2"KB" "\n"}'
  echo
done < $configFile > $temp
# 邮件程序位置
mail=$(which mutt)
# 日期时间
date=$(date +%F' '%T)
subject="目录使用情况监控 $date"
# 从临时文件获取邮件内容，发送邮件
$mail -s "$subject" "$1" < "$temp"
# 删除临时文件
rm -f "$temp"
exit
