#!/bin/bash
#Script to check if the repos need updating
for name in $(find $repodir -maxdepth 1 -type d -follow)
do
    cd $name
    if [[ -e ".git" ]]
    then
        git remote update
        if [[ -n $(git diff --stat refs/remotes/laptop/master | grep "changed") ]]
        then
            echo -e "\033[0;32m $name \033[0m changes" # print in green the folder name
        fi
    fi
    cd $OLDPWD
    
done

