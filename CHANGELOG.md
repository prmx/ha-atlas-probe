# Changelog

All notable changes to this project will be documented in this file.

## [5130.1] - 2026-08-24

### Changed
- Refresh reg_servers.sh on start to fix probe registration after the 5130 upgrade

## [5130.0] - 2026-08-24

### Changed
- Update RIPE Atlas probe to 5130

## [5120.0] - 2026-03-13

### Added
- Initial release of RIPE Atlas Probe add-on for Home Assistant
- Official RIPE Atlas `.deb` packages from ftp.ripe.net (probe version 5120)
- Support for amd64 and aarch64 architectures
- Persistent probe configuration via symlinks to /data/ (survives restarts and updates)
- Probe key backup to /config/ (survives uninstall+reinstall without re-registration)
- Probe public key visible in add-on Configuration tab (auto-populated after first startup)
- Factory defaults merge on startup (adds new files from package upgrades without overwriting probe keys)
- Pre-built images via ghcr.io for fast installs
- S6-overlay process supervision
- Probe public key displayed in add-on logs for easy registration
- Runtime probe user creation fallback (HA supervisor can override /etc/passwd)
- AppArmor security profile
- SSH compatibility fixes for OpenSSH 9.2+ containers:
  - `known_hosts.reg` rewritten to `[host]:443` format for non-standard port
  - `ssh-rsa` algorithm re-enabled via ssh_config.d
- RIPE NCC telemetry identification (`ID=ha-atlas-probe` in os-release)
- Automated weekly upstream version detection with build verification and auto-merge
- Auto-generated PR contributor notes in GitHub releases
- CI: lint checks (hadolint, shellcheck, yamllint, addon-linter), build caching, changelog validation
- Dependabot for GitHub Actions dependency updates
