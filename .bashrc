# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


export COLOURTERM=xterm
export TERM=xterm

export PATH=$PATH:~/Downloads/android-sdk-linux/

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias writer='soffice'
alias joshua='/home/clare/scripts/logjosh'
alias restartx='sudo restart lightdm'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export EDITOR=/usr/bin/vim

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

#function parse_git_branch () {
#       git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#}
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
                echo -n "$f_RED*"
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
function set_bash_prompt(){
    PS1="\[$GREEN\]\u@\h\[$RED\]:\w\[$YELLOW\]\[\$(. /home/clare/projects/configstuff/git_bashprompt_functions.sh branch)\]\[\$(hg_branch)\]\[$NO_COLOUR\]\[$(git_changes)\]\[$NO_COLOUR\]\$ \e\[s"
    trap '{ if [[ ! ("$BASH_COMMAND" == "set_bash_prompt") ]]; then echo -ne "\e]2;$BASH_COMMAND\007"; fi }' DEBUG
}

PROMPT_COMMAND=set_bash_prompt


t=`cat ~/.sys_facts | grep "repo_path"`
repodir=${t:9}
export repodir=$(echo $repodir | sed -e s@\$HOME@"${HOME}"@)

export COLOURTERM=xterm
export TERM=xterm
alias bat='acpi -b'
alias ins=$repodir/configstuff/install
alias unin=$repodir/configstuff/uninstall
alias off='$repodir/configstuff/bash_shutdown.sh'
alias xterm='xterm -fa "Anonymous Pro for Powerline"'
alias list="nmap -sP 192.168.0.0/24"
alias checkin="dpkg -s $1 | grep Status"

check=`tail -n1 $HOME/.sys_facts` 
if [[ ! ($check == "gitchecked") ]]
then
    $repodir/configstuff/gitupdate.sh
fi
