#!/bin/bash

if [ "${F2B_LOG_LEVEL}" == "DEBUG" ]; then
  echo "TZ: ${TZ}"
  echo "F2B_LOG_TARGET: ${F2B_LOG_TARGET}"
  echo "F2B_LOG_LEVEL: ${F2B_LOG_LEVEL}"
  echo "F2B_DB_PURGE_AGE: ${F2B_DB_PURGE_AGE}"
  echo "IPTABLES_MODE: ${IPTABLES_MODE}"
  echo "F2B_NO_DEB_DEFAULTS: ${F2B_NO_DEB_DEFAULTS}"
  iptables -V
  nft -v
fi

# Timezone
if [ "$(cat /etc/timezone)" != "${TZ}" ]; then
  echo "WARNING: timezone mismatched"
fi

# Init
if [ ! -d "/data/db" ]; then
  echo "WARNING: missing db folder"
fi

if [ "$IPTABLES_MODE" = "auto" ] && ! iptables -L &> /dev/null; then
  echo "WARNING: iptables is not supported by the host"
elif [ "$IPTABLES_MODE" = "nft" ]; then
  echo "WARNING: iptables-nft enforced"
elif [ "$IPTABLES_MODE" = "legacy" ]; then
  echo "WARNING: iptables-legacy enforced"
fi

if [ ! command -v journalctl &> /dev/null ]; then
  echo "WARNING: systemd-journalctl not found"
fi

exec "$@"
