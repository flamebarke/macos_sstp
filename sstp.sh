#!/bin/bash

SERVICE_NAME='<MODIFY>'
SERVICE_URL='<MODIFY>'

if [[ ${#USER} > 1 ]]
then
    read -p "Log in as ${USER}? [y/n] " LIA
else
    LIA = 'n'
fi

if [[ $LIA == 'y' ]] || [[ $LIA == 'Y' ]]
then
    UN=$USER
else
    read -p "VPN Username: " UN
fi

PW_KC=$(security find-generic-password -a $UN -s $SERVICE_NAME -w 2> /dev/null)
PW=''

if [[ ${#PW_KC} > 1 ]]
then
    read -p "Use password from keychain? [y/n] " UPWKC
    if [[ $UPWKC == 'y' ]] || [[ $UPWKC == 'Y' ]]
    then
        PW=$PW_KC
    fi
fi

if [[ ${#PW} == 0 ]]
then
    read -sp "VPN Password: " PW

    echo
    read -p "Store password in keychain? [y/n] " UPWKC
    if [[ $UPWKC == 'y' ]] || [[ $UPWKC == 'Y' ]]
    then
        security add-generic-password -a $UN -s $SERVICE_NAME -w $PW
    fi
fi

echo -e "\nConnecting after sudo.."
sudo /usr/local/sbin/sstpc --log-stderr --log-level 5 --cert-warn --user $UN --password $PW $SERVICE_URL usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap nobsdcomp nodeflate
