fetch() {
    files=$(curl https://releases.quilibrium.com/release | grep linux-amd64)
    new_release=false

    for file in $files; do
        version=$(echo "$file" | cut -d '-' -f 2)
        if ! test -f "./$file"; then
            curl "https://releases.quilibrium.com/$file" > "$file"
            new_release=true
            
            # 生成新的文件名，保持格式不变，只修改前缀
            new_name=$(echo "$file" | sed 's/node-2.0.0.6-linux-amd64/node/')
            mv "$file" "$new_name"
        fi
    done
}
fetch
