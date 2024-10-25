#!/bin/bash

# 检查是否安装了 jq
if ! command -v jq &> /dev/null; then
  echo "jq 未安装，正在安装..."
  sudo apt-get update
  sudo apt-get install -y jq
fi

# 获取日志文件路径
LOG_FILE=$(docker inspect --format='{{.LogPath}}' quilibrium-node-1)

# 检查是否成功获取日志文件路径
if [ -z "$LOG_FILE" ]; then
  echo "无法获取日志文件路径"
  exit 1
fi

# 读取日志文件的最后1000行，并提取包含frame_number的行
frame_number_lines=$(tail -n 1000 "$LOG_FILE" | grep "frame_number")

# 提取所有的frame_number值
frame_numbers=$(echo "$frame_number_lines" | jq -r '.log | fromjson | .frame_number')

# 判断所有的frame_number值是否相同
if [ -z "$frame_numbers" ]; then
  echo "日志文件中没有找到frame_number"
  exit 1
fi

first_frame_number=$(echo "$frame_numbers" | head -n 1)
all_same=1
max_frame_number=$first_frame_number

while read -r frame_number; do
  if [ "$frame_number" != "$first_frame_number" ]; then
    all_same=0
  fi
  if [ "$frame_number" -gt "$max_frame_number" ]; then
    max_frame_number=$frame_number
  fi
done <<< "$frame_numbers"

if [ "$all_same" -eq 1 ]; then
  echo "1 $first_frame_number"
  echo "所有frame_number相同，重启Docker容器..."
  cd ~/quil-docker/
  docker compose kill -s SIGINT
  docker compose down
  docker compose up -d
else
  echo "$max_frame_number"
fi

