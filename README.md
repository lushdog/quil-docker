# quil-docker

修改.env

限制cpu占用

`docker compose up -d`

启动之后备份 .config/config.yml .config/key.yml

查看节点信息

`docker compose exec node node -node-info --signature-check=false`
