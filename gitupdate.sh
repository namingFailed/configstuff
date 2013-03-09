#!/bin/bash
changes=false
for name in $(find $repodir -maxdepth 1 -type d -follow)
do
   cd $name
    if [[ -e ".git" ]]
    then
        git remote update
        for line in `git show-ref master | grep remotes | cut -f2 -d " "`
        do
            if [[ -n  $(`git rev-list --max-count=1 ^master "$line" --pretty --cherry-pick --no-merges`) ]]
            then
                echo "$line has changes"
                repochange=true
            fi
        done
        if [[ $repochange == true ]]
        then
            echo "$PWD"
            changes=true
        fi
        repochange=false
    fi
    cd $OLDPWD
done

if [[ $changes == false ]]
then
    echo "All the gits in $repodir are up to date on this host"
fi

