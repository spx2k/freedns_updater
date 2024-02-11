#!/bin/bash

# Check if check file for crontab already exists
JOB_FILE="/var/local/dns_updater/cronjob_added"
if [ -e "$JOB_FILE" ]; then
    echo "Job already exists, not first run."
    exit 0
fi
if [ -z "$MINS_INTERVAL" ]; then
    echo "MINS_INTERVAL not set, defaulting to 20 minutes."
    MINS_INTERVAL="*/20"
elif (( MINS_INTERVAL < 59 )) && (( MINS_INTERVAL > 0 )); then
    echo "Adding job to run every ${MINS_INTERVAL} hours."
    MINS_INTERVAL="*/${MINS_INTERVAL}"
    echo "job_added" > $JOB_FILE
else
    echo "MINS_INTERVAL must be 1-59."
    exit 1
fi
if [ -z "$HOURS_INTERVAL" ]; then
    echo "HOURS_INTERVAL not set, defaulting to 1 hours."
    HOURS_INTERVAL="*"
elif (( HOURS_INTERVAL < 24 )) && (( HOURS_INTERVAL > 0 )); then
    echo "Adding job to run every ${HOURS_INTERVAL} hours."
    HOURS_INTERVAL="*/${HOURS_INTERVAL}"
    echo "job_added" > $JOB_FILE
else
    echo "HOURS_INTERVAL must be 1-23."
    exit 1
fi

echo -e "${MINS_INTERVAL} ${HOURS_INTERVAL} * * * /bin/update-freedns.sh\n" > /var/spool/cron/crontabs/root
