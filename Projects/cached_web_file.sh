#!/usr/bin/env bash

PREFIX=$1

URL=$2
MAX_FILES=${3:-1}

files=$(ls --sort=time $PREFIX*)

count=0

for file in $files; do

    if [ "$count" -gt "$MAX_FILES" ]; then
        rm $file
    fi

    count=$((count+1))

done

url_hash=$(echo -n $URL | md5sum | cut -c -32)

output_file_name=$PREFIX$url_hash

test -e $output_file_name || curl -s $URL > $output_file_name

echo $output_file_name