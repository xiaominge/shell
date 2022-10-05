#!/usr/bin/env bash

# SQL文件目录
backup_path=/tmp/backups/db
# log 文件位置
log_file=$backup_path/db-backups.log
# 保存备份个数，备份 5 天数据
number=5
# 日期
date_time=$(date +%Y%m%d-%H:%M:%S)
# 远程mysql服务 Host 地址
host=xxx
# 将要备份的数据库
db_name=xxx
# 备份SQL文件
db_file=$backup_path/$db_name-$date_time.sql

# 如果文件夹不存在则创建
if [ ! -d $backup_path ]; then
  mkdir -p $backup_path
fi

# 执行备份命令
mysqldump -h $host $db_name >"$db_file"

# 写入创建备份日志
echo "create $db_file" >>$log_file

# 找出需要删除的备份
del_file=$(ls -l -crt $backup_path/*.sql | awk '{print $9 }' | head -1)

# 判断现在的备份数量是否大于 $number
count=$(ls -l -crt $backup_path/*.sql | awk '{print $9 }' | wc -l)

if [ "$count" -gt $number ]; then
  # 删除最早生成的备份，只保留 number 数量的备份
  rm "$del_file"
  # 写删除文件日志
  echo "delete $del_file" >>$log_file
fi

# 导入SQL文件到本地数据库
mysql $db_name <"$db_file"
