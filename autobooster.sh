#!/bin/bash

PIDFILE="/var/run/my_service.pid"
LOAD_THRESHOLD="$(($(nproc) * 1,5))"
CHECK_TIMEOUT=60
# DATE=$(date +"%Y-%m-%d %H:%M:%S")

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
# YELLOW='\033[1;33m'
NC='\033[0m'


turbo_booster(){

echo $! > "$PIDFILE"
echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  AutoBooster started with PID $(cat $PIDFILE)${NC}"
echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  AVG threshold is ${LOAD_THRESHOLD}${NC}"

while true ; do
   LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f3 | xargs)
   LOAD_INT=$(echo -e $LOAD | awk '{print int($1+0.5)}')

   if [ "${LOAD_INT}" -gt "${LOAD_THRESHOLD}" ]; then
     echo -e "${RED}$(date +"%Y-%m-%d %H:%M:%S")  AVG5 is ${LOAD_INT}/${LOAD_THRESHOLD}. Let it boost...${NC}"
     echo -e 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
   elif [ "${LOAD_INT}" -lt "${LOAD_THRESHOLD}" ]; then
     echo -e "${GREEN}$(date +"%Y-%m-%d %H:%M:%S")  AVG5 is ${LOAD_INT}/${LOAD_THRESHOLD}. Keeping low profile...${NC}"
     echo -e 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
   fi
   sleep "${CHECK_TIMEOUT}"
done
}

service_start() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE"); then
        echo -e "Service already running"
        exit 1
    fi
    echo -e "Starting TurboBooster..."
    turbo_booster &
    echo -e $! > "$PIDFILE"
    echo -e "TurboBooster started with PID $(cat $PIDFILE)"
}

service_stop() {
    if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE"); then
        echo -e "Stopping service..."
        kill $(cat "$PIDFILE")
        rm -f "$PIDFILE"
        echo -e "Service stopped"
    else
        echo -e "Service not running"
    fi
}

# case "$1" in
#     start)
#         service_start
#         ;;
#     stop)
#         service_stop
#         ;;
#     restart)
#         service_start
#         service_stop
#         ;;
#     status)
#         if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE"); then
#             echo -e "Service running with PID $(cat $PIDFILE)"
#         else
#             echo -e "Service not running"
#         fi
#         ;;
#     *)
#         echo -e "Usage: $0 {start|stop|restart|status}"
#         exit 1
#         ;;
# esac

turbo_booster