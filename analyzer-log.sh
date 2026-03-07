#!/bin/bash

ERROR_PATTERNS=("ERROR" "CRITICAL" "FATAL")
ROOT_DIR=$(pwd)
REPORT_FILE="$ROOT_DIR/report.txt"

# Find the logs file that is updated < 1 day
UPDATED_LOG_FILES=$(find $ROOT_DIR -name "*.log" -mtime -1)

echo "Analyzing log files...." > $REPORT_FILE
echo "Within 24 hours, $UPDATED_LOG_FILES log files are updated." >> $REPORT_FILE
echo "==================================================================================================" >> $REPORT_FILE

for LOG_FILE in $UPDATED_LOG_FILES;do
    echo "Start analyzing $LOG_FILE" >> $REPORT_FILE
    echo "==================================================================================================" >> $REPORT_FILE
    for ERROR_PATTERN in ${ERROR_PATTERNS[@]};do
        COUNT=$(grep -c $ERROR_PATTERN $LOG_FILE)
        echo "Found $COUNT $ERROR_PATTERN in $LOG_FILE" >> $REPORT_FILE
        grep $ERROR_PATTERN $LOG_FILE >> $REPORT_FILE
        if [ "$COUNT" -gt 10 ];then
            echo "⚠️ Found $COUNT $ERROR_PATTERN errors in $LOG_FILE. This needs to take immediate actions."
        fi
    done
done

echo "Finish analyzing log files, saved report to $REPORT_FILE"