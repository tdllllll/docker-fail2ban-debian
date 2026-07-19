# syntax=docker/dockerfile:1

ARG DEBIAN_VERSION=trixie-slim

FROM debian:${DEBIAN_VERSION}

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    ipset \
    iptables \
    nftables \
    python3-dnspython \
    python3-inotify \
    systemd \
    tzdata \
    whois \
    fail2ban \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /root/.cache

COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "fail2ban-server", "-f", "-x", "-v", "start" ]

HEALTHCHECK --interval=10s --timeout=5s \
  CMD fail2ban-client ping || exit 1
