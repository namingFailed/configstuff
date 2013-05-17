#!/bin/bash
changes=false
echo "gitchecked" >> $HOME/.sys_facts
echo "Checking git repos for updates"

for name in $(find $repodir -maxdepth 1 -type d -follow)
do
   cd $name
    if [[ -e ".git" ]]
    then
    #if wifi=home do all else just those with domain name ending .org, .com
    # .co.uk
        hotspot=`$repodir/configstuff/connection.sh | cut -f 6 -d " "`
        if [[ $hotspot == '"virginmedia113"' ]]
        then
            if [[ -n `ping -c3 www.google.com` ]]
            then
                git remote update > /dev/null
            else
                for i in `git remote -v | grep -ev "\.[o/c]" | grep "(fetch)" | cut -f 1`
                do
                    git remote update $i > /dev/null
                done
                #update only on local network
            fi
        else
    #find which to update and update
        if [[ -n `ping -c3 www.google.com` ]]
        then
            for i in `git remote -v | grep .org  | cut -f 1`
            do
                git remote update $i > /dev/null
            done
            for i in `git remote -v | grep .com | cut -f 1`
            do
                git remote update $i > /dev/null
            done
        fi
    fi
    for line in `git show-ref master | grep remotes | cut -f2 -d " "`
        do
            if [[ -n  `git rev-list --max-count=1 ^master "$line" --pretty --cherry-pick --no-merges` ]]
            then
                repochange=true
            fi
        done
        if [[ $repochange == true ]]
        then
            echo "$PWD  $line has changes"
            changes=true
        fi
        repochange=false
    fi
    cd $OLDPWD
done

if [[ $changes == false ]]
then
    echo "All the gits in $repodir are up to date on this host [as far as we can tell]"
fi
