#!/bin/bash
wifi=false
eth=false
wiconnection=false

if [[ `ip -oneline addr | grep "inet " | grep -c "wlan0"` -eq 1 ]]
then
    wifi=true
fi

if [[ `ip -oneline addr | grep "inet " | grep -c "eth0"` -eq 1 ]]
then
    eth=true
fi

if [[ $wifi -eq 'true' ]]
then
    wiconnection=$(iwconfig 2>&1 | grep 'ESSID' | awk '{print $4}'| cut -f 2 -d ':') 
fi

echo "eth $eth wifi $wifi wiconnect $wiconnection"

