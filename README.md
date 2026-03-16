# RIPE Atlas Probe Add-on for Home Assistant

[![GitHub Release][releases-shield]][releases]
[![License][license-shield]](LICENSE)

![Project Maintenance][maintenance-shield]

This Home Assistant add-on allows you to run a RIPE Atlas software probe on your Home Assistant system.

## About

RIPE Atlas is a global network of probes that measure Internet connectivity and reachability. By running a probe on your Home Assistant device, you:

- Contribute to the global Internet measurement infrastructure
- Earn credits to run your own network measurements
- Help monitor Internet health worldwide
- Gain insights into your network connectivity

## Installation

1. Add this repository to your Home Assistant add-on store:
   - Navigate to **Settings** → **Add-ons** → **Add-on Store** → **⋮** (menu) → **Repositories**
   - Add the repository URL: `https://github.com/prmx/ha-atlas-probe`
2. Find "RIPE Atlas Probe" in the add-on store and click **Install**
3. Start the add-on and check the logs
4. Follow the registration instructions in the logs to activate your probe

## Configuration

Example configuration:

```yaml
log_level: info
```

See [DOCS.md](DOCS.md) for detailed configuration options and setup instructions.

## Features

- Official RIPE Atlas probe packages from ftp.ripe.net
- Supports amd64 and aarch64 architectures
- Persistent probe configuration across updates
- Pre-built images via ghcr.io for fast installs
- Automated upstream version detection via GitHub Actions
- Easy registration process
- Runs as a system service with S6-overlay process supervision

## Technical Notes

### SSH compatibility fixes

Running the RIPE Atlas probe in a container with OpenSSH 9.2+ (Debian bookworm) requires several fixes that the upstream packages don't handle:

- **`known_hosts.reg` port format** — The probe connects to registration servers on port 443, but the shipped `known_hosts.reg` uses bare hostnames (`193.0.19.246 ssh-rsa ...`). OpenSSH looks up `[193.0.19.246]:443` for non-standard ports and finds no match, causing host key verification failure. We append `[host]:443` formatted entries at build time.

- **`ssh-rsa` algorithm disabled** — OpenSSH 8.8+ disabled `ssh-rsa` (SHA-1) by default, but RIPE Atlas registration servers still use `ssh-rsa` host keys. We re-enable it via `/etc/ssh/ssh_config.d/ripe-atlas.conf`.

## Support

If you encounter any issues or have questions:

- Check the [documentation](DOCS.md)
- Open an issue on [GitHub](https://github.com/prmx/ha-atlas-probe/issues)
- Visit the [RIPE Atlas website](https://atlas.ripe.net/) for probe-specific questions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GPL-3.0 License - see the LICENSE file for details.

## Acknowledgments

- [RIPE NCC](https://www.ripe.net/) for the RIPE Atlas platform
- The Home Assistant community

[releases-shield]: https://img.shields.io/github/release/prmx/ha-atlas-probe.svg
[releases]: https://github.com/prmx/ha-atlas-probe/releases
[license-shield]: https://img.shields.io/github/license/prmx/ha-atlas-probe.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
