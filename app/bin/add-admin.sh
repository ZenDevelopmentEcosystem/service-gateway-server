#!/usr/bin/env bash

ID=$1
KEY_FINGERPRINT=$2

echo "command=\"/opt/servicegwd/bin/admin-login.sh ${ID}\",no-user-rc ${KEY_FINGERPRINT}" >> "/etc/servicegwd/authorized_keys"
#echo "${KEY_FINGERPRINT}" >> "/etc/servicegwd/authorized_keys"
