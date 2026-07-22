## docker-fail2ban-debian

This is an experimental repository based on [crazy-max/docker-fail2ban](https://github.com/crazy-max/docker-fail2ban). It is modified to be Debian-based and uses the apt `fail2ban` package which contains os-specific configurations (e.g. defaults-debian.conf). It also supports integration with `systemd-journald`.

Most files are unchanged from upstream. Please refer to their [README.md](https://github.com/crazy-max/docker-fail2ban/blob/master/README.md) for more details.

WARNING: Performance, disk usage, functionality and stability are not guaranteed to be identical to upstream.

## Changes

1. `read_only` is enabled, so any specified `F2B_LOG_TARGET` will be written to `/data` directory.

## Credits

- [crazy-max/docker-fail2ban](https://github.com/crazy-max/docker-fail2ban)
