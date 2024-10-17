fetch() {
    files=$(curl https://releases.quilibrium.com/release | grep linux-amd64)
    new_release=false

    for file in $files; do
        # 下载文件
        if ! test -f "./$file"; then
            curl "https://releases.quilibrium.com/$file" > "$file"
            new_release=true
            
            # 使用正则表达式匹配，替换掉前缀部分为 'node'
            new_name=$(echo "$file" | sed 's/node-.*-linux-amd64/node/')
            
            # 只有当文件名不同的时候才执行重命名
            if [[ "$file" != "$new_name" ]]; then
                mv "$file" "$new_name"
            fi
        fi
    done
}

fetchQclient() {
    files=$(curl https://releases.quilibrium.com/qclient-release | grep linux-amd64)
    new_release=false

    for file in $files; do
        # 下载文件
        if ! test -f "./$file"; then
            curl "https://releases.quilibrium.com/$file" > "$file"
            new_release=true
            
            # 使用正则表达式匹配，替换掉前缀部分为 'node'
            new_name=$(echo "$file" | sed 's/qclient-.*-linux-amd64/qclient/')
            
            # 只有当文件名不同的时候才执行重命名
            if [[ "$file" != "$new_name" ]]; then
                mv "$file" "$new_name"
            fi
        fi
    done
}

rm ./node
rm ./node.dgst
rm ./node.dgst.*
rm ./qclient
rm ./qclient.dgst
rm ./qclient.dgst.*

fetch

fetchQclient

chmod +x node

chmod +x qclient
