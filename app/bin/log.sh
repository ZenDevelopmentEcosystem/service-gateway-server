#!/bin/bash

LOG_FILE=${LOG_FILE:-/var/log/ssh-gateway/access.log}
touch "${LOG_FILE}"

loginfo() {
    part=$1; shift
    echo "$(date --rfc-3339=seconds)-[${part}]: $*" >> "${LOG_FILE}"
}
