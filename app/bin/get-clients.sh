#!/bin/bash
set -eu

BIN_DIR=$(cd "$(dirname "$0")" && pwd)

# shellcheck source=lock.sh
source "${BIN_DIR}/lock.sh"
# shellcheck source=log.sh
source "${BIN_DIR}/log.sh"
# shellcheck source=db.sh
source "${BIN_DIR}/db.sh"

log() {
    loginfo "get-clients" "$@"
}

APP_ID=$1
CLIENT_IP=$(echo "${SSH_CONNECTION}" | cut -d " " -f 1)

log "$CLIENT_IP requested ${APP_ID} clients"

db_get_entries "${APP_ID}"
