#!/bin/bash

#use mysqldump to fully backup mysql data



BakDir=~/

LogFile=~/bak.log



Date=`date +%Y%m%d`

Begin=`date +"%Y/%m/%d %H:%M:%S"`

cd $BakDir

DumpFile=$Date.sql

GZDumpFile=wordpress_db_bak_$Date.tgz

mysqldump -uroot -pojxbcvisrev -h172.17.0.1 wordpress --lock-all-tables --routines --triggers --events > $DumpFile

tar zcvf $GZDumpFile $DumpFile

rm $DumpFile

Last=`date +"%Y/%m/%d %H:%M:%S"`

echo Start: $Begin end: $Last $GZDumpFile succ >> $LogFile
