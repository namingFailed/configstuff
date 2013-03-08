#!/bin/bash
#Script to check if the repos need updating
for name in $(find $repodir -maxdepth 1 -type d -follow)
do
   cd $name
    if [[ -e ".git" ]]
    then
        git remote update
        gsb=`git show-branch *master`
        
        for line in "$gsb"
        do
            branch=`git show-ref | cut -f 2 -d ' '`
            gsbc=$(echo "$gsb" | cut -f 2 -d ']')
            if [[ -z $(git log | grep "$gsbc") ]]
            then
                echo -e "\033[0;32m $name $branch $gsbc \033[0m "
            fi
        done
    fi
    cd $OLDPWD
done

