!#/bin/bash

#remove gitchecked
$checked = `tail -n 1 $HOME/.sys_facts`
if [ $checked == "gitchecked" ]
then
    head -n -1 $HOME/.sys_facts >> $HOME/.sys_facts
fi
sudo shutdown -h now
