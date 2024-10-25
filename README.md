# quil-docker

修改系统参数

`sysctl -w net.core.wmem_max=600000000`

`sysctl -w net.core.rmem_max=600000000`

修改.env，根据个人情况指定cpu核心
例如 `0-3` 指定 4 个核心

启动
`docker compose up -d`

启动之后备份 .config/config.yml .config/keys.yml (相当于密钥，一定要备份)

查看节点信息

`docker compose exec node node -node-info --signature-check=false`

查看节点的 peer-id (相当于地址)

`docker compose exec node node -peer-id --signature-check=false`

查看余额

`docker compose exec -it node node -balance -config /root/.config -signature-check=false`

### 使用Qclient命令

在quil-docker文件夹内执行

`docker compose exec -it node qclient <命令> --signature-check=false` 

例如查看quil余额

`docker compose exec -it node qclient token balance --signature-check=false`

### 优雅退出

`docker compose kill -s SIGINT`

`docker compose down`

### 更新

镜像地址
https://hub.docker.com/r/trancelife/quilibrium/tags

`docker compose pull`

`docker compose kill -s SIGINT`

`docker compose down`

`docker compose up -d`

#### 2.0.1 重启检查

`curl -s https://raw.githubusercontent.com/lushdog/quil-docker/refs/heads/main/check.sh | bash `
