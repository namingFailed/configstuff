#!/bin/bash
#every minute where battery is less than 1hr charge remaining give warning
#Requires: acpi, libnotify
#Cron:
# */1 * * * *  env DISPLAY=:0 /home/clare/projects/configstuff/checkbat.sh
  
bat=`acpi -b`
hours=$(echo $bat | cut -f 5 -d " " | cut -f 1 -d ":")
charging=`acpi -b | cut -f 3 -d " "`
if [[ $charging != "Charging," ]]
then
    if [ $hours -lt 1 ]
        then
            notify-send "WARNING: $bat"
    fi
fi

