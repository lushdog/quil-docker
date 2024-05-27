# quil-docker

修改.env，根据个人情况限制cpu线程

启动
`docker compose up -d`

启动之后备份 .config/config.yml .config/key.yml (相当于密钥，一定要备份)

查看节点信息

`docker compose exec node node -node-info --signature-check=false`

查看节点的 peer-id (相当于地址)

`docker compose exec node node -peer-id --signature-check=false`
