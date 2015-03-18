#!/bin/bash
LogFile=DeleteDuplicate
time=$(date +%Y%m%d%H%M%S)
LogFile=/var/log/DeleteDuplicate-$time

if [ $# != 1 ]
then
        echo "============================="
        echo "============================="
        echo "Usage: sh $0 path"
        echo "Please Input Absolute Path"
        echo "============================="
        echo "============================="
        exit 1
fi

echo "==============================="
echo "==============================="
echo "Begin To Analysis File Folder..."
echo "==============================="
echo "==============================="
for i in `find $1 -type f`
do
        dd if=$i of=$i.md5 count=1 bs=1024k >/dev/null 2>&1
        md5sum $i.md5 >> /tmp/result.txt
        cd $1
        rm -rf *.md5

done
for i in `find $1 -type l`
do
		dd if=$i of=$i.md5 count=1 bs=1024k >/dev/null 2>&1
        md5sum $i.md5 >> /tmp/result.txt
        cd $1
        rm -rf *.md5
done
ls -lh
#cat /root/result.txt
cat /tmp/result.txt | sort | awk '!i[$1]++'  | awk -F"  " '{print $2}' > /tmp/temp.txt
cat /tmp/temp.txt | sed 's/.md5//' > /tmp/1
sort /tmp/1 -o /tmp/1
find $1 -type f  | sort > /tmp/2
comm /tmp/1 /tmp/2 -3 > /tmp/temp-result.txt
echo "================================"
echo "================================"
echo "Begin to Delete Duplicate File......"
echo "================================"
echo "================================"
for i in `(cat /tmp/temp-result.txt)`
do
    echo "#### `date +%Y-%m-%d`  `date +%H:%M:%S`  #### `id -un` #### Begin to Record Duplicate File :$i" >> $LogFile
    rm -rf $i
done
echo "================================"
echo "================================"
echo "Record Duplicate File Has Finished......"
echo "Begin To Delete Temp File......"

rm -rf /tmp/result.txt
rm -rf /tmp/2
rm -rf /tmp/1
rm -rf /tmp/temp.txt
rm -rf /tmp/temp-result.txt

echo "================================"
echo "================================"
echo "Script has done"
