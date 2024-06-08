# quil-docker

修改系统参数

`sysctl -w net.core.wmem_max=600000000`

`sysctl -w net.core.rmem_max=600000000`

修改.env，根据个人情况限制cpu线程

启动
`docker compose up -d`

启动之后备份 .config/config.yml .config/keys.yml (相当于密钥，一定要备份)

查看节点信息

`docker compose exec node node -node-info --signature-check=false`

查看节点的 peer-id (相当于地址)

`docker compose exec node node -peer-id --signature-check=false`

查看余额

`docker compose exec -it node node -balance -config /root/.config -signature-check=false`

### 更新

镜像地址
https://hub.docker.com/r/trancelife/quilibrium/tags

`docker compose pull`

`docker compose up -d`
