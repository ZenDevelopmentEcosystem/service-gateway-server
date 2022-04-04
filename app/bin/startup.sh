#!/bin/bash

set -eu

GATEWAY_SERVER_CONFIG=${GATEWAY_SERVER_CONFIG:-/etc/ssh-gateway-server/server.conf}
GATEWAY_SERVER_SSHD_CONFIG=${GATEWAY_SERVER_SSHD_CONFIG:-/etc/ssh/ssh_config}

BIN_DIR=$(cd "$(dirname "$0")" && pwd)

# shellcheck source=../config/server.conf
source "${GATEWAY_SERVER_CONFIG}"

# shellcheck source=db.sh
source "${BIN_DIR}/db.sh"

start_sshd() {
 exec "/usr/sbin/sshd" \
    -D \
    -p "${GATEWAY_SERVER_SSHD_PORT}" \
    -f "${GATEWAY_SERVER_SSHD_CONFIG}" \
    -E "${GATEWAY_SERVER_SSHD_LOG_FILE}"
}

prune_disconnected_clients() {
    local client_port
    local client_host
    while true; do

        while IFS= read -r entry
        do
           if [ -n "${entry}" ]; then
               client_port=$(echo "${entry}"|awk '{ print $3 }')
               if ! grep -q -e "tcp.*0.0.0.0.0:${client_port}.*LISTEN" <(netstat -nl) 2> /dev/null; then
                   client_host=$(echo "${entry}"|awk '{ print $1 }')
                   db_entry_unset "${client_host}"
                   echo "pruned: host=${client_host}, port=${client_port}"
               fi
           fi
        done < <(printf '%s\n' "$(db_get_entries '.*')")

        sleep "${GATEWAY_SERVER_PRUNE_INTERVAL}"
    done
}

#start_sshd &
prune_disconnected_clients &

wait
