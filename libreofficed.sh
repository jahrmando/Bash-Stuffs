#!/bin/bash
#===============================================================================
#
# chkconfig: 35 99 99
#
# FILE: libreofficed.sh
#
# USAGE: libreofficed.sh [start|stop|restart]
#
# DESCRIPTION: Libreoffice service daemon.
# It allow you to execute LibreOffice in daemon mode
# and it's compatible with chkconfig (RedHat utility)
#
# OPTIONS: ---
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: ---
# AUTHOR: Armando Uch, jahrmando@gmail.com
# COMPANY: ---
# VERSION: 1.0
# CREATED: 20.05.2014 - 11:20:00
# REVISION: 20.05.2014
#===============================================================================

. /etc/rc.d/init.d/functions

USER="root"
DAEMON="/usr/bin/soffice"
LOG_DIR="/var/log/libreoffice"
LOG_FILE="$LOG_DIR/service.log"
LOCK_FILE="/var/lock/subsys/libreofficed"

if [[ ! -e $LOG_DIR ]]; then
        `mkdir -p $LOG_DIR`
fi

if [[ ! -e $LOG_FILE ]]; then
        `touch $LOG_FILE`
fi

do_start()
{
        if [ ! -f "$LOCK_FILE" ] ; then
                echo -n $"Starting libreofficed: "
                runuser -l "$USER" -c "$DAEMON --accept='socket,host=127.0.0.1,port=2002;urp;StarOffice.NamingService' --headless >> $LOG_FILE 2>&1 &" && echo_success || echo_failure
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && touch $LOCK_FILE
        else
                echo "libreofficed is locked."
                RETVAL=1
        fi
}
do_stop()
{
        echo -n $"Stopping libreofficed: "
	child_pid=""
        pid=`ps -aefw | grep "/usr/lib/libreoffice/program/oosplash" | grep -v " grep " | awk '{print $2}'`
	if [ "$pid" != '' ]; then
		child_pid=`ps -o pid --no-headers --ppid "$pid"`
	fi
        kill -9 $pid $child_pid > /dev/null 2>&1 && echo_success || echo_failure
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
}
case "$1" in
        start)
                do_start
                ;;
        stop)
                do_stop
                ;;
        restart)
                do_stop
                do_start
                ;;
        *)
                echo "Usage: $0 {start|stop|restart}"
                RETVAL=1
esac
exit $RETVAL
