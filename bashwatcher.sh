#!/bin/bash
inotifywait -m ~/.bashrc |
while read LINE; 
do
   echo "test" >> ~/test.txt; 
done
    #notify-send "change to bashrc";
  
#notifywait -e ATTRIB -e MODIFY -m ~/.bashrc
