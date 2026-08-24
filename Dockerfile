ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG PROBE_VERSION=5130
ARG BUILD_ARCH

# Create users/groups matching upstream expectations
RUN groupadd --force --system --gid 999 ripe-atlas \
    && useradd --system --uid 101 --home /run/ripe-atlas --gid ripe-atlas --no-create-home ripe-atlas \
    && useradd --system --uid 102 --home /var/spool/ripe-atlas --gid ripe-atlas --no-create-home ripe-atlas-measurement

# Stub out systemd commands that package scripts expect but aren't available
# in the HA base image. Users/groups are already created above, so these are
# safe no-ops.
RUN printf '#!/bin/sh\nexit 0\n' > /usr/bin/systemd-sysusers \
    && chmod +x /usr/bin/systemd-sysusers \
    && printf '#!/bin/sh\nexit 0\n' > /usr/bin/systemctl \
    && chmod +x /usr/bin/systemctl

# Download and install official RIPE Atlas probe packages
# Map HA arch names to Debian arch names (aarch64 -> arm64)
# psmisc provides killall (used by probe scripts); --force-depends skips the
# hard systemd dependency since we don't use systemd.
RUN case "${BUILD_ARCH}" in \
        amd64) DEB_ARCH="amd64" ;; \
        aarch64) DEB_ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${BUILD_ARCH}" && exit 1 ;; \
    esac \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libcap2-bin iproute2 openssh-client procps net-tools psmisc curl \
    && curl -fsSL -o /tmp/ripe-atlas-common.deb \
        "https://ftp.ripe.net/ripe/atlas/software-probe/debian/dists/bookworm/main/binary-${DEB_ARCH}/ripe-atlas-common_${PROBE_VERSION}_${DEB_ARCH}.deb" \
    && curl -fsSL -o /tmp/ripe-atlas-probe.deb \
        "https://ftp.ripe.net/ripe/atlas/software-probe/debian/dists/bookworm/main/binary-${DEB_ARCH}/ripe-atlas-probe_${PROBE_VERSION}_all.deb" \
    && dpkg -i --force-depends /tmp/ripe-atlas-common.deb /tmp/ripe-atlas-probe.deb \
    && rm -f /tmp/*.deb && rm -rf /var/lib/apt/lists/* \
    && rm -f /etc/ripe-atlas/probe_key*

# Remove systemd stubs (no longer needed after package install)
RUN rm -f /usr/bin/systemd-sysusers /usr/bin/systemctl

# Fix known_hosts.reg: SSH requires [host]:port format for non-standard ports.
# The probe connects to registration servers on port 443 but the package ships
# bare hostnames (e.g. "193.0.19.75 ssh-ed25519 ..."). SSH looks up host keys
# as "[193.0.19.75]:443" and fails to match. Add [host]:443 entries.
RUN cp /usr/share/ripe-atlas/known_hosts.reg /tmp/known_hosts.reg \
    && sed 's/^\([^ ]*\) /[\1]:443 /' /tmp/known_hosts.reg \
        >> /usr/share/ripe-atlas/known_hosts.reg \
    && rm /tmp/known_hosts.reg

# Identify this probe to RIPE NCC telemetry as an HA add-on
# (requested by RIPE NCC — see Jamesits/docker-ripe-atlas#52)
RUN sed -i 's/^ID=.*/ID=ha-atlas-probe/' /etc/os-release

# Save factory defaults, then remove originals — the run script symlinks
# these to /data/ (persistent storage) so writes go directly to disk.
RUN mkdir -p /usr/share/factory/etc /usr/share/factory/var/spool \
    && cp -rp /etc/ripe-atlas /usr/share/factory/etc/ripe-atlas \
    && cp -rp /var/spool/ripe-atlas /usr/share/factory/var/spool/ripe-atlas \
    && rm -rf /etc/ripe-atlas /var/spool/ripe-atlas

COPY rootfs /
