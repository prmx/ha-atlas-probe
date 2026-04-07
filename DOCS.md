# RIPE Atlas Probe Add-on Documentation

## About

This add-on allows you to run a RIPE Atlas software probe on your Home Assistant system. RIPE Atlas is a global network of probes that measure Internet connectivity and reachability. By running a probe, you contribute to the Internet measurement infrastructure and earn credits to run your own measurements.

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "RIPE Atlas Probe" add-on
3. Start the add-on
4. Check the logs for the probe registration instructions

## Configuration

```yaml
log_level: info
```

### Option: `log_level`

The log level for the add-on. Available options are:
- `debug`: Show detailed debug information
- `info`: Show normal informational messages (default)
- `warning`: Show only warnings and errors
- `error`: Show only errors

### Option: `probe_key` (auto-populated)

The probe's SSH public key, used for registration with RIPE NCC. This field is automatically populated after the probe generates its keys. You can copy it directly from the Configuration tab instead of searching through the logs.

## First Time Setup

After starting the add-on for the first time:

1. The probe generates its SSH key pair on first boot — watch the logs until the key appears.
2. Copy the public key from the `probe_key` field in the **Configuration** tab (auto-populated once ready), from the logs, or from `/config/.ripe-atlas/probe_key.pub`.
3. Paste the key into the registration form at https://atlas.ripe.net/apply/swprobe/
4. Your probe will connect automatically shortly after registration and appear on your RIPE Atlas dashboard.

## How to View Probe Status

- Check the add-on logs for status information
- Probe keys and configuration are stored in `/data/ripe-atlas/etc/`
- Measurement state is stored in `/data/ripe-atlas/spool/`
- Once registered and connected, your probe will appear on your RIPE Atlas dashboard

## Updating the Probe Software

The RIPE Atlas probe is installed from official RIPE NCC `.deb` packages at image build time. The upstream version is pinned via `PROBE_VERSION` in the Dockerfile.

**Update via Home Assistant (Recommended):**
1. Wait for a new add-on release that includes an updated probe version
2. Go to Settings -> Add-ons -> RIPE Atlas Probe
3. Click "Update" when a new version is available

**Automated Updates:**
A GitHub Actions workflow checks weekly for new upstream probe releases and opens a pull request automatically when one is found.

**Note:** Your probe configuration and registration are preserved during add-on updates. You do not need to re-register your probe after updating.

## Data Persistence

| Scenario | Probe keys preserved? |
|----------|----------------------|
| Container restart | Yes (`/data/` persists) |
| Add-on update | Yes (`/data/` persists) |
| Uninstall + reinstall | Yes (keys backed up to `/config/.ripe-atlas/`) |

Probe keys are automatically backed up to `/config/.ripe-atlas/` on first successful startup. If you uninstall and reinstall the add-on, keys are restored from this backup so your probe registration remains valid.

## Supported Architectures

- **amd64** (x86_64) — most Home Assistant installations
- **aarch64** (ARM 64-bit) — Raspberry Pi 4/5, ODROID, etc.

## Benefits

- Contribute to global Internet measurement infrastructure
- Earn credits to run your own measurements
- Monitor your network's connectivity from a global perspective
- Help the research and operational community

## Privacy

The RIPE Atlas probe:
- Only makes outgoing connections
- Does not provide content-level information about your network
- Participates in network measurement tasks (ping, traceroute, DNS queries)
- Reports results to RIPE NCC

## Support

For issues with the add-on:
- Check the [GitHub repository](https://github.com/prmx/ha-atlas-probe)

For RIPE Atlas probe issues:
- Visit https://atlas.ripe.net/
- Check the [RIPE Atlas documentation](https://atlas.ripe.net/docs/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
