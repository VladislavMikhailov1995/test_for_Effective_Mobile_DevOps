#!/bin/bash

PROCESS_NAME="test"
MONITOR_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/var/run/monitor_test.pid"

CURRENT_PID=$(pidof "$PROCESS_NAME")

if [[ -n "$CURRENT_PID" ]]; then
    if [[ -f "$PID_FILE" ]]; then
        LAST_PID=$(cat "$PID_FILE")
        if [[ "$CURRENT_PID" != "$LAST_PID" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Процесс $PROCESS_NAME был перезапущен. Новый PID: $CURRENT_PID" >> "$LOG_FILE"
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Обнаружен запуск процесса $PROCESS_NAME. PID: $CURRENT_PID" >> "$LOG_FILE"
    fi

    echo "$CURRENT_PID" > "$PID_FILE"

    curl -s -o /dev/null --connect-timeout 5 --max-time 10 --retry 2 --retry-delay 2 "$MONITOR_URL"
    if [[ $? -ne 0 ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Сервер мониторинга $MONITOR_URL недоступен." >> "$LOG_FILE"
    fi
fi
