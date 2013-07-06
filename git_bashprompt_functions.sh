#!/bin/bash
#RED='\[\033[0;31m\]'
#YELLOW='\[\033[0;33m\]'
#GREEN='\[\033[0;32m\]'
#NO_COLOUR='\[\033[0m\]'
#f_RED='\033[0;31m'
#f_YELLOW='\033[0;33m'
#f_GREEN='\033[0;32m'
#f_NO_COLOUR='\033[0m'


RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
NO_COLOUR=$(tput sgr0)
f_RED=$RED
f_YELLOW=$YELLOW
f_GREEN=$GREEN
f_NO_COLOUR=$NO_COLOUR


function parse_git_branch () {
       git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
function git_changes () {
    if [[ -e .git ]]
    then
        b=`git status --porcelain`
        c=`git status`
        unadd=false
        untrack=false
        mod=false
        remotes=false
        if [[ `echo "$c" | grep "# Your branch is ahead"` ]] 
        then
            echo -n -e "$f_GREEN" 
            echo -n -e "A"
            remotes=true
        fi
        if [[ `echo "$c" | grep "have diverged"` ]]
        then
            echo -n -e "\033[33;1m"
            echo -n -e "D"
            remotes=true
        fi
        if [[ `echo "$b" | grep  ^" M"` ]]
        then
            unadd=true
        fi
        if [[ `echo "$b" | grep ^"MM"` ]]
        then
            mod=true
        fi
        if [[ `echo "$b" | grep ^"??"` ]]
        then
            untrack=true
        fi
        if  $untrack || $unadd || $mod 
        then
            echo -n -e "$f_NO_COLOUR["    
        
        if $untrack;
        then
            echo -n "$f_NO_COLOUR?"
            untrack=false
        fi
        if $unadd;
        then
            printf "$f_RED*"
            unadd=false
        fi
        if $mod;
        then
            printf "$f_GREEN#"
            mod=false
        fi
        echo -n -e "$f_NO_COLOUR]"
    else
        if ! $remotes
        then
            echo -n -e "$f_GREEN="
        fi
    fi
    fi
}
function hg_branch () {
    echo `hg branch 2> /dev/null`;
}
if [[ "$1" == "branch" ]]
then
    parse_git_branch
fi
if [[ "$1" == "changes" ]]
then
    git_changes
fi
