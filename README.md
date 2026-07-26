## docker-fail2ban-debian

This is an experimental repository based on [crazy-max/docker-fail2ban](https://github.com/crazy-max/docker-fail2ban). It is modified to be Debian-based and uses the apt-managed `fail2ban` package which contains os-specific configurations (e.g. `defaults-debian.conf`). It can be useful for Debian hosts. It also supports integration with `systemd-journald`.

Most logic are unchanged from upstream. Please refer to their [README.md](https://github.com/crazy-max/docker-fail2ban/blob/master/README.md) for more details.

WARNING: Performance, disk usage, functionality, stability, security, etc. are not guaranteed to be identical to upstream.

## Changes

1. A `read_only` file system is enabled.
  - Any specified `F2B_LOG_TARGET` will be written to `/data` directory.
  - After configurations change you need to rerun `docker compose up -d` instead of just restarting.
  - `fail2ban.env` was removed. You now need to specify each variable at the `args` section in `compose.yml`.
  - A new variable `F2B_NO_DEB_DEFAULTS` was added. You can set any non-empty value to `F2B_NO_DEB_DEFAULTS` then `defaults-debian.conf` will be removed.
  - The recommended way to compose is now to run `deploy.sh` which helps initialize the working directory.

## Credits

- [crazy-max/docker-fail2ban](https://github.com/crazy-max/docker-fail2ban)
