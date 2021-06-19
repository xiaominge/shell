#!/usr/bin/env bash

# 获取脚本选项
while getopts m: opt
do
  case "$opt" in
  m) toUser=$OPTARG;;
  *) echo "未知的选项：$opt";;
  esac
done
# 获取脚本参数
shift $((OPTIND - 1))
msg=''
count=1
for param in "$@"
do
  if [ $count -eq 1 ]
  then
      msg=$param
  else
      msg=$msg' '$param
  fi
  count=$((count + 1))
done
# 判断选项
if [ -z "$toUser" ]
then
  echo "必须使用 -m xxx 选项"
  echo "退出"
  exit
fi
# 获取可以接收消息的用户
loggedOn=$(who -T | grep "+" | grep -i -m 1 "$toUser" | gawk '{print $1}')
if [ -z "$loggedOn" ]
then
  echo "用户未登录或未开启消息功能"
  echo "退出"
  exit
else
  echo "消息将要发送给：$loggedOn"
fi
# 验证消息内容
if [ -z "$msg" ]
then
  echo "消息不能为空"
  echo "退出"
  exit
else
  echo "消息内容为：$msg"
fi
# 获取接收消息的终端
userTerminal=$(who -T | grep "+" | grep -i -m 1 "$toUser" | gawk '{print $3}')
echo "$msg" | write "$loggedOn" "$userTerminal"
exit
