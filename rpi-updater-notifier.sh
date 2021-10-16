#!/usr/bin/env bash

MAIL_TO="YOR_EMAIL[at]gmail.com"
LOG_FILE="/var/log/rpi-update-status.log"
SUBJECT="[$(/usr/bin/hostname)] Status apt update $DATA_INICIO" 

{
    /usr/bin/echo "subject: $SUBJECT"
    /usr/bin/echo
    /usr/bin/date
    /usr/bin/echo
    /usr/bin/echo "# apt-get update"
    /usr/bin/apt-get update 2>&1
    /usr/bin/echo
    /usr/bin/echo "# apt-get upgrade -y"
    /usr/bin/apt-get upgrade -y 2>&1
    /usr/bin/echo
    /usr/bin/echo "# apt-get autoremove -y"
    /usr/bin/apt-get autoremove -y 2>&1 
    /usr/bin/echo
    /usr/bin/echo "# apt-get clean -y"
    /usr/bin/apt-get clean -y 2>&1 
    if [ -f  /var/run/reboot-required ]
    then
        /usr/bin/echo
        /usr/bin/echo "#################################"
        /usr/bin/echo "[$(hostname)] Needs reboot!"
        /usr/bin/echo "#################################"
        /usr/bin/echo
    fi
    /usr/bin/echo "# /usr/local/bin/pihole -up"
    /usr/local/bin/pihole -up 2>&1 
    /usr/bin/echo 
    /usr/bin/df --local --output=source,pcent --exclude-type=tmpfs
    /usr/bin/echo
    /usr/bin/date
    /usr/bin/echo "."
} > "$LOG_FILE"

/usr/sbin/sendmail -t "$MAIL_TO" < "$LOG_FILE"