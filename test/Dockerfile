ARG FAIL2BAN_IMAGE=tdllllll/fail2ban:edge

FROM ${FAIL2BAN_IMAGE}

ARG TZ=UTC \
    F2B_LOG_TARGET=STDOUT \
    F2B_LOG_LEVEL=INFO \
    F2B_DB_PURGE_AGE=1d \
    IPTABLES_MODE=auto \
    F2B_NO_DEB_DEFAULTS=

ENV TZ=${TZ} \
    F2B_LOG_TARGET=${F2B_LOG_TARGET} \
    F2B_LOG_LEVEL=${F2B_LOG_LEVEL} \
    F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE} \
    IPTABLES_MODE=${IPTABLES_MODE} \
    F2B_NO_DEB_DEFAULTS=${F2B_NO_DEB_DEFAULTS}

# Timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

# Fail2ban conf
RUN if [ "${F2B_LOG_TARGET}" = "STDOUT" ]; then \
      sed -i "s/logtarget =.*/logtarget = ${F2B_LOG_TARGET}/g" \
        /etc/fail2ban/fail2ban.conf; \
    else \
      sed -i "s|logtarget =.*|logtarget = /data/${F2B_LOG_TARGET#/}|g" \
        /etc/fail2ban/fail2ban.conf; \
    fi

RUN sed -i "s/loglevel =.*/loglevel = ${F2B_LOG_LEVEL}/g" \
      /etc/fail2ban/fail2ban.conf \
    && sed -i "s|dbfile =.*|dbfile = /data/db/fail2ban.sqlite3|g" \
      /etc/fail2ban/fail2ban.conf \
    && sed -i "s/dbpurgeage =.*/dbpurgeage = ${F2B_DB_PURGE_AGE}/g" \
      /etc/fail2ban/fail2ban.conf \
    && sed -i "s/#allowipv6 =.*/allowipv6 = auto/g" \
      /etc/fail2ban/fail2ban.conf \
    && sed -i "s|socket =.*|socket = /tmp/run/fail2ban/fail2ban.sock|g" \
      /etc/fail2ban/fail2ban.conf \
    && sed -i "s|pidfile =.*|pidfile = /tmp/run/fail2ban/fail2ban.pid|g" \
      /etc/fail2ban/fail2ban.conf

RUN if [ -n "${F2B_NO_DEB_DEFAULTS}" ]; then \
      rm -f /etc/fail2ban/jail.d/defaults-debian.conf; \
    fi

# Copy custom configs
COPY data/action.d/ /etc/fail2ban/action.d/
COPY data/filter.d/ /etc/fail2ban/filter.d/
COPY data/jail.d/ /etc/fail2ban/jail.d/

# iptables mode
RUN if [ "$IPTABLES_MODE" = "nft" ]; then \
      update-alternatives --set iptables /usr/sbin/iptables-nft && \
      update-alternatives --set ip6tables /usr/sbin/ip6tables-nft; \
    elif [ "$IPTABLES_MODE" = "legacy" ]; then \
      update-alternatives --set iptables /usr/sbin/iptables-legacy && \
      update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy; \
    fi
