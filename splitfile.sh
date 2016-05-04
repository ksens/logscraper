#!/bin/bash

FILE=$1
TAG=$2

cat $FILE | grep aio_save | egrep -v "show\(" | egrep -v "list\(" | cut -d ':' -f 5- | cut -d ';' -f 1 | sed -s "s/taq_20150611/taqPOC_20160401/g" | sed -s "s/20150611/20160401/g" | sed -s "s/^/time iquery -p 1240 -anq \"/g" | sed -s "s/$/\"/g" | awk -v COUNT=6 '{ f=(f%COUNT)+1 ; print > "queries_'$TAG'_" f ".prep" }'

for i in `seq 1 6`;
do

while read line; do
  echo "set -x" >> queries_${TAG}_${i}.sh
  cat common_queries.sh | sed -s "s/shim_output_buf/shim_output_buf_${TAG}_${i}/g" >> queries_${TAG}_${i}.sh
  echo $line | sed -s "s/shim_output_buf/shim_output_buf_${TAG}_${i}/g" >> queries_${TAG}_${i}.sh
  echo "rm -rf /run/shm/shim_output_buf_${TAG}_${i}*" >> queries_${TAG}_${i}.sh
  echo "" >> queries_${TAG}_${i}.sh
done < queries_${TAG}_${i}.prep
chmod a+x queries_${TAG}_${i}.sh
done

rm -rf *.prep
