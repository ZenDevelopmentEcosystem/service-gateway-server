#!/bin/bash
set -eu

BIN_DIR=$(cd "$(dirname "$0")" && pwd)
ARGS=(${SSH_ORIGINAL_COMMAND:-})

# shellcheck source=log.sh
source "${BIN_DIR}/log.sh"

log() {
    loginfo "gw" "$@"
}

log "arguments=${ARGS[*]}"

if [ "${ARGS[0]}" = "reg" ]; then
    "${BIN_DIR}/register.sh" "${ARGS[@]:1}"
elif [ "${ARGS[0]}" = "unreg" ]; then
    "${BIN_DIR}/unregister.sh" "${ARGS[@]:1}"
elif [ "${ARGS[0]}" = "get" ]; then
    "${BIN_DIR}/get-clients.sh" "${ARGS[@]:1}"
fi
