#!/bin/bash

PIDFILE="/var/run/my_service.pid"
INIFILE="${1:-/etc/autobooster.ini}"
LOAD_THRESHOLD="$(($(nproc) * 1,5))"
CHECK_TIMEOUT=60

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

source_config(){
    if [ -f "${INIFILE}" ] 
    then
        # shellcheck disable=SC1090
        source "${INIFILE}"
        echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  External configuration loaded, going further...${NC}"
    fi
}

check_boost(){
    echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  Checking Turbo Boost drivers...${NC}"

    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ] 
    then
        echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  The drivers is in place, going further...${NC}"
    else
        echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  The there no appropriate drivers, exiting...${NC}"
        exit 1
    fi
}

turbo_booster(){

echo $! > "$PIDFILE"
echo -e "${CYAN}$(date +"%Y-%m-%d %H:%M:%S")  AutoBooster successfully started${NC}"
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

check_boost
source_config
turbo_booster
