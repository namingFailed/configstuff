#!/bin/bash
fname=$2
file=$1
kword="function"
kwordl=`expr ${#kword} + 1`
endlen=`expr ${#kwordl} + ${#fname} - 1 `

infun=false

while read line;
do
    t=${line:$kwordl:$endlen}
    if [[ "$infun" == "true" ]]
    then
        echo "$line"
        if [[ ${line:0:1} == "}" ]]
        then
            infun=false
        fi
    fi
    if [[ "$t" == "$fname" ]]
    then
        echo "$line"
        infun=true
    fi
    
done < <(cat $file)
