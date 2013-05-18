#!/bin/bash
#change the group of the package
#usually this is to go between testing and a specific other group
if [ $# -lt 2 ] || [ $# -gt 3 ]
then
    echo "There needs to be 2 or 3 arguments..." 1>&2
    echo "If changing the group use 3 arguments" 1>&2
    echo "1: The name of the package" 1>&2
    echo "2: The name of the group that needs to be changed (NO SPACES)" 1>&2
    echo "3: The new group (NO SPACES)" 1>&2
    echo "If adding a group use 2 arguments" 1 >&2
    echo "1: The name of the package (NO SPACES)" 1>&2
    echo "2: The name of the new group (NO SPACES)" 1>&2
fi
#find the row in the frombase.txt file
options=`grep ++$1 /home/clare/sync/configstuff/frombase.txt`
IFS="++"
while line
do
    echo "$line"
done < "$options"
