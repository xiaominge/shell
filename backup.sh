#!/usr/bin/env bash

# 备份文件存储目录
backupsDir="/Users/xuyakun/backups"
# 当前年份
YEAR=$(date +%Y)
# 当前月份
MONTH=$(date +%m)
# 当前日期
DAY=$(date +%d)
# 当前时间
TIME=$(date +%k%M)
# 备份文件具体存储目录
backupsDateDir=$backupsDir/$YEAR/$MONTH/$DAY
# 创建备份文件具体存储目录
mkdir -p "$backupsDateDir"
# 备份文件名称
backupFile=$backupsDateDir/$TIME.tar.gz
# 备份配置文件
configFile=$backupsDir/BackUpConfig
# 配置文件行号
FileNo=1
# 需要备份的文件和目录列表
FileList=''

# 判断配置文件是否可读
if [ -r $configFile ]
then
  echo "配置文件验证通过！"
  echo
else
  echo "配置文件验证不通过！"
  exit
fi

# 输入重定向配置文件
exec < $configFile
# 读取一行配置文件
read FileName
# 遍历配置文件
while [ $? -eq 0 ]
do
  if [ -f "$FileName" ] || [ -d "$FileName" ]
  then
    FileList="$FileList $FileName"
  else
    echo "行号为 ${FileNo} 的文件或目录没有找到！"
  fi
  FileNo=$((FileNo + 1))
  read FileName
done

echo
echo "开始备份..."
echo

tar -czf $backupFile $FileList 2> /dev/null

echo "备份完成！"
echo "文件位置： ${backupFile}"
echo
exit
