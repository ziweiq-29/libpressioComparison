#!/usr/bin/env bash

# 设置数据路径
DATASET_DIR="dataset/100x500x500"
LOG_FILE="run_pressio.log"
SUMMARY_FILE="summary.csv"

# 清理旧文件
rm -f "$LOG_FILE" "$SUMMARY_FILE"

# 执行 Pressio 压缩操作，记录日志
for file in $(ls "$DATASET_DIR" | sort -V); do
    fullpath="$DATASET_DIR/$file"
    if [[ -f "$fullpath" ]]; then
        echo "Processing: $fullpath" >> "$LOG_FILE"

        pressio -b compressor=sz \
            -o rel=1e-2 \
            -i "$fullpath" \
            -d 500 -d 500 -d 100 \
            -t float \
            -m size -m time \
            -M size:compression_ratio \
            -M time:compress_many >> "$LOG_FILE" 2>&1

        echo "----------------------------------------" >> "$LOG_FILE"
    fi
done

# 用 awk 解析日志生成 CSV
awk '
BEGIN {
  print "file,compression_ratio,compress_time_ms"
}

/^Processing:/ {
  split($2, a, "/");
  file = a[length(a)];
  ratio = "";
  ctime = "";
}

/size:compression_ratio/ {
  if (match($0, /= *([0-9.]+)/, m)) {
    ratio = m[1];
  }
}

/time:compress_many/ {
  if (match($0, /= *([0-9.]+)/, m)) {
    ctime = m[1];
  }
}

(file != "" && ratio != "" && ctime != "") {
  print file "," ratio "," ctime;
  file = "";
  ratio = "";
  ctime = "";
}
' "$LOG_FILE" | tee "$SUMMARY_FILE" | column -s, -t

echo -e "\n✅ summarized to $SUMMARY_FILE"

