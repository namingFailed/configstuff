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
    if [[ $filetype != "Python" ]]
    then
    echo "I'm sorry only Shell and Python script supported right now :(" 1>&2
    exit 4
    fi
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
function forPy() {
    kword="def"
    kwordl=`expr ${#kword} + 1`
    endlen=`expr ${#kwordl} + ${#fname} - 1 `
    indentLevel=0
    #need to find the white space
    IFS=""
    while read line;
    do
        t=${line:$kwordl:$endlen}
        if [[ $t == "$fname" ]]
        then
            infun=true
            delay=0
            havefun=true
            #if this is a string then indentlevel =1 etc
            echo `echo $line | awk '/ / {print $1}'`
            indentLevel=`echo $line | tr -dc " " | wc -c`
            echo $line
        fi
        if $infun;
        then
            if [[ $delay -ge 1 ]]
            then
            n=`echo $line | tr -dc " " | wc -c` 
            if [[ `echo $line | tr -dc " " | wc -c` == $indentLevel ]]
            then
                echo $line
                infun=false
            else
                echo $line
            fi
            fi
        fi
        if [[ $delay == 0 ]]
        then
            delay=1
        fi
    done < <(cat $file)
}
if [[ $filetype == "Shell" ]]
then
    forShell
fi
if [[ $filetype == "Python" ]]
then
    forPy
fi
if ! $havefun;
then
    echo "$fname was not in file" 1>&2
    exit 2
fi
exit 0
