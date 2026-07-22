#!/bin/bash

TZ=${TZ:-UTC}

F2B_LOG_TARGET=${F2B_LOG_TARGET:-STDOUT}
F2B_LOG_LEVEL=${F2B_LOG_LEVEL:-INFO}
F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:-1d}
IPTABLES_MODE=${IPTABLES_MODE:-auto}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Init
echo "Initializing files and folders..."
mkdir -p /data/run /data/lib /data/db /data/action.d /data/filter.d /data/jail.d

# Fail2ban conf
echo "Setting Fail2ban configuration..."
sed -i "s|logtarget =.*|logtarget = /data/${F2B_LOG_TARGET#/}|g" /etc/fail2ban/fail2ban.conf
sed -i "s/loglevel =.*/loglevel = $F2B_LOG_LEVEL/g" /etc/fail2ban/fail2ban.conf
sed -i "s|dbfile =.*|dbfile = /data/db/fail2ban\.sqlite3|g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbpurgeage =.*/dbpurgeage = $F2B_DB_PURGE_AGE/g" /etc/fail2ban/fail2ban.conf
sed -i "s/#allowipv6 =.*/allowipv6 = auto/g" /etc/fail2ban/fail2ban.conf

# Check custom actions
echo "Checking for custom actions in /data/action.d..."
actions=$(ls -l /data/action.d | grep -E '^-' | awk '{print $9}')
for action in ${actions}; do
  if [ -f "/etc/fail2ban/action.d/${action}" ]; then
    echo "  WARNING: ${action} already exists and will be overriden"
    rm -f "/etc/fail2ban/action.d/${action}"
  fi
  echo "  Add custom action ${action}..."
  ln -sf "/data/action.d/${action}" "/etc/fail2ban/action.d/"
done

# Check custom filters
echo "Checking for custom filters in /data/filter.d..."
filters=$(ls -l /data/filter.d | grep -E '^-' | awk '{print $9}')
for filter in ${filters}; do
  if [ -f "/etc/fail2ban/filter.d/${filter}" ]; then
    echo "  WARNING: ${filter} already exists and will be overriden"
    rm -f "/etc/fail2ban/filter.d/${filter}"
  fi
  echo "  Add custom filter ${filter}..."
  ln -sf "/data/filter.d/${filter}" "/etc/fail2ban/filter.d/"
done

# Check custom jails
echo "Checking for custom jails in /data/jail.d..."
filters=$(ls -l /data/jail.d | grep -E '^-' | awk '{print $9}')
for filter in ${filters}; do
  if [ -f "/etc/fail2ban/jail.d/${filter}" ]; then
    echo "  WARNING: ${filter} already exists and will be overriden"
    rm -f "/etc/fail2ban/jail.d/${filter}"
  fi
  echo "  Add custom jail ${filter}..."
  ln -sf "/data/jail.d/${filter}" "/etc/fail2ban/jail.d/"
done

if [ "$IPTABLES_MODE" = "auto" ] && ! iptables -L &> /dev/null; then
  echo "WARNING: iptables is not supported by the host"
elif [ "$IPTABLES_MODE" = "nft" ]; then
  echo "WARNING: iptables-nft enforced"
  update-alternatives --set iptables /usr/sbin/iptables-nft
  update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
elif [ "$IPTABLES_MODE" = "legacy" ]; then
  echo "WARNING: iptables-legacy enforced"
  update-alternatives --set iptables /usr/sbin/iptables-legacy
  update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
fi

iptables -V
nft -v

if ! command -v journalctl &> /dev/null; then
  echo "WARNING: systemd-journalctl not found"
fi

exec "$@"
