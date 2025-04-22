#!/usr/bin/env bash

results_csv="/home/ziweiq2/LibPressio/project/results.csv"
summary_csv="/home/ziweiq2/LibPressio/summary.csv"
ratio_output="comparison_ratio.csv"
time_output="comparison_time.csv"

echo "file,Libpressio-predict,Pressio" > "$ratio_output"
echo "file,Libpressio-predict,Pressio" > "$time_output"

awk -F',' '
  NR==FNR {
    gsub(/^[ \t]+|[ \t]+$/, "", $1);
    results[$1] = $0;
    next
  }

  $1 != "file" {
    gsub(/^[ \t]+|[ \t]+$/, "", $1);
    split(results[$1], vals, ",");
    if (length(vals) == 3) {
      print $1 "," vals[3] "," $2 >> "comparison_ratio.csv";
      print $1 "," vals[2] "," $3 >> "comparison_time.csv";
    }
  }
' "$results_csv" "$summary_csv"

echo -e "\n📊 compression_ratio.csv"
column -s, -t "$ratio_output"
echo -e "\n⏱ compression_time.csv"
column -s, -t "$time_output"

