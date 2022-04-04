#!/bin/bash

DB_FILE=${DB_FILE:-/tmp/ssh-gateway/db.dat}

# shellcheck source=lock.sh
source "${BIN_DIR}/lock.sh"

db_prepare() {
    mkdir -p "$(dirname "${DB_FILE}")"
    touch "${DB_FILE}"
}

db_format_entry() {
    local host_id=$1
    local client_ip=$2
    local port=$3
    local app_id=$4
    printf "%s\t%s\t%s\t%s" "${host_id}" "${client_ip}" "${port}" "${app_id}"
}

db_entry_exists() {
    local host_id=$1
    grep -q --text -oP "^${host_id}\t" "${DB_FILE}" 2> /dev/null
}

db_entry_set() {
    local host_id=$1
    local client_ip=$2
    local port=$3
    local app_id=$4
    local entry; entry=$(db_format_entry "${host_id}" "${client_ip}" "${port}" "${app_id}")
    exlock
    if db_entry_exists "${host_id}"; then
        sed -i "s/^${host_id}\t.*/${entry}/" "${DB_FILE}"
    else
        echo "${entry}" >> "${DB_FILE}"
    fi
    unlock
}

db_get_entries() {
    local app_id=$1
    awk "\$4 ~ /${app_id}/ { print \$0 }" "${DB_FILE}" 2> /dev/null || true
}

db_entry_unset() {
    local host_id=$1
    if db_entry_exists "${host_id}"; then
        exlock
        sed -i "/^${host_id}\t/d" "${DB_FILE}"
        unlock
    fi
}
