#!/bin/bash

# 创建临时文件
temp_file=$(mktemp)

# 遍历所有index.md文件，提取日期和标题
for f in $(find posts -name "index.md" -type f); do
  # 跳过_drafts目录下的文件
  if [[ $f == *"_drafts"* ]]; then
    continue
  fi
  
  # 提取日期和标题
  date=$(grep -m 1 "^date:" "$f" | sed 's/date: //' | tr -d '"')
  title=$(grep -m 1 "^title:" "$f" | sed 's/title: //' | tr -d '"')
  
  # 如果日期和标题都存在，则添加到临时文件
  if [[ -n "$date" && -n "$title" ]]; then
    # 获取文章路径（去掉index.md）
    path=$(dirname "$f")
    echo "$date|$title|$path" >> "$temp_file"
  fi
done

# 按日期排序（降序）
sort -r -t '|' -k1 "$temp_file" > "${temp_file}.sorted"

# 生成侧边栏内容
echo "<!-- _sidebar.md -->" > _sidebar.md
echo "" >> _sidebar.md
echo "# 文章列表" >> _sidebar.md
echo "" >> _sidebar.md

while IFS='|' read -r date title path; do
  # 使用包含/index的链接格式
  echo "* [$title]($path/index)" >> _sidebar.md
done < "${temp_file}.sorted"

# 清理临时文件
rm "$temp_file" "${temp_file}.sorted"

echo "侧边栏内容已生成到 _sidebar.md"