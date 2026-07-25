#!/bin/bash

if [ "${F2B_LOG_LEVEL}" == "DEBUG" ]; then
  echo "TZ: ${TZ}"
  echo "F2B_LOG_TARGET: ${F2B_LOG_TARGET}"
  echo "F2B_LOG_LEVEL: ${F2B_LOG_LEVEL}"
  echo "F2B_DB_PURGE_AGE: ${F2B_DB_PURGE_AGE}"
  echo "IPTABLES_MODE: ${IPTABLES_MODE}"
  echo "F2B_NO_DEB_DEFAULTS: ${F2B_NO_DEB_DEFAULTS}"
fi

# Timezone
if [ "$(cat /etc/timezone)" != "${TZ}" ]; then
  echo "WARNING: timezone mismatched"
fi

# Init
if [ ! -d "/data/run" ] || [ ! -d "/data/lib" ] || [ ! -d "/data/db" ]; then
  echo "WARNING: missing folders"
fi

if [ "$IPTABLES_MODE" = "auto" ] && ! iptables -L &> /dev/null; then
  echo "WARNING: iptables is not supported by the host"
fi

iptables -V
nft -v

if [ ! command -v journalctl &> /dev/null ]; then
  echo "WARNING: systemd-journalctl not found"
fi

exec "$@"
