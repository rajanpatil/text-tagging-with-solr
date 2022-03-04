#!/usr/bin/env bash

DATA_HOME=$(dirname $0 | while read a; do cd $a && pwd && break; done)
csv_file_name="gen_author_names.csv"
num_records=5
if [[ $# == 1 ]]
then
  num_records=$1
fi
rm -f $DATA_HOME/$csv_file_name
for id in $(seq 1 "$num_records")
do
   echo "$id,firstname$id lastname$id" >> $DATA_HOME/$csv_file_name
done
