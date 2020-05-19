#!/bin/sh
# chkconfig: 2345 99 10
# description: STARTSTOP SHELL

DATA_LOCAL="/root/7dtd/7DaysToDie/Data"
DATA_SERVER="s3://7dtd-backup/Data"
WORLD_LOCAL="/root/7dtd/7DaysToDie/Saves"
WORLD_SERVER="s3://7dtd-backup/Saves"
LOGFILE="/var/log/save_data_sync_7dtd.log"
SUBSYS="/var/lock/subsys/save_data_sync"


echo "[$(date)] : $1" >> ${LOGFILE}
case "$1" in
  start)
    /usr/local/bin/aws s3 sync --exact-timestamps ${DATA_SERVER} ${DATA_LOCAL} >> ${LOGFILE}
    /usr/local/bin/aws s3 sync --exact-timestamps ${WORLD_SERVER} ${WORLD_LOCAL} >> ${LOGFILE}

    touch ${SUBSYS}
    ;;
  stop)
    /usr/local/bin/aws s3 sync --exact-timestamps ${DATA_LOCAL} ${DATA_SERVER} >> ${LOGFILE}
    /usr/local/bin/aws s3 sync --exact-timestamps ${WORLD_LOCAL} ${WORLD_SERVER} >> ${LOGFILE}

    rm -f ${SUBSYS}
    ;;
  *) break ;;
esac
