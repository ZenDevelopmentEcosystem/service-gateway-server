#!/bin/bash
set -eu

BIN_DIR=$(cd "$(dirname "$0")" && pwd)

# shellcheck source=log.sh
source "${BIN_DIR}/log.sh"
# shellcheck source=db.sh
source "${BIN_DIR}/db.sh"

log() {
    loginfo "register" "$@"
}

HOST_ID=$1
PORT=$2
APP_ID=$3
CLIENT_IP=$(echo "${SSH_CONNECTION}" | cut -d " " -f 1)

log "client $CLIENT_IP, host $HOST_ID, application ${APP_ID}, port $PORT"

db_prepare
db_entry_set "${HOST_ID}" "${CLIENT_IP}" "${PORT}" "${APP_ID}"
