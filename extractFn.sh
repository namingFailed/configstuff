#!/bin/bash
#Requires: ruby, ruby-dev, libicu-dev,  github-linguist gem
#todo add support for java and python

#Input Tests
if [[ $# -ne 2 ]]
then
    echo "usage:  extractFn.sh file function_name" 1>&2
    exit 1
fi
if [[ ! -r $1 ]]
then 
    echo "$1 is not a file..." 1>&2
    exit 3
fi
filetype=`exec ruby test.rb $1`
if [[ $filetype != "Shell" ]]
then
    echo "I'm sorry only Shell script supported right now :(" 1>&2
    exit 4
fi
fname=$2
file=$1
infun=false
havefun=false

#functions per filetype
function forShell() {
    kword="function"
    kwordl=`expr ${#kword} + 1`
    endlen=`expr ${#kwordl} + ${#fname} - 1 `

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
            havefun=true
        fi
        
    done < <(cat $file)
}
if [[ $filetype == "Shell" ]]
then
    forShell
fi
if ! $havefun;
then
    echo "$fname was not in file" 1>&2
    exit 2
fi
exit 0
