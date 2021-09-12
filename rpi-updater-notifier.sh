#!/usr/bin/env bash

MAIL_TO="YOR_EMAIL[at]gmail.com"
LOG_FILE="/var/log/rpi-update-status.log"
SUBJECT="[$(/usr/bin/hostname)] Status # apt update $DATA_INICIO" 

{
    /usr/bin/echo "subject: $SUBJECT"
    /usr/bin/echo "<pre>"
    /usr/bin/date
    /usr/bin/echo "# apt-get update"
    /usr/bin/apt-get update 2>&1
    /usr/bin/echo "# apt-get upgrade -y"
    /usr/bin/apt-get upgrade -y 2>&1
    /usr/bin/echo "# apt autoremove -y"
    /usr/bin/apt autoremove -y 2>&1 
    /usr/bin/echo "# apt clean -y"
    /usr/bin/apt clean -y 2>&1 
    if [ -f  /var/run/reboot-required ]
    then
        /usr/bin/echo "#################################"
        /usr/bin/echo "[$(hostname)] Needs reboot!"
        /usr/bin/echo "#################################"        
    fi
    /usr/bin/df --local --output=source,pcent --exclude-type=tmpfs
    /usr/bin/date
    /usr/bin/echo "</pre>"
    /usr/bin/echo "."
} > "$LOG_FILE"

/usr/sbin/sendmail -t "$MAIL_TO" < "$LOG_FILE"