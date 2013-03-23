#!/bin/bash

routerip=`route | grep default | awk -F " " '{print $2}'`
routermac=`arp $routerip | grep $routerip | awk -F " " '{print $3}'`
echo "router ip $routerip"
echo "router mac $routermac"
