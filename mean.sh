#!/bin/bash

# Check for correct number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <column> [file.csv]" >&2
  exit 1
fi

# Check if a file is provided as the second argument or read from stdin
if [ "$#" -eq 2 ]; then
  file="$2"
else
  file="/dev/stdin"
fi

# Calculate the mean of the specified column
cut -d ',' -f "$1" "$file" | tail -n +2 | {
  sum=0
  count=0
  while read line; do
    ((count++))
    sum=$(echo "scale=8; $sum + $line" | bc)
    # sum=$(awk "BEGIN {print $sum + $line}")
  done

  if [ "$count" -gt 0 ]; then
    mean=$(echo "scale=8; $sum / $count" | bc)
    echo "$mean"
  else
    echo "No data in the specified column."
  fi
}
