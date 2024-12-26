#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
echo "SCRIPT_DIR = $SCRIPT_DIR"
# 定义 JSON 文件的路径
JSON_FILE="$SCRIPT_DIR/file_list.json"
echo "JSON_FILE = $JSON_FILE"

# 获取所有被跟踪的文件
#FILES=$(git ls-files)
RELEASE="release/"
SNAPSHOT="snapshot/"
#FILES=$(find $RELEASE $SNAPSHOT -type f)
FILES_RELEASE_GRADLE=$(find $RELEASE -name *.gradle -exec ls -t {} + | sort -r)
FILES_RELEASE=$(find $RELEASE -name *.aar -exec ls -t {} + | sort -r)
FILES_SNAPSHOT=$(find $SNAPSHOT -name *.aar -exec ls -t {} + | sort -r)
#FILES+=("${FILES_SNAPSHOT[@]}")
#FILES=("${FILES_RELEASE[@]}" "${FILES_SNAPSHOT[@]}")
FILES=$(echo "$FILES_RELEASE_GRADLE" "$FILES_RELEASE")
# 开始创建 JSON 文件
echo "[" > $JSON_FILE

# 遍历所有文件并写入 JSON
FIRST=true
for FILE in $FILES; do
  echo file=$FILE
  if [[ "${FILE##*.}" == "aar" ]] || [[ "${FILE##*.}" == "gradle" ]] ; then
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      echo "," >> $JSON_FILE
    fi

    # 获取文件的大小和修改时间
    FILE_SIZE=$(stat -c%s "$FILE" | numfmt --to=iec --format="%.2f" --suffix="B")
    FILE_MOD_TIME=$(stat -c%y "$FILE")
    FILE_MOD_TIME=$(date -d "$FILE_MOD_TIME" +"%Y-%m-%d %H:%M:%S")
    echo "  { \"path\": \"$FILE\", \"size\": \"$FILE_SIZE\", \"modified_time\": \"$FILE_MOD_TIME\" }" >> $JSON_FILE
  fi
done

# 结束 JSON 文件
echo "]" >> $JSON_FILE

# 输出生成的 JSON 文件
echo "Generated JSON file: $JSON_FILE"

# 允许提交继续
exit 0
