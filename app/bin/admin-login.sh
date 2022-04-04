#!/usr/bin/env bash

set -eu -o pipefail

echo "Hello Admin: ${1:-}" | tee --append /tmp/ssh-login
echo "Original command: ${SSH_ORIGINAL_COMMAND:-}" | tee --append /tmp/ssh-login
