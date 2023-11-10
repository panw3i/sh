#!/bin/bash

# 检查是否提供了目标目录路径
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_directory_path>"
    exit 1
fi

# 读取第一个命令行参数作为目标目录
TARGET_DIR=$1
# 合并后的文件
OUTPUT_FILE="merged.txt"

# 判断合并后的文件是否已存在，如果存在则删除
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
fi

# 使用find命令查找所有的.mdx文件，并循环处理每个文件
find "$TARGET_DIR" -name '*.mdx' -print0 | while IFS= read -r -d $'\0' file; do
    # 将文件名追加到合并文件中
    echo "Merging $file into $OUTPUT_FILE"
    echo "File: $file" >> "$OUTPUT_FILE"
    # 追加mdx文件的内容到合并文件中，并添加换行符以分隔各文件内容
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
done

echo "All .mdx files have been merged into $OUTPUT_FILE"
