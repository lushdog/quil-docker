#!/bin/bash

# 检查是否安装了 bc
if ! command -v bc &> /dev/null; then
  echo "bc 未安装，正在安装..."
  sudo apt-get update
  sudo apt-get install -y bc
fi

# 设置时间阈值（20分钟 = 1200秒）
THRESHOLD=1200

# 进入 Docker Compose 所在目录
cd ~/quil-docker || exit

# 获取最新的 increment 时间戳
last_increment_ts=$(docker compose logs | grep increment | tail -n 1 | awk -F '"ts":' '{print $2}' | awk -F ',' '{print $1}')

# 获取当前的 Unix 时间戳
current_ts=$(date +%s)

# 计算时间差（转换为浮点数处理）
time_diff=$(echo "$current_ts - $last_increment_ts" | bc)

# 使用 awk 进行浮点数比较
if echo "$time_diff $THRESHOLD" | awk '{if ($1 > $2) exit 0; else exit 1}'; then
  echo "超过20分钟未检测到 'increment'，正在重启 Docker 容器..."
  docker compose restart
fi
