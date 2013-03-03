#!/bin/bash/
#find a host with the repos to connect to
function choose {
    ghaddr=`list | grep $1`
    if [ $? -eq 0 ]
    then gaddr=`echo ${ghaddr: -14 : -1 }`;
    else gaddr='false';
    fi
}
for line in `cat ./ghosts`
do
    choose($line);
    if [ $gaddr -ne 'false' ]
        type -P git || {echo 'needs git please install'; exit 1};
        mkdir ~/repos
        cd ~/repos
        #clone repos
        for line in `cat ./repos.txt`
        do
        git clone $user@$gaddr/~$user/repos/$line/.git
        done;
        exit 0;
    fi
done

